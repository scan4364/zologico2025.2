-- ============================================================
-- TRANSFORMAÇÃO 2 (T2)
-- Autor: Vitor
--
-- Objetivo:
-- 1) Remover linhas com id_ponto NULO
-- 2) Remover apenas duplicatas 100% idênticas DENTRO do mesmo ano
-- 3) Manter o histórico dos postes ao longo dos anos
-- 4) Gerar logs de controle (antes/depois)
-- 5) Não cruzar anos na deduplicação
-- ============================================================


-- ============================
-- ETAPA 0 — LOG INICIAL
-- ============================

SELECT COUNT(*) AS total_antes
FROM stg_iluminacao_unificada;



-- ============================
-- ETAPA 1 — REMOÇÃO DE ID NULO
-- ============================

DROP TABLE IF EXISTS stg_sem_id_nulo;

CREATE TABLE stg_sem_id_nulo AS
SELECT *
FROM stg_iluminacao_unificada
WHERE id_ponto IS NOT NULL
  AND TRIM(id_ponto) <> '';

-- LOG APÓS REMOÇÃO DE ID NULO
SELECT
    (SELECT COUNT(*) FROM stg_iluminacao_unificada) AS total_original,
    (SELECT COUNT(*) FROM stg_sem_id_nulo)          AS total_sem_id_nulo,
    (SELECT COUNT(*) FROM stg_iluminacao_unificada)
    - (SELECT COUNT(*) FROM stg_sem_id_nulo)       AS removidos_id_nulo;



-- ============================
-- ETAPA 2 — REMOÇÃO DE DUPLICATAS REAIS
-- Dentro do mesmo ano, comparando a linha inteira
-- ============================

DROP TABLE IF EXISTS postes_historico;

CREATE TABLE postes_historico AS
SELECT DISTINCT ON (
    id_ponto,
    ano_original,
    sequencia,
    rpa,
    localizaca,
    endereco,
    barramento,
    latitude,
    longitude,
    bairro,
    medicao,
    tipo_lumin,
    tipo_de_po,
    tipo_lampa,
    qtde,
    potencia,
    perdas,
    total_carg,
    consumo_kw,
    potencia_1,
    perdas_1,
    total_ca_1,
    consumo_1,
    atualizacao,
    bloq_amp
)
*
FROM stg_sem_id_nulo
ORDER BY
    id_ponto,
    ano_original,
    sequencia,
    rpa,
    localizaca,
    endereco,
    barramento,
    latitude,
    longitude,
    bairro,
    medicao,
    tipo_lumin,
    tipo_de_po,
    tipo_lampa,
    qtde,
    potencia,
    perdas,
    total_carg,
    consumo_kw,
    potencia_1,
    perdas_1,
    total_ca_1,
    consumo_1,
    atualizacao,
    bloq_amp;



-- ============================
-- ETAPA 3 — LOG FINAL
-- ============================

SELECT
    (SELECT COUNT(*) FROM stg_sem_id_nulo)  AS total_antes_deduplicacao,
    (SELECT COUNT(*) FROM postes_historico) AS total_final,
    (SELECT COUNT(*) FROM stg_sem_id_nulo)
    - (SELECT COUNT(*) FROM postes_historico) AS duplicatas_removidas;



-- ============================
-- ETAPA 4 — VALIDAÇÃO POR ANO
-- ============================

SELECT
    ano_original,
    COUNT(*) AS total_registros
FROM postes_historico
GROUP BY ano_original
ORDER BY ano_original;
