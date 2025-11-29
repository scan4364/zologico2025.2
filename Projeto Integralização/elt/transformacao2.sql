-- ============================================================
-- TRANSFORMAÇÃO 2 (T2)
-- Autor: Vitor
--
-- Objetivo:
-- 1) Remover linhas com id_ponto inválido (NULL, vazio ou igual a 0.0)
-- 2) Remover colunas geográficas (latitude e longitude), pois não são
--    consistentes e não estão presentes no dicionário oficial
-- 3) Remover apenas duplicatas 100% idênticas dentro do mesmo ano,
--    preservando corretamente o histórico anual dos postes
-- 4) Substituir valores inválidos ou não numéricos da coluna "sequencia"
--    pela mediana da própria coluna, garantindo consistência estrutural
-- 5) Padronizar a coluna data_atualizacao, substituindo valores nulos
--    por 'NAO_REGISTRADO_MODERNIZACAO' devido à ausência de certeza
--    sobre o motivo do campo estar vazio
-- 6) Garantir que a deduplicação não misture anos diferentes
--    (deduplicação estritamente por ano_original)
-- 7) Gerar logs de controle antes e depois de cada etapa
-- 8) Manter uma tabela final chamada postes_historico representando
--    a base limpa, padronizada e anualizada
-- ============================================================




-- ============================
-- ETAPA 0 — LOG INICIAL
-- ============================

SELECT COUNT(*) AS total_antes
FROM stg_iluminacao_unificada;



-- ============================
-- ETAPA 1 — REMOÇÃO DE ID INVÁLIDO
-- Remove:
--  - NULL
--  - texto vazio
--  - 0.0
-- ============================

DROP TABLE IF EXISTS stg_filtrada_ids;

CREATE TABLE stg_filtrada_ids AS
SELECT *
FROM stg_iluminacao_unificada
WHERE id_ponto IS NOT NULL
  AND TRIM(id_ponto) <> ''
  AND id_ponto::numeric <> 0.0;

SELECT
    (SELECT COUNT(*) FROM stg_iluminacao_unificada) AS total_original,
    (SELECT COUNT(*) FROM stg_filtrada_ids)         AS total_validos,
    (SELECT COUNT(*) FROM stg_iluminacao_unificada)
    - (SELECT COUNT(*) FROM stg_filtrada_ids)       AS removidos_id_invalidos;



-- ============================
-- ETAPA 2 — REMOVER LATITUDE E LONGITUDE
-- ============================

DROP TABLE IF EXISTS stg_sem_geo;

CREATE TABLE stg_sem_geo AS
SELECT 
    id_ponto,
    sequencia,
    rpa,
    localizacao,
    endereco,
    barramento,
    bairro,
    medicao,
    tipo_lumin,
    tipo_de_poste,
    tipo_lampa,
    qtde,
    potencia,
    perdas,
    ano_original,
    data_atualizacao,
    consumo_kwh,
    total_carga
FROM stg_filtrada_ids;



-- ============================
-- ETAPA 3 — SUBSTITUIR SEQUENCIA PELA MEDIANA
-- ============================

-- Calcular mediana da sequencia (convertida para número)
WITH med AS (
    SELECT percentile_cont(0.5) 
           WITHIN GROUP (ORDER BY sequencia::numeric) AS mediana
    FROM stg_sem_geo
    WHERE sequencia IS NOT NULL
      AND sequencia ~ '^[0-9]+$'
)
UPDATE stg_sem_geo
SET sequencia = (SELECT mediana FROM med)::TEXT
WHERE sequencia IS NULL
   OR sequencia !~ '^[0-9]+$';



-- ============================
-- ETAPA 4 — AJUSTE DA DATA DE ATUALIZAÇÃO
-- ============================

UPDATE stg_sem_geo
SET data_atualizacao = COALESCE(
    NULLIF(TRIM(data_atualizacao), ''),
    'NAO_REGISTRADO_MODERNIZACAO'
);



-- ============================
-- ETAPA 5 — REMOÇÃO DE DUPLICATAS REAIS
-- ============================

DROP TABLE IF EXISTS postes_historico;

CREATE TABLE postes_historico AS
SELECT DISTINCT ON (
    id_ponto,
    ano_original,
    sequencia,
    rpa,
    localizacao,
    endereco,
    barramento,
    bairro,
    medicao,
    tipo_lumin,
    tipo_de_poste,
    tipo_lampa,
    qtde,
    potencia,
    perdas,
    data_atualizacao,
    consumo_kwh,
    total_carga
)
*
FROM stg_sem_geo
ORDER BY
    id_ponto,
    ano_original,
    sequencia,
    rpa,
    localizacao,
    endereco,
    barramento,
    bairro,
    medicao,
    tipo_lumin,
    tipo_de_poste,
    tipo_lampa,
    qtde,
    potencia,
    perdas,
    data_atualizacao,
    consumo_kwh,
    total_carga;



-- ============================
-- ETAPA 6 — LOG FINAL
-- ============================

SELECT
    (SELECT COUNT(*) FROM stg_sem_geo)       AS total_antes_deduplicacao,
    (SELECT COUNT(*) FROM postes_historico)  AS total_final,
    (SELECT COUNT(*) FROM stg_sem_geo)
    - (SELECT COUNT(*) FROM postes_historico) AS duplicatas_removidas;



-- ============================
-- ETAPA 7 — VALIDAÇÃO POR ANO
-- ============================

SELECT
    ano_original,
    COUNT(*) AS total_registros
FROM postes_historico
GROUP BY ano_original
ORDER BY ano_original;
