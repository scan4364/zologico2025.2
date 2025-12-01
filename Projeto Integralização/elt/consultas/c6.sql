-- Consulta feita no fim de tudo para analisar se os valores estavam padronizados e sem valores nulos

SELECT 'localizacao' AS coluna, localizacao AS valor
FROM (
  SELECT DISTINCT localizacao
  FROM postes_normalizado
) t

UNION ALL

SELECT 'tipo_lumin' AS coluna, tipo_lumin AS valor
FROM (
  SELECT DISTINCT tipo_lumin
  FROM postes_normalizado
) t

UNION ALL

SELECT 'tipo_de_poste' AS coluna, tipo_de_poste AS valor
FROM (
  SELECT DISTINCT tipo_de_poste
  FROM postes_normalizado
) t

UNION ALL

SELECT 'tipo_lampa' AS coluna, tipo_lampa AS valor
FROM (
  SELECT DISTINCT tipo_lampa
  FROM postes_normalizado
) t

ORDER BY coluna, valor;
