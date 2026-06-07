
INSERT INTO CLIENTES(id_cliente, nome, email, data_nascimento, cidade)
VALUES(7, 'Maria Luiza', 'marialuiza@gmail.com' ,'21/11/2005', 'São Paulo')

INSERT INTO PEDIDOS(id_pedido, id_produto, data_pedido)
VALUES(7, 103, '09/04/2025')

SELECT * FROM PEDIDOS

-- Mostrando apenas os clientes que tem pedidos
SELECT CLIENTES.nome, PEDIDOS.data_pedido
FROM CLIENTES
	INNER JOIN PEDIDOS ON PEDIDOS.id_cliente = CLIENTES.id_cliente;

-- Mostrando todos os clientes que tem ou não pedidos
SELECT CLIENTES.nome, PEDIDOS.data_pedido
FROM CLIENTES
	LEFT JOIN PEDIDOS ON PEDIDOS.id_cliente = CLIENTES.id_cliente;
-- left considera tudo da tabela a esquerda

-- Mostrando todos os pedidos que tem ou não clientes
SELECT CLIENTES.nome, PEDIDOS.data_pedido
FROM CLIENTES
	RIGHT JOIN PEDIDOS ON PEDIDOS.id_cliente = CLIENTES.id_cliente;
-- left considera tudo da tabela a direita

-- TABELA DO FROM É A TABELA A ESQUERDA E TABELA DO JOIN É A TABELA DA DIREITA
-- nesse caso clientes a esquerda e pedidos a direita


-- Sintaxe antiga usando o WHERE - pegando todos os clientes com pedidos
SELECT CLIENTES.nome, PEDIDOS.data_pedido
FROM CLIENTES, PEDIDOS
WHERE CLIENTES.id_cliente = PEDIDOS.id_cliente
