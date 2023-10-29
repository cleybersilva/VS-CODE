import pyodbc

dados_conexao = (
    "Driver={SQL Server};"
    "Server=cleyber;"
    "Database=PythonSQL;"
)

conexao = pyodbc.connect(dados_conexao)
print("Conexão Bem Sucedida!")