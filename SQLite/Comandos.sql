/*
   Comandos usados no treinamento "Descubra o SQL"
*/



-- 01_01
SELECT 'Hello, World!'
SELECT 10
SELECT primeiro_nome FROM pessoas
SELECT primeiro_nome, ultimo_nome FROM pessoas
SELECT ultimo_nome, primeiro_nome FROM pessoas

SELECT * FROM pessoas

-- 01_02
SELECT * FROM pessoas WHERE sigla_estado = 'SP';
SELECT * FROM pessoas WHERE sigla_estado <> 'SP';
SELECT * FROM pessoas WHERE qte_pontos= 0;

-- 01_03
SELECT primeiro_nome, ultimo_nome FROM pessoas WHERE sigla_estado = 'SP' AND camiseta_ou_chapeu='camiseta';
SELECT primeiro_nome, ultimo_nome FROM pessoas WHERE sigla_estado = 'SP' AND camiseta_ou_chapeu='camiseta' AND nome_time='azul';
SELECT primeiro_nome, ultimo_nome FROM pessoas WHERE sigla_estado = 'SP' OR sigla_estado = 'MG'
SELECT primeiro_nome, ultimo_nome, sigla_estado  FROM pessoas WHERE sigla_estado = 'SP' OR sigla_estado = 'MG'
SELECT primeiro_nome, ultimo_nome, nome_time, sigla_estado FROM pessoas WHERE NOT(sigla_estado = 'SP')
SELECT primeiro_nome, ultimo_nome, nome_time, sigla_estado FROM pessoas WHERE  sigla_estado <> 'SP'
SELECT primeiro_nome, ultimo_nome, sigla_estado, nome_time FROM pessoas WHERE nome_time = 'vermelho' AND sigla_estado = 'SP' OR sigla_estado = 'MG' 
SELECT primeiro_nome, ultimo_nome, sigla_estado, nome_time FROM pessoas WHERE nome_time = 'vermelho' AND (sigla_estado = 'SP' OR sigla_estado = 'MG' )



-- 01_04
SELECT primeiro_nome, ultimo_nome, sigla_estado from Pessoas WHERE sigla_estado LIKE 'S%'
SELECT primeiro_nome, ultimo_nome, sigla_estado from Pessoas WHERE sigla_estado LIKE '%O'
SELECT primeiro_nome, ultimo_nome, sigla_estado FROM pessoas WHERE primeiro_nome LIKE '%DANI%';
SELECT primeiro_nome, ultimo_nome, sigla_estado FROM pessoas WHERE primeiro_nome LIKE '%DANI%' LIMIT 2
SELECT primeiro_nome, ultimo_nome, sigla_estado FROM pessoas WHERE primeiro_nome LIKE '%DANI%' LIMIT 2 OFFSET 2



-- 01_05
SELECT primeiro_nome, ultimo_nome, qte_pontos FROM pessoas
SELECT primeiro_nome, ultimo_nome FROM pessoas ORDER BY primeiro_nome
SELECT primeiro_nome, ultimo_nome FROM pessoas ORDER BY primeiro_nome ASC
SELECT primeiro_nome, ultimo_nome FROM pessoas ORDER BY primeiro_nome DESC
SELECT primeiro_nome, ultimo_nome FROM pessoas ORDER BY primeiro_nome DESC, ultimo_nome ASC
SELECT primeiro_nome, ultimo_nome , qte_pontos FROM pessoas ORDER BY qte_pontos
SELECT primeiro_nome, ultimo_nome , qte_pontos FROM pessoas ORDER BY qte_pontos DESC



-- 01_06
SELECT primeiro_nome FROM pessoas
SELECT primeiro_nome, LENGTH(primeiro_nome) FROM pessoas
SELECT DISTINCT(primeiro_nome) FROM pessoas
SELECT DISTINCT(primeiro_nome) FROM pessoas ORDER BY primeiro_nome
SELECT COUNT(*) FROM pessoas WHERE sigla_estado = 'SP' 

-- 02_01
SELECT primeiro_nome, sigla_estado FROM pessoas;
SELECT primeiro_nome, pessoas.sigla_estado FROM pessoas JOIN estados;
SELECT pessoas.primeiro_nome, pessoas.sigla_estado, estados.nome_capital FROM pessoas JOIN estados ON pessoas.sigla_estado = estados.sigla_estado
SELECT * FROM pessoas JOIN estados ON pessoas.sigla_estado = estados.sigla_estado;
SELECT * FROM pessoas JOIN estados ON pessoas.sigla_estado = estados.sigla_estado WHERE pessoas.primeiro_nome LIKE 'a%' AND estados.sigla_estado like '%P%'


