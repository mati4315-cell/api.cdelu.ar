#!/usr/bin/env node

/**
 * Script de verificación de inicio para CdelU API
 * Verifica que todas las dependencias y configuraciones estén correctas
 */

const fs = require('fs');
const path = require('path');
const mysql = require('mysql2/promise');

// Colores para la consola
const colors = {
    green: '\x1b[32m',
    red: '\x1b[31m',
    yellow: '\x1b[33m',
    blue: '\x1b[34m',
    reset: '\x1b[0m',
    bold: '\x1b[1m'
};

function log(message, color = colors.reset) {
    console.log(`${color}${message}${colors.reset}`);
}

function success(message) {
    log(`✅ ${message}`, colors.green);
}

function error(message) {
    log(`❌ ${message}`, colors.red);
}

function warning(message) {
    log(`⚠️  ${message}`, colors.yellow);
}

function info(message) {
    log(`ℹ️  ${message}`, colors.blue);
}

async function checkRequiredFiles() {
    info('Verificando archivos requeridos...');
    
    const requiredFiles = [
        'package.json',
        'src/app.js',
        'src/index.js',
        'src/config/default.js'
    ];
    
    let allFilesExist = true;
    
    for (const file of requiredFiles) {
        if (fs.existsSync(file)) {
            success(`${file} existe`);
        } else {
            error(`${file} no encontrado`);
            allFilesExist = false;
        }
    }
    
    return allFilesExist;
}

async function checkEnvironmentVariables() {
    info('Verificando variables de entorno...');
    
    // Intentar cargar dotenv si existe
    try {
        require('dotenv').config();
    } catch (e) {
        warning('dotenv no está instalado o no se pudo cargar');
    }
    
    const requiredEnvVars = [
        'DB_HOST',
        'DB_USER', 
        'DB_PASSWORD',
        'DB_NAME',
        'JWT_SECRET'
    ];
    
    const optionalEnvVars = [
        'PORT',
        'NODE_ENV',
        'CORS_ORIGIN'
    ];
    
    let allRequiredVarsSet = true;
    
    // Verificar variables requeridas
    for (const envVar of requiredEnvVars) {
        if (process.env[envVar] !== undefined) {
            success(`${envVar} está configurado`);
        } else {
            error(`${envVar} no está configurado`);
            allRequiredVarsSet = false;
        }
    }
    
    // Verificar variables opcionales
    for (const envVar of optionalEnvVars) {
        if (process.env[envVar]) {
            success(`${envVar} está configurado: ${process.env[envVar]}`);
        } else {
            warning(`${envVar} no está configurado (opcional)`);
        }
    }
    
    return allRequiredVarsSet;
}

async function checkDatabaseConnection() {
    info('Verificando conexión a la base de datos...');
    
    if (!process.env.DB_HOST || !process.env.DB_USER || !process.env.DB_NAME) {
        error('Variables de base de datos no configuradas');
        return false;
    }
    
    try {
        const connection = await mysql.createConnection({
            host: process.env.DB_HOST,
            port: process.env.DB_PORT || 3306,
            user: process.env.DB_USER,
            password: process.env.DB_PASSWORD,
            database: process.env.DB_NAME
        });
        
        await connection.execute('SELECT 1');
        await connection.end();
        
        success('Conexión a la base de datos exitosa');
        return true;
    } catch (err) {
        error(`Error de conexión a la base de datos: ${err.message}`);
        return false;
    }
}

async function checkDependencies() {
    info('Verificando dependencias...');
    
    const packageJson = JSON.parse(fs.readFileSync('package.json', 'utf8'));
    const requiredDeps = [
        'fastify',
        '@fastify/cors',
        '@fastify/jwt',
        '@fastify/swagger',
        '@fastify/swagger-ui',
        'mysql2'
    ];
    
    let allDepsInstalled = true;
    
    for (const dep of requiredDeps) {
        if (packageJson.dependencies[dep]) {
            try {
                require.resolve(dep);
                success(`${dep} está instalado`);
            } catch (e) {
                error(`${dep} está en package.json pero no está instalado`);
                allDepsInstalled = false;
            }
        } else {
            error(`${dep} no está en package.json`);
            allDepsInstalled = false;
        }
    }
    
    return allDepsInstalled;
}

