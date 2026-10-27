-- =============================================================================
-- FICHA 8 - RESOLUÇÃO COMPLETA E VALIDADA (SQLCHECK)
-- Base de Dados - ISEC / DEIS 2026/2027
-- Foco: Subconsultas avançadas, CTEs (WITH), ROWNUM / TOP-N, Funções Analíticas / Auto-junções temporais
-- =============================================================================

-- -----------------------------------------------------------------------------
-- EXERCÍCIO 3 (Pergunta 3 no Moodle)
-- Código SQLCheck: FHWBSWSCMNKSKYN
-- Enunciado: Qual o(s) último(s) livro(s) adquirido(s) por cada cliente da 
--            localidade de Moura. Ordene pelo nome do cliente e o título.
-- -----------------------------------------------------------------------------
SELECT c.nome, 
       l.titulo, 
       TO_CHAR(v.data_venda, 'DD-MM-YYYY') AS DATA_DA_VENDA
FROM livros l, vendas v, contem co, clientes c
WHERE v.codigo_venda = co.codigo_venda 
  AND co.codigo_livro = l.codigo_livro 
  AND v.codigo_cliente = c.codigo_cliente 
  AND c.morada LIKE '%Moura'
  AND v.data_venda = (
      SELECT MAX(v1.data_venda)
      FROM vendas v1
      WHERE v1.codigo_cliente = v.codigo_cliente
  )
ORDER BY c.nome, l.titulo;

CALL SQLCHECK('FHWBSWSCMNKSKYN');


-- -----------------------------------------------------------------------------
-- EXERCÍCIO 4 (Pergunta 4 no Moodle)
-- Código SQLCheck: FHJXDSVDOVZNLPX
-- Enunciado: Para o autor que escreveu o livro mais barato editado pela editora 
--            'LEYA', mostre o nome do autor, o título, quantos livros escreveu 
--            para essa editora e a totalidade de livros por ele escritos.
-- -----------------------------------------------------------------------------
SELECT a.nome,
       l.titulo,
       (SELECT COUNT(*)
        FROM livros l2, editoras e2
        WHERE l2.codigo_editora = e2.codigo_editora
          AND UPPER(e2.nome) = 'LEYA'
          AND l2.codigo_autor = a.codigo_autor) AS LIVROS_LEYA,
       (SELECT COUNT(*)
        FROM livros l3
        WHERE l3.codigo_autor = a.codigo_autor) AS TOTAL_DE_LIVRO
FROM autores a
JOIN livros l ON l.codigo_autor = a.codigo_autor
JOIN editoras e ON l.codigo_editora = e.codigo_editora
WHERE UPPER(e.nome) = 'LEYA'
  AND l.preco_tabela = (
      SELECT MIN(l4.preco_tabela)
      FROM livros l4
      JOIN editoras e4 ON l4.codigo_editora = e4.codigo_editora
      WHERE UPPER(e4.nome) = 'LEYA'
  );

CALL SQLCHECK('FHJXDSVDOVZNLPX');


-- -----------------------------------------------------------------------------
-- EXERCÍCIO 5 (Pergunta 5 no Moodle)
-- Código SQLCheck no Servidor: FHYRJNSEXQQNMIZ
-- NOTA IMPORTANTE: No texto do Moodle, o professor colocou por engano o código 
-- FHCVLJRFNGFANAM nesta pergunta, mas na base de dados o código deste exercício 
-- é FHYRJNSEXQQNMIZ.
-- Enunciado: Mostre para cada autor que escreveu mais do que 5 livros, a 
--            quantidade de livros que escreveu e quantos eram do seu género preferido.
-- -----------------------------------------------------------------------------
SELECT aut.nome, 
       DECODE(tab2.n_livros_g, NULL, '0', tab2.n_livros_g) AS "Genero Preferido", 
       tab1.n_livros AS "Total de Livros"
FROM autores aut, 
  (SELECT l.codigo_autor, COUNT(*) AS n_livros
   FROM livros l
   GROUP BY l.codigo_autor
   HAVING COUNT(*) > 5) tab1, 
  (SELECT l.codigo_autor, COUNT(*) AS n_livros_g
   FROM livros l, autores au
   WHERE l.codigo_autor = au.codigo_autor 
     AND au.genero_preferido = l.genero
   GROUP BY l.codigo_autor) tab2
