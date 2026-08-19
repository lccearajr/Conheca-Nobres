-- =====================================================
-- DESCUBRA NOBRES
-- Schema inicial do banco de dados
-- Sprint 1 - Modelagem
-- =====================================================

-- =====================================================
-- 1. CATEGORIAS
-- =====================================================

CREATE TABLE IF NOT EXISTS categorias (
    id BIGSERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    slug VARCHAR(120) NOT NULL UNIQUE,
    descricao TEXT,
    imagem_capa_url TEXT,
    ordem INTEGER NOT NULL DEFAULT 0,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    criado_em TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atualizado_em TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 2. PARCEIROS
-- Agências, hotéis, pousadas, transportadoras, guias etc.
-- =====================================================

CREATE TABLE IF NOT EXISTS parceiros (
    id BIGSERIAL PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    slug VARCHAR(180) NOT NULL UNIQUE,
    tipo VARCHAR(50) NOT NULL CHECK (
        tipo IN (
            'agencia',
            'atrativo',
            'hotel',
            'pousada',
            'transportadora',
            'guia',
            'restaurante',
            'outro'
        )
    ),
    descricao TEXT,
    responsavel_nome VARCHAR(150),
    telefone VARCHAR(30),
    whatsapp VARCHAR(30),
    email VARCHAR(150),
    cidade VARCHAR(100),
    endereco TEXT,
    site_url TEXT,
    instagram_url TEXT,
    possui_passeios BOOLEAN NOT NULL DEFAULT FALSE,
    possui_hospedagem BOOLEAN NOT NULL DEFAULT FALSE,
    possui_transporte BOOLEAN NOT NULL DEFAULT FALSE,
    possui_guia BOOLEAN NOT NULL DEFAULT FALSE,
    possui_restaurante BOOLEAN NOT NULL DEFAULT FALSE,
    possui_veiculo_4x4 BOOLEAN NOT NULL DEFAULT FALSE,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    observacoes_internas TEXT,
    criado_em TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atualizado_em TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 3. EXPERIÊNCIAS
-- Cadastro dos passeios e atrativos turísticos
-- =====================================================

CREATE TABLE IF NOT EXISTS experiencias (
    id BIGSERIAL PRIMARY KEY,
    categoria_id BIGINT NOT NULL REFERENCES categorias(id),
    nome VARCHAR(180) NOT NULL,
    slug VARCHAR(220) NOT NULL UNIQUE,
    titulo_comercial VARCHAR(220),
    descricao_curta TEXT NOT NULL,
    descricao_completa TEXT,
    o_que_vai_viver TEXT,
    como_funciona TEXT,
    para_quem_indicado TEXT,
    o_que_levar TEXT,
    incluso TEXT,
    nao_incluso TEXT,
    localizacao VARCHAR(180),
    cidade VARCHAR(100),
    distancia_km NUMERIC(8,2),
    tempo_deslocamento_minutos INTEGER,
    duracao_minutos INTEGER,
    duracao_descricao VARCHAR(100),
    horario_inicio TIME,
    horario_fim TIME,
    dias_funcionamento VARCHAR(200),
    idade_minima INTEGER,
    idade_maxima INTEGER,
    peso_minimo_kg NUMERIC(6,2),
    peso_maximo_kg NUMERIC(6,2),
    altura_minima_metros NUMERIC(4,2),
    dificuldade VARCHAR(30) CHECK (
        dificuldade IS NULL OR dificuldade IN (
            'facil',
            'moderada',
            'dificil',
            'variavel'
        )
    ),
    exige_agendamento BOOLEAN NOT NULL DEFAULT TRUE,
    exige_guia BOOLEAN NOT NULL DEFAULT FALSE,
    transporte_incluso BOOLEAN NOT NULL DEFAULT FALSE,
    valor_referencia_adulto NUMERIC(10,2),
    valor_referencia_crianca NUMERIC(10,2),
    faixa_etaria_crianca VARCHAR(100),
    validade_preco VARCHAR(100),
    restricoes TEXT,
    status VARCHAR(30) NOT NULL DEFAULT 'rascunho' CHECK (
        status IN (
            'rascunho',
            'publicado',
            'arquivado'
        )
    ),
    destaque BOOLEAN NOT NULL DEFAULT FALSE,
    criado_em TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atualizado_em TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 4. OFERTAS
-- Vincula uma experiência a um parceiro específico.
-- Permite preços diferentes para o mesmo atrativo.
-- =====================================================

CREATE TABLE IF NOT EXISTS ofertas (
    id BIGSERIAL PRIMARY KEY,
    experiencia_id BIGINT NOT NULL REFERENCES experiencias(id) ON DELETE CASCADE,
    parceiro_id BIGINT NOT NULL REFERENCES parceiros(id),
    nome_modalidade VARCHAR(180),
    descricao TEXT,
    preco_adulto NUMERIC(10,2),
    preco_crianca NUMERIC(10,2),
    faixa_etaria_crianca VARCHAR(100),
    distancia_km NUMERIC(8,2),
    duracao_minutos INTEGER,
    dias_funcionamento VARCHAR(200),
    horario_inicio TIME,
    horario_fim TIME,
    transporte_incluso BOOLEAN NOT NULL DEFAULT FALSE,
    comissao_percentual NUMERIC(5,2),
    comissao_valor NUMERIC(10,2),
    validade_inicio DATE,
    validade_fim DATE,
    status VARCHAR(30) NOT NULL DEFAULT 'ativa' CHECK (
        status IN (
            'ativa',
            'inativa',
            'expirada'
        )
    ),
    observacoes TEXT,
    criado_em TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atualizado_em TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 5. HOSPEDAGENS
-- =====================================================

CREATE TABLE IF NOT EXISTS hospedagens (
    id BIGSERIAL PRIMARY KEY,
    parceiro_id BIGINT REFERENCES parceiros(id),
    nome VARCHAR(180) NOT NULL,
    slug VARCHAR(220) NOT NULL UNIQUE,
    tipo VARCHAR(50) NOT NULL CHECK (
        tipo IN (
            'hotel',
            'pousada',
            'chale',
            'camping',
            'complexo_turistico',
            'outro'
        )
    ),
    descricao TEXT,
    cidade VARCHAR(100),
    endereco TEXT,
    distancia_bom_jardim_km NUMERIC(8,2),
    tempo_bom_jardim_minutos INTEGER,
    distancia_nobres_km NUMERIC(8,2),
    tempo_nobres_minutos INTEGER,
    capacidade_pessoas INTEGER,
    cafe_da_manha BOOLEAN NOT NULL DEFAULT FALSE,
    restaurante BOOLEAN NOT NULL DEFAULT FALSE,
    piscina BOOLEAN NOT NULL DEFAULT FALSE,
    estacionamento BOOLEAN NOT NULL DEFAULT FALSE,
    wifi BOOLEAN NOT NULL DEFAULT FALSE,
    ar_condicionado BOOLEAN NOT NULL DEFAULT FALSE,
    aceita_animais BOOLEAN NOT NULL DEFAULT FALSE,
    valor_diaria_referencia NUMERIC(10,2),
    observacoes TEXT,
    status VARCHAR(30) NOT NULL DEFAULT 'rascunho' CHECK (
        status IN (
            'rascunho',
            'publicado',
            'arquivado'
        )
    ),
    criado_em TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atualizado_em TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 6. TRANSPORTES
-- =====================================================

CREATE TABLE IF NOT EXISTS transportes (
    id BIGSERIAL PRIMARY KEY,
    parceiro_id BIGINT REFERENCES parceiros(id),
    nome VARCHAR(180) NOT NULL,
    tipo_veiculo VARCHAR(50) NOT NULL CHECK (
        tipo_veiculo IN (
            'carro',
            'van',
            'suv',
            '4x4',
            'onibus',
            'outro'
        )
    ),
    capacidade_passageiros INTEGER NOT NULL,
    origem VARCHAR(150),
    destino VARCHAR(150),
    distancia_km NUMERIC(8,2),
    tempo_estimado_minutos INTEGER,
    privativo BOOLEAN NOT NULL DEFAULT TRUE,
    compartilhado BOOLEAN NOT NULL DEFAULT FALSE,
    ar_condicionado BOOLEAN NOT NULL DEFAULT FALSE,
    espaco_bagagem BOOLEAN NOT NULL DEFAULT TRUE,
    cadeirinha_infantil BOOLEAN NOT NULL DEFAULT FALSE,
    preco_referencia NUMERIC(10,2),
    observacoes TEXT,
    status VARCHAR(30) NOT NULL DEFAULT 'ativo' CHECK (
        status IN (
            'ativo',
            'inativo'
        )
    ),
    criado_em TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atualizado_em TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 7. CLIENTES
-- =====================================================

CREATE TABLE IF NOT EXISTS clientes (
    id BIGSERIAL PRIMARY KEY,
    nome VARCHAR(180) NOT NULL,
    email VARCHAR(180),
    telefone VARCHAR(30),
    whatsapp VARCHAR(30),
    cidade_origem VARCHAR(100),
    estado_origem VARCHAR(2),
    observacoes TEXT,
    criado_em TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atualizado_em TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 8. VIAGENS
-- Uma viagem representa o planejamento completo de um cliente.
-- =====================================================

CREATE TABLE IF NOT EXISTS viagens (
    id BIGSERIAL PRIMARY KEY,
    cliente_id BIGINT REFERENCES clientes(id),
    nome VARCHAR(180),
    codigo VARCHAR(30) UNIQUE,
    data_entrada DATE,
    data_saida DATE,
    quantidade_adultos INTEGER NOT NULL DEFAULT 0,
    quantidade_criancas INTEGER NOT NULL DEFAULT 0,
    observacoes TEXT,
    status VARCHAR(40) NOT NULL DEFAULT 'rascunho' CHECK (
        status IN (
            'rascunho',
            'solicitada',
            'em_analise',
            'consultando_parceiros',
            'aguardando_cliente',
            'proposta_enviada',
            'aguardando_confirmacao',
            'confirmada',
            'em_andamento',
            'concluida',
            'cancelada',
            'arquivada'
        )
    ),
    hospedagem_id BIGINT REFERENCES hospedagens(id),
    transporte_id BIGINT REFERENCES transportes(id),
    criado_em TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atualizado_em TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 9. DIAS DO ROTEIRO
-- =====================================================

CREATE TABLE IF NOT EXISTS roteiro_dias (
    id BIGSERIAL PRIMARY KEY,
    viagem_id BIGINT NOT NULL REFERENCES viagens(id) ON DELETE CASCADE,
    numero_dia INTEGER NOT NULL,
    data_dia DATE,
    titulo VARCHAR(180),
    observacoes TEXT,
    UNIQUE (viagem_id, numero_dia)
);

-- =====================================================
-- 10. ITENS DO ROTEIRO
-- Experiências, refeições ou outros serviços adicionados a um dia.
-- =====================================================

CREATE TABLE IF NOT EXISTS roteiro_itens (
    id BIGSERIAL PRIMARY KEY,
    roteiro_dia_id BIGINT NOT NULL REFERENCES roteiro_dias(id) ON DELETE CASCADE,
    experiencia_id BIGINT REFERENCES experiencias(id),
    hospedagem_id BIGINT REFERENCES hospedagens(id),
    transporte_id BIGINT REFERENCES transportes(id),
    tipo VARCHAR(30) NOT NULL CHECK (
        tipo IN (
            'experiencia',
            'hospedagem',
            'transporte',
            'restaurante',
            'observacao'
        )
    ),
    titulo VARCHAR(180) NOT NULL,
    horario_inicio TIME,
    horario_fim TIME,
    periodo VARCHAR(20) CHECK (
        periodo IS NULL OR periodo IN (
            'manha',
            'tarde',
            'noite',
            'integral'
        )
    ),
    ordem INTEGER NOT NULL DEFAULT 0,
    quantidade_adultos INTEGER DEFAULT 0,
    quantidade_criancas INTEGER DEFAULT 0,
    observacoes TEXT,
    criado_em TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 11. MÍDIAS
-- Fotos, vídeos e materiais autorizados.
-- =====================================================

CREATE TABLE IF NOT EXISTS midias (
    id BIGSERIAL PRIMARY KEY,
    experiencia_id BIGINT REFERENCES experiencias(id) ON DELETE CASCADE,
    hospedagem_id BIGINT REFERENCES hospedagens(id) ON DELETE CASCADE,
    parceiro_id BIGINT REFERENCES parceiros(id) ON DELETE SET NULL,
    tipo VARCHAR(30) NOT NULL CHECK (
        tipo IN (
            'foto',
            'video',
            'drone',
            'reels',
            'mapa',
            'depoimento'
        )
    ),
    url TEXT NOT NULL,
    thumbnail_url TEXT,
    titulo VARCHAR(180),
    descricao TEXT,
    autor VARCHAR(180),
    fonte VARCHAR(180),
    autorizado BOOLEAN NOT NULL DEFAULT FALSE,
    data_autorizacao DATE,
    credito VARCHAR(180),
    ordem INTEGER NOT NULL DEFAULT 0,
    destaque BOOLEAN NOT NULL DEFAULT FALSE,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    criado_em TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 12. AVALIAÇÕES
-- =====================================================

CREATE TABLE IF NOT EXISTS avaliacoes (
    id BIGSERIAL PRIMARY KEY,
    experiencia_id BIGINT REFERENCES experiencias(id) ON DELETE CASCADE,
    hospedagem_id BIGINT REFERENCES hospedagens(id) ON DELETE CASCADE,
    cliente_id BIGINT REFERENCES clientes(id) ON DELETE SET NULL,
    nota INTEGER NOT NULL CHECK (nota BETWEEN 1 AND 5),
    comentario TEXT NOT NULL,
    nome_exibicao VARCHAR(120),
    data_visita DATE,
    status VARCHAR(30) NOT NULL DEFAULT 'pendente' CHECK (
        status IN (
            'pendente',
            'aprovada',
            'rejeitada',
            'arquivada'
        )
    ),
    criado_em TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 13. SOLICITAÇÕES
-- Registro formal enviado pelo turista.
-- =====================================================

CREATE TABLE IF NOT EXISTS solicitacoes (
    id BIGSERIAL PRIMARY KEY,
    viagem_id BIGINT NOT NULL UNIQUE REFERENCES viagens(id),
    codigo VARCHAR(30) NOT NULL UNIQUE,
    nome_contato VARCHAR(180) NOT NULL,
    email_contato VARCHAR(180),
    telefone_contato VARCHAR(30),
    canal_preferido VARCHAR(30) CHECK (
        canal_preferido IS NULL OR canal_preferido IN (
            'whatsapp',
            'email',
            'telefone'
        )
    ),
    mensagem_cliente TEXT,
    valor_estimado NUMERIC(10,2),
    status VARCHAR(40) NOT NULL DEFAULT 'recebida' CHECK (
        status IN (
            'recebida',
            'em_analise',
            'consultando_parceiros',
            'aguardando_cliente',
            'proposta_enviada',
            'aguardando_confirmacao',
            'confirmada',
            'cancelada',
            'concluida'
        )
    ),
    criado_em TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atualizado_em TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- ÍNDICES INICIAIS
-- =====================================================

CREATE INDEX IF NOT EXISTS idx_experiencias_categoria
    ON experiencias(categoria_id);

CREATE INDEX IF NOT EXISTS idx_experiencias_status
    ON experiencias(status);

CREATE INDEX IF NOT EXISTS idx_experiencias_cidade
    ON experiencias(cidade);

CREATE INDEX IF NOT EXISTS idx_ofertas_experiencia
    ON ofertas(experiencia_id);

CREATE INDEX IF NOT EXISTS idx_ofertas_parceiro
    ON ofertas(parceiro_id);

CREATE INDEX IF NOT EXISTS idx_hospedagens_cidade
    ON hospedagens(cidade);

CREATE INDEX IF NOT EXISTS idx_transportes_origem_destino
    ON transportes(origem, destino);

CREATE INDEX IF NOT EXISTS idx_viagens_cliente
    ON viagens(cliente_id);

CREATE INDEX IF NOT EXISTS idx_viagens_status
    ON viagens(status);

CREATE INDEX IF NOT EXISTS idx_solicitacoes_status
    ON solicitacoes(status);

-- =====================================================
-- CATEGORIAS INICIAIS
-- =====================================================

INSERT INTO categorias (nome, slug, descricao, ordem)
VALUES
    (
        'Flutuações',
        'flutuacoes',
        'Experiências em águas cristalinas, rios, nascentes e aquários naturais.',
        1
    ),
    (
        'Aventura',
        'aventura',
        'Passeios com emoção, trilhas, bóia cross, quadriciclo e atividades de aventura.',
        2
    ),
    (
        'Balneários',
        'balnearios',
        'Banho de rio, piscinas, day use e estruturas de lazer.',
        3
    ),
    (
        'Atividades náuticas',
        'atividades-nauticas',
        'Caiaque, stand up paddle e experiências em rios.',
        4
    ),
    (
        'Contemplação',
        'contemplacao',
        'Pôr do sol, observação da natureza, passeios a cavalo e paisagens.',
        5
    ),
    (
        'Cultura e gastronomia',
        'cultura-e-gastronomia',
        'Experiências culturais, gastronômicas e de valorização da comunidade local.',
        6
    )
ON CONFLICT (slug) DO NOTHING;

-- =====================================================
-- PARCEIROS INICIAIS
-- =====================================================

INSERT INTO parceiros (
    nome,
    slug,
    tipo,
    descricao,
    possui_passeios,
    possui_hospedagem,
    possui_transporte,
    possui_guia,
    ativo
)
VALUES
    (
        'Araras Tur',
        'araras-tur',
        'agencia',
        'Agência parceira para passeios, hospedagem, transporte e atendimento local.',
        TRUE,
        TRUE,
        TRUE,
        TRUE,
        TRUE
    ),
    (
        'Agência Bom Jardim Turismo',
        'agencia-bom-jardim-turismo',
        'agencia',
        'Agência de turismo receptivo localizada no complexo da Pousada Bom Jardim.',
        TRUE,
        TRUE,
        FALSE,
        TRUE,
        TRUE
    )
ON CONFLICT (slug) DO NOTHING;