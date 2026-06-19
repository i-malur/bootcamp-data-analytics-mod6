-- subquery não correlacionada


-- essa subquery pega todos os clientes que possuem compras com valor total > 500
-- usamos o distinct para retirar nomes repetidos e retornar uma lista sem repetições de clientes
-- a subquery não depende da query externa, pois, ela pega apenas o id do cliente da tabela pedidos onde valor > 500
SELECT C.nome AS 'Nome cliente'
FROM CLIENTES C
WHERE C.id_cliente IN(
	SELECT DISTINCT P.cliente_id
	FROM PEDIDOS P
	WHERE P.valor_total > 500

);

-- subquery correlacionada
SELECT C.nome  		 AS 'Nome cliente', 
	   P.id_pedido	 AS 'Código do pedido',
	   P.valor_total AS 'Valor total do pedido'
FROM PEDIDOS P
INNER JOIN CLIENTES C ON C.id_cliente = P.cliente_id
WHERE P.valor_total = (
			SELECT MAX(P2.valor_total)
			FROM PEDIDOS P2
			WHERE P2.cliente_id = P.cliente_id
);

/*SELECT C.nome AS 'Nome cliente', 
       P.id_pedido AS 'Código do pedido',
       P.valor_total AS 'Valor total do pedido'
FROM PEDIDOS P
JOIN CLIENTES C ON C.id_cliente = P.cliente_id

- juntando PEDIDOS e CLIENTES
- mostra o nome do cliente (na tabela CLIENTES), id_pedido e valor_total (da tabela PEDIDOS)


WHERE P.valor_total = (...)
-- filtrar para mostrar os resultados com base na condição a seguir

(
    SELECT MAX(P2.valor_total)
    FROM PEDIDOS P2
    WHERE P2.cliente_id = P.cliente_id
)

-- o bloco externo analisa o cliente e esse bloco interno analisa o maior valor de compra do cliente está sendo capturado no bloco externo
*/



-- CTE

WITH GASTO_CLIENTES AS (
		SELECT P.cliente_id,
		SUM(P.valor_total) AS total_cliente
		FROM PEDIDOS P
		GROUP BY P.cliente_id

)

SELECT C.nome, G.total_cliente
FROM GASTO_CLIENTES G
INNER JOIN CLIENTES C ON C.id_cliente = G.cliente_id
WHERE G.total_cliente > 500;


-- FINAL

-- clientes que mais compraram nos últimos 24 meses


-- criando tabela temporária
WITH ULT_24M AS (
		SELECT P.cliente_id, P.id_pedido AS id_pedido, P.dt_pedido, P.valor_total
		FROM PEDIDOS P
		WHERE P.dt_pedido >= DATE ('now', '-24 months')
),

-- criando KPIs para análise de clientes e suas compras
RESUME AS (
		SELECT 
			cliente_id,
			COUNT(*)   					AS qtd_pedidos,
			SUM(valor_total)			AS total_24m,
			AVG(valor_total)			AS ticket_medio_24m,
			MAX(dt_pedido)				AS dt_ultima_compra
		FROM ULT_24M
		GROUP BY cliente_id
)

-- selecionando os clientes e os KPIs
SELECT
	C.id_cliente, C.nome,
	R.qtd_pedidos,
	R.total_24m,
	R.ticket_medio_24m,
	R.dt_ultima_compra
FROM RESUME R
INNER JOIN CLIENTES C ON C.id_cliente = R.cliente_id
WHERE
	R.total_24m > (SELECT AVG(total_24m) FROM RESUME)
	
	AND EXISTS(
		SELECT 1
		FROM ULT_24M U
		WHERE U.cliente_id = R.cliente_id
			AND U.valor_total > 500
	)

-- ordenando em modo decrescente os clientes com base no total de suas compras 
ORDER BY R.total_24m DESC

-- limitando a saída em 5 registros
LIMIT 5;


