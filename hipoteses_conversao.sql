/* A duração do período de teste afeta a taxa de conversão? */
SELECT
  plano_ft,
  CAST(COUNT(CASE WHEN dt_assinatura_pago IS NOT NULL THEN id END) AS REAL) / 
  CAST(COUNT(id) AS REAL) AS perc_convertido
FROM
  df
GROUP BY
  plano_ft

/* Verificamos que o maior percentual de conversão está na população que conseguiu ter mais tempo para explorar a ferramenta - 30 dias.
plano_ft  perc_convertido
0  14 DIAS         0.584493
1  30 DIAS         0.808383
2   7 DIAS         0.405242
*/

/* A origem do cliente impacta a conversão? */

SELECT
  canal_venda,
  CAST(COUNT(CASE WHEN dt_assinatura_pago IS NOT NULL THEN id END) AS REAL) / 
  CAST(COUNT(id) AS REAL) AS perc_convertido
FROM
  df
GROUP BY
  canal_venda

/* A população advinda do canal de cross-sell - quando o cliente já utiliza outras soluções Caju, foi vista como a com maior percentual de conversão. 
A confiança pré-existente dos clientes que já utilizam outros produtos Caju parece ser um fator de peso para a conversão.
canal_venda  perc_convertido
0  CROSS-SELL         0.611204
1  MAR ABERTO         0.555921
*/

/* O número de colaboradores influencia a conversão? */
SELECT
  CASE
    WHEN n_colabs < 50 THEN 'Pequeno Porte'
    WHEN n_colabs >= 50 AND n_colabs < 250 THEN 'Médio Porte'
    WHEN n_colabs >= 250 THEN 'Grande Porte'
    ELSE 'Não Classificado' -- Para valores nulos ou fora do esperado
  END AS porte_empresa,
  CAST(COUNT(CASE WHEN dt_assinatura_pago IS NOT NULL THEN id END) AS REAL) / 
  CAST(COUNT(id) AS REAL) AS perc_convertido
FROM
  df
GROUP BY
  1
/*  
porte_empresa  perc_convertido
0   Grande Porte         0.653333
1    Médio Porte         0.599607
2  Pequeno Porte         0.577039
Os resultados evidenciam um equilíbrio interessante de conversão dentre empresas de pequeno e médio porte, assim como, uma conversão maior para empresas de grande porte - que possuem mais de 250 colaboradores */
/* O valor por colaborador interfere na conversão? */
SELECT
  preco,
  CAST(COUNT(CASE WHEN dt_assinatura_pago IS NOT NULL THEN id END) AS REAL) / 
  CAST(COUNT(id) AS REAL) AS perc_convertido
FROM
  df
GROUP BY
  1
/* É possível perceber uma diferença muito pequena nas conversões de cada grupo, mas o grupo que paga o menor valor é o que presenta maior conversão.
preco  perc_convertido
0   7,9         0.619141
1   8,9         0.594378
2   9,9         0.585714 */

/* A experiência prévia com a marca afeta a conversão? */
SELECT
  CASE WHEN flag_beneficios = 1 or flag_despesas = 1 or flag_premiacao = 1 THEN 'Sim'
  WHEN flag_premiacao = 0 AND flag_despesas = 0 AND flag_beneficios = 0 THEN 'Não'
  ELSE NULL END AS experiencia_previa,
  CAST(COUNT(CASE WHEN dt_assinatura_pago IS NOT NULL THEN id END) AS REAL) / 
  CAST(COUNT(id) AS REAL) AS perc_convertido
FROM
  df
GROUP BY
  1
/* Apesar de acirrado, o percentual de conversão para o público que já teve experiência com algum produto Caju é mais alto, o que reforça que clientes 
que já usam os produtos Benefícios ou Despesas têm maior taxa de conversão, pois eles já estão familiarizados com a marca e a usabilidade de outras soluções Caju.

 experiencia_previa  perc_convertido
0                Não         0.555921
1                Sim         0.611204



/* A taxa de conversão do canal CROSS_SELL continua mais alta mesmo nos planos de 7 dias? E a do MAR ABERTO, melhora no plano de 30 dias? */

SELECT
  canal_venda,
  plano_ft,
  CAST(COUNT(CASE WHEN dt_assinatura_pago IS NOT NULL THEN id END) AS REAL) / 
  CAST(COUNT(id) AS REAL) AS perc_convertido
