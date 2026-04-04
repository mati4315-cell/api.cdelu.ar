const fs = require('fs');
const path = require('path');
const pool = require(path.join(process.cwd(), 'src/config/database'));

async function runSql(filePath) {
  const sql = fs.readFileSync(path.join(__dirname, '..', filePath), 'utf8');
  const commands = sql.split(';').map(c => c.trim()).filter(c => c.length > 0);
  
  console.log(`Running SQL from ${filePath} (${commands.length} commands)...`);
  
  for (let cmd of commands) {
    try {
      await pool.execute(cmd);
      // console.log(`✅ Success: ${cmd.substring(0, 50)}...`);
    } catch (e) {
      if (e.message.includes('already exists') || e.message.includes('Duplicate entry')) {
        // console.log(`ℹ️ Ignored: ${e.message}`);
      } else {
        console.error(`❌ Error executing: ${cmd.substring(0, 50)}...`);
        console.error(`Message: ${e.message}`);
      }
    }
  }
}

async function main() {
  try {
    await runSql('sql/create_lottery_tables.sql');
    await runSql('sql/create_surveys_tables_simple.sql');
    console.log('\n--- Checking all lottery tables now ---');
    const [rows] = await pool.execute('show tables;');
    const tables = rows.map(r => Object.values(r)[0]);
    console.log('Tables in database:', tables);
  } finally {
    await pool.end();
  }
}

main();