/*
1ª Etapa: Filtro Temporal (ULT_24M)
O que faz: Cria um recorte no banco de dados contendo apenas os pedidos realizados nos últimos 24 meses. Reduzimos o volume de dados logo no primeiro bloco.

2ª Etapa: Agregação e Métricas (RESUME)
O que faz: Pega os dados filtrados da etapa anterior e os agrupa por cliente (GROUP BY cliente_id). Aqui são gerados os KPIs (indicadores) individuais:
- Total gasto no período (SUM).
- Frequência de compra / Quantidade de pedidos (COUNT).
- Ticket Médio por pedido (AVG).
- Data do último contato/compra (MAX).


A Seleção Final e Regras de Negócio (O Filtro VIP)
Na consulta principal, usamos INNER JOIN para colocar o nome do cliente ao lado das métricas calculadas e aplicou dois critérios de corte no WHERE:

Critério 1 (Faturamento acima da média): R.total_24m > (SELECT AVG(total_24m) FROM RESUME)
- O cliente só entra no relatório se o dinheiro que ele deixou na loja for maior que a média geral de gasto de todos os outros clientes ativos. É uma subconsulta que define o ponto de corte dinamicamente.

Critério 2 (Presença de Pedido de Alto Valor): AND EXISTS (...)
- Para ser considerado VIP, ele obrigatoriamente precisa ter feito pelo menos um pedido individual acima de R$ 500,00 dentro do período analítico.


Organização dos Resultados
Por fim, o código organiza o ranking colocando os clientes que mais gastaram no topo (ORDER BY R.total_24m DESC) e limita a exibição apenas para o Top 5 (LIMIT 5).
 * */


-- Window Functions

-- por cliente, qual pedido mais antigo (1) e qual mais recente (2)
SELECT P.cliente_id  AS 'id_cliente',
	   P.id_pedido   AS 'pedido_id',
	   P.dt_pedido   AS 'data pedido',
	   P.valor_total AS 'total compra',
ROW_NUMBER() OVER(
		PARTITION BY cliente_id
		ORDER BY dt_pedido 
) AS numero_pedido
FROM PEDIDOS P;


-- analisa todos os pedidos dos clientes e para cada, vamos calcular a média dos 3 ultimos pedidos
SELECT P.cliente_id  AS 'id_cliente',
	   P.id_pedido	 AS 'pedido_id',
	   P.dt_pedido 	 AS 'data pedido',
   	   P.valor_total AS 'Valor total',
ROUND(
	   AVG(P.valor_total) OVER(
						   		PARTITION BY P.cliente_id
						   		ORDER BY 	 P.dt_pedido
						   		ROWS BETWEEN 2 PRECEDING AND CURRENT ROW -- janela que olha os 2 pedidos anteriores + o atual
						   ), 2 -- 2 casas decimais
	   
) AS media_ultimos_3_pedidos
FROM PEDIDOS P;


-- uso do RANK para descobrir qual cliente gastou mais e menos
SELECT P.cliente_id  AS 'Cliente id',
	   P.valor_total AS 'Valor total de compra',
RANK() OVER (ORDER BY P.valor_total DESC) AS rank_exemplo
FROM PEDIDOS P;

-- uso do DENSE RANK para descobrir qual cliente gastou mais e menos
SELECT P.cliente_id  AS 'Cliente id',
	   P.valor_total AS 'Valor total de compra',
DENSE_RANK() OVER (ORDER BY P.valor_total DESC) AS dense_rank_exemplo
FROM PEDIDOS P;

-- uso do LAG para descobrir o valor de pedido anterior
SELECT P.cliente_id   AS 'cliente_id',
	   P.id_pedido	  AS 'pedido_id',
	   P.dt_pedido	  AS 'data pedido',
	   P.valor_total  AS 'Valor total',
LAG(valor_total, 1) OVER(
							PARTITION BY cliente_id
							ORDER BY dt_pedido
						) 	AS valor_pedido_anterior
FROM PEDIDOS P;


-- uso do LEAD para descobrir o valor de pedido sucessor
SELECT P.cliente_id   AS 'cliente_id',
	   P.id_pedido	  AS 'pedido_id',
	   P.dt_pedido	  AS 'data pedido',
	   P.valor_total  AS 'Valor total',
LEAD(valor_total, 1) OVER(
							PARTITION BY cliente_id
							ORDER BY dt_pedido
						) 	AS valor_proximo_pedido
FROM PEDIDOS P;


-- uso do FRIST VALUE para descobrir o valor de primeiro pedido
SELECT P.cliente_id   AS 'cliente_id',
	   P.id_pedido	  AS 'pedido_id',
	   P.dt_pedido	  AS 'data pedido',
	   P.valor_total  AS 'Valor total',
FIRST_VALUE(valor_total) OVER(
							PARTITION BY cliente_id
							ORDER BY dt_pedido
						) 	AS valor_primeiro_pedido
FROM PEDIDOS P;

-- uso do LAST VALUE para descobrir o valor de último valor
SELECT P.cliente_id   AS 'cliente_id',
	   P.id_pedido	  AS 'pedido_id',
	   P.dt_pedido	  AS 'data pedido',
	   P.valor_total  AS 'Valor total',
