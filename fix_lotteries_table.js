const mysql = require('mysql2/promise');

async function fixLotteriesTable() {
  const config = {
    host: '193.203.175.35',
    port: 3306,
    user: 'u692901087_api_cdelu',
    password: 'Mati4315.',
    database: 'u692901087_api_cdelu_ar'
  };

  try {
    const connection = await mysql.createConnection(config);
    console.log('🔄 Alterando tabla lotteries...');
    
    // Lista de columnas a agregar si no existen (hacemos un query que falle silenciosamente si existen)
    // O mejor, chequear que no existan primero, pero para ser más directos podemos hacer ALTER IGNORE? 
    // MySQL no tiene ALTER TABLE ADD COLUMN IF NOT EXISTS de manera estándar y fácil sin stored procedures.
    
    // Obtenemos las columnas actuales
    const [columnsInfo] = await connection.execute('SHOW COLUMNS FROM lotteries');
    const existingCols = columnsInfo.map(c => c.Field);
    
    const alterQueries = [];
    
    if (!existingCols.includes('is_free')) {
      alterQueries.push('ADD COLUMN is_free BOOLEAN DEFAULT FALSE');
    }
    if (!existingCols.includes('min_tickets')) {
      alterQueries.push('ADD COLUMN min_tickets INT DEFAULT 1');
    }
    if (!existingCols.includes('num_winners')) {
      alterQueries.push('ADD COLUMN num_winners INT DEFAULT 1');
    }
    if (!existingCols.includes('prize_description')) {
      alterQueries.push('ADD COLUMN prize_description TEXT NULL');
    }
    if (!existingCols.includes('terms_conditions')) {
      alterQueries.push('ADD COLUMN terms_conditions TEXT NULL');
    }
    if (!existingCols.includes('created_by')) {
      alterQueries.push('ADD COLUMN created_by INT NULL');
    }
    if (!existingCols.includes('winner_selected_at')) {
      alterQueries.push('ADD COLUMN winner_selected_at DATETIME NULL');
    }
    
    if (alterQueries.length > 0) {
      const query = `ALTER TABLE lotteries ${alterQueries.join(', ')}`;
      console.log('🚀 Ejecutando:', query);
      await connection.execute(query);
      console.log('✅ Columnas agregadas exitosamente.');
    } else {
      console.log('✅ La tabla lotteries ya tiene todas las columnas necesarias.');
    }
    
    // También aseguremos las tablas lottery_tickets y lottery_winners si acaso faltan,
    // o al ver si lotteries funcionaba asumimos que esas quizá también falten o estén bien.
    
    await connection.end();
  } catch (error) {
    console.error('❌ Error:', error.message);
  }
}

fixLotteriesTable();
