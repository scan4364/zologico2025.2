DROP TABLE IF EXISTS postes_normalizado;

CREATE TABLE postes_normalizado AS
SELECT * FROM stg_t3_step2;
