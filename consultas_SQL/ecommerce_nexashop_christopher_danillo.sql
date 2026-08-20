/*DANILLO*/

-- Atividade 0 — Validação do ambiente (entrega individual, rápida)
USE ecommerce_nexashop;
SELECT
'clientes' AS tabela, COUNT(*) AS total FROM clientes
UNION ALL
SELECT
'produtos' AS tabela, COUNT(*) AS total FROM produtos
UNION ALL
SELECT
'pedidos' AS tabela, COUNT(*) AS total FROM pedidos
UNION ALL
SELECT
'avaliacoes' AS tabela, COUNT(*) AS total FROM avaliacoes;

Explicação: Os comandos a cima mostra uma tabela, sem filtro nenhum.
O SELECT * traz todas as colunas e o LIMIT 10 segura o resultado pra não
despejar a tabela inteira na tela.

/*------------------------------------------------------------*/
-- Bloco 1 — Reconhecimento do banco

/*Tarefa 1.1 — Primeiro contato com os dados
Tarefa: Execute um SELECT * com LIMIT 10 em cada uma das quatro tabelas (clientes, produtos, pedidos, avaliacoes).
Evidência esperada: As quatro consultas executadas e, em uma frase por tabela, o que ela representa no negócio da NexaShop.*/
--  >>>> DANILLO <<<<

-- >>>>>>>>>>>>>>Tabela de avaliações
SELECT * FROM ecommerce_nexashop.avaliacoes LIMIT 10; 
-- >>>>>>>>>>>>>>Tabela de clientes
SELECT * FROM ecommerce_nexashop.clientes LIMIT 10;
-- >>>>>>>>>>>>>>Tabela de pedidos
SELECT * FROM ecommerce_nexashop.pedidos LIMIT 10;
-- >>>>>>>>>>>>>>Tabela de produtos
SELECT * FROM ecommerce_nexashop.produtos LIMIT 10;

Explicação: Tabela, sem filtro nenhum.
O SELECT * traz todas as colunas e o LIMIT 10 segura o resultado pra não
despejar a tabela inteira na tela, serve só pra reconhecer estrutura e dado de exemplo.

    
/*--------------------------------------------------------------*/
/*Tarefa 1.2 — Catálogo de produtos para o marketing
Contexto: O time de marketing pediu uma listagem legível do catálogo, sem colunas técnicas desnecessárias.
Tarefa: Liste nome, categoria, marca, preço (com alias "Valor (R$)") e estoque de todos os produtos, sem usar SELECT *.
Evidência esperada: Consulta com seleção objetiva de colunas e alias amigável para quem não é da área técnica.*/

SELECT 
    nome, 
    categoria, 
    marca, 
    preco AS "Valor (R$)", 
    estoque 
FROM 
    produtos;
/*-----------------------------------------------------------------*/
/*Tarefa 1.3 — Quantas categorias a loja realmente vende
Contexto: A diretoria quer saber quantas categorias de produto a NexaShop trabalha antes de decidir se vale abrir uma nova linha.
Tarefa: Liste as categorias de produtos sem repetição, em ordem alfabética.
Evidência esperada: Uso correto de DISTINCT combinado com ORDER BY.*/
--  >>>> DANILLO <<<<

SELECT DISTINCT categoria 
FROM produtos 
ORDER BY categoria;

-- >>>> pesquisa feita para que coloca-se um sequencial numérico para que aparecesse a contagem de categorias<<<<<
/*SELECT  
    categoria, 
    ROW_NUMBER() OVER (ORDER BY categoria) AS quantidade
FROM produtos
GROUP BY categoria;*/

Explicação: Retorna categorias únicas da tabela produtos, ordenadas em ordem alfabética.
DISTINCT elimina categorias repetidas, então cada nome aparece só uma
vez no resultado. O ORDER BY organiza essa lista em ordem alfabética. Não conta
quantidade, só mostra as categorias únicas
Pra contar teria que usar COUNT(DISTINCT categoria).
/*--------------------------------------------------------------*/

