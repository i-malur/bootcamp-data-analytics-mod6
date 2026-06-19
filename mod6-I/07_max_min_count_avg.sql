-- COUNT

-- contando o total de clientes
SELECT COUNT(*) AS 'Total de clientes'
FROM CLIENTES;

SELECT COUNT(CLIENTES.cidade) AS 'Clientes com cidades'
FROM CLIENTES;

-- COUNT(Coluna) não conta as linhas da coluna que possui NULL


-- SUM
-- calculando o valor total dos produtos
SELECT SUM(PRODUTOS.preco) AS 'Valor total'
FROM PRODUTOS

-- AVG
-- calculando o preço médio dos produtos
SELECT AVG(PRODUTOS.preco) AS 'Preço Médio'
FROM PRODUTOS

-- MAX e MIN
-- pegando o menor e maior valor dos produtos
SELECT MIN(PRODUTOS.preco) AS 'Produto mais barato',
	   MAX(PRODUTOS.preco) AS 'Produto mais caro'
FROM PRODUTOS
