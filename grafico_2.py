import pandas as pd
import matplotlib.pyplot as plt

# Dados fornecidos
data = {
    'Porte da empresa': ['Grande Porte', 'Grande Porte',
                         'Médio Porte', 'Médio Porte',
                         'Pequeno Porte', 'Pequeno Porte'],
    'canal_venda': ['CROSS-SELL', 'MAR ABERTO',
                    'CROSS-SELL', 'MAR ABERTO',
                    'CROSS-SELL', 'MAR ABERTO'],
    'Conversão': [0.6614, 0.6087,
                  0.6168, 0.5381,
                  0.5714, 0.6034]
}

df = pd.DataFrame(data)

# Converter a conversão para porcentagem
df['Conversão'] = df['Conversão'] * 100

# Usar a função `pivot` para organizar os dados para o gráfico de barras agrupado
df_pivot = df.pivot(index='Porte da empresa', columns='canal_venda', values='Conversão')

# Criar o gráfico
df_pivot.plot(kind='bar', figsize=(10, 6))
plt.title('Taxa de Conversão por Porte da Empresa e Canal de Venda')
plt.xlabel('Porte da Empresa')
plt.ylabel('Taxa de Conversão (%)')
plt.xticks(rotation=0)
plt.legend(title='Canal de Venda')
plt.tight_layout()

# Exibir o gráfico
plt.show()