/* Tarefa 2.1 — Clientes ativos da região Sul
Contexto: O time comercial quer priorizar uma campanha regional.
Tarefa: Liste nome, cidade, estado e status dos clientes ativos dos estados SC, PR e RS, ordenando por estado e depois por nome.
Evidência esperada: WHERE com status = 'Ativo', IN para os estados, AND e ORDER BY em duas*/

SELECT nome, cidade, estado, status
FROM clientes
WHERE status = 'Ativo' AND estado IN ('SC', 'PR', 'RS')
ORDER BY estado, nome;

Explicação: Seleciona clientes ativos do Sul e ordena por estado e nome.
O WHERE filtra só clientes com status 'Ativo', e o IN funciona como um
"OR" simplificado pra pegar os três estados da região Sul de uma vez. O AND une os
dois filtros, e o ORDER BY estado, nome ordena primeiro por estado e, dentro d o
mesmo estado, por nome (ordenação em duas colunas).
/*--------------------------------------------------------------*/
/*Tarefa 2.2 — Busca de cliente por nome (tela de atendimento)
Contexto: O atendimento recebe do cliente apenas parte do nome.
Tarefa: Crie uma consulta que encontre clientes cujo nome contenha um termo escolhido pela dupla.
Evidência esperada: Uso correto de LIKE com o caractere %.*/

SELECT id, nome, email, telefone, cidade, estado
FROM clientes
WHERE nome LIKE '%joaquim%';

/*-------------------------------------------------------*/

/*Tarefa 2.3 — Clientes sem telefone cadastrado
Contexto: Uma campanha de atualização cadastral por e-mail será disparada para quem não tem telefone informado.
Tarefa: Liste nome, e-mail, cidade e estado dos clientes com telefone nulo.
Evidência esperada: Uso de IS NULL e seleção objetiva de colunas.*/

SELECT nome, email, cidade, estado
FROM clientes
WHERE telefone IS NULL;


Explicação: O IS NULL filtra exatamente os registros que não
têm telefone preenchido, que é o público-alvo da campanha por e-mail.

/*--------------------------------------------------------------*/

/*arefa 2.5 — Alerta de reposição de estoque
Contexto: O time de compras precisa saber quais produtos ativos estão com estoque crítico.
Tarefa: Liste nome, categoria e estoque dos produtos ativos com estoque menor que 10, ordenados do menor estoque para o maior.
Evidência esperada: WHERE com duas condições unidas por AND e ORDER BY ascendente.*/


SELECT nome, categoria, estoque
FROM produtos
WHERE ativo = 1 AND estoque < 10
ORDER BY estoque ASC;

Explicação: WHERE com duas condições (produto ativo e estoque abaixo de 10) ligadas
por AND, então as duas precisam ser verdadeiras ao mesmo tempo. ORDER BY estoque ASC
é o padrão do ORDER BY, mas deixar o ASC explícito reforça que é crescente —
os itens mais críticos (estoque menor) aparecem primeiro.

/*Bloco 3 — Indicadores agregados
Recursos praticados: COUNT, SUM, AVG, MIN, MAX, GROUP BY, HAVING, TIMESTAMPDIFF
Chegou a hora de transformar linhas em indicadores — o tipo de número que aparece em um dashboard de gestão.

Tarefa 3.1 — Radar de ticket médio
Contexto: A diretoria comercial pediu um indicador rápido do comportamento de compra.
Tarefa: Calcule, apenas para pedidos aprovados, a quantidade de pedidos, o ticket médio (arredondado em 2 casas), o menor e o maior valor.
Evidência esperada: Uso de COUNT, AVG com ROUND, MIN, MAX e aliases claros para cada indicador.
*/

