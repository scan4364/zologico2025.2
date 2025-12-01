-- DIAGNÓSTICO T2 — Avaliação da Qualidade dos Dados
-- Esta consulta gera todas as evidências para tratamento de dados
-- inconsistentes




-- 1) Avaliar id_ponto inválido (NULL, vazio, 0.0)
SELECT
    COUNT(*) FILTER (WHERE id_ponto IS NULL) AS id_nulos,
    COUNT(*) FILTER (WHERE TRIM(id_ponto) = '') AS id_vazios,
    COUNT(*) FILTER (WHERE id_ponto ~ '^[0\.]+$') AS id_zero_ou_invalidos
FROM stg_iluminacao_unificada;



-- 2) Avaliar latitude/longitude — nulos, vazios, formatos ruins

SELECT
    COUNT(*) FILTER (WHERE latitude IS NULL OR TRIM(latitude) = '') AS lat_nulas_ou_vazias,
    COUNT(*) FILTER (WHERE longitude IS NULL OR TRIM(longitude) = '') AS long_nulas_ou_vazias,
    COUNT(*) FILTER (WHERE latitude !~ '^-?[0-9]+\.[0-9]+$') AS lat_invalida,
    COUNT(*) FILTER (WHERE longitude !~ '^-?[0-9]+\.[0-9]+$') AS long_invalida
FROM stg_iluminacao_unificada;



-- 3) Avaliar "sequencia" — valores nulos, vazios ou não-numéricos

SELECT
    COUNT(*) FILTER (WHERE sequencia IS NULL) AS seq_nulos,
    COUNT(*) FILTER (WHERE TRIM(sequencia) = '') AS seq_vazios,
    COUNT(*) FILTER (WHERE sequencia !~ '^[0-9]+$') AS seq_nao_numericos
FROM stg_iluminacao_unificada;



-- 4) Verificar nulos em data_atualizacao

SELECT
    COUNT(*) FILTER (WHERE data_atualizacao IS NULL OR TRIM(data_atualizacao) = '') AS data_atualizacao_nulos,
    COUNT(*) AS total_registros
FROM stg_iluminacao_unificada;



-- 5) Verificar duplicatas por ano (100% idênticas)

SELECT
    ano_original,
    COUNT(*) AS total_registros,
    COUNT(*) - COUNT(DISTINCT (
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
        data_atualizacao,
        consumo_kwh,
        total_carga
    )) AS duplicatas_reais
FROM stg_iluminacao_unificada
GROUP BY ano_original
ORDER BY ano_original;



-- 6) Log geral de completude — contagem de nulos por coluna
SELECT
    COUNT(*) FILTER (WHERE id_ponto IS NULL) AS nulos_id_ponto,
    COUNT(*) FILTER (WHERE sequencia IS NULL) AS nulos_sequencia,
    COUNT(*) FILTER (WHERE rpa IS NULL) AS nulos_rpa,
    COUNT(*) FILTER (WHERE localizacao IS NULL) AS nulos_localizacao,
    COUNT(*) FILTER (WHERE endereco IS NULL) AS nulos_endereco,
    COUNT(*) FILTER (WHERE barramento IS NULL) AS nulos_barramento,
    COUNT(*) FILTER (WHERE bairro IS NULL) AS nulos_bairro,
    COUNT(*) FILTER (WHERE medicao IS NULL) AS nulos_medicao,
    COUNT(*) FILTER (WHERE tipo_lumin IS NULL) AS nulos_tipo_lumin,
    COUNT(*) FILTER (WHERE tipo_de_poste IS NULL) AS nulos_tipo_de_poste,
    COUNT(*) FILTER (WHERE tipo_lampa IS NULL) AS nulos_tipo_lampa,
    COUNT(*) FILTER (WHERE qtde IS NULL) AS nulos_qtde,
    COUNT(*) FILTER (WHERE potencia IS NULL) AS nulos_potencia,
    COUNT(*) FILTER (WHERE perdas IS NULL) AS nulos_perdas,
    COUNT(*) FILTER (WHERE data_atualizacao IS NULL) AS nulos_data_atualizacao,
    COUNT(*) FILTER (WHERE consumo_kwh IS NULL) AS nulos_consumo_kwh,
    COUNT(*) FILTER (WHERE total_carga IS NULL) AS nulos_total_carga

FROM stg_iluminacao_unificada;
