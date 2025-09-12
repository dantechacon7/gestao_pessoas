/* As notas de satisfação estão ligadas à retenção? */
SELECT
    CAST(COUNT(CASE WHEN dt_cancelamento_pago IS NULL AND dt_assinatura_pago IS NOT NULL THEN id END) AS REAL) /
    CAST(COUNT(CASE WHEN dt_assinatura_pago IS NOT NULL THEN id END) AS REAL) AS taxa_retencao,
    CASE WHEN nps_especifico BETWEEN 0 AND 7 THEN 'Detrator'
         WHEN nps_especifico = 8 THEN 'Neutro'
         WHEN nps_especifico BETWEEN 9 AND 10 THEN 'Promotor'
    ELSE NULL END AS nps
FROM
    df
GROUP BY 2

/* Aqui classificamos o perfil do cliente, e estamos analisando o NPS específico do produto de gestão de pessoas. É possível perceber que o cliente promotor - notas entre 9 e 10 - possui a maior taxa de retenção. 
Contudo, até mesmo os detratores se encontram com uma alta taxa de retenção, abrindo espaço para entender o que gerou a insatisfação com o produto para evitarmos churn desses clientes.
taxa_retencao       nps
1       0.878601  Detrator
2       0.917722    Neutro
3       0.929688  Promotor
*/

/* O tamanho da empresa afeta o tempo de permanência no plano pago? */
WITH data AS (
    SELECT
        CASE
            WHEN dt_cancelamento_pago IS NOT NULL
            THEN julianday(dt_cancelamento_pago) - julianday(dt_assinatura_pago)
            ELSE julianday('now') - julianday(dt_assinatura_pago)
        END AS tempo_permanencia_dias,
        CASE
            WHEN n_colabs < 50 THEN 'Pequeno Porte'
            WHEN n_colabs >= 50 AND n_colabs < 250 THEN 'Médio Porte'
            WHEN n_colabs >= 250 THEN 'Grande Porte'
            ELSE 'Não Classificado'
        END AS porte_empresa
    FROM
        df
    WHERE
        dt_assinatura_pago IS NOT NULL
)

SELECT
    CASE
        WHEN tempo_permanencia_dias BETWEEN 0 AND 100 THEN '0 a 100 dias'
        WHEN tempo_permanencia_dias BETWEEN 101 AND 250 THEN '101 a 250 dias'
        WHEN tempo_permanencia_dias > 250 THEN 'Maior que 250 dias'
        ELSE NULL
    END AS tempo_permanencia,
    porte_empresa,
    COUNT(porte_empresa) as numero_empresas
FROM
    data
GROUP BY
    tempo_permanencia,
    porte_empresa
ORDER BY
    porte_empresa,
    tempo_permanencia

/* Não há correlação. Apesar da maior parte das empresas de grande porte possuírem permanência maior que 250 dias, as empresas de pequeno e médio porte também se concentra em períodos mais longos de permanência.
tempo_permanencia  porte_empresa  numero_empresas
0                 None   Grande Porte                1
1         0 a 100 dias   Grande Porte                7
2       101 a 250 dias   Grande Porte               36
3   Maior que 250 dias   Grande Porte               54
4                 None    Médio Porte                3
5         0 a 100 dias    Médio Porte               36
6       101 a 250 dias    Médio Porte              218
7   Maior que 250 dias    Médio Porte              354
8         0 a 100 dias  Pequeno Porte               34
9       101 a 250 dias  Pequeno Porte               77
10  Maior que 250 dias  Pequeno Porte               80
*/

/* A origem do cliente impacta a taxa de retenção? */
SELECT
    CAST(COUNT(CASE WHEN dt_cancelamento_pago IS NULL AND dt_assinatura_pago IS NOT NULL THEN id END) AS REAL) /
    CAST(COUNT(CASE WHEN dt_assinatura_pago IS NOT NULL THEN id END) AS REAL) AS taxa_retencao,
    canal_venda
FROM
    df
GROUP BY 2

