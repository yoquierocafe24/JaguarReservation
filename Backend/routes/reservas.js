const express = require('express');
const router = express.Router();
const db = require('../db');

// =======================================
// Generar ID de reserva (R001, R002...)
// =======================================
async function generarIdReserva() {

    const [rows] = await db.query(`
        SELECT id_reserva
        FROM Reservas
        ORDER BY id_reserva DESC
        LIMIT 1
    `);

    if (rows.length === 0) {
        return "R001";
    }

    const ultimo = parseInt(rows[0].id_reserva.substring(1));
    const nuevo = ultimo + 1;

    return "R" + String(nuevo).padStart(3, "0");
}

// =======================================
// Crear Reserva
// POST /api/reservas
// =======================================

router.post('/', async (req, res) => {

    try {

       // Verificar sesión
        if (!req.session.usuario) {
            return res.status(401).json({
                ok: false,
                mensaje: "Debe iniciar sesión."
            });
        }

        // Solo estudiantes pueden reservar
        if (req.session.usuario.rol !== "estudiante") {
            return res.status(403).json({
                ok: false,
                mensaje: "No tiene permisos para realizar reservas."
            });
        }

        // El id del estudiante sale de la sesión
        const id_estudiante = req.session.usuario.id;

        const {

            id_espacio,
            id_item,
            tipo_reserva,
            id_equipo,
            fecha,
            hora_inicio,
            hora_fin,
            telefono,
            solicitud_especial,
            cant_acompanantes

        } = req.body;

        // Validación
        if (!fecha || !hora_inicio || !hora_fin) {

            return res.status(400).json({
                ok: false,
                mensaje: "Faltan datos obligatorios."
            });

        }

        // Validar estudiante

        const [estudiante] = await db.query(

            `SELECT * FROM Estudiantes
             WHERE id_estudiante = ?
             AND activo = 1`,

            [id_estudiante]

        );

        if (estudiante.length === 0) {

            return res.status(404).json({

                ok: false,
                mensaje: "El estudiante no existe o está inactivo."

            });

        }

        // Validar horario ocupado

        const [ocupado] = await db.query(

            `SELECT *
            FROM Reservas
            WHERE id_espacio = ?
            AND fecha = ?
            AND estado IN ('pendiente','aprobada')
            AND (
                (? BETWEEN hora_inicio AND hora_fin)
                OR
                (? BETWEEN hora_inicio AND hora_fin)
            )`,

            [

                id_espacio,
                fecha,
                hora_inicio,
                hora_fin

            ]

        );

        if (ocupado.length > 0) {

            return res.status(400).json({

                ok: false,
                mensaje: "Ese horario ya se encuentra reservado."

            });

        }

        // Crear ID

        const id_reserva = await generarIdReserva();

        // Estado

        let estado = "aprobada";

        if (id_item != null) {
            estado = "pendiente";

        }

        // Guardar reserva 

        await db.query(

            `INSERT INTO Reservas(

                id_reserva,
                id_estudiante,
                id_espacio,
                id_item,
                tipo_reserva,
                id_equipo,
                fecha,
                hora_inicio,
                hora_fin,
                telefono,
                solicitud_especial,
                cant_acompanantes,
                estado

            )

            VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)`,

            [

                id_reserva,
                id_estudiante,
                id_espacio,
                id_item,
                tipo_reserva || "individual",
                id_equipo,
                fecha,
                hora_inicio,
                hora_fin,
                telefono,
                solicitud_especial,
                cant_acompanantes || 0,
                estado

            ]

        );

        res.json({

            ok: true,
            mensaje: "Reserva creada correctamente.",
            id_reserva

        });

    }

    catch (error) {

        console.log(error);

        res.status(500).json({

            ok: false,
            mensaje: "Error del servidor."

        });

    }

});

// =======================================
// Obtener todas las reservas
// =======================================

router.get('/', async (req, res) => {

    try {
 // Debe haber sesión
        if (!req.session.usuario) {
            return res.status(401).json({
                ok: false,
                mensaje: "Debe iniciar sesión."
            });
        }

        let rows;

        // Si es administrador, ve todas las reservas
        if (req.session.usuario.rol === "admin") {

            [rows] = await db.query(`
                SELECT *
                FROM Reservas
                ORDER BY fecha, hora_inicio
            `);

        }

        // Si es estudiante, solo ve las suyas
        else if (req.session.usuario.rol === "estudiante") {

            [rows] = await db.query(

                `SELECT *
                 FROM Reservas
                 WHERE id_estudiante = ?
                 ORDER BY fecha, hora_inicio`,

                [req.session.usuario.id]

            );

        }

        else {

            return res.status(403).json({
                ok: false,
                mensaje: "No tiene permisos."
            });

        }

        res.json({
            ok: true,
            reservas: rows
        });

    } catch (error) {

        console.error(error);

        res.status(500).json({
            ok: false,
            mensaje: "Error del servidor."
        });

    }

});

// =======================================
// Obtener reserva por ID
// =======================================

router.get('/:id', async (req,res)=>{

    try{

        if (!req.session.usuario) {

            return res.status(401).json({
                ok: false,
                mensaje: "Debe iniciar sesión."
            });

        }

        const [rows] = await db.query(

            `SELECT *
             FROM Reservas
             WHERE id_reserva = ?`,

            [req.params.id]

        );

        if (rows.length === 0) {

            return res.status(404).json({
                ok: false,
                mensaje: "Reserva no encontrada."
            });

        }

        const reserva = rows[0];

        // Si es estudiante solo puede ver la suya
        if (
            req.session.usuario.rol === "estudiante" &&
            reserva.id_estudiante !== req.session.usuario.id
        ) {

            return res.status(403).json({
                ok: false,
                mensaje: "No tiene permisos."
            });

        }

        res.json({
            ok: true,
            reserva
        });

    } catch (error) {

        console.error(error);

        res.status(500).json({
            ok: false,
            mensaje: "Error del servidor."
        });

    }

});

// =======================================
// Cancelar Reserva
// =======================================

router.put('/:id/cancelar', async(req,res)=>{

    try{

         if (!req.session.usuario) {

            return res.status(401).json({
                ok: false,
                mensaje: "Debe iniciar sesión."
            });

        }

        const [rows] = await db.query(

            `SELECT *
             FROM Reservas
             WHERE id_reserva = ?`,

            [req.params.id]

        );

        if (rows.length === 0) {

            return res.status(404).json({
                ok: false,
                mensaje: "Reserva no encontrada."
            });

        }

        const reserva = rows[0];

        // Un estudiante solo puede cancelar sus reservas
        if (
            req.session.usuario.rol === "estudiante" &&
            reserva.id_estudiante !== req.session.usuario.id
        ) {

            return res.status(403).json({
                ok: false,
                mensaje: "No tiene permisos."
            });

        }

        const cancelado_por =
            req.session.usuario.rol === "admin"
                ? "admin"
                : "estudiante";

        await db.query(

            `UPDATE Reservas
             SET estado='cancelada',
                 cancelado_por=?
             WHERE id_reserva=?`,

            [
                cancelado_por,
                req.params.id
            ]

        );

        res.json({

            ok: true,
            mensaje: "Reserva cancelada."

        });

    } catch (error) {

        console.error(error);

        res.status(500).json({

            ok: false,
            mensaje: "Error del servidor."

        });

    }

});

module.exports = router;