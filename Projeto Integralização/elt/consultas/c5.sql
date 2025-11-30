SELECT 'localizacao'   AS coluna, localizacao AS valor
FROM (
  SELECT DISTINCT localizacao
  FROM postes_normalizado
  WHERE localizacao IS NOT NULL AND TRIM(localizacao) <> ''
) t

UNION ALL

SELECT 'tipo_lumin'    AS coluna, tipo_lumin AS valor
FROM (
  SELECT DISTINCT tipo_lumin
  FROM postes_normalizado
  WHERE tipo_lumin IS NOT NULL AND TRIM(tipo_lumin) <> ''
) t

UNION ALL

SELECT 'tipo_de_poste' AS coluna, tipo_de_poste AS valor
FROM (
  SELECT DISTINCT tipo_de_poste
  FROM postes_normalizado
  WHERE tipo_de_poste IS NOT NULL AND TRIM(tipo_de_poste) <> ''
) t

UNION ALL

SELECT 'tipo_lampa'    AS coluna, tipo_lampa AS valor
FROM (
  SELECT DISTINCT tipo_lampa
  FROM postes_normalizado
  WHERE tipo_lampa IS NOT NULL AND TRIM(tipo_lampa) <> ''
) t

ORDER BY coluna, valor;
