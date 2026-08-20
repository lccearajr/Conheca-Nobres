const express = require('express');
const router = express.Router();
const experienciaController = require('../controllers/experienciaController');
const verificarToken = require('../middlewares/verificarToken');

router.post('/', verificarToken, experienciaController.criarExperiencia);
router.put('/:id', verificarToken, experienciaController.atualizarExperiencia);
router.delete('/:id', verificarToken, experienciaController.deletarExperiencia);

module.exports = router;