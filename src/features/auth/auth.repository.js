"use strict";

const pool = require('../../config/database');

async function findUserByEmail(email) {
  const [rows] = await pool.query(
    `SELECT id, nombre, email, password, role_id, profile_picture_url, created_at
     FROM users
     WHERE email = ?`,
    [email]
  );
  if (rows.length === 0) return null;
  const user = rows[0];
  const roleMap = { 1: 'administrador', 2: 'colaborador', 3: 'usuario' };
  user.rol = roleMap[user.role_id] || 'usuario';
  return user;
}

async function findUserById(id) {
  const [rows] = await pool.query(
    `SELECT id, nombre, email, role_id, profile_picture_url, created_at
     FROM users
     WHERE id = ?`,
    [id]
  );
  if (rows.length === 0) return null;
  const user = rows[0];
  const roleMap = { 1: 'administrador', 2: 'colaborador', 3: 'usuario' };
  user.rol = roleMap[user.role_id] || 'usuario';
  return user;
}

async function emailExists(email) {
  const [rows] = await pool.query('SELECT id FROM users WHERE email = ?', [email]);
  return rows.length > 0;
}

async function insertUser({ nombre, email, passwordHash, rol }) {
  // Mapear nombre de rol a id
  const roleMap = {
    'administrador': 1,
    'colaborador': 2,
    'usuario': 3
  };
  const roleId = roleMap[rol] || 3;

  const [result] = await pool.query(
    `INSERT INTO users (nombre, email, password, role_id)
     VALUES (?, ?, ?, ?)`,
    [nombre, email, passwordHash, roleId]
  );
  return result.insertId;
}

async function updateUserProfile(id, { nombre, email }) {
  const [result] = await pool.query(
    'UPDATE users SET nombre = ?, email = ? WHERE id = ?',
    [nombre, email, id]
  );
  return result.affectedRows > 0;
}

async function otherUserHasEmail(email, excludeUserId) {
  const [rows] = await pool.query(
    'SELECT id FROM users WHERE email = ? AND id != ?',
    [email, excludeUserId]
  );
  return rows.length > 0;
}

module.exports = {
  findUserByEmail,
  findUserById,
  emailExists,
  insertUser,
  updateUserProfile,
  otherUserHasEmail,
};


