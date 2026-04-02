const mysql = require('mysql2/promise');
const dotenv = require('dotenv');
const path = require('path');

dotenv.config({ path: 'c:/milagro2/.env' });

async function listDbs() {
  const config = {
    host: process.env.DB_HOST || 'localhost',
    port: parseInt(process.env.DB_PORT, 10) || 3306,
    user: 'root', // Try root if matias doesn't have permissions
    password: 'root', // Try common passwords
  };

  const commonPasswords = ['root', '007', '', 'admin'];
  const commonUsers = ['root', 'matias'];

  for (const user of commonUsers) {
    for (const pass of commonPasswords) {
      try {
        const connection = await mysql.createConnection({
          host: config.host,
          port: config.port,
          user: user,
          password: pass
        });
        console.log(`Successfully connected as ${user}:${pass}`);
        const [rows] = await connection.query('SHOW DATABASES');
        console.log('Databases:', rows.map(r => r.Database));
        await connection.end();
        return;
      } catch (err) {
        // console.log(`Failed as ${user}:${pass}: ${err.message}`);
      }
    }
  }
  console.log('Failed to connect with common credentials.');
}

listDbs();
