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
    (2, 'Juci', 'Iphone', '29/10/2023', 8000, 1)"""

cursor.execute(comando)
cursor.commit()