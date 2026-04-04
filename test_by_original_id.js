const mysql = require('mysql2/promise');

async function testByOriginalId() {
  const config = {
    host: '193.203.175.35',
    port: 3306,
    user: 'u692901087_api_cdelu',
    password: 'Mati4315.',
    database: 'u692901087_api_cdelu_ar'
  };

  const type = 1; // Noticias
  const originalId = 48;

  try {
    const connection = await mysql.createConnection(config);
    console.log(`🔍 Buscando content_feed para type=${type}, originalId=${originalId}...`);
    
    const query = `
      SELECT id, titulo, type, original_id 
      FROM content_feed 
      WHERE type = ? AND original_id = ?
    `;
    
    const [rows] = await connection.execute(query, [type, originalId]);
    
    if (rows.length > 0) {
      console.log('✅ Encontrado:', rows[0]);
    } else {
      console.log('❌ No se encontró en el feed. ¿Existe en la tabla news?');
      const [news] = await connection.execute('SELECT id, titulo FROM news WHERE id = ?', [originalId]);
      if (news.length > 0) {
        console.log('✔ Existe en "news":', news[0]);
        console.log('⚠️ El feed parece estar DESINCRONIZADO.');
      } else {
        console.log('❌ Tampoco existe en "news".');
      }
    }

    await connection.end();
  } catch (error) {
    console.error('❌ Error:', error.message);
  }
}

testByOriginalId();
