require('dotenv').config();
const pool = require('../src/config/database');

async function removeResumenLocal() {
  try {
    console.log(`🔍 Eliminando 'resumen' en base de datos local...`);

    // 1. Eliminar columnas
    const dropColumnIfExists = async (table, col) => {
      const [cols] = await pool.query(`DESCRIBE ${table}`);
      if (cols.map(c => c.Field).includes(col)) {
        console.log(`   - Borrando ${col} de ${table}...`);
        await pool.query(`ALTER TABLE ${table} DROP COLUMN ${col}`);
      }
    };

    await dropColumnIfExists('news', 'resumen');
    await dropColumnIfExists('content_feed', 'resumen');

    // 2. Actualizar triggers
    await pool.query('DROP TRIGGER IF EXISTS after_news_insert');
    await pool.query(`
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

    await pool.query('DROP TRIGGER IF EXISTS after_news_update');
    await pool.query(`
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

    console.log('\n✅ Local: Columna resúmen eliminada y triggers actualizados.');
    process.exit(0);
  } catch (error) {
    console.error('\n❌ ERROR LOCAL:', error.message);
    process.exit(1);
  }
}

removeResumenLocal();