SELECT COUNT(id) AS quantidade_pedidos, ROUND(AVG(valor_total), 2) AS ticket_medio,
MIN(valor_total) AS menor_valor,
MAX(valor_total) AS maior_valor
FROM pedidos
WHERE status = 'Aprovado';

Explicação: Junta quatro funções agregadoras numa consulta só — COUNT conta as
linhas, AVG tira a média (com ROUND arredondando pra 2 casas decimais), e MIN/MAX
pegam os extremos. O WHERE filtra pra considerar só pedidos aprovados antes de agregar,
então o cálculo não mistura pedidos cancelados ou pendentes.

/*--------------------------------------------------------------*/
/*Tarefa 3.3 — Onde estão os clientes da NexaShop
Tarefa: Mostre a quantidade de clientes por estado, ordenando do estado com mais clientes 
para o com menos.Evidência esperada: GROUP BY combinado com ORDER BY.*/

SELECT estado, COUNT(id) AS quantidade_clientes
FROM clientes
GROUP BY estado
ORDER BY quantidade_clientes DESC;

Explicação: (GROUP BY estado) agrupa todos os clientes por estado e o COUNT conta
quantos caem em cada grupo. O ORDER BY quantidade_clientes DESC ordena do estado com
mais clientes pro com menos.

/*--------------------------------------------------------------------*/
/*Tarefa 3.5 — Perfil etário por segmento de cliente
Tarefa: Calcule a idade média dos clientes (usando TIMESTAMPDIFF) agrupada por segmento (Varejo, Atacado, Corporativo).
Evidência esperada: Função de data combinada corretamente com GROUP BY.*/

SELECT segmento, ROUND(AVG(TIMESTAMPDIFF(YEAR, data_nascimento, NOW())), 2) AS idade_media
FROM clientes
GROUP BY segmento;

/*ENTENDIMENTO>>>>>>
TIMESTAMPDIFF(YEAR, data_nascimento, NOW())Essa função calcula a diferença de tempo entre duas datas. 
Ela precisa de 3 informações:YEAR: Diz que você quer o resultado em Anos (a idade da pessoa).data_nascimento: 
A data antiga (quando o cliente nasceu).NOW(): A data atual (o dia de hoje no relógio do computador).*/

Explicação: TIMESTAMPDIFF calcula a idade de cada cliente em anos na hora da consulta
(NOW() traz a data atual). Isso vira o "DAdo" que entra dentro do AVG, então a
média é calculada em cima da idade calculada, e o GROUP BY segmento separa esse
cálculo por Varejo, Atacado e Corporativo.

/*-------------------------------------------------------------------*/

/*Tarefa 3.6 — Valor de estoque parado por categoria
Contexto: O financeiro quer saber onde está concentrado o capital investido em estoque.
Tarefa: Para produtos ativos, calcule o valor total em estoque (preço × estoque) por categoria, ordenado do maior para o menor.
Evidência esperada: Expressão calculada dentro de uma função agregadora — SUM(preco * estoque) — combinada com GROUP BY e ORDER BY.*/

SELECT categoria, SUM(preco * estoque) AS valor_estoque_parado
FROM produtos
WHERE ativo = 1
GROUP BY categoria
ORDER BY valor_estoque_parado DESC;

/*----------------------------------------------------*/
/*----------------------------------------------------*/
/*Bloco 4 — Classificação com CASE e regras de negócio
Recursos praticados: CASE, GROUP BY pelo alias do CASE, AVG(CASE WHEN...) para taxas percentuais
Números isolados dizem pouco sem uma régua de interpretação. É isso que o CASE resolve.

Tarefa 4.1 — Classificando avaliações
Tarefa: Usando CASE, classifique cada avaliação (coluna nota) em 'Excelente' (5), 'Boa' (4), 'Regular' (3) ou 'Insatisfatória' (1 ou 2).
Evidência esperada: CASE com múltiplas condições e alias para a coluna resultante.
*/