/* Curiosamente, clientes de MAR ABERTO possuem uma taxa de retenção superior aos clientes CROSS-SELL. Apesar de ser uma resposta contraintuitiva, isso nos mostra que a empresa buscou ativamente uma solução 
como a caju. Isso significa que eles tinham uma necessidade clara e imediata, e esse produto foi a resposta que encontraram. Eles passaram pelo funil de venda e pelo free trial por uma demanda genuína.
Já no cenário de cross-sell, a oferta pode ter sido mais um "upgrade" ou uma sugestão baseada no histórico do cliente com a Caju. A conversão pode ter ocorrido mais por conveniência e confiança na marca
do que por uma necessidade urgente e intrínseca do produto. O cliente MAR ABERTO, apesar de mais difícil de converter, parece ser um cliente mais fiel a longo prazo.

taxa_retencao canal_venda
0       0.893297  CROSS-SELL
1       0.928994  MAR ABERTO

*/

/* O valor da assinatura está associado ao tempo de permanência? */

WITH data AS (
    SELECT
        CASE
            WHEN dt_cancelamento_pago IS NOT NULL
            THEN julianday(dt_cancelamento_pago) - julianday(dt_assinatura_pago)
            ELSE julianday('now') - julianday(dt_assinatura_pago)
        END AS tempo_permanencia_dias,
        (preco * n_colabs * 12) AS valor_total_anual
    FROM
        df
    WHERE
        dt_assinatura_pago IS NOT NULL
)

SELECT
    CASE
        WHEN tempo_permanencia_dias BETWEEN 0 AND 100 THEN '0 a 100 dias'
        WHEN tempo_permanencia_dias BETWEEN 101 AND 250 THEN '101 a 250 dias'
        WHEN tempo_permanencia_dias > 250 THEN 'Maior que 250 dias'
        ELSE NULL
    END AS tempo_permanencia,
    CASE
        WHEN valor_total_anual < 1000 THEN 'Menos de R$ 1k/ano'
        WHEN valor_total_anual >= 1000 AND valor_total_anual < 5000 THEN 'R$ 1k a 5k/ano'
        WHEN valor_total_anual >= 5000 AND valor_total_anual < 10000 THEN 'R$ 5k a 10k/ano'
        WHEN valor_total_anual >= 10000 THEN 'Mais de R$ 10k/ano'
        ELSE NULL
    END AS faixa_valor_anual,
    COUNT(1) AS numero_empresas
FROM
    data
GROUP BY
    tempo_permanencia,
    faixa_valor_anual
ORDER BY
    faixa_valor_anual,
    tempo_permanencia;

/* A proporção de clientes com tempo de permanência "Maior que 250 dias" é muito alta nas faixas de maior valor. 
No grupo "Mais de R$ 10k/ano", 237 empresas (58.23% do total do grupo) permanecem por mais de 250 dias.
No grupo "R$ 5k a 10k/ano", 179 empresas (55.24% do total do grupo) também estão na faixa de maior retenção.

tempo_permanencia   faixa_valor_anual  numero_empresas
0                 None  Mais de R$ 10k/ano                3
1         0 a 100 dias  Mais de R$ 10k/ano               16
2       101 a 250 dias  Mais de R$ 10k/ano              151
3   Maior que 250 dias  Mais de R$ 10k/ano              237
4         0 a 100 dias  Menos de R$ 1k/ano                1
5       101 a 250 dias  Menos de R$ 1k/ano                1
6   Maior que 250 dias  Menos de R$ 1k/ano                1
7         0 a 100 dias      R$ 1k a 5k/ano               29
8       101 a 250 dias      R$ 1k a 5k/ano               66
9   Maior que 250 dias      R$ 1k a 5k/ano               71
10                None     R$ 5k a 10k/ano                1
11        0 a 100 dias     R$ 5k a 10k/ano               31
12      101 a 250 dias     R$ 5k a 10k/ano              113
13  Maior que 250 dias     R$ 5k a 10k/ano              179
*/
