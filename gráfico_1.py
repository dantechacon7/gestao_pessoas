import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

# Dados completos e corrigidos com base na imagem
data = {
    'Porte da empresa': ['Grande Porte', 'Grande Porte', 'Grande Porte',
                         'Grande Porte', 'Grande Porte', 'Grande Porte',
                         'Médio Porte', 'Médio Porte', 'Médio Porte',
                         'Médio Porte', 'Médio Porte', 'Médio Porte',
                         'Pequeno Porte', 'Pequeno Porte', 'Pequeno Porte',
                         'Pequeno Porte', 'Pequeno Porte', 'Pequeno Porte'],
    'canal_venda': ['CROSS-SELL', 'CROSS-SELL', 'CROSS-SELL',
                    'MAR ABERTO', 'MAR ABERTO', 'MAR ABERTO',
                    'CROSS-SELL', 'CROSS-SELL', 'CROSS-SELL',
                    'MAR ABERTO', 'MAR ABERTO', 'MAR ABERTO',
                    'CROSS-SELL', 'CROSS-SELL', 'CROSS-SELL',
                    'MAR ABERTO', 'MAR ABERTO', 'MAR ABERTO'],
    'plano_ft': ['14 DIAS', '30 DIAS', '7 DIAS',
                 '14 DIAS', '30 DIAS', '7 DIAS',
                 '14 DIAS', '30 DIAS', '7 DIAS',
                 '14 DIAS', '30 DIAS', '7 DIAS',
                 '14 DIAS', '30 DIAS', '7 DIAS',
                 '14 DIAS', '30 DIAS', '7 DIAS'],
    'Conversão': [0.6522, 0.8571, 0.4615,
                  0.4444, 0.8000, 0.5000,
                  0.5914, 0.8182, 0.4318,
                  0.5190, 0.7714, 0.3378,
                  0.6064, 0.7831, 0.3542,
                  0.5556, 0.8095, 0.4211]
}

df = pd.DataFrame(data)

# Converter a conversão para porcentagem
df['Conversão'] = df['Conversão'] * 100

# Criar o gráfico usando Seaborn
sns.set_style("whitegrid")
g = sns.catplot(
    data=df,
    x="plano_ft",
    y="Conversão",
    hue="canal_venda",
    col="Porte da empresa",
    kind="bar",
    height=5,
    aspect=0.8,
    palette="viridis"
)

# Adicionar título e ajustar os rótulos
g.fig.suptitle('Taxa de Conversão por Porte da Empresa, Canal e Plano', y=1.02, fontsize=16)
g.set_axis_labels("Plano", "Taxa de Conversão (%)")
g.set_titles(col_template='{col_name}')
g.legend.set_title("Canal de Venda")

# Exibir o gráfico
plt.show()
