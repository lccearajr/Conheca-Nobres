const express = require('express');
const cors = require('cors');

const app = express();

// Middlewares globais obrigatórios
app.use(cors());
app.use(express.json());

// Rota de teste recomendada (GET /health)
app.get('/health', (req, res) => {
  res.status(200).json({ status: "ok" });
});

module.exports = app;