const pool = require('../config/database');

const gerarSlug = (texto) => {
  return texto
    .toLowerCase()
    .normalize('NFD').replace(/[\u0300-\u036f]/g, '')
    .replace(/[^a-z0-9\s-]/g, '')
    .trim()
    .replace(/\s+/g, '-');
};

const listarExperiencias = async (req, res) => {
  try {
    const query = `
      SELECT id, nome, slug, categoria_id, descricao_curta, distancia_km, duracao_minutos, status
      FROM experiencias
      WHERE status = 'publicado'
      ORDER BY nome
    `;
    const resultado = await pool.query(query);
    res.status(200).json(resultado.rows);
  } catch (erro) {
    console.error(erro);
    res.status(500).json({ erro: 'Erro ao buscar experiências' });
  }
};

const listarPorCategoria = async (req, res) => {
  try {
    const { categoriaId } = req.params;
    const query = `
      SELECT id, nome, slug, categoria_id, descricao_curta, distancia_km, duracao_minutos, status
      FROM experiencias
      WHERE categoria_id = $1 AND status = 'publicado'
      ORDER BY nome
    `;
    const resultado = await pool.query(query, [categoriaId]);
    res.status(200).json(resultado.rows);
  } catch (erro) {
    console.error(erro);
    res.status(500).json({ erro: 'Erro ao buscar experiências por categoria' });
  }
};

const buscarPorId = async (req, res) => {
  try {
    const { id } = req.params;
    const query = 'SELECT * FROM experiencias WHERE id = $1';
    const resultado = await pool.query(query, [id]);
    if (resultado.rows.length === 0) {
      return res.status(404).json({ erro: 'Experiência não encontrada' });
    }
    res.status(200).json(resultado.rows[0]);
  } catch (erro) {
    console.error(erro);
    res.status(500).json({ erro: 'Erro ao buscar experiência' });
  }
};

const criarExperiencia = async (req, res) => {
  try {
    const {
      nome, categoria_id, descricao_curta, descricao_completa,
      distancia_km, duracao_minutos, idade_minima, dificuldade, status
    } = req.body;

    if (!nome || !categoria_id || !descricao_curta) {
      return res.status(400).json({ erro: 'nome, categoria_id e descricao_curta são obrigatórios' });
    }

    const slug = gerarSlug(nome);

    const query = `
      INSERT INTO experiencias
        (nome, slug, categoria_id, descricao_curta, descricao_completa, distancia_km, duracao_minutos, idade_minima, dificuldade, status)
      VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10)
      RETURNING *
    `;
    const values = [
      nome, slug, categoria_id, descricao_curta, descricao_completa || null,
      distancia_km || null, duracao_minutos || null, idade_minima || null,
      dificuldade || null, status || 'rascunho'
    ];
    const resultado = await pool.query(query, values);
    res.status(201).json(resultado.rows[0]);
  } catch (erro) {
    console.error(erro);
    if (erro.code === '23505') {
      return res.status(409).json({ erro: 'Já existe uma experiência com esse nome' });
    }
    res.status(500).json({ erro: 'Erro ao criar experiência' });
  }
};

const atualizarExperiencia = async (req, res) => {
  try {
    const { id } = req.params;
    const {
      nome, categoria_id, descricao_curta, descricao_completa,
      distancia_km, duracao_minutos, idade_minima, dificuldade, status
    } = req.body;

    const slug = nome ? gerarSlug(nome) : null;

    const query = `
      UPDATE experiencias
      SET nome=$1, slug=COALESCE($2, slug), categoria_id=$3, descricao_curta=$4, descricao_completa=$5,
          distancia_km=$6, duracao_minutos=$7, idade_minima=$8, dificuldade=$9, status=$10,
          atualizado_em=CURRENT_TIMESTAMP
      WHERE id=$11
      RETURNING *
    `;
    const values = [
      nome, slug, categoria_id, descricao_curta, descricao_completa,
      distancia_km, duracao_minutos, idade_minima, dificuldade, status, id
    ];
    const resultado = await pool.query(query, values);
    if (resultado.rows.length === 0) {
      return res.status(404).json({ erro: 'Experiência não encontrada' });
    }
    res.status(200).json(resultado.rows[0]);
  } catch (erro) {
    console.error(erro);
    res.status(500).json({ erro: 'Erro ao atualizar experiência' });
  }
};

const deletarExperiencia = async (req, res) => {
  try {
    const { id } = req.params;
    const query = `
      UPDATE experiencias SET status = 'arquivado' WHERE id = $1 RETURNING *
    `;
    const resultado = await pool.query(query, [id]);
    if (resultado.rows.length === 0) {
      return res.status(404).json({ erro: 'Experiência não encontrada' });
    }
    res.status(200).json({ mensagem: 'Experiência despublicada com sucesso' });
  } catch (erro) {
    console.error(erro);
    res.status(500).json({ erro: 'Erro ao remover experiência' });
  }
};

module.exports = {
  listarExperiencias, listarPorCategoria, buscarPorId,
  criarExperiencia, atualizarExperiencia, deletarExperiencia
};