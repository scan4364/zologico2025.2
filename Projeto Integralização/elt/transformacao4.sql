-- ==========================
-- TRANSFORMAÇÃO 4 (T4) – MODELAGEM DIMENSIONAL (ESQUEMA ESTRELA) - CORRIGIDA
-- Autor: Thiago (Corrigido)
-- Objetivo:
-- 1) Criação das tabelas de Dimensão a partir de 'postes_normalizado'
-- 2) Ajuste de colunas removidas e renomeadas nas etapas anteriores
-- 3) Tratamento de tipos de dados (Texto -> Numérico/Data)
-- ==========================

-- 1. DIMENSÃO LOCALIDADE (Onde?)
DROP TABLE IF EXISTS dim_localidade;
CREATE TABLE dim_localidade AS
SELECT DISTINCT
    MD5(COALESCE(bairro, '') || COALESCE(endereco, '') || COALESCE(rpa, '')) AS id_localidade,
    bairro,
    endereco,
    rpa,
    localizacao AS tipo_localizacao
FROM postes_normalizado
WHERE bairro IS NOT NULL;

-- 2. DIMENSÃO POSTE (O quê?)
DROP TABLE IF EXISTS dim_poste;
CREATE TABLE dim_poste AS
SELECT DISTINCT
    MD5(COALESCE(tipo_de_poste, '') || COALESCE(tipo_lumin, '') || COALESCE(tipo_lampa, '')) AS id_poste,
    tipo_de_poste AS tipo_poste,
    tipo_lumin AS tipo_luminaria,
    tipo_lampa AS tipo_lampada,
    barramento,
    medicao
FROM postes_normalizado;

-- 3. DIMENSÃO ATUALIZAÇÃO (Quando?)
DROP TABLE IF EXISTS dim_atualizacao;
CREATE TABLE dim_atualizacao AS
SELECT DISTINCT
    MD5(COALESCE(data_atualizacao, '')) AS id_atualizacao,
    
    -- Se for o valor texto padrão de nulo, transforma em NULL para o campo data
    NULLIF(data_atualizacao, 'NAO_REGISTRADO_MODERNIZACAO')::DATE AS data_atualizacao,
    
    -- Extração segura de datas (retorna NULL se não houver data válida)
    EXTRACT(YEAR FROM NULLIF(data_atualizacao, 'NAO_REGISTRADO_MODERNIZACAO')::DATE) AS ano,
    EXTRACT(MONTH FROM NULLIF(data_atualizacao, 'NAO_REGISTRADO_MODERNIZACAO')::DATE) AS mes,
    EXTRACT(DAY FROM NULLIF(data_atualizacao, 'NAO_REGISTRADO_MODERNIZACAO')::DATE) AS dia
FROM postes_normalizado
WHERE data_atualizacao IS NOT NULL;

-- 4. TABELA FATO ILUMINAÇÃO (Métricas)
DROP TABLE IF EXISTS fato_iluminacao;
CREATE TABLE fato_iluminacao AS
SELECT
    -- Chaves Estrangeiras (FKs)
    MD5(COALESCE(s.bairro, '') || COALESCE(s.endereco, '') || COALESCE(s.rpa, '')) AS id_localidade,
    MD5(COALESCE(s.tipo_de_poste, '') || COALESCE(s.tipo_lumin, '') || COALESCE(s.tipo_lampa, '')) AS id_poste,
    MD5(COALESCE(s.data_atualizacao, '')) AS id_atualizacao,
    
    -- ID de Rastreabilidade (Degenerate Dimension)
    s.id_ponto,
    
    -- Métricas
    -- Conversão explícita de texto para numérico, tratando possíveis vírgulas
    CAST(REPLACE(s.qtde, ',', '.') AS INTEGER) AS quantidade,
    CAST(REPLACE(s.potencia, ',', '.') AS NUMERIC) AS potencia_w,
    CAST(REPLACE(s.perdas, ',', '.') AS NUMERIC) AS perdas_w,
    CAST(REPLACE(s.total_carga, ',', '.') AS NUMERIC) AS carga_total,
    CAST(REPLACE(s.consumo_kwh, ',', '.') AS NUMERIC) AS consumo_kwh
    
    -- 'bloq_amp' foi removido pois não existe na tabela de origem (removido na T2)
FROM postes_normalizado s;