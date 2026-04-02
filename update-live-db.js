const mysql = require('mysql2/promise');
const dotenv = require('dotenv');
dotenv.config();

const newHash = '$2a$10$QYVHmSOXyhJkpMHm2NErWOczuquqqwJ8EQrM2p73p8a7bxZSqMDja';

async function update() {
  try {
    const connection = await mysql.createConnection({
      host: process.env.DB_HOST || 'localhost',
      port: parseInt(process.env.DB_PORT) || 3306,
      user: process.env.DB_USER || 'root',
      password: process.env.DB_PASSWORD || '',
      database: 'cdelu2'
    });
    
    await connection.query('UPDATE users SET password = ? WHERE id = 1', [newHash]);
    console.log('✅ Contraseña actualizada correctamente en cdelu2');
    await connection.end();
  } catch (err) {
    console.log('❌ Error: ' + err.message);
  }
}
update();
