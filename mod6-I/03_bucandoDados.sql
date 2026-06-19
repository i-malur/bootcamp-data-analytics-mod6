-- selecionando TODAS as colunas da tabela CLIENTE

SELECT * FROM CLIENTES;

-- selecionando as colunas nome e email dos clientes

SELECT CLIENTES.nome, CLIENTES.email FROM CLIENTES;

-- selecionando TODAS as colunas da tabela PRODUTOS

SELECT * FROM PRODUTOS;

-- selecionando nome e preço dos produtos

SELECT PRODUTOS.nome, PRODUTOS.preco FROM PRODUTOS;

-- selecionando TODAS as colunas da tabela PEDIDOS

SELECT * FROM PEDIDOS;

-- selecionando apenas o ID e data do pedido

SELECT PEDIDOS.id_pedido, PEDIDOS.data_pedido FROM PEDIDOS;


-- selecionando mais tabelas

SELECT PEDIDOS.data_pedido, CLIENTES.nome, PRODUTOS.nome
FROM PEDIDOS, CLIENTES, PRODUTOS
WHERE PEDIDOS.id_cliente = CLIENTES.id_cliente;
