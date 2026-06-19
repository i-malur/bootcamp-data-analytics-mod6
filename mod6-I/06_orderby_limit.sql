-- Order by
-- por padrão, order by vai ser ASC

-- ordenando os clientes por ordem alfabética - ASC
SELECT *
FROM CLIENTES 
ORDER BY CLIENTES.nome ASC;

-- ordenando os clientes por ordem alfabética inversa - DESC
SELECT *
FROM CLIENTES 
ORDER BY CLIENTES.nome DESC;

-- ordenando os produtos do maior para o menor valor - DESC
SELECT *
FROM PRODUTOS 
ORDER BY PRODUTOS.preco DESC;


-- limit
-- vendo o produto mais caro
-- ordena e depois limita
SELECT *
FROM PRODUTOS 
ORDER BY PRODUTOS.preco DESC
LIMIT 1; -- limita a quantidade de registros que retornam


-- vendo o produto mais barato
-- ordena e depois limita
SELECT *
FROM PRODUTOS 
ORDER BY PRODUTOS.preco ASC
LIMIT 1; -- limita a quantidade de registros que retornam

-- distinct

-- criando nova coluna e add valores
ALTER TABLE CLIENTES ADD COLUMN cidade VARCHAR(50);
UPDATE CLIENTES SET cidade = 'São Paulo' WHERE ID_CLIENTE IN (1,3);
UPDATE CLIENTES SET cidade = 'Rio de Janeiro' WHERE ID_CLIENTE = 2;
UPDATE CLIENTES SET cidade = 'Belo Horizonte' WHERE ID_CLIENTE = 4;

-- apresentar valores sem repetições
SELECT DISTINCT CLIENTES.cidade
FROM CLIENTES
