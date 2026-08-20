-- atividade 0 Validação do ambiente

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

-- =====================================================================
-- ATIVIDADE PRATICA DE CONSOLIDACAO - CONSULTAS SQL COM MYSQL
-- CENARIO NEXASHOP - RESOLUCAO DOS EXERCICIOS PARES
-- =====================================================================


-- ---------------------------------------------------------------------
-- Tarefa 1.2 - Catalogo de produtos para o marketing
-- ---------------------------------------------------------------------

/* Liste nome, categoria, marca, preço (com alias "Valor (R$)")
   e estoque de todos os produtos, sem usar SELECT *. */

select
    nome,
    categoria,
    marca,
    preco as "Valor (R$)",
    estoque
from produtos;

-- Interpretação de negócio:
-- Essa consulta entrega ao time de marketing exatamente o que foi solicitado:
-- uma listagem limpa do catálogo, sem colunas técnicas (como id ou status)
-- que não fazem sentido para quem vai usar esses dados em uma peça de
-- divulgação ou em uma planilha de apoio. O alias "Valor (R$)" também deixa
-- claro, para qualquer pessoa não técnica, que aquela coluna representa o
-- preço de venda em reais, evitando ambiguidade na leitura do relatório.


-- ---------------------------------------------------------------------
-- Tarefa 1.4 - Formas de pagamento e canais de venda aceitos
-- ---------------------------------------------------------------------

/* Liste, sem repetição, todas as formas de pagamento e,
   em outra consulta, todos os canais de venda registrados nos pedidos. */

select distinct forma_pagamento
from pedidos;

select distinct canal_venda
from pedidos;

-- Interpretação de negócio:
-- As duas consultas usam DISTINCT para eliminar repetições e mostrar, de
-- forma resumida, quais são as opções de pagamento e os canais de venda
-- que a NexaShop realmente utiliza na operação. Esse tipo de levantamento é
-- comum antes de negociações com gateways de pagamento ou de marketplaces
-- parceiros, pois permite confirmar rapidamente, sem depender de memória ou
-- de planilhas paralelas, quais integrações já existem e quais ainda
-- precisariam ser criadas.


-- ---------------------------------------------------------------------
-- Tarefa 2.2 - Busca de cliente por nome (tela de atendimento)
-- ---------------------------------------------------------------------

/* Crie uma consulta que encontre clientes cujo nome contenha
   um termo escolhido pela dupla. */

select
    nome,
    email,
    cidade,
    estado
from clientes
where nome like '%Silva%';

-- Interpretação de negócio:
-- Essa consulta simula o comportamento de uma tela de atendimento ao
-- cliente, em que o operador recebe apenas um trecho do nome informado
-- verbalmente. O uso do LIKE com o caractere % antes e depois do termo
-- ("Silva") garante que qualquer cliente cujo nome contenha esse trecho,
-- em qualquer posição, seja localizado, o que reduz o tempo de atendimento
-- e evita a necessidade de o cliente soletrar seu nome completo.


-- ---------------------------------------------------------------------
-- Tarefa 2.4 - Pedidos de ticket intermediário aprovados
-- ---------------------------------------------------------------------

/* Liste os pedidos aprovados com valor_total entre R$ 100 e R$ 500,
   ordenados do maior para o menor valor. */

select
    id,
    valor_total,
    status
from pedidos
where status = 'Aprovado'
    and valor_total between 100 and 500
order by valor_total desc;

-- Interpretação de negócio:
-- Ao combinar o filtro de status com o BETWEEN sobre valor_total, a
-- consulta isola exatamente a faixa de pedidos que a diretoria classificou
-- como "ticket médio" — nem os pedidos de baixo valor, que normalmente
-- representam compras avulsas, nem os de alto valor, que costumam ser
-- casos isolados. Ordenar do maior para o menor ajuda a priorizar
-- visualmente os pedidos mais relevantes dentro dessa faixa, facilitando a
-- leitura de um possível padrão de consumo nesse intervalo de preço.


