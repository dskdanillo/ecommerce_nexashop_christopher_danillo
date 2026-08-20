# Atividade Prática de Consolidação — Consultas SQL com MySQL
## Cenário NexaShop

**Disciplina:** Análise e Desenvolvimento de Sistemas — UniSENAI
**Responsáveis pelo repositório:**
- Christopher Steudel
- Danillo de Souza

---

## 1. Sobre este repositório

Este repositório contém a resolução da **Atividade Prática de Consolidação de Consultas SQL**, baseada no cenário fictício de e-commerce **NexaShop**. A atividade tem como objetivo praticar comandos SQL de consulta a uma tabela só (sem JOIN e sem subconsultas), incluindo:

- Seleção de colunas com `SELECT`, `alias`, `DISTINCT` e `LIMIT`;
- Filtros com `WHERE`, `LIKE`, `IN`, `BETWEEN` e `IS NULL`;
- Ordenação com `ORDER BY`;
- Agregações com `COUNT`, `SUM`, `AVG`, `MIN`, `MAX`, `GROUP BY` e `HAVING`;
- Classificações de negócio com `CASE`.

Cada consulta deste repositório responde a uma pergunta de negócio da NexaShop (marketing, comercial, financeiro ou qualidade), simulando o trabalho de um(a) analista de dados júnior.

> Este README foi escrito pensando em alguém que **nunca usou um banco de dados antes**. Se você já tem experiência com MySQL, pode pular direto para a seção 5 (Organização em branches) ou 6 (Estrutura do repositório).

---

## 2. O que você vai precisar

Antes de rodar qualquer consulta, você precisa de um programa capaz de se conectar a um banco de dados MySQL e executar comandos SQL. Neste projeto foi usado o **MySQL Workbench**, mas o mesmo arquivo `.sql` também funciona no **phpMyAdmin**, caso seu laboratório use essa ferramenta.

Você vai precisar de:

1. **MySQL Server** — o "banco de dados" propriamente dito, o programa que armazena as tabelas e os dados.
2. **MySQL Workbench** — a interface gráfica onde você escreve e executa os comandos SQL, sem precisar usar o terminal.

### 2.1. Baixando e instalando o MySQL

1. Acesse o site oficial: https://dev.mysql.com/downloads/installer/
2. Baixe o **MySQL Installer for Windows** (ou, se estiver no macOS/Linux, use o **MySQL Community Server** + **MySQL Workbench** separadamente, disponíveis na mesma página de downloads).
3. Execute o instalador e escolha a opção **"Developer Default"** — essa opção já instala o MySQL Server, o MySQL Workbench e outras ferramentas úteis, tudo de uma vez.
4. Siga o assistente de instalação. Em algum momento ele vai pedir para você definir uma **senha para o usuário root** (o usuário administrador do banco). Anote essa senha em um lugar seguro — você vai precisar dela sempre que abrir o Workbench.
5. Finalize a instalação e deixe o instalador configurar o MySQL Server como um serviço que inicia automaticamente com o computador.

### 2.2. Abrindo o MySQL Workbench pela primeira vez

1. Abra o programa **MySQL Workbench** (procure no menu iniciar, caso esteja no Windows).
2. Na tela inicial, clique na conexão chamada **"Local instance MySQL"** (ou crie uma nova conexão, se ela não existir, clicando no ícone de "+" ao lado de "MySQL Connections").
3. Digite a senha do usuário `root` que você definiu na instalação.
4. Você verá uma tela dividida em duas áreas principais: uma área de texto em branco no topo (onde você escreve os comandos SQL) e um painel de resultados na parte de baixo (onde aparecem as respostas das consultas).

---

## 3. Importando a base de dados `ecommerce_nexashop`

O arquivo `ecommerce_nexashop.sql` (fornecido pelo professor) contém o comando que cria o banco de dados, as quatro tabelas (`clientes`, `produtos`, `pedidos` e `avaliacoes`) e todos os dados fictícios da NexaShop. Sem importar esse arquivo primeiro, nenhuma das consultas deste repositório vai funcionar.

### Passo a passo pelo MySQL Workbench