WHERE aut.codigo_autor = tab1.codigo_autor 
  AND aut.codigo_autor = tab2.codigo_autor(+)
ORDER BY 1;

CALL SQLCHECK('FHYRJNSEXQQNMIZ');


-- -----------------------------------------------------------------------------
-- EXERCÍCIO 6 (Pergunta 6 no Moodle)
-- Código SQLCheck no Servidor: FHCVLJRFNGFANAM
-- Enunciado: Para a editora que menos livros vendeu (unidades_vendidas), mostre 
--            quais os autores e a quantidade de livros que escreveram para essa 
--            editora. Além dessa informação, mostre também para esses autores, 
--            a quantidade total de livros escritos.
-- -----------------------------------------------------------------------------
SELECT 'O autor ' || a.nome || ' escreveu ' || COUNT(*) || ' de ' ||
       (SELECT COUNT(*)
        FROM livros l2
        WHERE l2.codigo_autor = a.codigo_autor) ||
       ' livros para a editora ' || e.nome || '.' AS RESULTADO
FROM livros l
JOIN autores a ON l.codigo_autor = a.codigo_autor
JOIN editoras e ON l.codigo_editora = e.codigo_editora
WHERE e.codigo_editora IN (
    SELECT codigo_editora
    FROM livros
    GROUP BY codigo_editora
    HAVING SUM(unidades_vendidas) <= ALL (
        SELECT SUM(unidades_vendidas)
        FROM livros
        GROUP BY codigo_editora
    )
)
GROUP BY a.codigo_autor, a.nome, e.nome
ORDER BY a.nome;

CALL SQLCHECK('FHCVLJRFNGFANAM');


-- -----------------------------------------------------------------------------
-- EXERCÍCIO 7 (Pergunta 7 no Moodle)
-- Código SQLCheck no Servidor: FHEMLBVGUMMSOKC
-- Enunciado: Apresente o top 3 dos livros mais vendidos após 10 de janeiro de 2025.
-- -----------------------------------------------------------------------------
SELECT 'top ' || ROWNUM AS TOP, 
       titulo, 
       soma
FROM (
    SELECT l.titulo, 
           SUM(c.quantidade) AS soma
    FROM livros l
    JOIN contem c ON c.codigo_livro = l.codigo_livro
    JOIN vendas v ON v.codigo_venda = c.codigo_venda
    WHERE v.data_venda >= TO_DATE('10-01-2025', 'DD-MM-YYYY')
    GROUP BY l.titulo
    ORDER BY soma DESC
)
WHERE ROWNUM <= 3;

CALL SQLCHECK('FHEMLBVGUMMSOKC');


-- -----------------------------------------------------------------------------
-- EXERCÍCIO 8 (Pergunta 8 no Moodle)
-- Código SQLCheck no Servidor: FHNWPVJHJITGPJC
-- Enunciado: Considerando a quantidade de livros vendidos em cada mês, mostre quais 
--            os meses que apresentaram um decréscimo percentual inferior a 50%, 
--            em relação às vendas do mês anterior. Ordene pelo ano e mês.
-- -----------------------------------------------------------------------------
WITH mes AS (
    SELECT TRUNC(data_venda, 'MM') AS data, 
           SUM(quantidade) AS soma
    FROM vendas v
    JOIN contem c ON v.codigo_venda = c.codigo_venda
    GROUP BY TRUNC(data_venda, 'MM')
    ORDER BY 1
) 
SELECT TO_CHAR(mes.data, 'YYYY/MM') AS MES, 
       mes.soma AS VENDAS_DO_MES, 
       ROUND(100 * (mes.soma - mes1.soma) / mes1.soma, 2) AS VARIACAO_PERCENT 
FROM mes, mes mes1 
WHERE MONTHS_BETWEEN(mes.data, mes1.data) = 1 
  AND ROUND(100 * (mes.soma - mes1.soma) / mes1.soma, 2) < 50 
ORDER BY 1;

CALL SQLCHECK('FHNWPVJHJITGPJC');
