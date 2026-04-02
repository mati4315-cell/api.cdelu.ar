const mysql = require('mysql2/promise');
const fs = require('fs');
const dotenv = require('dotenv');

dotenv.config({ path: 'c:/milagro2/.env' });

async function run() {
  const connection = await mysql.createConnection({
    host: process.env.DB_HOST,
    port: parseInt(process.env.DB_PORT, 10),
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    multipleStatements: true
  });

  try {
    console.log(`Applying schema to ${process.env.DB_NAME}...`);
    const sql = fs.readFileSync('c:/milagro2/tmp/final_schema.sql', 'utf8');
    
    // We need to split by DELIMITER if multipleStatements doesn't handle them (Standard mysql2 doesn't always handle DELIMITER command which is a CLI feature)
    // But my final_schema.sql has DELIMITER // ...
    // Actually, I can just use a simple parser or just remove DELIMITER lines and split by END // or ;
    
    const parts = sql.split(/DELIMITER\s+\/\//i);
    // Part 0 is standard SQL
    const standardSql = parts[0];
    await connection.query(standardSql);
    
    // Subsequent parts contain triggers
    for (let i = 1; i < parts.length; i++) {
        const triggerAndMore = parts[i].split(/DELIMITER\s+;/i);
        const triggerSql = triggerAndMore[0].trim().replace(/\/\/$/, '');
        if (triggerSql) {
            console.log("Creating trigger...");
            await connection.query(triggerSql);
        }
        if (triggerAndMore[1]) {
            await connection.query(triggerAndMore[1]);
        }
    }

    console.log('Schema applied successfully.');
  } catch (err) {
    console.error('Error applying schema:', err);
  } finally {
    await connection.end();
  }
}

run();
