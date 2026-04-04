
const mysql = require('mysql2/promise');

async function optimizeRemoteDB() {
  const config = {
    host: '193.203.175.35',
    port: 3306, // Puerto estándar
    user: 'u692901087_api_cdelu',
    password: 'Mati4315.',
    database: 'u692901087_api_cdelu_ar',
  };

  console.log('--- Optimizando Base de Datos Remota (Hostinger) ---');
  let connection;
  try {
    connection = await mysql.createConnection(config);
    console.log('✅ Conectado a ' + config.host);

    // 1. Optimizando content_feed
    console.log('Optimizando tabla content_feed...');
    try { 
      await connection.query('DROP INDEX idx_feed_perf ON content_feed'); 
      console.log('  - Índice previo idx_feed_perf eliminado.');
    } catch(e){}
    
    await connection.query('CREATE INDEX idx_feed_perf ON content_feed (type, id, published_at)');
    console.log('  - Índice idx_feed_perf (compuesto) creado.');

    try {
        await connection.query('CREATE INDEX idx_type ON content_feed (type)');
        console.log('  - Índice idx_type creado.');
    } catch(e){}

    try {
        await connection.query('CREATE INDEX idx_published_at ON content_feed (published_at)');
        console.log('  - Índice idx_published_at creado.');
    } catch(e){}

    // 2. Optimizando news
    console.log('Optimizando tabla news...');
    try { 
      await connection.query('CREATE INDEX idx_published_at ON news (published_at)'); 
      console.log('  - Índice idx_published_at creado en tabla news.');
    } catch(e){
      console.log('  - El índice idx_published_at ya existía en news.');
    }

    // 3. Optimizando likes/comments si existen
    try {
      await connection.query('CREATE INDEX idx_news_id ON likes (news_id)');
      console.log('  - Índice idx_news_id creado en likes.');
    } catch(e){}

    try {
      await connection.query('CREATE INDEX idx_news_id ON comments (news_id)');
      console.log('  - Índice idx_news_id creado en comments.');
    } catch(e){}

    console.log('\n🚀 ¡Optimización de base de datos remota completada exitosamente!');
  } catch (err) {
    console.error('\n❌ ERROR:', err.message);
    if (err.code === 'ER_ACCESS_DENIED_ERROR') {
      console.error('Comprobar que el servidor permita conexiones externas (Whitelist IP).');
    }
  } finally {
    if (connection) await connection.end();
  }
}

optimizeRemoteDB();
