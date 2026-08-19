require('dotenv').config();
const app = require('./src/app');

// Carrega o arquivo de configuração para forçar o disparo da conexão com o banco
require('./src/config/database');

const port = process.env.PORT || 3000;

app.listen(port, () => {
  console.log(`🚀 Servidor rodando profissionalmente na porta http://localhost:${port}`);
});