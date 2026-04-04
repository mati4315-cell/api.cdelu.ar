const mysql = require('mysql2/promise');

async function syncRemoteRoles() {
  const config = {
    host: '193.203.175.35',
    port: 3306,
    user: 'u692901087_api_cdelu',
    password: 'Mati4315.',
    database: 'u692901087_api_cdelu_ar'
  };

  try {
    const connection = await mysql.createConnection(config);
    console.log('📦 Ajustando tabla "roles" en servidor remoto...');
    
    const [columns] = await connection.execute('SHOW COLUMNS FROM roles');
    const existingColumns = columns.map(c => c.Field);

    if (existingColumns.includes('name') && !existingColumns.includes('nombre')) {
      console.log('  🔄 Renombrando columna "name" a "nombre" para consistencia con el código...');
      await connection.execute('ALTER TABLE roles CHANGE name nombre VARCHAR(50) NOT NULL');
      console.log('  ✅ Columna renombrada.');
    } else if (!existingColumns.includes('nombre')) {
      console.log('  ➕ Añadiendo columna "nombre"...');
      await connection.execute('ALTER TABLE roles ADD COLUMN nombre VARCHAR(50) NOT NULL');
      console.log('  ✅ Columna añadida.');
    } else {
      console.log('  ✔ La columna "nombre" ya existe.');
    }

    await connection.end();
    console.log('\n🎉 ¡DB sincronizada!');
  } catch (error) {
    console.error('❌ Error:', error.message);
  }
}

syncRemoteRoles();
