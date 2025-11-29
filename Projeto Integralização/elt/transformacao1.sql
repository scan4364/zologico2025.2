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

-- BASE 2023
SELECT
    id_ponto::TEXT,
    sequencia::TEXT,
    rpa::TEXT,
    localizaca::TEXT AS localizacao,
    endereco::TEXT,
    barramento::TEXT AS barramento,
    longitude::TEXT,
    latitude::TEXT,
    bairro::TEXT,
    medicao::TEXT,
    tipo_lumin::TEXT,
    tipo_de_po::TEXT AS tipo_de_poste,
    tipo_lampa::TEXT,
    qtde::TEXT,
    potencia::TEXT,
    perdas::TEXT,
    '2023'::TEXT AS ano_original,
    "atualizaç"::TEXT AS data_atualizacao,
    consumo_kw::TEXT AS consumo_kwh,
    total_carg::TEXT AS total_carga
FROM stg_iluminacao_2023

UNION ALL

-- BASE 2024
SELECT
    id_ponto::TEXT,
    sequencia::TEXT,
    rpa::TEXT,
    localizaca::TEXT AS localizacao,
    endereco::TEXT,
    barrament0::TEXT AS barramento,
    longitude::TEXT,
    latitude::TEXT,
    bairro::TEXT,
    medicao::TEXT,
    tipo_lumin::TEXT,
    tipo_de_po::TEXT AS tipo_de_poste,
    tipo_lampa::TEXT,
    qtde::TEXT,
    potencia::TEXT,
    perdas::TEXT,
    '2024'::TEXT AS ano_original,
    atualizaca::TEXT AS data_atualizacao,
    consumo_kw::TEXT AS consumo_kwh,
    total_carg::TEXT AS total_carga
FROM stg_iluminacao_2024

UNION ALL

-- BASE 2025
SELECT
    id_ponto::TEXT,
    sequencia::TEXT,
    rpa::TEXT,
    localizaca::TEXT AS localizacao,
    endereco::TEXT,
    barrament0::TEXT AS barramento,
    longitude::TEXT,
    latitude::TEXT,
    bairro::TEXT,
    medicao::TEXT,
    tipo_lumin::TEXT,
    tipo_de_po::TEXT AS tipo_de_poste,
    tipo_lampa::TEXT,
    qtde::TEXT,
    potencia::TEXT,
    perdas::TEXT,
    '2025'::TEXT AS ano_original,
    atualizaca::TEXT AS data_atualizacao,
    consumo_kw::TEXT AS consumo_kwh,
    total_carg::TEXT AS total_carga
FROM stg_iluminacao_2025;

-- LOG
SELECT COUNT(*) AS total_unificado
FROM stg_iluminacao_unificada;
