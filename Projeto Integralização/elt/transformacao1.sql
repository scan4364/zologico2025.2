-- ============================================================
-- TRANSFORMAÇÃO 1 (T1) – UNIFICAÇÃO E PADRONIZAÇÃO ESTRUTURAL
-- Autor: Vitor
-- Objetivo:
-- 1) Unificar bases de 2023, 2024 e 2025
-- 2) Padronizar nomes de colunas divergentes entre os anos
-- 3) Criar a coluna ano_original
-- 4) Manter todos os dados sem limpeza (modelo ELT)
-- ============================================================

DROP TABLE IF EXISTS stg_iluminacao_unificada;

CREATE TABLE stg_iluminacao_unificada AS

-- =======================
-- BASE 2023
-- =======================
SELECT
    id_ponto::TEXT,
    sequencia::TEXT,
    rpa::TEXT,
    localizaca::TEXT,
    endereco::TEXT,
    barramento::TEXT                         AS barramento,
    latitude::TEXT,
    longitude::TEXT,
    bairro::TEXT,
    medicao::TEXT,
    tipo_lumin::TEXT,
    tipo_de_po::TEXT,
    tipo_lampa::TEXT,
    qtde::TEXT,
    potencia::TEXT,
    perdas::TEXT,
    total_carg::TEXT,
    consumo_kw::TEXT,
    potencia_1::TEXT,
    perdas_1::TEXT,
    total_ca_1::TEXT,
    consumo__1::TEXT                         AS consumo_1,
    "atualizaç"::TEXT                        AS atualizacao,
    bloq_amp::TEXT,
    '2023'                                   AS ano_original
FROM stg_iluminacao_2023

UNION ALL

-- =======================
-- BASE 2024
-- =======================
SELECT
    id_ponto::TEXT,
    sequencia::TEXT,
    rpa::TEXT,
    localizaca::TEXT,
    endereco::TEXT,
    barrament0::TEXT                         AS barramento,
    latitude::TEXT,
    longitude::TEXT,
    bairro::TEXT,
    medicao::TEXT,
    tipo_lumin::TEXT,
    tipo_de_po::TEXT,
    tipo_lampa::TEXT,
    qtde::TEXT,
    potencia::TEXT,
    perdas::TEXT,
    total_carg::TEXT,
    consumo_kw::TEXT,
    potencia_1::TEXT,
    perdas_1::TEXT,
    total_ca_1::TEXT,
    consumo_1::TEXT,
    atualizaca::TEXT                         AS atualizacao,
    bloq_amp::TEXT,
    '2024'                                   AS ano_original
FROM stg_iluminacao_2024

UNION ALL

-- =======================
-- BASE 2025
-- =======================
SELECT
    id_ponto::TEXT,
    sequencia::TEXT,
    rpa::TEXT,
    localizaca::TEXT,
    endereco::TEXT,
    barrament0::TEXT                         AS barramento,
    latitude::TEXT,
    longitude::TEXT,
    bairro::TEXT,
    medicao::TEXT,
    tipo_lumin::TEXT,
    tipo_de_po::TEXT,
    tipo_lampa::TEXT,
    qtde::TEXT,
    potencia::TEXT,
    perdas::TEXT,
    total_carg::TEXT,
    consumo_kw::TEXT,
    potencia_1::TEXT,
    perdas_1::TEXT,
    total_ca_1::TEXT,
    consumo_1::TEXT,
    atualizaca::TEXT                         AS atualizacao,
    bloq_amp::TEXT,
    '2025'                                   AS ano_original
FROM stg_iluminacao_2025;

-- Log básico de conferência da T1
SELECT COUNT(*) AS total_unificado
FROM stg_iluminacao_unificada;