SELECT id, pedido_id, nota, comentario,
       CASE 
           WHEN nota = 5 THEN 'Excelente'
           WHEN nota = 4 THEN 'Boa'
           WHEN nota = 3 THEN 'Regular'
           WHEN nota IN (1, 2) THEN 'Insatisfatória'
       END AS classificacao_avaliacao
FROM avaliacoes;

Explicação: CASE funciona tipo um if/else dentro do SELECT — testa cada WHEN em
ordem e, no primeiro que bater, atribui o valor do THEN. Não altera os dados da
tabela, só cria uma coluna nova com o AS (classificacao_avaliacao).

/*-----------------------------------------------------*/

/*Tarefa 4.2 — Quantas avaliações caem em cada faixa
Contexto: A qualidade quer um resumo por faixa, não avaliação por avaliação.
Tarefa: A partir da classificação da tarefa 4.1, mostre quantas avaliações existem em cada faixa, da maior para a 
menor quantidade, em uma única consulta.
Evidência esperada: Agrupamento pelo alias definido no CASE (GROUP BY na faixa), sem uso de subconsulta.*/

SELECT 
    CASE 
        WHEN nota = 5 THEN 'Excelente'
        WHEN nota = 4 THEN 'Boa'
        WHEN nota = 3 THEN 'Regular'
        WHEN nota IN (1, 2) THEN 'Insatisfatória'
    END AS faixa_avaliacao,
    COUNT(*) AS quantidade_avaliacoes
FROM avaliacoes
GROUP BY faixa_avaliacao
ORDER BY quantidade_avaliacoes DESC;

/*----------------------------------------------------------*/

/*Tarefa 4.3 — Taxa de aprovação de pedidos
Contexto: A diretoria pediu, literalmente, "a taxa de aprovação dos pedidos, em percentual" — 
uma métrica de conversão comum em qualquer negócio digital.
Tarefa: Calcule, em uma única consulta, o percentual de pedidos com status = 'Aprovado' em relação ao total de pedidos.
Evidência esperada: Uso da técnica AVG(CASE WHEN ... THEN 1 ELSE 0 END) * 100 — uma forma real de calcular 
taxas sem subconsulta, muito usada em relatórios de mercado..*/

SELECT 
    ROUND(AVG(CASE WHEN status = 'Aprovado' THEN 1 ELSE 0 END) * 100, 2) AS taxa_aprovacao_percentual
FROM pedidos;

Explicação: CASE transforma cada linha em 1 (se for aprovado) ou 0 (se não for), 
e o AVG desses 0 e 1 dá exatamente a proporção de aprovados.
Multiplicar por 100 vira percentual, e o ROUND arredonda em 2 casas. Isso evita
fazer duas consultas separadas (total e aprovados) e depois dividir.

/*------------------------------------------------*/
/*Tarefa 4.4 — Perfil de relacionamento dos clientes
Tarefa: Classifique os clientes em 'Novo' (cadastro há menos de 1 ano), 'Fiel' (entre 1 e 3 anos) 
ou 'Veterano' (mais de 3 anos), usando CASE combinado com TIMESTAMPDIFF, e mostre quantos clientes existem em cada perfil.
Evidência esperada: Função de data usada corretamente dentro do CASE, combinada com GROUP BY.*/

SELECT 
    CASE 
        WHEN TIMESTAMPDIFF(YEAR, data_cadastro, NOW()) < 1 THEN 'Novo'
        WHEN TIMESTAMPDIFF(YEAR, data_cadastro, NOW()) BETWEEN 1 AND 3 THEN 'Fiel'
        WHEN TIMESTAMPDIFF(YEAR, data_cadastro, NOW()) > 3 THEN 'Veterano'
    END AS perfil_cliente,
    COUNT(*) AS quantidade_clientes
FROM clientes
GROUP BY perfil_cliente
ORDER BY quantidade_clientes DESC;

