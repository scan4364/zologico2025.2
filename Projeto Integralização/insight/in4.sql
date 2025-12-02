-- análise de perdas de Energia
-- samuel
SELECT 
    p.tipo_lumin, 
    SUM(f.perdas) AS total_perdas_w,
    ROUND(AVG(f.perdas), 2) AS media_perdas_por_ponto
FROM fato_iluminacao f
JOIN dim_poste p ON f.id_poste_sk = p.id_poste_sk
GROUP BY p.tipo_lumin
HAVING SUM(f.perdas) > 0
ORDER BY total_perdas_w DESC;