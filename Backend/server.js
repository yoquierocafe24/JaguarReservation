// server.js — Punto de entrada del backend Jaguar Reserva (Persona 1)
// Arranca Express, activa CORS y sesiones, y monta las rutas de login.
// Los demas (Persona 2, 4, 5) agregan sus rutas aqui con app.use(...).

const express = require('express');
const session = require('express-session');
const cors = require('cors');
require('dotenv').config();

require('./db'); // inicia el pool y prueba la conexion a MySQL
const authRoutes = require('./routes/auth');

const app = express();

// --- Middlewares base ---
app.use(express.json()); // para leer JSON del body

// CORS: permite que el frontend (Live Server u otro puerto) llame con la cookie de sesion.
app.use(cors({
  origin: true,      // refleja el origen que hace la peticion
  credentials: true  // necesario para enviar/recibir la cookie de sesion
}));

// Sesiones: guardan { id, rol, nombre } del usuario logueado.
app.use(session({
  secret: process.env.SESSION_SECRET || 'jaguar_secreto',
  resave: false,
  saveUninitialized: false,
  cookie: {
    httpOnly: true,
    maxAge: 1000 * 60 * 60 * 4 // 4 horas
  }
}));

// --- Rutas ---
app.get('/', (req, res) => res.json({ ok: true, mensaje: 'API Jaguar Reserva funcionando' }));
app.use('/', authRoutes);
// Aqui los demas montaran sus rutas, por ejemplo:
//   app.use('/', require('./routes/estudiantes'));  // Persona 2
//   app.use('/', require('./routes/reservas'));      // Persona 4 y 5

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Servidor en http://localhost:${PORT}`));
