CREATE TABLE pessoas (
     id INT NOT NULL PRIMARY KEY AUTOINCREMENT,
     nome VARCHAR(30) NOT NULL,
     nascimento DATE
)

INSERT INTO pessoas (nome, nascimento) VALUES ('Cleyber Silva', '17-06-1984')
INSERT INTO pessoas (nome, nascimento) VALUES ('João Paulo', '10-05-1994')
INSERT INTO pessoas (nome, nascimento) VALUES ('Edvando Fernandes', '19-11-1980')
INSERT INTO pessoas (nome, nascimento) VALUES ('João Rez', '26-10-1992')

UPDATE pessoas SET nome = 'Cleyber Silva' WHERE id = '1'

DELETE FROM pessoas WHERE id = 4

SELECT * FROM pessoas ORDER BY nome;
SELECT * FROM pessoas ORDER BY DESC;