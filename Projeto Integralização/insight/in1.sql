--Consulta que apresenta, por RPA, a quantidade de postes por tipo de lâmpada, destacando a porcentagem de luminárias em LED com base no estado mais recente de cada poste.
WITH ultimo_estado AS (
    SELECT DISTINCT ON (id_ponto)
           id_ponto,
           rpa,
           tipo_lampa
    FROM postes_historico
    ORDER BY id_ponto, ano_original DESC
),
contagem AS (
    SELECT
        rpa,
        COUNT(*) FILTER (WHERE tipo_lampa = 'LED')              AS led,
        COUNT(*) FILTER (WHERE tipo_lampa = 'VAPOR DE SODIO')   AS vapor_sodio,
        COUNT(*) FILTER (WHERE tipo_lampa = 'VAPOR METALICO')  AS vapor_metalico,
        COUNT(*) FILTER (WHERE tipo_lampa = 'DESATIVADO')      AS desativado,
        COUNT(*) FILTER (WHERE tipo_lampa = 'PARTICULAR')      AS particular,
        COUNT(*) FILTER (WHERE tipo_lampa = 'LAMPADA HALOGENA') AS lampada_halogena,
        COUNT(*) AS total
    FROM ultimo_estado
    GROUP BY rpa
)
SELECT
    rpa,

    led,
    ROUND(led * 100.0 / NULLIF(total, 0), 2) AS pct_led,

    vapor_sodio,
    vapor_metalico,
    desativado,
    particular,
    lampada_halogena,

    total AS total_postes

FROM contagem
ORDER BY rpa;
