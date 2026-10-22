-- =============================================================================
-- FICHA 5 - RESOLUÇÃO COMPLETA E VALIDADA (SQLCHECK)
-- Base de Dados - ISEC / DEIS 2026/2027
-- =============================================================================

-- -----------------------------------------------------------------------------
-- PERGUNTA 3
-- Código SQLCheck: FEVWOFPCULRBHZL
-- Enunciado: Escreva um comando que mostre quantos livros de Informática existem 
--            com preço de tabela superior a 25 euros.
-- -----------------------------------------------------------------------------
SELECT COUNT(*) AS "Total livros de Informática"
FROM LIVROS
WHERE UPPER(GENERO) = 'INFORMÁTICA'
  AND PRECO_TABELA > 25;

CALL SQLCHECK('FEVWOFPCULRBHZL');


-- -----------------------------------------------------------------------------
-- PERGUNTA 4
-- Código SQLCheck: FEJLKUNDMISOIMK
-- Enunciado: Considerando apenas os livros de Romance e Policial, conte o número 
--            de livros editados, calcule o preço médio dos livros (arredondado 
--            aos cêntimos) e o total de livros vendidos.
-- -----------------------------------------------------------------------------
SELECT COUNT(*) AS "Total de Livros",
       ROUND(AVG(PRECO_TABELA), 2) AS "Preço Médio",
       SUM(UNIDADES_VENDIDAS) AS "Total de livros vendidos"
FROM LIVROS
WHERE UPPER(GENERO) IN ('ROMANCE', 'POLICIAL');

CALL SQLCHECK('FEJLKUNDMISOIMK');


-- -----------------------------------------------------------------------------
-- PERGUNTA 5
-- Código SQLCheck: FEHTQIEELYUPJVM
-- Enunciado: Mostre quantos livros existem para cada género. Ordene o resultado 
--            pelo número de livros e pelo género.
-- -----------------------------------------------------------------------------
SELECT GENERO,
       COUNT(*) AS "Num. Livros"
FROM LIVROS
GROUP BY GENERO
ORDER BY "Num. Livros", GENERO;

CALL SQLCHECK('FEHTQIEELYUPJVM');


-- -----------------------------------------------------------------------------
-- PERGUNTA 6
-- Código SQLCheck: FEFYIXKFRQYPKRB
-- Enunciado: Para cada livro de Aventuras, encontre o preço mais alto, mais baixo 
--            e médio (arredondado a 1 casa decimal) que foi vendido. Considere apenas 
--            as vendas em dezembro de 2023. Ordene pelo preço mais alto e pelo titulo.
-- -----------------------------------------------------------------------------
SELECT L.TITULO,
       MAX(C.PRECO_UNITARIO) AS "P_MAIS_ALTO",
       MIN(C.PRECO_UNITARIO) AS "P_MAIS_BAIXO",
       ROUND(AVG(C.PRECO_UNITARIO), 1) AS "P_MEDIO"
FROM LIVROS L
JOIN CONTEM C ON L.CODIGO_LIVRO = C.CODIGO_LIVRO
JOIN VENDAS V ON C.CODIGO_VENDA = V.CODIGO_VENDA
WHERE UPPER(L.GENERO) = 'AVENTURA'
  AND TO_CHAR(V.DATA_VENDA, 'MM-YYYY') = '12-2023'
GROUP BY L.TITULO
ORDER BY "P_MAIS_ALTO", L.TITULO;

CALL SQLCHECK('FEFYIXKFRQYPKRB');


-- -----------------------------------------------------------------------------
-- PERGUNTA 7
-- Código SQLCheck: FEMTUDAGMJORLYW
-- Enunciado: Para cada género, encontre a diferença entre os preços de tabela 
--            mais alto e mais baixo dos livros de cada género. Mostre também o 
--            número de livros. Ordene pelo género.
-- -----------------------------------------------------------------------------
SELECT GENERO,
       MAX(PRECO_TABELA) - MIN(PRECO_TABELA) AS "DIF_PRECOS",
       COUNT(*) AS "N_LIVROS"
FROM LIVROS
GROUP BY GENERO
ORDER BY GENERO;

CALL SQLCHECK('FEMTUDAGMJORLYW');


-- -----------------------------------------------------------------------------
-- PERGUNTA 8
-- Código SQLCheck: FEUHRWEHLKMFMHQ
-- Enunciado: Para cada livro com preco de tabela superior a 50 euros, mostre o 
--            seu preço de tabela, quantos livros foram vendidos no ano de 2025, 
--            a receita esperada e a receita efectivamente realizada. Ordene pelo titulo.
-- -----------------------------------------------------------------------------
SELECT L.TITULO,
       L.PRECO_TABELA AS "PRECO",
       SUM(C.QUANTIDADE) AS "NUM_VENDIDOS",
       SUM(C.QUANTIDADE * L.PRECO_TABELA) AS "REC_ESPERADA",
       SUM(C.QUANTIDADE * C.PRECO_UNITARIO) AS "REC_EFECTIVA"
