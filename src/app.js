const express = require('express');
const cors = require('cors');
const categoriaRoutes = require('./routes/categoriaRoutes');


const authRoutes = require('./routes/authRoutes');
const app = express();
const experienciaRoutes = require('./routes/experienciaRoutes');
const adminExperienciaRoutes = require('./routes/adminExperienciaRoutes');

// Middlewares globais obrigatórios
app.use(cors());
app.use(express.json());
app.use('/categorias', categoriaRoutes);
app.use('/admin', authRoutes);
app.use('/experiencias', experienciaRoutes);
app.use('/admin/experiencias', adminExperienciaRoutes);

// Rota de teste recomendada (GET /health)
app.get('/health', (req, res) => {
  res.status(200).json({ status: "ok" });
});

module.exports = app;