1. Abra o MySQL Workbench e conecte-se à sua instância local (veja a seção 2.2).
2. No menu superior, clique em **File → Open SQL Script...**
3. Selecione o arquivo `ecommerce_nexashop.sql` no seu computador.
4. O conteúdo do arquivo vai aparecer na área de texto. Clique no ícone de **raio (⚡)** na barra de ferramentas, ou pressione **Ctrl + Shift + Enter**, para executar o script inteiro.
5. Aguarde o processamento — como o script cria quatro tabelas e insere milhares de linhas, pode levar alguns segundos.
6. No painel lateral esquerdo ("Schemas"), clique com o botão direito e escolha **"Refresh All"**. Você deve ver o banco **`ecommerce_nexashop`** aparecer na lista, com as tabelas `clientes`, `produtos`, `pedidos` e `avaliacoes` dentro dele.

### Passo a passo pelo phpMyAdmin (alternativa)

1. Abra o phpMyAdmin no navegador.
2. Clique na aba **"Importar"**.
3. Clique em **"Escolher arquivo"** e selecione `ecommerce_nexashop.sql`.
4. Clique em **"Executar"** e aguarde a confirmação de que a importação foi concluída.

### Conferindo se deu tudo certo

Depois de importar, rode esta consulta de validação (ela também está no início dos arquivos `.sql` deste repositório, na seção "Atividade 0"):

```sql
USE ecommerce_nexashop;
SELECT 'clientes' AS tabela, COUNT(*) AS total FROM clientes
UNION ALL
SELECT 'produtos' AS tabela, COUNT(*) AS total FROM produtos
UNION ALL
SELECT 'pedidos' AS tabela, COUNT(*) AS total FROM pedidos
UNION ALL
SELECT 'avaliacoes' AS tabela, COUNT(*) AS total FROM avaliacoes;
```

Se a importação foi bem-sucedida, o resultado esperado é:

| tabela | total |
|---|---|
| clientes | 3.000 |
| produtos | 250 |
| pedidos | 12.000 |
| avaliacoes | 6.000 |

---

## 4. Como executar as consultas deste repositório

1. Com o banco `ecommerce_nexashop` já importado (seção 3), abra o arquivo `.sql` que você quer conferir no MySQL Workbench (**File → Open SQL Script...**).
2. Cada consulta está separada por comentários que indicam o número e o título da tarefa (ex.: `-- Tarefa 1.2 - Catálogo de produtos para o marketing`).
3. Para executar **uma única consulta**: clique em qualquer lugar dentro do bloco `SELECT ... ;` que você quer rodar e pressione **Ctrl + Enter** (ou clique no ícone do raio com um risco, que executa apenas a instrução atual).
4. Para executar **todo o arquivo de uma vez**: use **Ctrl + Shift + Enter**.
5. O resultado de cada consulta aparece em uma aba na parte inferior da tela ("Result Grid").

### O que é `--` e `/* */` no meio do código?

São comentários — trechos de texto que o MySQL ignora ao executar o script. Eles servem apenas para explicar, para quem está lendo o código, o que cada consulta faz e por quê. Isso inclui:
- `-- Tarefa X.X - Título`: identifica qual exercício aquela consulta resolve;
- `/* ... */`: reproduz o enunciado original da tarefa;
- `-- Interpretação de negócio:`: explica, em linguagem simples, o que o resultado da consulta significa para a NexaShop.

Você pode selecionar o conteúdo inteiro de um arquivo (**Ctrl + A**) e colar direto no Workbench sem medo — os comentários não afetam a execução, só a leitura do código.

---

## 5. Organização em branches

Esta atividade foi dividida entre os dois integrantes da dupla: **Christopher** resolveu as tarefas de **numeração par** (1.2, 1.4, 2.2, 2.4, 2.6, 3.2, 3.4, 3.6, 4.2, 4.4, 5.2) e **Danillo** resolveu as tarefas de **numeração ímpar** (1.1, 1.3, 2.1, 2.3, 2.5, 3.1, 3.3, 3.5, 4.1, 4.3, 5.1, 5.3), além da Atividade 0 (validação do ambiente).

Para deixar claro, na correção, o que foi desenvolvido por cada integrante, o trabalho foi organizado em duas branches, uma por autor:

- **`christopher`** — contém apenas os arquivos e commits produzidos por Christopher Steudel.
- **`danillo`** — contém apenas os arquivos e commits produzidos por Danillo de Souza.

