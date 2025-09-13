import pandas as pd
import matplotlib.pyplot as plt

# Dados fornecidos
data = {
    'Experiência Prévia?': ['Não', 'Não', 'Não', 'Sim', 'Sim', 'Sim'],
    'Preço': [7.9, 8.9, 9.9, 7.9, 8.9, 9.9],
    'Conversão': [0.50862, 0.56522, 0.60417, 0.65152, 0.60099, 0.58122]
}

df = pd.DataFrame(data)

# Converter a conversão para porcentagem
df['Conversão'] = df['Conversão'] * 100

# Usar a função `pivot` para organizar os dados para o gráfico de linhas
df_pivot = df.pivot(index='Preço', columns='Experiência Prévia?', values='Conversão')

# Criar o gráfico
df_pivot.plot(kind='line', marker='o', figsize=(10, 6))
plt.title('Taxa de Conversão por Preço e Experiência Prévia')
plt.xlabel('Preço')
plt.ylabel('Taxa de Conversão (%)')
plt.xticks(df_pivot.index)
plt.grid(True)
plt.legend(title='Experiência Prévia?')
plt.tight_layout()

# Exibir o gráfico
plt.show()
