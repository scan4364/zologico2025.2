-- ==============================================================================
-- 3. TRANSFORMAÇÃO T3

-- Autor :Thales
-- Objetivo: Padronização de Texto (Upper/Trim), correção de nomes, tratamento de nulos e tipagem de dados
-- ==============================================================================

DROP TABLE IF EXISTS silver_iluminacao;

CREATE TABLE silver_iluminacao AS
SELECT
    id_ponto,
    ano_original,
    sequencia,
    rpa,

    -- 1. LOCALIZACAO (Correção do "PRAAA") e correção do nome (localizaca para localizacao)
    CASE 
        WHEN TRIM(TRANSLATE(UPPER(localizaca), 'ÁÀÃÂÄÉÈÊËÍÌÎÏÓÒÕÔÖÚÙÛÜÇÑ', 'AAAAAEEEEIIIIOOOOOUUUUCN')) = 'PRAAA' THEN 'PRACA'
        ELSE COALESCE(TRIM(TRANSLATE(UPPER(localizaca), 'ÁÀÃÂÄÉÈÊËÍÌÎÏÓÒÕÔÖÚÙÛÜÇÑ', 'AAAAAEEEEIIIIOOOOOUUUUCN')), 'NAO INFORMADO')
    END AS localizacao,

    UPPER(TRIM(endereco))   AS endereco,
    COALESCE(barramento, 'NAO INFORMADO') AS barramento, 
    NULLIF(REPLACE(latitude, ',', '.'), '')::NUMERIC  AS latitude,
    NULLIF(REPLACE(longitude, ',', '.'), '')::NUMERIC AS longitude,
    TRIM(TRANSLATE(UPPER(bairro), 'ÁÀÃÂÄÉÈÊËÍÌÎÏÓÒÕÔÖÚÙÛÜÇÑ', 'AAAAAEEEEIIIIOOOOOUUUUCN'))     AS bairro,
    TRIM(TRANSLATE(UPPER(medicao), 'ÁÀÃÂÄÉÈÊËÍÌÎÏÓÒÕÔÖÚÙÛÜÇÑ', 'AAAAAEEEEIIIIOOOOOUUUUCN'))   AS medicao,

    -- 2. TIPO LUMINARIA (Correção de Várias Variações)
    CASE 
        WHEN TRIM(TRANSLATE(UPPER(tipo_lumin), 'ÁÀÃÂÄÉÈÊËÍÌÎÏÓÒÕÔÖÚÙÛÜÇÑ', 'AAAAAEEEEIIIIOOOOOUUUUCN')) IN ('LUMINARIAFECHADA', 'FECHADA', 'LUMINARIA') THEN 'LUMINARIA FECHADA'
        WHEN TRIM(TRANSLATE(UPPER(tipo_lumin), 'ÁÀÃÂÄÉÈÊËÍÌÎÏÓÒÕÔÖÚÙÛÜÇÑ', 'AAAAAEEEEIIIIOOOOOUUUUCN')) = 'PATALA' THEN 'PETALA'
        WHEN TRIM(TRANSLATE(UPPER(tipo_lumin), 'ÁÀÃÂÄÉÈÊËÍÌÎÏÓÒÕÔÖÚÙÛÜÇÑ', 'AAAAAEEEEIIIIOOOOOUUUUCN')) = 'BRAAO ORNAMENTAL' THEN 'BRACO ORNAMENTAL'
        ELSE TRIM(TRANSLATE(UPPER(tipo_lumin), 'ÁÀÃÂÄÉÈÊËÍÌÎÏÓÒÕÔÖÚÙÛÜÇÑ', 'AAAAAEEEEIIIIOOOOOUUUUCN'))
    END AS tipo_lumin,

    -- 3. TIPO DE POSTE (Simplificação de Nomes)
    CASE 
        WHEN TRIM(TRANSLATE(UPPER(tipo_de_po), 'ÁÀÃÂÄÉÈÊËÍÌÎÏÓÒÕÔÖÚÙÛÜÇÑ', 'AAAAAEEEEIIIIOOOOOUUUUCN')) = 'POSTE CIRCULAR'  THEN 'CIRCULAR'
        WHEN TRIM(TRANSLATE(UPPER(tipo_de_po), 'ÁÀÃÂÄÉÈÊËÍÌÎÏÓÒÕÔÖÚÙÛÜÇÑ', 'AAAAAEEEEIIIIOOOOOUUUUCN')) = 'POSTE COMUM'     THEN 'COMUM'
        WHEN TRIM(TRANSLATE(UPPER(tipo_de_po), 'ÁÀÃÂÄÉÈÊËÍÌÎÏÓÒÕÔÖÚÙÛÜÇÑ', 'AAAAAEEEEIIIIOOOOOUUUUCN')) = 'POSTE MADEIRA'   THEN 'MADEIRA'
        WHEN TRIM(TRANSLATE(UPPER(tipo_de_po), 'ÁÀÃÂÄÉÈÊËÍÌÎÏÓÒÕÔÖÚÙÛÜÇÑ', 'AAAAAEEEEIIIIOOOOOUUUUCN')) = 'POSTE PARTICULAR' THEN 'PARTICULAR'
        WHEN TRIM(TRANSLATE(UPPER(tipo_de_po), 'ÁÀÃÂÄÉÈÊËÍÌÎÏÓÒÕÔÖÚÙÛÜÇÑ', 'AAAAAEEEEIIIIOOOOOUUUUCN')) = 'POSTE DE FIBRA'    THEN 'FIBRA'
        WHEN TRIM(TRANSLATE(UPPER(tipo_de_po), 'ÁÀÃÂÄÉÈÊËÍÌÎÏÓÒÕÔÖÚÙÛÜÇÑ', 'AAAAAEEEEIIIIOOOOOUUUUCN')) = 'POSTE DE CONCRETO' THEN 'CONCRETO'
        ELSE COALESCE(TRIM(TRANSLATE(UPPER(tipo_de_po), 'ÁÀÃÂÄÉÈÊËÍÌÎÏÓÒÕÔÖÚÙÛÜÇÑ', 'AAAAAEEEEIIIIOOOOOUUUUCN')), 'NAO INFORMADO')
    END AS tipo_de_po,
        
    tipo_lampa,
    qtde,
    potencia,
    perdas,
    total_carg,
    NULLIF(REPLACE(consumo_kw::TEXT, ',', '.'), '')::NUMERIC AS consumo_kw,
    potencia_1,
    perdas_1,
    total_ca_1,
    consumo_1,
    atualizacao,
    bloq_amp

FROM
    postes_historico;