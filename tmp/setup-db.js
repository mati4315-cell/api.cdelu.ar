const mysql = require('mysql2/promise');
const dotenv = require('dotenv');
const fs = require('fs');
const path = require('path');

dotenv.config({ path: 'c:/milagro2/.env' });

async function setupDb() {
  const connection = await mysql.createConnection({
    host: process.env.DB_HOST || 'localhost',
    port: parseInt(process.env.DB_PORT, 10) || 3306,
    user: 'root',
    password: '',
    multipleStatements: true
  });

  try {
    console.log('Creating database cdelu2...');
    await connection.query('CREATE DATABASE IF NOT EXISTS cdelu2');
    await connection.query('USE cdelu2');
    
    console.log('Creating user matias...');
    await connection.query("CREATE USER IF NOT EXISTS 'matias'@'localhost' IDENTIFIED BY '007'");
    await connection.query("GRANT ALL PRIVILEGES ON cdelu2.* TO 'matias'@'localhost'");
    await connection.query('FLUSH PRIVILEGES');

    console.log('Running schema.sql...');
    let schemaSql = fs.readFileSync('c:/milagro2/sql/schema.sql', 'utf8');
    schemaSql = schemaSql.replace(/`expires_at` timestamp NOT NULL/g, '`expires_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP');
    await connection.query(schemaSql);
    
    console.log('Running admin_user.sql...');
    const adminSql = fs.readFileSync('c:/milagro2/sql/admin_user.sql', 'utf8');
    await connection.query(adminSql);

    console.log('Database setup completed successfully.');
  } catch (err) {
    console.error('Error setting up database:', err);
  } finally {
    await connection.end();
  }
}

setupDb();
