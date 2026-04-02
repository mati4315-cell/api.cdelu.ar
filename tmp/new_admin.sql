
-- Nuevo administrador con la contraseña: matias4315
INSERT INTO users (nombre, email, password, role_id)
SELECT 
    'Admin Backup', 
    'admin_backup@cdelu.ar', 
    '$2a$10$UD75ar6D2GUbKISdf5h/TelEL5Iby7KGm0G3xErwHMo2dX1vtdk7C', 
    id
FROM roles 
WHERE nombre = 'administrador';
