import pandas as pd
import matplotlib.pyplot as plt

# Dados completos e corrigidos com base na imagem
data = {
    'segmento': ['ALIMENTAÇÃO', 'ALIMENTAÇÃO', 'ALIMENTAÇÃO',
                 'INDÚSTRIA', 'INDÚSTRIA', 'INDÚSTRIA',
                 'SERVIÇOS', 'SERVIÇOS', 'SERVIÇOS',
                 'TI', 'TI', 'TI',
                 'VAREJO', 'VAREJO', 'VAREJO'],
    'plano_ft': ['14 DIAS', '30 DIAS', '7 DIAS',
                 '14 DIAS', '30 DIAS', '7 DIAS',
                 '14 DIAS', '30 DIAS', '7 DIAS',
                 '14 DIAS', '30 DIAS', '7 DIAS',
                 '14 DIAS', '30 DIAS', '7 DIAS'],
    'Conversão': [0.6333, 0.8254, 0.4333,
                  0.4796, 0.8514, 0.3626,
                  0.9157, 0.9610, 0.7067,
                  0.8312, 0.9759, 0.6203,
                  0.3730, 0.6618, 0.2094]
}

df = pd.DataFrame(data)

# Converter a conversão para porcentagem
df['Conversão'] = df['Conversão'] * 100

# Usar a função `pivot_table` para lidar com dados duplicados, se houver
df_pivot = df.pivot_table(index='segmento', columns='plano_ft', values='Conversão')

# Criar o gráfico
df_pivot.plot(kind='bar', figsize=(12, 8))
plt.title('Taxa de Conversão por Segmento e Plano')
plt.xlabel('Segmento')
plt.ylabel('Taxa de Conversão (%)')
plt.xticks(rotation=45, ha='right')
plt.legend(title='Plano')
plt.tight_layout()

# Exibir o gráfico
plt.show()
