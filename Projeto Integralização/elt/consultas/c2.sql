-- Consulta feita para analisar os valores únicos das variáveis categóricas com inconsistência.
-- Essa consulta foi feita de motivação para a T3 de padronização de valores

SELECT 'localizacao' AS coluna, localizacao AS valor
FROM postes_historico
GROUP BY localizacao

UNION ALL

SELECT 'tipo_lumin' AS coluna, tipo_lumin AS valor
FROM postes_historico
GROUP BY tipo_lumin

UNION ALL

SELECT 'tipo_de_poste' AS coluna, tipo_de_poste AS valor
FROM postes_historico
GROUP BY tipo_de_poste

UNION ALL

SELECT 'tipo_lampa' AS coluna, tipo_lampa AS valor
FROM postes_historico
GROUP BY tipo_lampa


ORDER BY coluna, valor;
