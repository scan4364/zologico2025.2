-- ranking dos 10 bairros que demandam maior consumo de energia
-- Samuel
SELECT 
    l.bairro,
    SUM(f.consumo_kwh) AS total_consumo_kwh,
    SUM(f.qtde) AS total_postes  
FROM fato_iluminacao f
JOIN dim_localidade l ON f.id_localidade_sk = l.id_localidade_sk
GROUP BY l.bairro
ORDER BY total_consumo_kwh DESC
LIMIT 10;