Ao final, as duas branches foram unidas na branch **`main`**, que reúne a entrega completa da dupla (README, os dois arquivos `.sql`, prints e relatório em PDF). Como os arquivos de cada integrante têm nomes diferentes e não se sobrepõem, essa união não altera nem mistura o conteúdo já commitado em cada branch individual — ela só reúne os dois trabalhos num mesmo estado final do repositório.

Isso permite duas formas de avaliação:
- Abrir a branch `christopher` ou a branch `danillo` isoladamente, para conferir a autoria e o histórico de commits de cada um;
- Abrir a branch `main`, para ver a entrega completa e organizada da dupla, como pede o modelo de entrega da atividade.

O hash do commit informado no AVA corresponde ao commit final da branch `main`.

---

## 6. Estrutura do repositório

```
/ (raiz)
├── README.md
├── ecommerce_nexashop.sql                        -> script de criação e carga da base (fornecido pelo professor)
├── consultas_christopher.sql                -> consultas pares, resolvidas por Christopher Steudel
├── consultas_danillo.sql                  -> consultas ímpares, resolvidas por Danillo de Souza
├── prints/                                        -> capturas de tela dos resultados no Workbench
│   ├── 1.1.png
│   ├── 1.2.png
│   ├── 1.3.png
│   ├── 1.4.png
│   ├── ...
│   └── 5.3.png
└── Docs/
    └── relatorio_nexashop.pdf                     -> relatório final em PDF (modelo de entrega da atividade)
```

---

## 7. Consultas resolvidas neste repositório

| Bloco | Tarefas de Christopher (pares) | Tarefas de Danillo (ímpares) |
|---|---|---|
| Atividade 0 — Validação do ambiente | Validação do ambiente | Validação do ambiente |
| Bloco 1 — Reconhecimento do banco | 1.2, 1.4 | 1.1, 1.3 |
| Bloco 2 — Filtros, busca e ordenação | 2.2, 2.4, 2.6 | 2.1, 2.3, 2.5 |
| Bloco 3 — Indicadores agregados | 3.2, 3.4, 3.6 | 3.1, 3.3, 3.5 |
| Bloco 4 — Classificação com CASE | 4.2, 4.4 | 4.1, 4.3 |
| Bloco 5 — Desafio integrador | 5.2 | 5.1, 5.3 |

Cada consulta, nos arquivos `.sql`, segue o mesmo padrão:
1. Comentário com o número e o título da tarefa;
2. Comentário com o enunciado original;
3. A consulta SQL, comentada e formatada;
4. Um parágrafo de **interpretação de negócio**, explicando o que o resultado significa para a NexaShop (no caso da Tarefa 5.3, esse parágrafo segue o formato sintoma → evidência → hipótese → validação → conclusão, exigido pelo enunciado).

Os prints dos resultados de cada consulta, executados no MySQL Workbench, estão organizados na pasta `prints/`, nomeados de acordo com o número da tarefa correspondente.

---

## 8. Sobre a base de dados `ecommerce_nexashop`

A base simula uma loja virtual fictícia de eletrônicos e variedades, com quatro tabelas principais:

| Tabela | O que representa |
|---|---|
| `clientes` | Dados cadastrais dos clientes (nome, cidade, estado, segmento, status) |
| `produtos` | Catálogo de produtos (nome, categoria, marca, preço, estoque, se está ativo) |
| `pedidos` | Cada pedido realizado (valor, forma de pagamento, canal de venda, status) |
| `avaliacoes` | Nota e comentário deixados pelo cliente após um pedido aprovado |

As colunas `cliente_id`, `produto_id` e `pedido_id` já existem nas tabelas para permitir o uso de `JOIN` na próxima etapa da disciplina, mas **nenhuma consulta deste repositório usa JOIN ou subconsulta**, conforme exigido pelo enunciado da atividade.

---

## 9. Referências

- Documentação oficial do MySQL: https://dev.mysql.com/doc/
- Material complementar "Consultas SQL com MySQL" (UniSENAI, 2026)
- Documentação do MySQL Workbench: https://dev.mysql.com/doc/workbench/en/
- Documentação do phpMyAdmin: https://docs.phpmyadmin.net/
