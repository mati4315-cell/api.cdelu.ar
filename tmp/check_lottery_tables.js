const path = require('path');
const mysql = require('mysql2/promise');
require('dotenv').config({ path: path.join(__dirname, '../.env') });

const config = {
  host: process.env.DB_HOST || 'localhost',
  port: parseInt(process.env.DB_PORT, 10) || 3306,
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || '',
  database: process.env.DB_NAME || 'cdelu_diario',
};

async function checkTables() {
  const connection = await mysql.createConnection(config);
  try {
    const [rows] = await connection.execute('show tables;');
    console.log('Tables in database:', rows.map(r => Object.values(r)[0]));
    
    const lotteryTables = ['lotteries', 'lottery_tickets', 'lottery_winners', 'lottery_reserved_numbers', 'lottery_settings'];
    for (const table of lotteryTables) {
      try {
        const [desc] = await connection.execute(`DESCRIBE ${table}`);
        console.log(`\n--- TABLE: ${table} ---`);
        console.table(desc);
      } catch (e) {
        console.log(`\n❌ Table ${table} NOT FOUND or error:`, e.message);
      }
    }
  } finally {
    await connection.end();
  }
}

checkTables();
