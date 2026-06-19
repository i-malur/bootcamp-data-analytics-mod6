-- GROUP BY

-- contando clientes POR CIDADE
SELECT CLIENTES.cidade AS 'Cidade',
	   COUNT(*)		   AS 'Quantidade de clientes'
FROM CLIENTES
GROUP BY CLIENTES.cidade; -- agrupando os clientes por cidade


-- HAVING
SELECT CLIENTES.cidade AS 'Cidade',
COUNT(*) 			   AS "Quantidade de Clientes"
FROM CLIENTES
GROUP BY CLIENTES.cidade
HAVING COUNT(*) > 1;

-- Não usamos o WHERE, pois, o where é observado primeiro antes do agrupamento, com o HAVING, podemos fazer filtros de grupo

/*	O HAVING serve para filtrar os resultados de um agrupamento em uma consulta SQL.
	Ele funciona exatamente como o WHERE, mas com uma diferença de "momento". 
	Enquanto o WHERE filtra linhas individuais antes dos dados serem agrupados, 
	o HAVING filtra os grupos depois que o agrupamento (GROUP BY) já foi feito.
*/
