CREATE TABLE pessoas (
     id INT NOT NULL PRIMARY KEY AUTOINCREMENT,
     nome VARCHAR(30) NOT NULL,
     nascimento DATE
)

INSERT INTO pessoas (nome, nascimento) VALUES ('Cleyber Silva', '17-06-1984')
INSERT INTO pessoas (nome, nascimento) VALUES ('João Paulo', '10-05-1994')
INSERT INTO pessoas (nome, nascimento) VALUES ('Edvando Fernandes', '19-11-1980')