-- ==========================
-- TRANSFORMAÇÃO 4 (T4) – MODELAGEM DIMENSIONAL (ESQUEMA ESTRELA)
-- Autor: Thiago
-- Objetivo:
-- 1) Criação das tabelas de Dimensão (Localidade, Poste, Atualização)
-- 2) Geração de IDs únicos (Surrogate Keys) via Hash (MD5) para integridade
-- 3) Criação da Tabela Fato (Iluminação) contendo métricas e chaves estrangeiras
-- 4) Estruturação final dos dados para consumo em ferramentas de BI/Analytics
-- ==========================

-- 1. DIMENSÃO LOCALIDADE (Onde?)
DROP TABLE IF EXISTS dim_localidade;
CREATE TABLE dim_localidade AS
SELECT DISTINCT
    MD5(COALESCE(bairro, '') || COALESCE(endereco, '') || COALESCE(rpa, '')) AS id_localidade,
    bairro,
    endereco,
    rpa,
    localizacao AS tipo_localizacao,
    latitude,
    longitude
FROM silver_iluminacao
WHERE bairro IS NOT NULL;

-- 2. DIMENSÃO POSTE (O quê?)
DROP TABLE IF EXISTS dim_poste;
CREATE TABLE dim_poste AS
SELECT DISTINCT
    MD5(COALESCE(tipo_de_po, '') || COALESCE(tipo_lumin, '') || COALESCE(tipo_lampa, '')) AS id_poste,
    tipo_de_po AS tipo_poste,
    tipo_lumin AS tipo_luminaria,
    tipo_lampa AS tipo_lampada,
    barramento,
    medicao
FROM silver_iluminacao;

-- 3. DIMENSÃO ATUALIZAÇÃO (Quando?)
DROP TABLE IF EXISTS dim_atualizacao;
CREATE TABLE dim_atualizacao AS
SELECT DISTINCT
    MD5(COALESCE(atualizacao::TEXT, '')) AS id_atualizacao,
    atualizacao::DATE AS data_atualizacao,
    EXTRACT(YEAR FROM atualizacao::DATE) AS ano,
    EXTRACT(MONTH FROM atualizacao::DATE) AS mes,
    EXTRACT(DAY FROM atualizacao::DATE) AS dia
FROM silver_iluminacao
WHERE atualizacao IS NOT NULL;

-- 4. TABELA FATO ILUMINAÇÃO (Métricas)
DROP TABLE IF EXISTS fato_iluminacao;
CREATE TABLE fato_iluminacao AS
SELECT
    -- Chaves Estrangeiras (FKs)
    MD5(COALESCE(s.bairro, '') || COALESCE(s.endereco, '') || COALESCE(s.rpa, '')) AS id_localidade,
    MD5(COALESCE(s.tipo_de_po, '') || COALESCE(s.tipo_lumin, '') || COALESCE(s.tipo_lampa, '')) AS id_poste,
    MD5(COALESCE(s.atualizacao::TEXT, '')) AS id_atualizacao,
    
    -- ID de Rastreabilidade (Degenerate Dimension)
    s.id_ponto,
    
    -- Métricas
    s.qtde::INTEGER AS quantidade,
    s.potencia::NUMERIC AS potencia_w,
    s.perdas::NUMERIC AS perdas_w,
    s.total_carg::NUMERIC AS carga_total,
    s.consumo_kw,
    s.bloq_amp AS bloqueio_amp
FROM silver_iluminacao s;