LAST_VALUE(valor_total) OVER(
							PARTITION BY cliente_id
							ORDER BY dt_pedido
							ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING 
						) 	AS valor_ultimo_pedido
FROM PEDIDOS P;

-- ROWS BETWEEN: entre quais linhas vamos consultar
-- UNBOUNDED PRECEDING: desde a primeira linha disponivel
-- UNBOUNDED FOLLOWING: até a última linha



-- date
-- cálculo de previsão de entrega de um produto

SELECT P.id_pedido 			  AS 'id do produto',
	   P.dt_pedido 			  AS 'data do pedido',
DATE(P.dt_pedido, '+30 days') AS 'data de previsão de entrega'
FROM PEDIDOS P

-- julianday para subtrair e tirar a diferença entre o dia do cadastro do cliente até o dia da compra do pedido
SELECT 	P.id_pedido AS 'Id_pedido',
	    C.nome      AS 'Nome cliente',
	    P.dt_pedido	AS 'Data pedido',
ROUND(JULIANDAY(P.dt_pedido) - JULIANDAY(C.dt_cadastro)) AS dias_cadastro_cliente_ate_pedido
FROM PEDIDOS P
INNER JOIN CLIENTES C ON P.cliente_id = C.id_cliente;

-- strftime para extrair mês e ano 
SELECT P.id_pedido,
	   P.dt_pedido,
STRFTIME('%m', P.dt_pedido) AS 'Mês do pedido',
STRFTIME('%Y', P.dt_pedido) AS 'Ano do pedido'
FROM PEDIDOS P;


-- concatenação de nome e estado 
SELECT 
C.nome || ' - ' || C.estado AS 'nome e estado do cliente'
FROM CLIENTES C;

-- substring para retornar partes do texto
SELECT 
C.nome,
SUBSTR(C.nome, 1, 2) AS 'Iniciais do cliente'
FROM CLIENTES C;

-- substituindo valores
SELECT P.id_pedido 												AS 'ID pedido',
REPLACE(P.status, 'pago', 'Não pago') AS 'Status atualizado',
	   P.dt_pedido 												AS 'Data pedido',
	   P.cliente_id												AS 'ID pedido'
FROM PEDIDOS P;

-- TRIM, LTRIM, RTRIM
SELECT
		'[' || TRIM(' TEXTO ') || ']' 		AS 'TRIM',
		'[' || LTRIM(' TEXTO ') || ']' 		AS 'LTRIM',
		'[' || RTRIM(' TEXTO ') || ']' 		AS 'RTRIM';
		
-- CAST E CONVERT
SELECT CAST('1234' AS INTEGER)  AS 'valor como int';
SELECT CAST(3.4567 AS TEXT)		AS 'valor como string';


-- tabelas temporárias
DROP TABLE IF EXISTS temp_vendas_clientes;

CREATE TEMP TABLE temp_vendas_clientes AS
SELECT 
	C.id_cliente		AS 'id_cliente',
	C.nome				AS 'nome cliente',
	SUM(P.valor_total)  AS 'valor total'
FROM CLIENTES C
INNER JOIN PEDIDOS P ON C.id_cliente = P.cliente_id
GROUP BY C.id_cliente, C.nome;


SELECT * FROM temp_vendas_clientes;

-- Views
CREATE VIEW vendas_clientes AS
SELECT
	C.id_cliente		AS 'id_cliente',
	C.nome				AS 'nome cliente',
	SUM(P.valor_total)  AS 'valor total'
FROM CLIENTES C
INNER JOIN PEDIDOS P ON C.id_cliente = P.cliente_id
GROUP BY C.id_cliente, C.nome;


SELECT * FROM vendas_clientes;


DROP TABLE IF EXISTS temp.tmp_clientes_6m;
DROP TABLE IF EXISTS temp.tmp_ultima_compra;

-- criação da tabela de compras dos últimos 6 meses
CREATE TEMP TABLE tmp_clientes_6m AS
SELECT
    cliente_id,
    SUM(valor_total) AS total_6m,
    AVG(valor_total) AS ticket_medio
FROM PEDIDOS
WHERE dt_pedido >= DATE('now', '-6 months')
GROUP BY cliente_id;

-- criação da tabela com a data da última compra de cada um
CREATE TEMP TABLE tmp_ultima_compra AS
SELECT
    cliente_id,
    MAX(dt_pedido) AS dt_ultima_compra
FROM PEDIDOS
GROUP BY cliente_id;


