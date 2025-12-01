SELECT 
    tipo_lampa,
    COUNT(*) AS total
FROM postes_normalizado
GROUP BY tipo_lampa
ORDER BY total DESC;