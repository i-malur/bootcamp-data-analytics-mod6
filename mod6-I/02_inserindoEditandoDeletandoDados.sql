-- INSERTS

INSERT INTO CLIENTES(id_cliente, nome, email, data_nascimento)
VALUES
		(1, 'Mariana Silva', 'mariana.silva@gmail.com', '2000-02-01'),
		(2, 'Bruno Costa', 'bruno.costa@hotmail.com', '2005-08-08'),
		(3, 'Carolina Santos', 'carolina.santos@yahoo.com.br', '2008-12-20'),
		(4, 'Daniel Souza', 'daniel.souza@gmail.com', '1995-07-01'),
		(5, 'Maria Clara', 'maria.clara@gmail.com', '1997-12-07');

INSERT INTO PRODUTOS(id_produto, nome, preco)
VALUES
	  (101, 'Notebook', 7500.95),
	  (102, 'Mouse', 125.30),
	  (103, 'Monitor', 649.90);


INSERT INTO PEDIDOS(id_pedido, data_pedido, id_cliente, id_produto)
VALUES 
	(1, '2020-08-05', 1, 101),
	(2, '2021-05-30', 2, 102),
	(3, '2022-07-01', 2, 103),
	(4, '2023-08-14', 3, 101),
	(5, '2025-02-10', 4, 101),
	(6, '2025-09-01', 5, 102),
	(NULL, '03/09/2025', 1, 103);


-- Verificando se os registros foram adicionados
SELECT * FROM CLIENTES;
SELECT * FROM PEDIDOS;
SELECT * FROM PRODUTOS;

-- UPDATE COM CONDIÇÃO USANDO WHERE
UPDATE PRODUTOS 
SET PRECO = 6800.50
WHERE id_produto = 101;

-- DELETE
DELETE FROM PEDIDOS 
WHERE id_pedido IS NULL;

DELETE FROM PEDIDOS 
WHERE id_pedido = 3;
