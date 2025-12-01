-- Transformação 3
-- Autor: Thales
-- A T3 foi dividida em 3 partes porque estava crashando com todas as etapas juntas
-- Objetivo: padronização de colunas

DROP TABLE IF EXISTS stg_t3_step1;

CREATE TABLE stg_t3_step1 AS
SELECT
    id_ponto,
    sequencia,
    rpa,
    UPPER(TRIM(translate(localizacao, 'ÁÀÃÂÉÊÍÓÔÕÚÇáàãâéêíóôõúç', 'AAAAEEIOOOUCaaaaeeiooouc'))) AS localizacao,
    UPPER(TRIM(translate(endereco,    'ÁÀÃÂÉÊÍÓÔÕÚÇáàãâéêíóôõúç', 'AAAAEEIOOOUCaaaaeeiooouc'))) AS endereco,
    UPPER(TRIM(translate(barramento,  'ÁÀÃÂÉÊÍÓÔÕÚÇáàãâéêíóôõúç', 'AAAAEEIOOOUCaaaaeeiooouc'))) AS barramento,
    UPPER(TRIM(translate(bairro,      'ÁÀÃÂÉÊÍÓÔÕÚÇáàãâéêíóôõúç', 'AAAAEEIOOOUCaaaaeeiooouc'))) AS bairro,
    UPPER(TRIM(translate(medicao,     'ÁÀÃÂÉÊÍÓÔÕÚÇáàãâéêíóôõúç', 'AAAAEEIOOOUCaaaaeeiooouc'))) AS medicao,
    UPPER(TRIM(translate(tipo_lumin,  'ÁÀÃÂÉÊÍÓÔÕÚÇáàãâéêíóôõúç', 'AAAAEEIOOOUCaaaaeeiooouc'))) AS tipo_lumin,
    UPPER(TRIM(translate(tipo_de_poste,'ÁÀÃÂÉÊÍÓÔÕÚÇáàãâéêíóôõúç', 'AAAAEEIOOOUCaaaaeeiooouc'))) AS tipo_de_poste,
    tipo_lampa,
    qtde,
    potencia,
    perdas,
    ano_original,
    UPPER(TRIM(translate(data_atualizacao,'ÁÀÃÂÉÊÍÓÔÕÚÇáàãâéêíóôõúç','AAAAEEIOOOUCaaaaeeiooouc'))) AS data_atualizacao,
    consumo_kwh,
    total_carga
FROM postes_historico;

