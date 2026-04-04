const mysql = require('mysql2/promise');

const config = {
  host: 'srv1183.hstgr.io',
  user: 'u692901087_api_cdelu',
  password: 'Mati4315.',
  database: 'u692901087_api_cdelu_ar'
};

const sql_surveys = `
CREATE TABLE IF NOT EXISTS surveys (
  id int(11) NOT NULL AUTO_INCREMENT,
  question varchar(255) NOT NULL,
  description text DEFAULT NULL,
  status enum('active','completed','draft') DEFAULT 'active',
  is_multiple_choice tinyint(1) DEFAULT 0,
  max_votes_per_user int(11) DEFAULT 1,
  expires_at timestamp NULL DEFAULT NULL,
  created_by int(11) DEFAULT NULL,
  created_at timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;`;

const sql_options = `
CREATE TABLE IF NOT EXISTS survey_options (
  id int(11) NOT NULL AUTO_INCREMENT,
  survey_id int(11) NOT NULL,
  option_text varchar(255) NOT NULL,
  votes_count int(11) DEFAULT 0,
  display_order int(11) DEFAULT 1,
  PRIMARY KEY (id),
  KEY survey_id_idx (survey_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;`;

const sql_votes = `
CREATE TABLE IF NOT EXISTS survey_votes (
  id int(11) NOT NULL AUTO_INCREMENT,
  survey_id int(11) NOT NULL,
  option_id int(11) NOT NULL,
  user_id int(11) DEFAULT NULL,
  user_ip varchar(45) NOT NULL,
  user_agent text DEFAULT NULL,
  created_at timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (id),
  KEY survey_id_idx (survey_id),
  KEY option_id_idx (option_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;`;

async function run() {
  const connection = await mysql.createConnection(config);
  try {
    console.log('Validando tablas en DB remota...');
    
    // surveys
    await connection.query(sql_surveys);
    console.log('✅ Tabla "surveys" verificada/creada');
    
    // survey_options
    await connection.query(sql_options);
    console.log('✅ Tabla "survey_options" verificada/creada');
    
    // survey_votes
    await connection.query(sql_votes);
    console.log('✅ Tabla "survey_votes" verificada/creada');
    
    // Verificar si existe la columna maldita para eliminarla
    const [cols] = await connection.query('SHOW COLUMNS FROM survey_votes LIKE "has_voted"');
    if (cols.length > 0) {
      console.log('🗑️  Encontrada columna obsoleta "has_voted", eliminando...');
      await connection.query('ALTER TABLE survey_votes DROP COLUMN has_voted');
      console.log('✅ Columna eliminada');
    } else {
      console.log('✨ No existe la columna "has_voted", no es necesario parchar schema.');
    }
    
    console.log('🏁 Proceso finalizado con éxito');
  } catch (error) {
    console.error('❌ Error:', error);
  } finally {
    await connection.end();
  }
}

run();
