const mysql = require('mysql2/promise');
(async () => {
    const conn = await mysql.createConnection({
        host: '127.0.0.1',
        port: 3307,
        user: 'root',
        password: '',
        database: 'cdelu2'
    });
    await conn.query('DELETE FROM news');
    await conn.query('DELETE FROM content_feed');
    await conn.query(`INSERT INTO news (id, titulo, descripcion, resumen, image_url, original_url, is_oficial, created_by, published_at) VALUES 
        (1, 'Trabas legales en el proyecto local', 'El proyecto enfrenta diversos desafíos legales que retrasan su ejecución en la zona céntrica.', 'Desafíos legales retrasan proyecto.', 'https://picsum.photos/800/400', 'https://example.com/1', 1, 1, NOW()), 
        (2, 'Nueva plaza inaugurada en el barrio Sur', 'Con gran asistencia de vecinos, se habilitó el nuevo espacio recreativo con juegos modernos.', 'Inauguran plaza en barrio Sur.', 'https://picsum.photos/801/401', 'https://example.com/2', 1, 1, NOW())`);
    await conn.query('INSERT INTO content_feed (titulo, descripcion, resumen, image_url, type, original_id, user_id, user_name, user_profile_picture, published_at, created_at, updated_at, original_url, is_oficial) SELECT n.titulo, n.descripcion, n.resumen, n.image_url, 1, n.id, n.created_by, u.nombre, u.profile_picture_url, n.published_at, n.created_at, n.updated_at, n.original_url, n.is_oficial FROM news n LEFT JOIN users u ON n.created_by = u.id');
    console.log('Fixed data inserted');
    await conn.end();
})().catch(console.error);
