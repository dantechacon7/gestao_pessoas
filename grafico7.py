import pandas as pd
import matplotlib.pyplot as plt

# Dados fornecidos
data = {
    'tempo_permanencia': ['0 a 100 dias', '101 a 250 dias', 'Maior que 250 dias',
                          '0 a 100 dias', '101 a 250 dias', 'Maior que 250 dias',
                          '0 a 100 dias', '101 a 250 dias', 'Maior que 250 dias',
                          '0 a 100 dias', '101 a 250 dias', 'Maior que 250 dias'],
    'faixa_valor_anual': ['Mais de R$ 10k/ano', 'Mais de R$ 10k/ano', 'Mais de R$ 10k/ano',
                          'Menos de R$ 1k/ano', 'Menos de R$ 1k/ano', 'Menos de R$ 1k/ano',
                          'R$ 1k a 5k/ano', 'R$ 1k a 5k/ano', 'R$ 1k a 5k/ano',
                          'R$ 5k a 10k/ano', 'R$ 5k a 10k/ano', 'R$ 5k a 10k/ano'],
    'numero_empresas': [16, 151, 237, 1, 1, 1, 29, 66, 71, 31, 113, 179]
}

df = pd.DataFrame(data)

# Reorganizar os dados para o gráfico
df_pivot = df.pivot(index='tempo_permanencia', columns='faixa_valor_anual', values='numero_empresas')

# Criar o gráfico
df_pivot.plot(kind='bar', figsize=(12, 8))
plt.title('Número de Empresas por Tempo de Permanência e Faixa de Valor')
plt.xlabel('Tempo de Permanência')
plt.ylabel('Número de Empresas')
plt.xticks(rotation=0)
plt.legend(title='Faixa de Valor Anual')
plt.tight_layout()

# Exibir o gráfico
plt.show()
