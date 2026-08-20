const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');

router.post('/register', authController.registrarAdmin);
router.post('/login', authController.loginAdmin);

const verificarToken = require('../middlewares/verificarToken');

router.get('/teste', verificarToken, (req, res) => {
  res.status(200).json({ mensagem: 'Acesso autorizado!', usuario: req.usuario });
});

module.exports = router;