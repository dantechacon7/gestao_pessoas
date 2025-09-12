# 1. Instalação da biblioteca pandasql
!pip install pandasql

# 2. Importação das bibliotecas necessárias
import pandas as pd
from pandasql import sqldf

# 3. Criação de um DataFrame de exemplo
data = {
    'id': [1, 2, 3, 4, 5, 6],
    'segmento': ['Saúde', 'Finanças', 'Varejo', 'Saúde', 'Tecnologia', 'Finanças'],
    'n_colabs': [100, 50, 200, 80, 150, 45],
    'dt_assinatura_pago': ['2024-01-15', None, '2024-02-20', '2024-03-05', None, '2024-04-10'],
    'canal_venda': ['CROSS_SELL', 'MAR ABERTO', 'MAR ABERTO', 'CROSS_SELL', 'MAR ABERTO', 'CROSS_SELL']
}

df_empresas = pd.DataFrame(data)

print("DataFrame Original:")
print(df_empresas)

# 4. Execução de uma consulta SQL usando a função sqldf()
# Teste que evidencia o formnato que devemos seguir daqui em diante:

query = """
    SELECT
        canal_venda,
        COUNT(id) AS total_convertidos
    FROM
        df_empresas
    WHERE
        dt_assinatura_pago IS NOT NULL
    GROUP BY
        canal_venda
"""

# A função sqldf() executa a consulta no DataFrame 'df_empresas'
resultado_sql = sqldf(query, locals())

# Exibindo o resultado da consulta
print("\nResultado da consulta SQL:")
print(resultado_sql)