-- consulta Final Unindo tudo com as tabelas temporárias
SELECT
    C.id_cliente,
    COALESCE(T.total_6m, 0)       AS "total_6m",
    COALESCE(T.ticket_medio, 0)   AS "ticket_medio",
    CASE
        WHEN U.dt_ultima_compra < DATE('now', '-7 days') OR U.dt_ultima_compra IS NULL THEN 1
        ELSE 0
    END AS churn
FROM CLIENTES C
LEFT JOIN temp.tmp_clientes_6m T ON C.id_cliente = T.cliente_id  
LEFT JOIN temp.tmp_ultima_compra U ON C.id_cliente = U.cliente_id; 
-- uso do .temp para consulta nas tabelas temporárias


-- indices

-- usando explain para ver o método usado para a procura

EXPLAIN QUERY PLAN
SELECT *
FROM CLIENTES
WHERE id_cliente = 3;

/*
 * banco de dados está realizando 
 * uma busca rápida e otimizada usando 
 * a chave primária da tabela, id_cliente
 * */

CREATE INDEX IF NOT EXISTS id_pedido_cliente_id
ON PEDIDOS(cliente_id);


/*
 * Em vez de olhar a tabela inteira linha por linha, 
 * o banco de dados usou um atalho 
 * chamado id_pedido_cliente_id para 
 * ir direto nos pedidos do cliente específico 
 * que buscamos (representado pelo ?).
 * SEARCH PEDIDOS USING INDEX id_pedido_cliente_id (cliente_id=?)
 * */

-- resultado desse select
-- coluna id é a quantidade de passos que demos para o resultado
-- coluna parent explica se o passo que demos está dentro de outro passo
EXPLAIN QUERY PLAN
SELECT *
FROM PEDIDOS
WHERE cliente_id = 3;



-- 1. Adicionar novas colunas na tabela CLIENTES
ALTER TABLE CLIENTES ADD COLUMN email TEXT;
ALTER TABLE CLIENTES ADD COLUMN phone TEXT;
ALTER TABLE CLIENTES ADD COLUMN age INTEGER;
ALTER TABLE CLIENTES ADD COLUMN status TEXT;

-- 2. Preencher valores fictícios para os clientes que já existem (IDs de 1 a 5)
UPDATE CLIENTES
SET email = CASE
    WHEN id_cliente % 2 = 0 THEN 'cliente' || id_cliente || '@exemplo.com'
    ELSE NULL
END,
phone = CASE
    WHEN id_cliente % 3 = 0 THEN '(11) 9' || printf('%08d', id_cliente * 123)
    ELSE NULL
END,
age = 18 + (id_cliente % 50),
status = CASE
    WHEN id_cliente % 4 = 0 THEN 'Ativo'
    WHEN id_cliente % 4 = 1 THEN 'Inativo'
    WHEN id_cliente % 4 = 2 THEN 'Pendente'
    ELSE NULL
END;

-- 3. Adicionar novas colunas na tabela PEDIDOS
ALTER TABLE PEDIDOS ADD COLUMN desconto REAL DEFAULT 0;
ALTER TABLE PEDIDOS ADD COLUMN nota_avaliacao INTEGER;

-- 4. Inserir novos clientes especificando os IDs de 6 a 10 de forma fixa
INSERT INTO CLIENTES (id_cliente, nome, estado, dt_cadastro, email, phone, age, status) VALUES
(6, 'Paulo Santos', 'SP', '2024-05-01', 'paulo.santos@email.com', '(11) 99999-1111', 30, 'Ativo'),
(7, 'Carla Dias', 'RJ', '2024-06-10', 'carla.dias@email.com', NULL, 25, 'Inativo'),
(8, 'Rodrigo Costa', 'MG', '2024-07-15', NULL, '(31) 98888-2222', 40, 'Pendente'),
(9, 'Fernanda Lima', 'SP', '2024-08-01', 'fernanda@email.com', '(41) 97777-3333', 28, 'Ativo'),
(10, 'Gustavo Oliveira', 'PR', '2024-09-05', NULL, NULL, 35, 'Ativo');   

-- 5. Inserir novos pedidos vinculados perfeitamente aos IDs acima
INSERT INTO PEDIDOS (cliente_id, dt_pedido, valor_total, desconto, status, nota_avaliacao) VALUES
(6, '2025-08-10', 350.00, 5, 'Entregue', 4),
(7, '2025-08-11', 0.00, 10, 'Pendente', 3),
(8, '2025-08-12', 150.00, 5, 'Cancelado', 2),
(9, '2025-08-13', 200.00, 5, 'Entregue', 5),
(10, '2025-08-14', 0.00, 0, 'Pendente', 2),
(6, '2025-08-15', 500.00, 10, 'Entregue', 4),
(8, '2025-08-16', 600.00, 5, 'Entregue', 5);


