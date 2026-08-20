const express = require('express');
const router = express.Router();
const experienciaController = require('../controllers/experienciaController');

router.get('/', experienciaController.listarExperiencias);
router.get('/categoria/:categoriaId', experienciaController.listarPorCategoria);
router.get('/:id', experienciaController.buscarPorId);

module.exports = router;