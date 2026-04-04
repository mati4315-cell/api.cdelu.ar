const mysql = require('mysql2/promise');

async function checkLotteriesColumns() {
  const config = {
    host: '193.203.175.35',
    port: 3306,
    user: 'u692901087_api_cdelu',
    password: 'Mati4315.',
    database: 'u692901087_api_cdelu_ar'
  };

  try {
    const connection = await mysql.createConnection(config);
    const [columns] = await connection.execute('SHOW COLUMNS FROM lotteries');
    console.log(JSON.stringify(columns.map(c => c.Field)));
    await connection.end();
  } catch (error) {
    console.error('❌ Error:', error.message);
  }
}

checkLotteriesColumns();