FROM LIVROS L
JOIN CONTEM C ON L.CODIGO_LIVRO = C.CODIGO_LIVRO
JOIN VENDAS V ON C.CODIGO_VENDA = V.CODIGO_VENDA
WHERE L.PRECO_TABELA > 50
  AND TO_CHAR(V.DATA_VENDA, 'YYYY') = '2025'
GROUP BY L.TITULO, L.PRECO_TABELA
ORDER BY L.TITULO;

CALL SQLCHECK('FEUHRWEHLKMFMHQ');


-- -----------------------------------------------------------------------------
-- PERGUNTA 9
-- Código SQLCheck: FELZBJWIKNWLNKA
-- Enunciado: Preço de tabela médio de cada género arredondado para o menor inteiro 
--            superior ou igual (CEIL). Géneros com mais de 10 títulos. Ordene por 
--            ordem crescente dos preços médios e descendente pelo género.
-- -----------------------------------------------------------------------------
SELECT GENERO,
       CEIL(AVG(PRECO_TABELA)) AS "Preço Médio"
FROM LIVROS
GROUP BY GENERO
HAVING COUNT(*) > 10
ORDER BY "Preço Médio" ASC, GENERO DESC;

CALL SQLCHECK('FELZBJWIKNWLNKA');


-- -----------------------------------------------------------------------------
-- PERGUNTA 10
-- Código SQLCheck: FELGVJUJEECZOFA
-- Enunciado: Para cada autor, preço de tabela do livro mais barato. Exclua autores 
--            com preço mínimo inferior a 40. Ordene por preço mínimo e nome.
-- -----------------------------------------------------------------------------
SELECT A.NOME,
       MIN(L.PRECO_TABELA) AS "Preco do Mais Barato"
FROM LIVROS L
JOIN AUTORES A ON L.CODIGO_AUTOR = A.CODIGO_AUTOR
GROUP BY A.NOME
HAVING MIN(L.PRECO_TABELA) >= 40
ORDER BY "Preco do Mais Barato", A.NOME;

CALL SQLCHECK('FELGVJUJEECZOFA');


-- -----------------------------------------------------------------------------
-- PERGUNTA 11
-- Código SQLCheck: FEOQNODKNSNUPXC
-- Enunciado: Clientes de Lisboa que adquiriram menos de 30 livros, a preço médio 
--            superior a 24 euros, quantidade adquirida, preço médio (2 casas decimais) 
--            e quantos autores diferentes. Exclua clientes com apenas 1 editora.
-- -----------------------------------------------------------------------------
SELECT C.NOME,
       SUM(O.QUANTIDADE) AS "N.Livros",
       ROUND(AVG(O.PRECO_UNITARIO), 2) AS "Preco Medio",
       COUNT(DISTINCT L.CODIGO_AUTOR) AS "N.Autor Diferent"
FROM CLIENTES C
JOIN VENDAS V ON C.CODIGO_CLIENTE = V.CODIGO_CLIENTE
JOIN CONTEM O ON V.CODIGO_VENDA = O.CODIGO_VENDA
JOIN LIVROS L ON O.CODIGO_LIVRO = L.CODIGO_LIVRO
WHERE UPPER(C.MORADA) LIKE '%LISBOA%'
GROUP BY C.NOME
HAVING SUM(O.QUANTIDADE) < 30
   AND AVG(O.PRECO_UNITARIO) > 24
   AND COUNT(DISTINCT L.CODIGO_EDITORA) > 1
ORDER BY C.NOME;

CALL SQLCHECK('FEOQNODKNSNUPXC');


-- -----------------------------------------------------------------------------
-- PERGUNTA 12
-- Código SQLCheck: FEIPFSYLCQDAQIE
-- Enunciado: Autores com mais de 50 anos que preferem Romances. Output com 
--            'Não escreveu Livros' ou 'Escreveu X livros de Género'.
-- -----------------------------------------------------------------------------
SELECT NOME, 
       DECODE(COUNT(TITULO), 0, 'Não escreveu Livros', 'Escreveu ' || COUNT(*) || ' livros de ' || GENERO) AS "Num.de Livros que escreveu" 
FROM LIVROS L, AUTORES A 
WHERE MONTHS_BETWEEN(SYSDATE, DATA_NASCIMENTO) / 12 > 50 
  AND GENERO_PREFERIDO = 'Romance' 
  AND A.CODIGO_AUTOR = L.CODIGO_AUTOR (+)  
GROUP BY NOME, GENERO
ORDER BY 1;

CALL SQLCHECK('FEIPFSYLCQDAQIE');
