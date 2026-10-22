-- =============================================================================
-- FICHA 7 - RESOLUÇÃO COMPLETA E VALIDADA (SQLCHECK)
-- Base de Dados - ISEC / DEIS 2026/2027
-- Foco: Agrupamentos avançados, Subconsultas (IN, ALL, ANY, EXISTS, FROM, Correlacionadas)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- PERGUNTA 3
-- Código SQLCheck: FFHLPAKCRARVIKH
-- Enunciado: Para cada loja que vendeu livros de autores de Coimbra mostre a 
--            quantidade de livros que vendeu, o preço médio de venda e de quantos 
--            géneros distintos eram esses livros. Exclua as lojas com menos de 10 
--            unidades vendidas. Ordene pelo nome da loja e descendente pelo número 
--            de livros vendidos.
-- -----------------------------------------------------------------------------
SELECT LJ.NOME,
       SUM(C.QUANTIDADE) AS NUM_LIVROS_VENDIDOS,
       ROUND(AVG(C.PRECO_UNITARIO), 2) AS PRECO_MEDIO,
       COUNT(DISTINCT L.GENERO) AS GENEROS_DIFERENTES
FROM LOJAS LJ
JOIN VENDAS V ON LJ.CODIGO_LOJA = V.CODIGO_LOJA
JOIN CONTEM C ON V.CODIGO_VENDA = C.CODIGO_VENDA
JOIN LIVROS L ON C.CODIGO_LIVRO = L.CODIGO_LIVRO
JOIN AUTORES A ON L.CODIGO_AUTOR = A.CODIGO_AUTOR
WHERE UPPER(A.MORADA) LIKE '%COIMBRA%'
GROUP BY LJ.NOME
HAVING SUM(C.QUANTIDADE) >= 10
ORDER BY LJ.NOME ASC, NUM_LIVROS_VENDIDOS DESC;

CALL SQLCHECK('FFHLPAKCRARVIKH');


-- -----------------------------------------------------------------------------
-- PERGUNTA 4
-- Código SQLCheck: FFUCFCLDCNPLJOZ
-- Enunciado: Mostre a quantidade de livros vendidos a clientes do Barreiro por faixa 
--            etária (0X, 1X, 2X, ...). Para cada faixa etária mostre a quantidade 
--            de livros vendidos, o número de vendas e quantos clientes distintos compraram. 
--            Exclua as faixas etárias com apenas 1 venda. Ordene pela faixa etária.
-- -----------------------------------------------------------------------------
SELECT TRUNC(CL.IDADE / 10) || 'X' AS FAIXA_ETARIA,
       SUM(C.QUANTIDADE) AS NUM_LIVROS_VENDIDOS,
       COUNT(DISTINCT V.CODIGO_VENDA) AS NUM_VENDAS,
       COUNT(DISTINCT CL.CODIGO_CLIENTE) AS NUM_CLIENTES_DIFERENTES
FROM CLIENTES CL
JOIN VENDAS V ON CL.CODIGO_CLIENTE = V.CODIGO_CLIENTE
JOIN CONTEM C ON V.CODIGO_VENDA = C.CODIGO_VENDA
WHERE UPPER(CL.MORADA) LIKE '%BARREIRO%'
GROUP BY TRUNC(CL.IDADE / 10) || 'X'
HAVING COUNT(DISTINCT V.CODIGO_VENDA) > 1
ORDER BY FAIXA_ETARIA;

CALL SQLCHECK('FFUCFCLDCNPLJOZ');


-- -----------------------------------------------------------------------------
-- PERGUNTA 5
-- Código SQLCheck: FFXWHGKEFMVTKDT
-- Enunciado: Qual o livro mais caro (preço de tabela mais alto).
-- -----------------------------------------------------------------------------
SELECT TITULO, 
       PRECO_TABELA AS PRECO_MAIS_ALTO
FROM LIVROS
WHERE PRECO_TABELA = (
    SELECT MAX(PRECO_TABELA) 
    FROM LIVROS
);

CALL SQLCHECK('FFXWHGKEFMVTKDT');


-- -----------------------------------------------------------------------------
-- PERGUNTA 6
-- Código SQLCheck: FFEWHCUFZRBYLVR
-- Enunciado: Qual o livro dramático mais barato (preço de tabela mais baixo). 
--            a) Usando o MIN.
-- -----------------------------------------------------------------------------
SELECT TITULO, 
       PRECO_TABELA AS "Preco_mais_Baixo"
FROM LIVROS
WHERE UPPER(GENERO) = 'DRAMA'
  AND PRECO_TABELA = (
      SELECT MIN(PRECO_TABELA) 
      FROM LIVROS 
      WHERE UPPER(GENERO) = 'DRAMA'
  );

CALL SQLCHECK('FFEWHCUFZRBYLVR');


-- -----------------------------------------------------------------------------
-- PERGUNTA 7
-- Código SQLCheck: FFLSWHGGDVCEMGJ
-- Enunciado: Qual o livro dramático mais barato (preço de tabela mais baixo). 
--            B) Usando o ALL.
-- -----------------------------------------------------------------------------
SELECT TITULO, 
       PAGINAS AS "Num_Paginas", 
       PRECO_TABELA AS "Preco_mais_Baixo"
FROM LIVROS
WHERE UPPER(GENERO) = 'DRAMA'
  AND PRECO_TABELA <= ALL (
      SELECT PRECO_TABELA 
      FROM LIVROS 
      WHERE UPPER(GENERO) = 'DRAMA'
  );

CALL SQLCHECK('FFLSWHGGDVCEMGJ');


