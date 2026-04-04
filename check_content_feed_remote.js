const mysql = require('mysql2/promise');

async function checkContentFeedTable() {
  const config = {
    host: '193.203.175.35',
    port: 3306,
    user: 'u692901087_api_cdelu',
    password: 'Mati4315.',
    database: 'u692901087_api_cdelu_ar'
  };

  try {
    const connection = await mysql.createConnection(config);
    const [columns] = await connection.execute('SHOW COLUMNS FROM content_feed');
    console.log(JSON.stringify(columns.map(c => c.Field)));
    await connection.end();
  } catch (error) {
    console.error('❌ Error:', error.message);
  }
}

checkContentFeedTable();