async function checkDatabaseTables() {
    info('Verificando tablas de la base de datos...');
    
    if (!process.env.DB_HOST || !process.env.DB_USER || !process.env.DB_NAME) {
        warning('No se pueden verificar las tablas - variables de DB no configuradas');
        return false;
    }
    
    try {
        const connection = await mysql.createConnection({
            host: process.env.DB_HOST,
            port: process.env.DB_PORT || 3306,
            user: process.env.DB_USER,
            password: process.env.DB_PASSWORD,
            database: process.env.DB_NAME
        });
        
        const requiredTables = ['users', 'news', 'comments', 'likes'];
        
        for (const table of requiredTables) {
            const [rows] = await connection.execute(
                `SELECT COUNT(*) as count FROM information_schema.tables 
                 WHERE table_schema = ? AND table_name = ?`,
                [process.env.DB_NAME, table]
            );
            
            if (rows[0].count > 0) {
                success(`Tabla ${table} existe`);
            } else {
                warning(`Tabla ${table} no existe - será necesario crearla`);
            }
        }
        
        await connection.end();
        return true;
    } catch (err) {
        warning(`No se pudieron verificar las tablas: ${err.message}`);
        return false;
    }
}

async function displaySummary(checks) {
    console.log('\n' + '='.repeat(50));
    log('📋 RESUMEN DE VERIFICACIONES', colors.bold);
    console.log('='.repeat(50));
    
    const results = [
        { name: 'Archivos requeridos', status: checks.files },
        { name: 'Variables de entorno', status: checks.env },
        { name: 'Dependencias', status: checks.deps },
        { name: 'Conexión a BD', status: checks.db },
        { name: 'Tablas de BD', status: checks.tables }
    ];
    
    results.forEach(result => {
        if (result.status) {
            success(result.name);
        } else {
            error(result.name);
        }
    });
    
    console.log('='.repeat(50));
    
    const allPassed = Object.values(checks).every(Boolean);
    
    if (allPassed) {
        success('✨ ¡Todas las verificaciones pasaron! El servidor está listo para iniciarse.');
        info('Para iniciar el servidor:');
        console.log('  npm run dev     # Desarrollo');
        console.log('  npm start       # Producción');
        info('Documentación disponible en: http://localhost:3001/api/v1/docs');
    } else {
        error('❌ Algunas verificaciones fallaron. Revisa los errores arriba.');
        info('💡 Consejos:');
        console.log('  - Asegúrate de que el archivo .env esté configurado');
        console.log('  - Ejecuta "npm install" para instalar dependencias');
        console.log('  - Verifica que MySQL esté ejecutándose');
        console.log('  - Ejecuta los scripts SQL para crear las tablas');
    }
    
    console.log('='.repeat(50));
    
    return allPassed;
}

async function main() {
    log('🚀 CdelU API - Verificación de Inicio', colors.bold + colors.blue);
    console.log('='.repeat(50));
    
    const checks = {
        files: await checkRequiredFiles(),
        env: await checkEnvironmentVariables(), 
        deps: await checkDependencies(),
        db: await checkDatabaseConnection(),
        tables: await checkDatabaseTables()
    };
    
    const allPassed = await displaySummary(checks);
    
    // Exit code
    process.exit(allPassed ? 0 : 1);
}

// Ejecutar si es llamado directamente
if (require.main === module) {
    main().catch(error => {
        console.error('Error durante la verificación:', error);
        process.exit(1);
    });
}

module.exports = {
    checkRequiredFiles,
    checkEnvironmentVariables,
    checkDatabaseConnection,
    checkDependencies,
    checkDatabaseTables
}; 