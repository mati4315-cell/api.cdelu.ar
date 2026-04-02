const bcrypt = require('bcryptjs');
const fs = require('fs');
const password = 'matias4315';
const saltRounds = 10;
const hash = bcrypt.hashSync(password, saltRounds);

const sql = `
-- Nuevo administrador con la contraseña: ${password}
INSERT INTO users (nombre, email, password, role_id)
SELECT 
    'Admin Backup', 
    'admin_backup@cdelu.ar', 
    '${hash}', 
    id
FROM roles 
WHERE nombre = 'administrador';
`;

fs.writeFileSync('c:\\milagro2\\tmp\\new_admin.sql', sql);
console.log('SQL generado en c:\\milagro2\\tmp\\new_admin.sql');
