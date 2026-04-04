const mysql = require('mysql2/promise');

async function fixRemoteDb() {
  const config = {
    host: '193.203.175.35',
    port: 3306,
    user: 'u692901087_api_cdelu',
    password: 'Mati4315.',
    database: 'u692901087_api_cdelu_ar',
    connectTimeout: 10000
  };

  console.log('🚀 Iniciando reparación de base de datos remota...');
  let connection;

  try {
    connection = await mysql.createConnection(config);
    console.log('✅ Conexión establecida con el servidor remoto.');

    // 1. Verificar y reparar tabla 'users'
    console.log('📦 Verificando tabla "users"...');
    const [columns] = await connection.execute('SHOW COLUMNS FROM users');
    const existingColumns = columns.map(c => c.Field);

    const columnsToAdd = [
      { name: 'username', type: 'VARCHAR(100) UNIQUE AFTER email' },
      { name: 'bio', type: 'TEXT' },
      { name: 'location', type: 'VARCHAR(100)' },
      { name: 'website', type: 'VARCHAR(255)' },
      { name: 'profile_picture_url', type: 'VARCHAR(255)' },
      { name: 'is_verified', type: 'TINYINT(1) DEFAULT 0' },
      { name: 'updated_at', type: 'TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP' }
    ];

    for (const col of columnsToAdd) {
      if (!existingColumns.includes(col.name)) {
        console.log(`  ➕ Añadiendo columna: ${col.name}`);
        try {
          await connection.execute(`ALTER TABLE users ADD COLUMN ${col.name} ${col.type}`);
          console.log(`  ✅ Columna ${col.name} añadida.`);
        } catch (err) {
          console.error(`  ❌ Error añadiendo ${col.name}:`, err.message);
        }
      } else {
        console.log(`  ✔ Columna ${col.name} ya existe.`);
      }
    }

    // 2. Crear tabla user_follows si no existe
    console.log('📦 Verificando tabla "user_follows"...');
    await connection.execute(`
      CREATE TABLE IF NOT EXISTS user_follows (
        id INT AUTO_INCREMENT PRIMARY KEY,
        follower_id INT NOT NULL,
        following_id INT NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        UNIQUE KEY unique_follow (follower_id, following_id),
        FOREIGN KEY (follower_id) REFERENCES users(id) ON DELETE CASCADE,
        FOREIGN KEY (following_id) REFERENCES users(id) ON DELETE CASCADE
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    `);
    console.log('  ✅ Tabla "user_follows" lista.');

    // 3. Crear tabla com_likes si no existe
    console.log('📦 Verificando tabla "com_likes"...');
    await connection.execute(`
      CREATE TABLE IF NOT EXISTS com_likes (
        id INT AUTO_INCREMENT PRIMARY KEY,
        user_id INT NOT NULL,
        com_id INT NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        UNIQUE KEY unique_like (user_id, com_id),
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
        FOREIGN KEY (com_id) REFERENCES com(id) ON DELETE CASCADE
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    `);
    console.log('  ✅ Tabla "com_likes" lista.');

    // 4. Poblar usernames vacíos (si existen) para evitar errores de UNIQUE
    console.log('🧹 Limpiando usernames vacíos...');
    await connection.execute(`
      UPDATE users 
      SET username = CONCAT('user_', id) 
      WHERE username IS NULL OR username = '';
    `);

    console.log('\n🎉 ¡Reparación completada con éxito!');

  } catch (error) {
    console.error('❌ Error crítico durante la reparación:', error.message);
    if (error.code === 'ETIMEDOUT' || error.code === 'ECONNREFUSED') {
      console.log('\n💡 TIP: Asegurate de haber habilitado el acceso para tu IP actual en la sección "Remote MySQL" del cPanel de Hostinger.');
    }
  } finally {
    if (connection) await connection.end();
  }
}

fixRemoteDb();
