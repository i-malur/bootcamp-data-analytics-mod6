-- começamos a criação de tabelas que não precisam de outras conexões para existir,
-- ou seja, tabelas sem FK


-- CREATE 
CREATE TABLE CLIENTES(
	id_cliente int primary key,
	nome varchar(100),
	email varchar(50) ;

)

CREATE TABLE PRODUTOS(
	id_produto int primary key,
	nome varchar(100),
	preco decimal(10,2);
)

CREATE TABLE PEDIDOS(
	id_pedido int primary key,
	data_pedido datetime,
	id_cliente int,
	id_produto int,
	
	FOREIGN KEY (id_cliente) REFERENCES CLIENTES(id_cliente),
	FOREIGN KEY (id_produto) REFERENCES PRODUTOS(id_produto);
)

-- ALTER TABLE
ALTER TABLE CLIENTES 
ADD COLUMN data_nascimento DATE;


-- EXEMPLO DE EXCLUSÃO
-- DROP TABLE CLIENTES ;