/*-------------------------------------------------------*/
/*Bloco 5 — Desafio integrador — sem JOIN
Recursos praticados: WHERE + GROUP BY + HAVING + ORDER BY + LIMIT + CASE combinados na mesma consulta
Chegou o momento de responder perguntas de negócio completas, do jeito que elas chegam de verdade: 
combinando várias cláusulas na mesma consulta.*/

/*Tarefa 5.1 — Ranking de canal de venda e forma de pagamento
Tarefa: Entre os pedidos aprovados, mostre canal_venda, forma_pagamento, quantidade de pedidos e faturamento,
 considerando apenas combinações com pelo menos 200 pedidos. Ordene pelo faturamento e mostre somente as 5 primeiras combinações.
Evidência esperada: WHERE + GROUP BY em duas colunas + HAVING + ORDER BY + LIMIT, todos na mesma consulta.*/

SELECT canal_venda, forma_pagamento, 
       COUNT(id) AS quantidade_pedidos, 
       SUM(valor_total) AS faturamento
FROM pedidos
WHERE status = 'Aprovado'
GROUP BY canal_venda, forma_pagamento
HAVING quantidade_pedidos >= 200
ORDER BY faturamento DESC
LIMIT 5;

Explicação: Consulta completa combinando quase tudo. WHERE filtra antes de agrupar
(só aprovados), GROUP BY em duas colunas cria um grupo pra cada combinação
canal+pagamento, e o HAVING filtra os grupos já agregados (diferente do WHERE,
que não enxerga COUNT/SUM). ORDER BY + LIMIT 5 pegam só o top 5 por faturamento.

/*------------------------------------------------------*/
/*Tarefa 5.2 — Categorias "premium" do catálogo
Tarefa: Entre os produtos ativos, mostre categoria, quantidade de produtos e preço médio, 
apenas para categorias cujo preço médio seja superior a R$ 300, ordenado do maior para o menor preço médio.
Evidência esperada: WHERE + GROUP BY + HAVING com função agregadora (AVG) + ORDER BY.*/

SELECT categoria, 
       COUNT(id) AS quantidade_produtos, 
       ROUND(AVG(preco), 2) AS preco_medio
FROM produtos
WHERE ativo = 1
GROUP BY categoria
HAVING AVG(preco) > 300
ORDER BY preco_medio DESC;
/*------------------------------------------------------*/

/*Tarefa 5.3 — Investigação: o boleto cancela mais que os outros meios de pagamento?
Contexto: Em uma reunião, um gestor da NexaShop afirmou que "pedidos pagos por boleto 
parecem cancelar mais". Isso é uma hipótese, não um fato — é trabalho da dupla confirmar
ou refutar com dados, sem aceitar a afirmação apenas porque veio de um gestor.
Tarefa: Construa uma consulta que calcule a taxa de cancelamento (percentual de pedidos 
com status = 'Cancelado') para cada forma de pagamento, usando a mesma técnica da tarefa 4.3.
Evidência esperada: Consulta correta (GROUP BY forma_pagamento + AVG(CASE...)) e, no relatório, 
um parágrafo estruturado no formato sintoma → evidência → hipótese → validação → conclusão, 
indicando se a hipótese do gestor se confirma ou não.*/

SELECT forma_pagamento,
ROUND(AVG(CASE WHEN status = 'Cancelado' THEN 1 ELSE 0 END) * 100, 2) AS taxa_cancelamento_percentual
FROM pedidos
GROUP BY forma_pagamento
ORDER BY taxa_cancelamento_percentual DESC;

Explicação: mesma técnica da 4.3 (CASE virando 0/1 dentro do AVG pra achar
percentual), mas agora com GROUP BY forma_pagamento, então a taxa de cancelamento
sai calculada separadamente pra cada meio de pagamento. O ORDER BY DESC já deixa
o meio com maior cancelamento no topo, facilitando checar se é mesmo o boleto.




