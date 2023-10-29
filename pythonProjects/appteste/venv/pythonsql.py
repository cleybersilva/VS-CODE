import pyodbc

dados_conexao = (
    "Driver={SQL Server};"
    "Server=cleyber;"
    "Database=PythonSQL;"
)

conexao = pyodbc.connect(dados_conexao)
print("Conexão Bem Sucedida!")

cursor = conexao.cursor()

comando = """INSERT INTO Vendas(id_venda, cliente, produto, data_venda, preco, quantidade)
VALUES
    (1, 'Lira', 'PC', '15/02/2021', 8000, 1)"""

cursor.execute(comando)