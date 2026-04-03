const mysql = require('mysql2/promise');

async function removeResumenFromProduction() {
  const config = {
    host: 'srv1183.hstgr.io',
    user: 'u692901087_api_cdelu',
    password: 'Mati4315.',
    database: 'u692901087_api_cdelu_ar',
    port: 3306
  };

  let connection;

  try {
    console.log(`🔍 Conectando a Hostinger para eliminar 'resumen'...`);
    connection = await mysql.createConnection(config);
    console.log('✅ Conexión exitosa!');

    // 1. Eliminar columnas de las tablas
    console.log('\n🗑️ Eliminando columna resumen de las tablas...');
    
    // Función auxiliar para borrar columna si existe
    const dropColumnIfExists = async (table, col) => {
      const [cols] = await connection.query(`DESCRIBE ${table}`);
      if (cols.map(c => c.Field).includes(col)) {
        console.log(`   - Borrando ${col} de ${table}...`);
        await connection.query(`ALTER TABLE ${table} DROP COLUMN ${col}`);
      } else {
        console.log(`   - ${col} no existe en ${table}.`);
      }
    };

    await dropColumnIfExists('news', 'resumen');
    await dropColumnIfExists('content_feed', 'resumen');

    // 2. Actualizar Triggers (Versión sin resumen)
    console.log('\n🔄 Actualizando triggers (Removiendo resumen)...');
    
    await connection.query('DROP TRIGGER IF EXISTS after_news_insert');
    await connection.query(`
      CREATE TRIGGER after_news_insert
      AFTER INSERT ON news
      FOR EACH ROW
      BEGIN
        INSERT INTO content_feed (
          titulo, descripcion, image_url, type, original_id, 
          user_id, user_name, published_at, 
          original_url, is_oficial, diario, categoria,
          likes_count, comments_count
        ) VALUES (
          NEW.titulo, NEW.descripcion, NEW.image_url, 1, NEW.id,
          NEW.created_by, (SELECT nombre FROM users WHERE id = NEW.created_by),
          COALESCE(NEW.published_at, NEW.created_at),
          NEW.original_url, NEW.is_oficial, NEW.diario, NEW.categoria,
          0, 0
        );
      END
    `);

    await connection.query('DROP TRIGGER IF EXISTS after_news_update');
    await connection.query(`
      CREATE TRIGGER after_news_update
      AFTER UPDATE ON news
      FOR EACH ROW
      BEGIN
        UPDATE content_feed SET
          titulo = NEW.titulo,
          descripcion = NEW.descripcion,
          image_url = NEW.image_url,
          published_at = COALESCE(NEW.published_at, NEW.created_at),
          original_url = NEW.original_url,
          is_oficial = NEW.is_oficial,
          diario = NEW.diario,
          categoria = NEW.categoria,
          updated_at = NOW()
        WHERE type = 1 AND original_id = NEW.id;
      END
    `);

    console.log('\n🚀 ¡Hecho! La columna resumen ha sido eliminada y los triggers actualizados en Hostinger.');

  } catch (error) {
    console.error('\n❌ ERROR:', error.message);
  } finally {
    if (connection) await connection.end();
  }
}

removeResumenFromProduction();