-- -----------------------------------------------------------------------------
-- PERGUNTA 8
-- Código SQLCheck: FFTBENOHGPWUNEU
-- Enunciado: Qual o livro dramático mais barato (preço de tabela mais baixo). 
--            C) Usando o EXISTS.
-- -----------------------------------------------------------------------------
SELECT L1.PRECO_TABELA AS "Menor Preco de tabela", 
       L1.TITULO
FROM LIVROS L1
WHERE UPPER(L1.GENERO) = 'DRAMA'
  AND NOT EXISTS (
      SELECT 1
      FROM LIVROS L2
      WHERE UPPER(L2.GENERO) = 'DRAMA'
        AND L2.PRECO_TABELA < L1.PRECO_TABELA
  );

CALL SQLCHECK('FFTBENOHGPWUNEU');


-- -----------------------------------------------------------------------------
-- PERGUNTA 9
-- Código SQLCheck: FFEAUOMICXDPOWY
-- Enunciado: Qual o livro dramático mais barato (preço de tabela mais baixo). 
--            d) Utilizando subquery na cláusula FROM.
-- -----------------------------------------------------------------------------
SELECT L.TITULO AS "Livro Mais Barato"
FROM LIVROS L,
     (SELECT MIN(PRECO_TABELA) AS MIN_PRECO 
      FROM LIVROS 
      WHERE UPPER(GENERO) = 'DRAMA') M
WHERE UPPER(L.GENERO) = 'DRAMA'
  AND L.PRECO_TABELA = M.MIN_PRECO;

CALL SQLCHECK('FFEAUOMICXDPOWY');


-- -----------------------------------------------------------------------------
-- PERGUNTA 10
-- Código SQLCheck: FFBAQQLJTBMDPLP
-- Enunciado: Quais os autores que escreveram livros com mais do que o dobro do 
--            número médio de páginas por livro.
-- -----------------------------------------------------------------------------
SELECT DISTINCT A.NOME
FROM AUTORES A
JOIN LIVROS L ON A.CODIGO_AUTOR = L.CODIGO_AUTOR
WHERE L.PAGINAS > 2 * (SELECT AVG(PAGINAS) FROM LIVROS)
ORDER BY A.NOME;

CALL SQLCHECK('FFBAQQLJTBMDPLP');


-- -----------------------------------------------------------------------------
-- PERGUNTA 11
-- Código SQLCheck: FFZODKCKMLJWQDJ
-- Enunciado: Quais os autores que escreveram mais livros do que a média de livros 
--            por autor. Pretendo ver também a data de nascimento dos autores.
-- -----------------------------------------------------------------------------
SELECT A.NOME,
       TO_CHAR(A.DATA_NASCIMENTO, 'YYYY-MM') AS ANO_MES,
       COUNT(L.CODIGO_LIVRO) AS NUM_LIVROS
FROM AUTORES A
JOIN LIVROS L ON A.CODIGO_AUTOR = L.CODIGO_AUTOR
GROUP BY A.NOME, A.DATA_NASCIMENTO
HAVING COUNT(L.CODIGO_LIVRO) > (
    SELECT AVG(COUNT(*))
    FROM LIVROS
    GROUP BY CODIGO_AUTOR
)
ORDER BY A.NOME;

CALL SQLCHECK('FFZODKCKMLJWQDJ');


-- -----------------------------------------------------------------------------
-- PERGUNTA 12
-- Código SQLCheck: FFQNPFRLLABFRGU
-- Enunciado: Para cada livro do género de Informática obtenha o seu preço de tabela, 
--            o preço médio dos livros editados pelo autor que o escreveu e a 
--            diferença em relação a esse preço médio. Considere apenas autores de 
--            Portalegre. Ordene pelo titulo e pelo código do autor.
-- -----------------------------------------------------------------------------
SELECT L.TITULO,
       L.CODIGO_AUTOR,
       L.PRECO_TABELA AS PRECO,
       (SELECT AVG(L2.PRECO_TABELA) 
        FROM LIVROS L2 
        WHERE L2.CODIGO_AUTOR = L.CODIGO_AUTOR
          AND UPPER(L2.GENERO) = 'INFORMÁTICA') AS PRECO_MEDIO,
       L.PRECO_TABELA - (SELECT AVG(L2.PRECO_TABELA) 
                         FROM LIVROS L2 
                         WHERE L2.CODIGO_AUTOR = L.CODIGO_AUTOR
                           AND UPPER(L2.GENERO) = 'INFORMÁTICA') AS "DIFERENÇA"
FROM LIVROS L
JOIN AUTORES A ON L.CODIGO_AUTOR = A.CODIGO_AUTOR
WHERE UPPER(L.GENERO) = 'INFORMÁTICA'
  AND UPPER(A.MORADA) LIKE '%PORTALEGRE%'
ORDER BY L.CODIGO_AUTOR, L.TITULO;

CALL SQLCHECK('FFQNPFRLLABFRGU');


-- -----------------------------------------------------------------------------
-- PERGUNTA 13
-- Código SQLCheck: FFOJNOQMRYYJSYA
-- Enunciado: Qual o livro best seller (com mais unidades vendidas) de cada género. 
--            Ordene pelo género.
-- -----------------------------------------------------------------------------
SELECT L1.GENERO,
       L1.TITULO,
       L1.UNIDADES_VENDIDAS
FROM LIVROS L1
WHERE L1.UNIDADES_VENDIDAS = (
    SELECT MAX(L2.UNIDADES_VENDIDAS)
    FROM LIVROS L2
    WHERE L2.GENERO = L1.GENERO
)
ORDER BY L1.GENERO;

CALL SQLCHECK('FFOJNOQMRYYJSYA');