-- COALESE
SELECT 
	C.nome,
	COALESCE(C.email, 'Sem e-mail cadastrado') AS 'Email final',
	COALESCE(C.phone, 'Sem telefone cadastrado') AS 'Telefone final'
FROM CLIENTES C;

-- NULLIF
SELECT 
	P.id_pedido,
	P.valor_total,
NULLIF(valor_total, 0) AS 'Valor tratado'
FROM PEDIDOS P;

-- IFNULL
SELECT 
	C.nome,
	IFNULL(C.email, 'sem.email@exemplo.com') AS 'Sem e-mail'
FROM CLIENTES C;

-- CASE
SELECT 
	C.nome,
CASE 
	WHEN SUM(P.valor_total) > 1500 THEN 'VIP'
	WHEN SUM(P.valor_total) >= 800 THEN 'Ouro'
	ELSE 'Comum'
END AS 'Categoria cliente'
FROM CLIENTES C
LEFT JOIN PEDIDOS P ON C.id_cliente = P.cliente_id
GROUP BY C.nome;

-- EXISTS/NOT EXISTS
SELECT 
	C.nome
FROM CLIENTES C
WHERE EXISTS (
				SELECT 1 
				FROM PEDIDOS P
				WHERE P.cliente_id = C.id_cliente 
			);

-- IIF
SELECT C.nome, IIF(C.age < 30, 'Jovem', 'Adulto') AS "Faixa etária"
FROM CLIENTES C;

-- SELF JOIN
SELECT A.id_pedido AS pedido1, B.id_pedido AS pedido2, A.cliente_id, C.nome
FROM PEDIDOS A
JOIN PEDIDOS B -- self join, fazendo join na mesma tabela da consulta principal
	ON A.cliente_id = B.cliente_id
	AND A.id_pedido <> B.id_pedido 
	AND STRFTIME('%m', A.dt_pedido) = STRFTIME('%m', B.dt_pedido)
JOIN CLIENTES C ON A.cliente_id = C.id_cliente;


-- FULL OUTER JOIN

-- pegando os clientes e relacionando eles aos seus pedidos
SELECT 
	C.id_cliente,
	C.nome,
	C.email,
	C.phone,
	C.age,
	
	P.id_pedido,
	P.valor_total,
	P.status
FROM CLIENTES C
LEFT JOIN PEDIDOS P ON C.id_cliente = P.cliente_id

UNION

-- pegando os pedidos e associando aos seus clientes
SELECT 
	C.id_cliente,
	C.nome,
	C.email,
	C.phone,
	C.age,
	
	P.id_pedido,
	P.valor_total,
	P.status
FROM PEDIDOS P
LEFT JOIN CLIENTES C ON P.cliente_id = C.id_cliente;


-- tabela de métodos de pagamento
CREATE TABLE IF NOT EXISTS METODOS_PAGAMENTO (
    id_metodo INTEGER PRIMARY KEY AUTOINCREMENT,
    nome_metodo TEXT NOT NULL UNIQUE
);

INSERT INTO METODOS_PAGAMENTO (nome_metodo) 
VALUES 
    ('Pix'),
    ('Cartão de Crédito'),
    ('Cartão de Debito'),
    ('Boleto');

SELECT * FROM METODOS_PAGAMENTO;

ALTER TABLE PEDIDOS 
ADD COLUMN id_metodo_pg INTEGER 
REFERENCES METODOS_PAGAMENTO(id_metodo);

UPDATE PEDIDOS SET id_metodo_pg = 1 WHERE id_pedido IN (101, 103, 106, 109, 110); -- 1 = Pix
UPDATE PEDIDOS SET id_metodo_pg = 2 WHERE id_pedido IN (102, 104, 107, 108, 112); -- 2 = Cartão de Crédito
UPDATE PEDIDOS SET id_metodo_pg = 4 WHERE id_pedido IN (111);


SELECT * FROM PEDIDOS

-- multiplos joins
SELECT 
	C.id_cliente,
	C.nome,
	C.email,
	C.phone,
	C.age,
	
	P.valor_total,
	P.status,
	M.nome_metodo AS 'Método de pagamento'
FROM CLIENTES C
JOIN PEDIDOS P ON C.id_cliente = P.cliente_id
LEFT JOIN METODOS_PAGAMENTO M ON P.id_metodo_pg = M.id_metodo;
	
