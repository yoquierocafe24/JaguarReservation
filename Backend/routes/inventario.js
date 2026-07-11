const express = require('express');
const router = express.Router();
const db = require('../db');

// =====================================
// OBTENER JUEGOS ACTIVOS
// =====================================
router.get('/juegos', async (req, res) => {

    try {

        const [rows] = await db.query(`
            SELECT
                id_item,
                nombre,
                categoria,
                cantidad_total
            FROM Inventario
            WHERE estado = 'activo'
            ORDER BY nombre
        `);

        res.json({
            ok: true,
            juegos: rows
        });

    } catch (error) {

        console.error(error);

        res.status(500).json({
            ok: false,
            mensaje: 'Error al obtener el inventario.'
        });

    }

});

module.exports = router;