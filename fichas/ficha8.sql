-- =============================================================================
-- FICHA 8 - RESOLUÇÃO PREPARADA
-- Base de Dados - ISEC / DEIS 2026/2027
-- Foco: Subconsultas correlacionadas, subconsultas no FROM, ROWNUM, agregação condicional
-- =============================================================================

-- -----------------------------------------------------------------------------
-- EXERCÍCIO 3
-- SQLCheck base: FHJHHOMCPTVVKNH
-- Descrição: Nome do autor, título do livro mais barato da editora 'Leya',
--            total de livros do autor na 'Leya' e total geral de livros do autor.
-- CORREÇÃO CRÍTICA: Ajustado 'COUNT()' para 'COUNT(*)' (evita erro ORA-00909).
-- -----------------------------------------------------------------------------
SELECT  a.Nome                          AS Nome,
        l.Titulo                        AS Titulo,
        ( SELECT COUNT(*)
          FROM   Livros   l2
                 JOIN Editoras e2 ON e2.Codigo_Editora = l2.Codigo_Editora
          WHERE  l2.Codigo_Autor = a.Codigo_Autor
            AND  e2.Nome = 'Leya'
        )                               AS Livros_Leya,
        ( SELECT COUNT(*)
          FROM   Livros l3
          WHERE  l3.Codigo_Autor = a.Codigo_Autor
        )                               AS Total_de_Livros
FROM   Autores  a
JOIN   Livros   l ON l.Codigo_Autor = a.Codigo_Autor
JOIN   Editoras e ON e.Codigo_Editora = l.Codigo_Editora
WHERE  e.Nome = 'Leya'
  AND  l.Preco_Tabela = (
          SELECT MIN(l2.Preco_Tabela)
          FROM   Livros   l2
                 JOIN Editoras e2 ON e2.Codigo_Editora = l2.Codigo_Editora
          WHERE  e2.Nome = 'Leya'
       );

EXEC SQLCHECK('FHJHHOMCPTVVKNH');


-- -----------------------------------------------------------------------------
-- EXERCÍCIO 4
-- SQLCheck base: FHFQELJDGYAOLUQ
-- Descrição: Autores com mais de 5 livros no total, indicando quantos desses 
--            livros são do seu género preferido.
-- -----------------------------------------------------------------------------
SELECT A.NOME AS NOME, 
       SUM(CASE WHEN L.GENERO = A.GENERO_PREFERIDO THEN 1 ELSE 0 END) AS "Genero Preferido",
       COUNT(L.CODIGO_LIVRO) AS "Total de Livros"
FROM AUTORES A
JOIN LIVROS L ON A.CODIGO_AUTOR = L.CODIGO_AUTOR
GROUP BY A.CODIGO_AUTOR, A.NOME, A.GENERO_PREFERIDO
HAVING COUNT(L.CODIGO_LIVRO) > 5
ORDER BY A.NOME;

EXEC SQLCHECK('FHFQELJDGYAOLUQ');


-- -----------------------------------------------------------------------------
-- EXERCÍCIO 5
-- SQLCheck base: FHMETHREKCIAMWP
-- Descrição: Formata uma frase para a editora com menor soma de unidades vendidas:
--            'O autor X escreveu Y de Z livros para a editora W.'
-- -----------------------------------------------------------------------------
SELECT 'O autor ' || A.NOME || 
       ' escreveu ' || COUNT(L.CODIGO_LIVRO) || 
       ' de ' || (SELECT COUNT(L2.Codigo_Livro) FROM LIVROS L2 WHERE L2.CODIGO_AUTOR = A.CODIGO_AUTOR) || 
       ' livros para a editora ' || E.NOME || '.' AS RESULTADO
FROM LIVROS L
JOIN AUTORES A ON L.CODIGO_AUTOR = A.CODIGO_AUTOR
JOIN EDITORAS E ON L.CODIGO_EDITORA = E.CODIGO_EDITORA
WHERE E.CODIGO_EDITORA = (
    -- Subquery: encontra a editora com a menor soma de UNIDADES_VENDIDAS
    SELECT Codigo_Editora 
    FROM (
        SELECT L3.Codigo_Editora, SUM(L3.Unidades_Vendidas) AS Total_Vendas
        FROM LIVROS L3
        GROUP BY L3.Codigo_Editora
        ORDER BY Total_Vendas ASC
    )
    WHERE ROWNUM = 1
)
GROUP BY A.CODIGO_AUTOR, A.NOME, E.NOME
ORDER BY A.NOME;

EXEC SQLCHECK('FHMETHREKCIAMWP');


-- -----------------------------------------------------------------------------
-- EXERCÍCIO 6
-- SQLCheck base: FHFQLCOFFOHMNHS
-- Descrição: Top 3 livros mais vendidos após 10 de janeiro de 2025.
-- -----------------------------------------------------------------------------
SELECT 'top ' || ROWNUM AS TOP, T.TITULO, T.SOMA
FROM (
    SELECT L.TITULO AS TITULO,
           SUM(C.QUANTIDADE) AS SOMA
    FROM LIVROS L
    JOIN CONTEM C ON L.CODIGO_LIVRO = C.CODIGO_LIVRO
    JOIN VENDAS V ON C.CODIGO_VENDA = V.CODIGO_VENDA
    WHERE V.DATA_VENDA > TO_DATE('10-JAN-2025', 'DD-MON-YYYY')
    GROUP BY L.TITULO
    ORDER BY SOMA DESC
) T
WHERE ROWNUM <= 3;

EXEC SQLCHECK('FHFQLCOFFOHMNHS');
