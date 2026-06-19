-- AULA 09

WITH 
-- 1. Calcula a Receita Total
RECEITA_TOTAL AS (
    SELECT SUM(P.valor_total) AS receita_total
    FROM PEDIDOS P
),

-- 2. Calcula o Ticket Médio
TICKET_MEDIO AS (
    SELECT AVG(P.valor_total) AS ticket_medio
    FROM PEDIDOS P
),

-- 3. Identifica os clientes que compraram nos últimos 90 dias
CLIENTES_ATIVOS AS (
    SELECT DISTINCT P.cliente_id AS id_cliente
    FROM PEDIDOS P
    WHERE P.dt_pedido >= DATE('now', '-90 days')
),

-- 4. Identifica quem não comprou nos últimos 90 dias
CLIENTES_INATIVOS AS (
    SELECT DISTINCT C.id_cliente
    FROM CLIENTES C
    LEFT JOIN CLIENTES_ATIVOS CA ON C.id_cliente = CA.id_cliente
    WHERE CA.id_cliente IS NULL
),

-- 5. Calcula a taxa de Churn (Inativos / Total de Clientes * 100)
CHURN_RATE AS (
    SELECT 
        ROUND(
            (CAST(COUNT(*) AS FLOAT) / (SELECT COUNT(*) FROM CLIENTES)) * 100, 
            2
        ) AS churn_rate
    FROM CLIENTES_INATIVOS
), 
-- 6. Top 5 clientes com maiores gastos (Removido o segundo WITH daqui)
ltv_por_cliente AS (
    SELECT 
        P.cliente_id AS cliente_id, 
        SUM(P.valor_total) AS total_gasto
    FROM PEDIDOS P
    WHERE P.status <> 'Cancelado'
    GROUP BY P.cliente_id
),

ltv_top5 AS (
    SELECT json_group_array(
        json_object(
            'cliente', cliente_id,
            'LTV', total_gasto
        )
    ) AS top5_ltv
    FROM (
        SELECT * FROM ltv_por_cliente
        ORDER BY total_gasto DESC
        LIMIT 5
    )
),

-- 7. Receita por estado
receita_estado AS (
    SELECT json_group_array(
        json_object(
            'estado', estado,
            'receita', total_receita
        )
    ) AS receita_por_estado
    FROM (
        SELECT C.estado, SUM(P.valor_total) AS total_receita
        FROM PEDIDOS P
        JOIN CLIENTES C ON P.cliente_id = C.id_cliente 
        GROUP BY C.estado
    )
)

-- RESULTADOS 
SELECT 
    rt.receita_total,
    tm.ticket_medio,
    ch.churn_rate,
    ltv.top5_ltv,
    re.receita_por_estado
FROM RECEITA_TOTAL rt
JOIN TICKET_MEDIO tm ON 1 = 1
JOIN CHURN_RATE ch ON 1 = 1
JOIN ltv_top5 ltv ON 1 = 1
JOIN receita_estado re ON 1 = 1;
