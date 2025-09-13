import pandas as pd
import matplotlib.pyplot as plt

# Dados fornecidos
data = {
    'taxa_retencao': [0.878601, 0.917722, 0.929688],
    'nps': ['Detrator', 'Neutro', 'Promotor']
}

df = pd.DataFrame(data)

# Converter a taxa de retenção para porcentagem
df['taxa_retencao_pct'] = df['taxa_retencao'] * 100

# Criar o gráfico de barras horizontais
plt.figure(figsize=(10, 6))
bars = plt.barh(df['nps'], df['taxa_retencao_pct'], color=['#d62728', '#ff7f0e', '#2ca02c'])

plt.title('Taxa de Retenção por Categoria de NPS')
plt.xlabel('Taxa de Retenção (%)')
plt.ylabel('NPS')
plt.xlim(0, 100)
plt.grid(axis='x', linestyle='--', alpha=0.7)

# Adicionar os valores percentuais em cada barra
for bar in bars:
    width = bar.get_width()
    plt.text(width + 1, bar.get_y() + bar.get_height()/2, f'{width:.2f}%', 
             va='center', ha='left', fontsize=12)

plt.tight_layout()
plt.show()