-- 02_03
SELECT primeiro_nome, COUNT(*) FROM pessoas
SELECT primeiro_nome, COUNT(*) FROM pessoas GROUP BY primeiro_nome
SELECT primeiro_nome, COUNT(*) , sigla_estado FROM pessoas GROUP BY primeiro_nome, sigla_estado 
SELECT primeiro_nome, AVG(qte_pontos) FROM pessoas GROUP BY primeiro_nome, sigla_estado
SELECT primeiro_nome, AVG(qte_pontos) FROM pessoas GROUP BY primeiro_nome
SELECT primeiro_nome, MIN(qte_pontos) FROM pessoas GROUP BY primeiro_nome
SELECT primeiro_nome, MAX(qte_pontos) FROM pessoas GROUP BY primeiro_nome
SELECT primeiro_nome, SUM(qte_pontos) FROM pessoas GROUP BY primeiro_nome

-- 03_02
SELECT 3+2;
SELECT 3/2;
SELECT 3/2.0;
SELECT primeiro_nome, qte_pontos FROM pessoas WHERE qte_pontos > 70;
SELECT  qte_pontos + 10 FROM pessoas WHERE qte_pontos < 70;


-- 03_03
SELECT primeiro_nome, ultimo_nome, qte_pontos FROM pessoas WHERE qte_pontos > = max (qte_pontos)
SELECT primeiro_nome, ultimo_nome, qte_pontos FROM pessoas WHERE qte_pontos >=  (select MAX(qte_pontos) from Pessoas)



-- 03_04
SELECT primeiro_nome, ultimo_nome FROM pessoas;
SELECT LOWER(primeiro_nome), UPPER(ultimo_nome) FROM pessoas;
SELECT LOWER(primeiro_nome), SUBSTR(ultimo_nome, 1, 5) FROM pessoas;
SELECT LOWER(primeiro_nome), SUBSTR(ultimo_nome, 2) FROM pessoas;
SELECT LOWER(primeiro_nome), SUBSTR(ultimo_nome, -2) FROM pessoas;
SELECT LOWER(primeiro_nome), SUBSTR(ultimo_nome, -4) FROM pessoas;
SELECT LOWER(primeiro_nome), REPLACE(ultimo_nome, 'a', '@@') FROM pessoas;
SELECT LOWER(primeiro_nome), REPLACE(ultimo_nome, 'A', '@@') FROM pessoas;
SELECT LOWER(primeiro_nome), REPLACE(ultimo_nome, 'e', '') FROM pessoas;

-- 03_05
SELECT  qte_pontos FROM pessoas
SELECT MAX( qte_pontos) FROM pessoas
SELECT CAST(qte_pontos as char) FROM pessoas
SELECT MAX(CAST(qte_pontos AS CHAR)) FROM pessoas
SELECT MAX(CAST(qte_pontos AS INT)) FROM pessoas


-- 03_06
SELECT primeiro_nome, ultimo_nome FROM pessoas;
SELECT primeiro_nome, UPPER(ultimo_nome) FROM pessoas;
SELECT primeiro_nome, UPPER(ultimo_nome) AS sobrenome FROM pessoas;
SELECT pessoas.primeiro_nome, pessoas.sigla_estado, estados.nome_capital FROM pessoas JOIN estados ON pessoas.sigla_estado = estados.sigla_estado
SELECT P.primeiro_nome, P.sigla_estado, E.nome_capital FROM pessoas AS P JOIN estados AS E ON P.sigla_estado = E.sigla_estado


-- 04_01
INSERT INTO pessoas (primeiro_nome) VALUES ('Dani')
INSERT INTO pessoas (primeiro_nome, ultimo_nome) VALUES ('Dani', 'Monteiro')
SELECT primeiro_nome, ultimo_nome FROM pessoas WHERE primeiro_nome = 'Dani'
INSERT INTO pessoas (primeiro_nome, ultimo_nome, sigla_estado, camiseta_ou_chapeu, nome_time) VALUES
('Danielle', 'Monteiro', 'SP', 'chapéu', 'lilás')
SELECT * FROM pessoas
INSERT INTO pessoas (primeiro_nome, ultimo_nome, sigla_estado, camiseta_ou_chapeu, nome_time) VALUES
('DaniMonteiroDBA', 'Apelido', 'SP', 'camiseta', 'vermelho'),
('Teresa', 'Costa', 'MG', 'chapéu', 'azul')
SELECT * FROM pessoas

-- 04_02
UPDATE pessoas SET primeiro_nome = 'Pedro' 
WHERE primeiro_nome = 'DaniMonteiroDBA'

SELECT * FROM pessoas
WHERE primeiro_nome = 'DaniMonteiroDBA'

SELECT * FROM pessoas
WHERE primeiro_nome = 'Pedro'



-- 04_03
DELETE FROM pessoas
WHERE primeiro_nome = 'Pedro'

SELECT * FROM pessoas
WHERE primeiro_nome = 'Pedro'
