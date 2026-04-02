const bcrypt = require('bcryptjs');
const mysql = require('mysql2/promise');
const dotenv = require('dotenv');

dotenv.config({ path: 'c:/milagro2/.env' });

async function createAdmin() {
  const config = {
    host: process.env.DB_HOST,
    port: parseInt(process.env.DB_PORT, 10),
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME
  };

  const nombre = 'Admin CdelU';
  const email = 'admin@cdelu.ar';
  const plainPassword = 'admin2026';

  try {
    const connection = await mysql.createConnection(config);
    
    // Hash password
    const hashedPassword = await bcrypt.hash(plainPassword, 10);
    
    // Ensure roles exist
    await connection.query('INSERT IGNORE INTO roles (id, nombre) VALUES (1, "administrador"), (2, "colaborador"), (3, "usuario")');
    
    // Get role id
    const [roles] = await connection.query('SELECT id FROM roles WHERE nombre = "administrador"');
    if (roles.length === 0) {
      console.error('Role "administrador" not found');
      return;
    }
    const roleId = roles[0].id;

    // Check if user exists
    const [existing] = await connection.query('SELECT id FROM users WHERE email = ?', [email]);
    if (existing.length > 0) {
      await connection.query('UPDATE users SET password = ?, role_id = ? WHERE email = ?', [hashedPassword, roleId, email]);
      console.log(`Updated existing admin user: ${email}`);
    } else {
      await connection.query(
        'INSERT INTO users (nombre, email, password, role_id) VALUES (?, ?, ?, ?)',
        [nombre, email, hashedPassword, roleId]
      );
      console.log(`Created new admin user: ${email}`);
    }
    
    console.log(`Email: ${email}`);
    console.log(`Password: ${plainPassword}`);
    
    await connection.end();
  } catch (err) {
    console.error('Error creating admin:', err);
  }
}

createAdmin();
