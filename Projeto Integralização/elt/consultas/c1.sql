-- Essa consulta foi feita para a consulta de localizacao nula e gerar uma etapa na T2
-- de substituição dos null por "NAO INFORMADO" 
-- A persistência de valores nulos foi percebida na consulta de padronização, para gerar a T3, então fizemos essa consulta para alterar a T2
SELECT * FROM postes_sem_duplicatas_sem_id where localizacao is null;
SELECT * FROM postes_sem_duplicatas_sem_id where tipo_de_poste is null;
SELECT * FROM postes_sem_duplicatas_sem_id where barramento is null
