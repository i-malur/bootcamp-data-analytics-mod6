-- consultas com apelidos para as colunas para apresentação amigável

SELECT PRODUTOS.id_produto AS 'Código', -- apelido para a coluna. Para o banco, a tabela ainda é id_produtos, mas, ele permite apelidos nas tabelas para consultas mais amigáveis
	   PRODUTOS.nome	   AS 'Nome do produto',
	   PRODUTOS.preco	   AS 'Preço do produto'
FROM PRODUTOS;

SELECT CLIENTES.id_cliente         							AS 'Código', 
	   CLIENTES.nome	   		   							AS 'Nome do cliente',
	   CLIENTES.data_nascimento	   							AS 'Data de nascimento',
	   CASE WHEN CLIENTES.data_nascimento <= '2008-12-31' 
	   		THEN 'Apto'
	   		ELSE 'Inapto'
	   END													AS 'Status'
FROM CLIENTES;

/*
 * CASE WHEN condição
 * 		THEN (executa caso condição seja verdadeira)
 * 		ELSE (executa caso condição seja false)
 * END
 * 
 * - cria nova coluna
 * */