-- ---------------------------------------------------------------------
-- Tarefa 2.6 - Alcance das campanhas de cupom
-- ---------------------------------------------------------------------

/* Liste id, valor_total e cupom_desconto dos pedidos
   que tiveram cupom aplicado (não nulo). */

select
    id,
    valor_total,
    cupom_desconto
from pedidos
where cupom_desconto is not null;

-- Interpretação de negócio:
-- O uso de IS NOT NULL isola apenas os pedidos em que algum cupom de
-- desconto foi de fato utilizado no fechamento da compra. Esse recorte é
-- importante para o time de marketing avaliar o alcance real de uma
-- campanha promocional: não basta saber quantos cupons foram distribuídos,
-- é preciso confirmar quantos pedidos efetivamente os aplicaram, o que
-- ajuda a mensurar a taxa de conversão da campanha e o volume de
-- faturamento impactado por ela.


-- ---------------------------------------------------------------------
-- Tarefa 3.2 - Faturamento por forma de pagamento
-- ---------------------------------------------------------------------

/* Calcule o faturamento total (SUM) de pedidos aprovados,
   agrupado por forma de pagamento, do maior para o menor. */

select
    forma_pagamento,
    sum(valor_total) as faturamento_total
from pedidos
where status = 'Aprovado'
group by forma_pagamento
order by faturamento_total desc;

-- Interpretação de negócio:
-- Essa consulta mostra, de forma direta, qual meio de pagamento é
-- responsável pela maior fatia do faturamento aprovado da NexaShop. Esse
-- tipo de indicador é essencial para decisões financeiras, como negociar
-- taxas menores com a operadora mais utilizada ou avaliar se vale a pena
-- investir em divulgação de meios de pagamento que hoje têm pouca adesão,
-- mas que poderiam representar economia de taxas para a empresa.


-- ---------------------------------------------------------------------
-- Tarefa 3.4 - Estados prioritários para expansão
-- ---------------------------------------------------------------------

/* Liste apenas os estados com mais de 200 clientes cadastrados. */

select
    estado,
    count(*) as total_clientes
from clientes
group by estado
having count(*) > 200
order by total_clientes desc;

-- Interpretação de negócio:
-- O uso do HAVING, em vez do WHERE, é fundamental aqui, pois o filtro
-- precisa ser aplicado depois que o agrupamento por estado já foi
-- calculado — não é possível filtrar por COUNT(*) antes de agrupar os
-- dados. O resultado entrega ao time de expansão uma lista objetiva dos
-- estados em que a NexaShop já tem uma base de clientes relevante,
-- servindo como ponto de partida para decisões de abertura de centros de
-- distribuição ou de campanhas regionais mais robustas.


-- ---------------------------------------------------------------------
-- Tarefa 3.6 - Valor de estoque parado por categoria
-- ---------------------------------------------------------------------

/* Para produtos ativos, calcule o valor total em estoque
   (preço × estoque) por categoria, ordenado do maior para o menor. */

select
    categoria,
    sum(preco * estoque) as valor_total_estoque
from produtos
where ativo = 1
group by categoria
order by valor_total_estoque desc;

-- Interpretação de negócio:
-- Multiplicar preço por estoque dentro da função SUM permite calcular
-- quanto capital da NexaShop está imobilizado em mercadoria parada em cada
-- categoria. Esse indicador é especialmente relevante para o setor
-- financeiro, pois categorias com valores muito altos de estoque parado
-- podem indicar excesso de compra, baixa rotatividade de produtos ou a
-- necessidade de promoções pontuais para liberar capital de giro
-- imobilizado nessas linhas de produto.


-- ---------------------------------------------------------------------
-- Tarefa 4.2 - Quantas avaliações caem em cada faixa
-- ---------------------------------------------------------------------

