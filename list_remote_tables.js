const mysql = require('mysql2/promise');

async function listRemoteTables() {
  const config = {
    host: '193.203.175.35',
    port: 3306,
    user: 'u692901087_api_cdelu',
    password: 'Mati4315.',
    database: 'u692901087_api_cdelu_ar'
  };

  try {
    const connection = await mysql.createConnection(config);
    const [rows] = await connection.execute('SHOW TABLES');
    const tableNames = rows.map(r => Object.values(r)[0]);
    console.log('📦 TABLAS EN EL SERVIDOR REMOTO:');
    console.log(tableNames.join(', '));
    await connection.end();
  } catch (error) {
    console.error('❌ Error:', error.message);
  }
}

listRemoteTables();
