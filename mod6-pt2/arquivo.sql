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

SELECT * FROM PEDIDOS;
SELECT * FROM CLIENTES;