/* A partir da classificação da tarefa 4.1, mostre quantas avaliações
   existem em cada faixa, da maior para a menor quantidade,
   em uma única consulta. */

SELECT
    faixa_avaliacao,
    COUNT(*) AS quantidade_avaliacoes
FROM (
    SELECT
        CASE
            WHEN nota = 5 THEN 'Excelente'
            WHEN nota = 4 THEN 'Boa'
            WHEN nota = 3 THEN 'Regular'
            WHEN nota IN (1, 2) THEN 'Insatisfatória'
        END AS faixa_avaliacao
    FROM avaliacoes
) AS classificacao
GROUP BY faixa_avaliacao
ORDER BY quantidade_avaliacoes DESC;

-- Interpretação de negócio:
-- Ao agrupar diretamente pelo alias criado no CASE, a consulta transforma
-- notas individuais em um panorama de qualidade percebida pelos clientes,
-- sem a necessidade de uma subconsulta. Esse resumo por faixa é o formato
-- ideal para o time de qualidade acompanhar a satisfação geral da base:
-- permite identificar rapidamente se a maioria das avaliações está
-- concentrada nas faixas positivas ("Excelente" e "Boa") ou se existe um
-- volume preocupante de avaliações "Insatisfatórias" que mereça
-- investigação mais aprofundada.


-- ---------------------------------------------------------------------
-- Tarefa 4.4 - Perfil de relacionamento dos clientes
-- ---------------------------------------------------------------------

/* Classifique os clientes em 'Novo' (cadastro há menos de 1 ano),
   'Fiel' (entre 1 e 3 anos) ou 'Veterano' (mais de 3 anos),
   usando CASE combinado com TIMESTAMPDIFF, e mostre quantos clientes
   existem em cada perfil. */

select
    case
        when timestampdiff(year, data_cadastro, curdate()) < 1 then 'Novo'
        when timestampdiff(year, data_cadastro, curdate()) between 1 and 3 then 'Fiel'
        else 'Veterano'
    end as perfil_relacionamento,
    count(*) as quantidade_clientes
from clientes
group by perfil_relacionamento
order by quantidade_clientes desc;

-- Interpretação de negócio:
-- O TIMESTAMPDIFF calcula, em anos completos, há quanto tempo cada cliente
-- está cadastrado na base, e o CASE traduz esse número em uma
-- classificação de fácil leitura para o time comercial. Esse indicador
-- ajuda a NexaShop a entender a maturidade da sua base de clientes: uma
-- concentração muito grande de clientes "Novos" pode indicar sucesso na
-- captação, mas também alerta para a necessidade de estratégias de
-- retenção, enquanto uma base robusta de "Veteranos" costuma indicar maior
-- fidelidade e menor sensibilidade a preço.


-- ---------------------------------------------------------------------
-- Tarefa 5.2 - Categorias "premium" do catálogo
-- ---------------------------------------------------------------------

/* Entre os produtos ativos, mostre categoria, quantidade de produtos
   e preço médio, apenas para categorias cujo preço médio seja superior
   a R$ 300, ordenado do maior para o menor preço médio. */

select
    categoria,
    count(*) as quantidade_produtos,
    round(avg(preco), 2) as preco_medio
from produtos
where ativo = 1
group by categoria
having avg(preco) > 300
order by preco_medio desc;

-- Interpretação de negócio:
-- Essa consulta combina, em uma única instrução, um filtro de linha
-- (WHERE status = 'Ativo'), um agrupamento por categoria e um filtro sobre
-- o resultado agregado (HAVING AVG(preco) > 300), isolando apenas as
-- categorias que podem ser consideradas "premium" dentro do catálogo da
-- NexaShop. Esse recorte é valioso para o time comercial posicionar essas
-- categorias em campanhas de maior margem, além de sinalizar para o
-- marketing quais linhas de produto merecem uma comunicação mais
-- sofisticada, voltada a um público disposto a pagar um ticket mais alto.

