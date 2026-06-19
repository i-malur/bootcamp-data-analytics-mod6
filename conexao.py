import sqlite3


conexao = sqlite3.connect('C:/Users/ACER/Documents/banco_dados_mod6/bi_class.db')
cursor = conexao.cursor()

cursor.executescript('''
    DROP TABLE IF EXISTS CLIENTES;
    DROP TABLE IF EXISTS PEDIDOS;
    
    CREATE TABLE IF NOT EXISTS CLIENTES(
        id_cliente INTEGER PRIMARY KEY,
        nome TEXT NOT NULL,
        estado VARCHAR(2),
        dt_cadastro DATE NOT NULL
    );
    
    CREATE TABLE IF NOT EXISTS PEDIDOS(
        id_pedido INTEGER PRIMARY KEY,
        cliente_id INTEGER NOT NULL,
        dt_pedido DATE NOT NULL,
        status TEXT,
        valor_total REAL NOT NULL,
        
        
        FOREIGN KEY(cliente_id) REFERENCES clientes(id_cliente)
    );
''')

cursor.executemany('''
    INSERT INTO CLIENTES(id_cliente, nome, estado, dt_cadastro)
    VALUES(?, ?, ?, ?)
    ''', [
        (1, 'Ana Luiza', 'SP', '2024-05-01'),
        (2, 'Bruno Sousa', 'RJ', '2024-03-10'),
        (3, 'Carla Dias', 'MG', '2024-02-15'),
        (4, 'Diego Ramos', 'SP', '2024-03-01'),
        (5, 'Eva Fagundes', 'PR', '2024-04-01')
    ]
)

cursor.executemany('''
    INSERT INTO PEDIDOS(id_pedido, cliente_id, dt_pedido, status, valor_total)
    VALUES (?, ?, ?, ?, ?)
    ''', [
        (101, 1, '2025-03-10', 'pago', 700.00),
        (102, 1, '2025-06-05', 'pago', 450.00),
        (103, 2, '2025-01-20', 'pago', 300.00),
        (104, 2, '2025-07-15', 'pago', 600.00),
        (105, 3, '2025-03-12', 'pago', 200.00),
        (106, 3, '2025-05-09', 'pago', 300.00),
        (107, 3, '2025-08-01', 'pago', 1200.00),
        (108, 4, '2024-12-30', 'pago', 900.00),
        (109, 4, '2025-02-25', 'pago', 510.00),
        (110, 5, '2025-04-14', 'pago', 200.00),
        (111, 5, '2025-04-30', 'pago', 220.00),
        (112, 5, '2025-05-12', 'pago', 260.00)
    ]
)

conexao.commit()
conexao.close()

print('Banco criado e dados inseridos com sucesso!!')