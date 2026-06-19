-- 1. Preparação do ambiente

-- Apagar tabelas antigas
DROP TABLE IF EXISTS matriculas;
DROP TABLE IF EXISTS alunos;
DROP TABLE IF EXISTS cursos;

-- Criar as novas tabelas
CREATE TABLE ALUNOS(
	id_aluno INT PRIMARY KEY,
	nome_aluno VARCHAR(150),
	email VARCHAR(100),
	data_ingresso DATE
);

CREATE TABLE CURSOS(
	id_curso INT PRIMARY KEY,
	nome_curso VARCHAR(100),
	departamento VARCHAR(100),
	creditos INT
);

CREATE TABLE MATRICULAS(
	id_matricula INT PRIMARY KEY,
	id_aluno INT,
	id_curso INT,
	nota_final DECIMAL(4, 2),
	
	FOREIGN KEY(id_aluno) REFERENCES ALUNOS(id_aluno),
	FOREIGN KEY(id_curso) REFERENCES CURSOS(id_curso)
);

-- inserindo dados
INSERT INTO ALUNOS(id_aluno, nome_aluno, email, data_ingresso)
VALUES
	(1, 'Lucas Martins', 'lucas.m@email.com', '2023-02-01'), 
	(2, 'Sofia Pereira', 'sofia.p@email.com', '2023-02-01'), 
	(3, 'Mariana Costa', 'mariana.c@email.com', '2022-08-01'), 
	(4, 'Rafael Santos', 'rafael.s@email.com', '2024-02-01');  

INSERT INTO CURSOS(id_curso, nome_curso, departamento, creditos)
VALUES
	(101, 'Algoritmos e Programação', 'Ciência da Computação', 4),
	(102, 'Cálculo I', 'Matemática', 6),
	(103, 'Administração de Empresas', 'Gestão', 4),
	(104, 'Estrutura de Dados', 'Ciência da Computação', 6);

INSERT INTO MATRICULAS(id_matricula, id_aluno, id_curso, nota_final)
VALUES
	(1, 1, 101, 8.5),
	(2, 1, 102, 7.0),
	(3, 2, 101, 9.0),
	(4, 2, 104, 8.8),
	(5, 3, 103, 6.5);



-- 2. Exercícios por Nível 

-- Parte 01 DQL
-- Consulta nas tabelas (aproveitei para dar o select em todas as tabelas)
SELECT * FROM ALUNOS;
SELECT * FROM CURSOS;
SELECT * FROM MATRICULAS;

-- Consulta específica
SELECT CURSOS.nome_curso   AS 'Curso',
	   CURSOS.departamento AS 'Departamento Responsável'
FROM CURSOS;

-- Consulta numérica
SELECT CURSOS.nome_curso   AS 'Curso',
	   CURSOS.creditos 	   AS 'Créditos do curso'
FROM CURSOS
WHERE CURSOS.creditos > 4;

-- Filtro de data
SELECT ALUNOS.nome_aluno  AS 'Nome aluno',
	   ALUNOS.email 	  AS 'E-mail aluno'
FROM ALUNOS
WHERE ALUNOS.data_ingresso >= '2023-01-01';

-- Filtro AND e Ordenação
SELECT CURSOS.nome_curso  		AS 'Nome do curso',
	   MATRICULAS.id_aluno		AS 'Identificador do aluno',
	   MATRICULAS.nota_final 	AS 'Nota final'
FROM CURSOS, MATRICULAS
WHERE MATRICULAS.id_curso = CURSOS.id_curso
AND MATRICULAS.id_aluno = 1 
AND MATRICULAS.nota_final >= 7.0;

-- Parte 2 DQL

-- departamentos sem repetições
SELECT DISTINCT CURSOS.departamento AS 'Departamentos'
FROM CURSOS;

-- lógica e nova coluna
SELECT MATRICULAS.id_matricula        							AS 'Matrícula', 
	   CASE WHEN MATRICULAS.nota_final >= 7.0 
	   		THEN 'Aprovado'
	   		ELSE 'Reprovado'
	   END														AS 'Status'
FROM MATRICULAS;

-- ordenação e limite
SELECT CURSOS.creditos    AS 'Créditos do curso', 
	   CURSOS.nome_curso  AS 'Nome do curso'
FROM CURSOS
ORDER BY CURSOS.creditos DESC
LIMIT 1;

-- Parte 3 DQL

-- contagem e média
SELECT COUNT(*) AS 'Total de matrículas'
FROM MATRICULAS;

SELECT AVG(MATRICULAS.nota_final) AS 'Média das notas'
FROM MATRICULAS;

-- agrupamento 
SELECT CURSOS.departamento  AS 'Departamento',
COUNT(*) 			     	AS 'Quantos cursos esse departamento dá'
FROM CURSOS
GROUP BY CURSOS.departamento;

-- filtro de grupo
SELECT CURSOS.departamento  AS 'Departamento',
COUNT(*) 			     	AS 'Quantos cursos esse departamento dá'
FROM CURSOS
GROUP BY CURSOS.departamento
HAVING COUNT(*) > 1;


SELECT * FROM ALUNOS; 
SELECT * FROM CURSOS; 
SELECT * FROM MATRICULAS; 

-- Parte 3 DQL
-- Relatório de desempenho
SELECT ALUNOS.nome_aluno 	AS 'Nome alunos', 
CURSOS.nome_curso			AS 'Nome curso', 
MATRICULAS.nota_final		AS 'Nota final'
FROM ALUNOS
	INNER JOIN MATRICULAS ON MATRICULAS.id_aluno = ALUNOS.id_aluno
	INNER JOIN CURSOS ON CURSOS.id_curso = MATRICULAS.id_curso;

-- alunos sem matrícula
SELECT ALUNOS.nome_aluno			AS 'Nome aluno', 
	   MATRICULAS.id_matricula		AS 'Matrícula id'
FROM ALUNOS
	LEFT JOIN MATRICULAS ON MATRICULAS.id_aluno = ALUNOS.id_aluno
WHERE MATRICULAS.id_aluno IS NULL;

-- DESAFIO
SELECT ALUNOS.nome_aluno 			    		AS 'Nome aluno',
	   ROUND(AVG(MATRICULAS.nota_final), 2)		AS 'Maior média final'
FROM ALUNOS
INNER JOIN MATRICULAS ON MATRICULAS.id_aluno = ALUNOS.id_aluno
GROUP BY ALUNOS.id_aluno, ALUNOS.nome_aluno
ORDER BY AVG(MATRICULAS.nota_final) DESC
LIMIT 1;

