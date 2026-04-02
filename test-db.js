const mysql = require('mysql2/promise');
const dotenv = require('dotenv');
dotenv.config();

async function test() {
  try {
    const connection = await mysql.createConnection({
      host: process.env.DB_HOST || 'localhost',
      port: parseInt(process.env.DB_PORT) || 3306,
      user: process.env.DB_USER || 'root',
      password: process.env.DB_PASSWORD || '',
      database: 'cdelu2'
    });
    const [rows] = await connection.query('SHOW TABLES');
    console.log('TABLES IN cdelu2:');
    rows.forEach(row => console.log(` - ${Object.values(row)[0]}`));
    await connection.end();
  } catch (err) {
    console.log('ERROR: ' + err.message);
  }
}
test();
