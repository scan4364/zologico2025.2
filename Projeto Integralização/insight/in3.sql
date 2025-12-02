-- potência média por tipo de lâmpada
-- samuel
SELECT 
    p.tipo_lampada,
    ROUND(AVG(f.potencia), 2) AS potencia_media_w, -- Verifique se é 'potencia' ou 'potencia_w' no seu banco
    SUM(f.qtde) AS qtd_pontos
FROM fato_iluminacao f
JOIN dim_poste p ON f.id_poste_sk = p.id_poste_sk
GROUP BY p.tipo_lampada
ORDER BY potencia_media_w DESC;