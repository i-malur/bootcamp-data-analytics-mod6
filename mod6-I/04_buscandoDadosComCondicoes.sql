-- selecionando cliente específico pelo ID

SELECT * 
FROM CLIENTES
WHERE CLIENTES.id_cliente = 5;

-- selecionando cliente pelo seu nome
-- o nome passado no where deve ser igual ao nome que está no registro
SELECT * 
FROM CLIENTES
WHERE CLIENTES.nome = 'Mariana Silva';

-- comando like: busca um registro com base em apenas uma parte do nome
SELECT * 
FROM CLIENTES
WHERE nome 
LIKE '%Silva%'; -- usamos %% para indicar se tem no meio do nome, ou seja, sabemos que o nome tem "Silva", não importa se está no começo, meio ou fim

SELECT * 
FROM CLIENTES
WHERE nome 
LIKE 'Mari%'; -- usamos % no final para indicar se o nome começa com 'Mari'


-- operadores relacionais


-- selecionando produtos com valores acima de 200
SELECT PRODUTOS.nome, PRODUTOS.preco
FROM PRODUTOS
WHERE PRODUTOS.preco > 200;

-- selecionando todos os clientes exceto com ID = 1
SELECT *
FROM CLIENTES
WHERE CLIENTES.id_cliente != 1; -- != ou <> (os dois deram certo)



-- operadores lógicos
-- AND
SELECT *
FROM PEDIDOS
WHERE PEDIDOS.id_cliente = 1 AND PEDIDOS.DATA_PEDIDO >= '2025-01-01'

-- OR
SELECT *
FROM PRODUTOS
WHERE PRODUTOS.preco < 200 OR PRODUTOS.preco > 8000
