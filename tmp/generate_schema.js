const mysql = require('mysql2/promise');
const fs = require('fs');
const path = require('path');

async function run() {
  const connection = await mysql.createConnection({
    host: 'localhost',
    port: 3307,
    user: 'root',
    password: '',
    multipleStatements: true
  });

  try {
    console.log('Creating temp DB...');
    await connection.query('DROP DATABASE IF EXISTS temp_schema_db');
    await connection.query('CREATE DATABASE temp_schema_db');
    await connection.query('USE temp_schema_db');

    console.log('Executing SQL files...');
    const files = [
      'schema.sql',
      'add-profile-picture-migration.sql',
      'create_lottery_tables.sql',
      'create_ads_system.sql',
      'create_surveys_tables_simple.sql',
      'content_feed.sql',
      'optimize_content_feed_triggers.sql'
    ];

    for (const file of files) {
      const p = path.join('c:/milagro2/sql', file);
      if (fs.existsSync(p)) {
        console.log(`Executing ${file}...`);
        const sql = fs.readFileSync(p, 'utf8');
        try {
          if (file.includes('trigger')) {
             const parts = sql.split('DELIMITER $$');
             if (parts.length > 1) {
                const pre = parts[0].replace(/USE\s+[a-zA-Z0-9_]+;/gi, '');
                await connection.query(pre);
                
                const triggerSection = parts[1].split('DELIMITER ;')[0];
                const triggers = triggerSection.split('END$$');
                for (let trig of triggers) {
                    trig = trig.trim();
                    if (trig.length > 5) {
                        await connection.query(trig + ' END');
                    }
                }
             }
          } else {
              let cleanSql = sql.replace(/USE\s+[a-zA-Z0-9_]+;/gi, '');
              cleanSql = cleanSql.replace(/`expires_at` timestamp NOT NULL/g, '`expires_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP');
              await connection.query(cleanSql);
          }
        } catch (e) {
          console.error(`Error in ${file}:`, e.message);
        }
      }
    }

    console.log('Extracting tables...');
    const [tables] = await connection.query('SHOW TABLES');
    let finalSchema = '-- Schema generation \n\n';

    finalSchema += 'SET FOREIGN_KEY_CHECKS=0;\n\n';

    for (const row of tables) {
      const tableName = Object.values(row)[0];
      const [createTableStmt] = await connection.query(`SHOW CREATE TABLE \`${tableName}\``);
      let createSql = createTableStmt[0]['Create Table'];
      createSql = createSql.replace(/CREATE TABLE/i, 'CREATE TABLE IF NOT EXISTS');
      finalSchema += `-- Table: ${tableName}\n`;
      finalSchema += createSql + ';\n\n';
    }

    console.log('Extracting triggers...');
    const [triggers] = await connection.query('SHOW TRIGGERS');
    for (const row of triggers) {
      const trigName = row.Trigger;
      const [createTrig] = await connection.query(`SHOW CREATE TRIGGER \`${trigName}\``);
      let stmt = createTrig[0]['SQL Original Statement'];
      // if SQL Original Statement is null, sometimes it is under 'Create Trigger' ? (No, MySQL says SQL Original Statement is CREATE TRIGGER ... )
      if (!stmt) {
          stmt = `-- WARNING: Could not extract trigger ${trigName}\n`;
          console.error('Missing trigger definition for', trigName);
      } else {
          // Remove DEFINER
          stmt = stmt.replace(/DEFINER=`[^`]+`@`[^`]+`/g, '');
          // Wrap with delimiters
          stmt = `DELIMITER //\n${stmt} //\nDELIMITER ;`;
      }
      finalSchema += `-- Trigger: ${trigName}\n`;
      finalSchema += stmt + '\n\n';
    }

    finalSchema += 'SET FOREIGN_KEY_CHECKS=1;\n';

    const outFile = 'c:/milagro2/tmp/final_schema.sql';
    fs.writeFileSync(outFile, finalSchema);
    console.log(`Saved to ${outFile}`);

  } catch (err) {
    console.error(err);
  } finally {
    await connection.query('DROP DATABASE IF EXISTS temp_schema_db');
    await connection.end();
  }
}

run();
