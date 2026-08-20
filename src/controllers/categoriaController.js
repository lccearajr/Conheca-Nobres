const pool = require('../config/database');

const listarCategorias = async (req, res) => {
  try {
    const query = 'SELECT id, nome, slug, ordem, ativo FROM categorias ORDER BY ordem';
    const resultado = await pool.query(query);
    res.status(200).json(resultado.rows);
  } catch (erro) {
    console.error(erro);
    res.status(500).json({ erro: 'Erro ao buscar categorias' });
  }
};

const criarCategoria = async (req, res) => {
  try {
    const { nome, slug, ordem, ativo, descricao } = req.body;
    const query = `
      INSERT INTO categorias (nome, slug, ordem, ativo, descricao)
      VALUES ($1, $2, $3, $4, $5)
      RETURNING *
    `;
    const values = [nome, slug, ordem, ativo ?? true, descricao || null];
    const resultado = await pool.query(query, values);
    res.status(201).json(resultado.rows[0]);
  } catch (erro) {
    console.error(erro);
    res.status(500).json({ erro: 'Erro ao criar categoria' });
  }
};

const atualizarCategoria = async (req, res) => {
  try {
    const { id } = req.params;
    const { nome, slug, ordem, ativo, descricao } = req.body;
    const query = `
      UPDATE categorias
      SET nome = $1, slug = $2, ordem = $3, ativo = $4, descricao = $5
      WHERE id = $6
      RETURNING *
    `;
    const values = [nome, slug, ordem, ativo, descricao, id];
    const resultado = await pool.query(query, values);
    if (resultado.rows.length === 0) {
      return res.status(404).json({ erro: 'Categoria não encontrada' });
    }
    res.status(200).json(resultado.rows[0]);
  } catch (erro) {
    console.error(erro);
    res.status(500).json({ erro: 'Erro ao atualizar categoria' });
  }
};

const deletarCategoria = async (req, res) => {
  try {
    const { id } = req.params;
    const query = 'DELETE FROM categorias WHERE id = $1 RETURNING *';
    const resultado = await pool.query(query, [id]);
    if (resultado.rows.length === 0) {
      return res.status(404).json({ erro: 'Categoria não encontrada' });
    }
    res.status(200).json({ mensagem: 'Categoria deletada com sucesso' });
  } catch (erro) {
    console.error(erro);
    res.status(500).json({ erro: 'Erro ao deletar categoria' });
  }
};

module.exports = { listarCategorias, criarCategoria, atualizarCategoria, deletarCategoria };