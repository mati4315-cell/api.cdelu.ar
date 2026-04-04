const mysql = require('mysql2/promise');

async function testProfileQuery() {
  const config = {
    host: '193.203.175.35',
    port: 3306,
    user: 'u692901087_api_cdelu',
    password: 'Mati4315.',
    database: 'u692901087_api_cdelu_ar',
    connectTimeout: 10000
  };

  console.log('🔍 Probando consulta de perfil en BD remota...');
  let connection;

  try {
    connection = await mysql.createConnection(config);
    const userId = 1; // Un id de prueba

    console.log('  📡 Ejecutando consulta principal de perfil...');
    const [users] = await connection.execute(
      `SELECT u.id, u.nombre, u.email, u.profile_picture_url, r.nombre as rol, 
              u.created_at, u.updated_at
       FROM users u
       LEFT JOIN roles r ON u.role_id = r.id
       WHERE u.id = ?`,
      [userId]
    );
    console.log('  ✅ Consulta principal OK:', users.length > 0 ? 'Usuario encontrado' : 'Usuario 1 no existe');

    console.log('  📡 Ejecutando consultas de métricas...');
    const queries = [
      { name: 'comments', sql: 'SELECT COUNT(*) AS count FROM comments WHERE user_id = ?' },
      { name: 'lottery_tickets', sql: 'SELECT COUNT(DISTINCT lottery_id) AS count FROM lottery_tickets WHERE user_id = ? AND payment_status = \'paid\'' },
      { name: 'lottery_winners', sql: 'SELECT COUNT(*) AS count FROM lottery_winners WHERE user_id = ?' },
      { name: 'com', sql: 'SELECT COUNT(*) AS count FROM com WHERE user_id = ?' }
    ];

    for (const q of queries) {
      try {
        const [rows] = await connection.execute(q.sql, [userId]);
        console.log(`  ✅ Tabla "${q.name}" OK: ${rows[0].count} registros`);
      } catch (err) {
        console.error(`  ❌ Error en tabla "${q.name}":`, err.message);
      }
    }

  } catch (error) {
    console.error('❌ Error general:', error.message);
  } finally {
    if (connection) await connection.end();
  }
}

testProfileQuery();
