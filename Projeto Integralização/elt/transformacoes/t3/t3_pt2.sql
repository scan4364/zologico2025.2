DROP TABLE IF EXISTS stg_t3_step2;

CREATE TABLE stg_t3_step2 AS
SELECT
    id_ponto,
    sequencia,
    rpa,

    CASE WHEN localizacao = 'PRAAA' THEN 'PRACA'
    ELSE localizacao END AS localizacao,

    endereco,
    barramento,
    bairro,

    CASE 
        WHEN medicao IN ('SIM','NAO') THEN medicao
        ELSE medicao END AS medicao,

    CASE
        WHEN tipo_lumin IN ('LUMINARIAFECHADA','FECHADA','LUMINARIA')
            THEN 'LUMINARIA FECHADA'
        WHEN tipo_lumin = 'LUMINARIA ABERTA'
            THEN 'LUMINARIA ABERTA'
        WHEN tipo_lumin = 'LAMPIAO'
            THEN 'LAMPIAO'
        WHEN tipo_lumin = 'PATALA'
            THEN 'PETALA'
        WHEN tipo_lumin = 'BRAAO ORNAMENTAL'
            THEN 'BRACO ORNAMENTAL'
        ELSE tipo_lumin
    END AS tipo_lumin,

    CASE
        WHEN tipo_de_poste = 'POSTE CIRCULAR' THEN 'CIRCULAR'
        WHEN tipo_de_poste = 'POSTE COMUM' THEN 'COMUM'
        WHEN tipo_de_poste = 'POSTE MADEIRA' THEN 'MADEIRA'
        WHEN tipo_de_poste = 'POSTE PARTICULAR' THEN 'PARTICULAR'
        WHEN tipo_de_poste = 'POSTE DE FIBRA' THEN 'FIBRA'
        WHEN tipo_de_poste = 'POSTE DE CONCRETO' THEN 'CONCRETO'
        ELSE tipo_de_poste
    END AS tipo_de_poste,

    tipo_lampa,
    qtde,
    potencia,
    perdas,
    ano_original,
    data_atualizacao,
    consumo_kwh,
    total_carga

FROM stg_t3_step1;
