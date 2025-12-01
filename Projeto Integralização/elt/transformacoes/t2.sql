-- TRANSFORMAÇÃO 2 (T2)
-- Autora: Mariana
-- Objetivos: remoção de ids inválidos, remoçãao de longitude, latitude e bloq_amp (muitas linhas nulas), Corrigir sequencia usando mediana
-- padronização de datas e remoção de duplicados


-- 1) Remover IDs inválidos

DROP TABLE IF EXISTS stg_t2_validos;

CREATE TABLE stg_t2_validos AS
SELECT *
FROM stg_iluminacao_unificada
WHERE id_ponto IS NOT NULL
  AND id_ponto <> ''
  AND id_ponto::float <> 0.0;


-- 2) Remover latitude, longitude e bloq_amp

DROP TABLE IF EXISTS stg_t2_sem_geo;

CREATE TABLE stg_t2_sem_geo AS
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
FROM stg_t2_validos;




-- 2.5) Preencher campos opcionais com 'NAO INFORMADO'

UPDATE stg_t2_sem_geo
SET 
    tipo_de_poste = COALESCE(NULLIF(tipo_de_poste, ''), 'NAO INFORMADO'),
    localizacao   = COALESCE(NULLIF(localizacao, ''), 'NAO INFORMADO'),
    barramento    = COALESCE(NULLIF(barramento, ''), 'NAO INFORMADO');


-- 3) Corrigir sequencia usando mediana

DROP TABLE IF EXISTS stg_t2_seq_corrigida;

CREATE TABLE stg_t2_seq_corrigida AS
WITH med AS (
    SELECT percentile_cont(0.5) WITHIN GROUP (ORDER BY sequencia::float) AS mediana
    FROM stg_t2_sem_geo
)
SELECT
    id_ponto,
    CASE 
        WHEN sequencia ~ '^[0-9]+$' THEN sequencia::integer
        ELSE (SELECT mediana FROM med)
    END AS sequencia,
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
FROM stg_t2_sem_geo;



-- 4) Padronizar data_atualizacao

DROP TABLE IF EXISTS stg_t2_data_corrigida;

CREATE TABLE stg_t2_data_corrigida AS
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
    COALESCE(NULLIF(data_atualizacao, ''), 'NAO_REGISTRADO_MODERNIZACAO') AS data_atualizacao,
    consumo_kwh,
    total_carga
FROM stg_t2_seq_corrigida;




-- 5) Deduplicação REAL (sem considerar id_ponto)
-- Mantendo o ID original (ROW_NUMBER)

DROP TABLE IF EXISTS postes_historico;

CREATE TABLE postes_historico AS
WITH grupos AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY 
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
            ORDER BY id_ponto  
        ) AS ordem
    FROM stg_t2_data_corrigida
)
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
FROM grupos

WHERE ordem = 1;   