FROM
  df
GROUP BY
  canal_venda, plano_ft

/* A taxa do canal cross_sell continua mais alta mesmo nos planos de 7 dias? Sim, mas somente quando comparamos com a performance do mesmo plano para o canal MAR ABERTO. A conversão de cross sell em 30 dias 
é expressivamente superior quando comparado com o mesmo canal. 
E a do MAR ABERTO, melhora no plano de 30 dias? Sim, expressivamente. Contudo, ainda é menor do que a taxa de conversão de cross_sell que possui o mesmo plano_ft.
canal_venda plano_ft  perc_convertido
0  CROSS-SELL  14 DIAS         0.602015
1  CROSS-SELL  30 DIAS         0.815000
2  CROSS-SELL   7 DIAS         0.416040
3  MAR ABERTO  14 DIAS         0.518868
4  MAR ABERTO  30 DIAS         0.782178
5  MAR ABERTO   7 DIAS         0.360825
*/

/* O período de 30 dias de free trial é mais benéfico para empresas de Grande Porte? Empresas pequenas conseguem se converter mais rapidamente? */

SELECT
    CASE
        WHEN n_colabs < 50 THEN 'Pequeno Porte'
        WHEN n_colabs >= 50 AND n_colabs < 250 THEN 'Médio Porte'
        WHEN n_colabs >= 250 THEN 'Grande Porte'
        ELSE 'Não Classificado'
    END AS porte_empresa,
    plano_ft,
    CAST(COUNT(CASE WHEN dt_assinatura_pago IS NOT NULL THEN id END) AS REAL) / 
    CAST(COUNT(id) AS REAL) AS perc_convertido
FROM
    df
GROUP BY
    porte_empresa,
    plano_ft
ORDER BY
    porte_empresa,
    plano_ft

/* Empresas de grande porte que possuem plano_ft de 30 dias realmente possuem uma conversão maior - 84.6%, mas empresas de menor porte também convertem com mais facilidade tendo mais tempo de 
explorar a ferramenta, ou seja, com plano_ft de 30 dias. Em geral, as maiores conversões se dão em empresas que tiveram plano_ft de 30 dias.
 porte_empresa plano_ft  perc_convertido
0   Grande Porte  14 DIAS         0.618182
1   Grande Porte  30 DIAS         0.846154
2   Grande Porte   7 DIAS         0.465116
3    Médio Porte  14 DIAS         0.574405
4    Médio Porte  30 DIAS         0.808696
5    Médio Porte   7 DIAS         0.411243
6  Pequeno Porte  14 DIAS         0.598214
7  Pequeno Porte  30 DIAS         0.788462
8  Pequeno Porte   7 DIAS         0.365217

*/ Clientes com experiência prévia na Caju são mais ou menos sensíveis ao preço? */

SELECT
  CASE WHEN flag_beneficios = 1 or flag_despesas = 1 or flag_premiacao = 1 THEN 'Sim'
  WHEN flag_premiacao = 0 AND flag_despesas = 0 AND flag_beneficios = 0 THEN 'Não'
  ELSE NULL END AS experiencia_previa,
  preco,
  CAST(COUNT(CASE WHEN dt_assinatura_pago IS NOT NULL THEN id END) AS REAL) / 
  CAST(COUNT(id) AS REAL) AS perc_convertido
FROM
  df
GROUP BY
  1, 2

/* É verdade que clientes com experiência prévia são mais sensíveis ao preço, ou seja, o percentual de conversão desse público aumenta conforme o preço diminui, mas curiosamente, 
a população que não possui experiência com os produtos possui o efeito contrário - quanto menor o preço, menor a conversão.
experiencia_previa preco  perc_convertido
0                Não   7,9         0.508621
1                Não   8,9         0.565217
2                Não   9,9         0.604167
3                Sim   7,9         0.651515
4                Sim   8,9         0.600985
5                Sim   9,9         0.581218

Há um adendo importante aqui. Quando quebramos a seleção por porte da empresa, dentre as sem experiência, verificamos que empresas sem experiência que possuem a maior conversão são as de grande porte
que pagam o menor valor por colaborador. A menor barreira de entrada (preço de R$ 7,9) parece ser um fator decisivo para convencer empresas de grande porte a experimentar o produto. 
A estratégia de "entrada acessível" parece funcionar para esse segmento, incentivando a conversão.
*/








