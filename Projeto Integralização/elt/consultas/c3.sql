
-- CONSULTAR DUPLICATAS DESCONSIDERANDO id_ponto


SELECT 
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
    total_carga,
    COUNT(*) AS qtd_duplicada
FROM postes_historico
GROUP BY
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
HAVING COUNT(*) > 1
ORDER BY qtd_duplicada DESC;
