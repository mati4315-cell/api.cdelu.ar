/**
 * Middleware para validación de fotos de perfil
 * Valida tipo, tamaño y estructura del archivo antes del procesamiento
 */

const ALLOWED_MIME_TYPES = ['image/jpeg', 'image/jpg', 'image/png', 'image/webp'];
const MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB
const MIN_FILE_SIZE = 1024; // 1KB

/**
 * Middleware para validar archivos de foto de perfil
 * @param {Object} request - Objeto de solicitud Fastify
 * @param {Object} reply - Objeto de respuesta Fastify
 */
async function validateProfilePicture(request, reply) {
  try {
    const body = request.body || {};
    console.log('[DEBUG] validateProfilePicture - Content-Type:', request.headers['content-type']);
    console.log('[DEBUG] validateProfilePicture - Body keys:', Object.keys(body));
    
    let profilePictureFile = body.profile_picture;
    
    // Si attachFieldsToBody: true, a veces puede venir como array si se envían múltiples archivos con el mismo nombre
    if (Array.isArray(profilePictureFile)) {
      console.log('[DEBUG] profile_picture is an array, taking the first element');
      profilePictureFile = profilePictureFile[0];
    }
    
    if (profilePictureFile) {
      console.log('[DEBUG] profile_picture found:', {
        filename: profilePictureFile.filename,
        mimetype: profilePictureFile.mimetype,
        hasFile: !!profilePictureFile.file,
        hasValue: !!profilePictureFile.value
      });
    }

    // Verificar que existe el campo
    if (!profilePictureFile) {
      return reply.status(400).send({
        error: 'Campo profile_picture requerido',
        details: 'Debe proporcionar un archivo de imagen en el campo profile_picture'
      });
    }

    // Registrar estructura para debug si falla en el controlador
    console.log('[DEBUG] profile_picture found - Full keys:', Object.keys(profilePictureFile));
    
    // Validación básica: al menos debe tener un nombre de archivo o ser un objeto
    if (typeof profilePictureFile !== 'object') {
      return reply.status(400).send({
        error: 'Estructura de archivo inválida',
        details: 'El campo profile_picture no fue reconocido como un archivo multipart.'
      });
    }

    // Agregar metadata de validación para uso posterior (más flexible)
    request.validationMetadata = {
      originalName: profilePictureFile.filename || 'perfil.jpg',
      mimeType: profilePictureFile.mimetype || 'image/jpeg',
      maxAllowedSize: MAX_FILE_SIZE,
      minAllowedSize: MIN_FILE_SIZE
    };
  } catch (error) {
    request.log.error('Error en validación de foto de perfil:', error);
    return reply.status(500).send({
      error: 'Error interno en validación',
      details: 'No se pudo procesar la validación del archivo'
    });
  }
}

/**
 * Middleware para validar que el usuario está autenticado
 * @param {Object} request - Objeto de solicitud Fastify
 * @param {Object} reply - Objeto de respuesta Fastify
 */
async function requireAuthentication(request, reply) {
  try {
    await request.jwtVerify();
    
    if (!request.user || !request.user.id) {
      return reply.status(401).send({
        error: 'Usuario no válido',
        details: 'El token no contiene información de usuario válida'
      });
    }
  } catch (error) {
    return reply.status(401).send({
      error: 'Token de acceso requerido',
      details: 'Debe proporcionar un token JWT válido en el header Authorization'
    });
  }
}

/**
 * Middleware de limitación de velocidad para subida de fotos
 * Previene spam de subidas de archivos
 */
const profileUploadRateLimit = {
  max: 5, // máximo 5 intentos
  timeWindow: '1 minute', // por minuto
  skipSuccessfulRequests: true,
  keyFunction: (request) => {
    // Usar ID de usuario para limitar por usuario
    return request.user?.id || request.ip;
  },
  errorMessage: {
    error: 'Demasiados intentos de subida',
    details: 'Máximo 5 subidas de fotos por minuto. Intente nuevamente más tarde.'
  }
};

module.exports = {
  validateProfilePicture,
  requireAuthentication,
  profileUploadRateLimit,
  ALLOWED_MIME_TYPES,
  MAX_FILE_SIZE,
  MIN_FILE_SIZE
}; 