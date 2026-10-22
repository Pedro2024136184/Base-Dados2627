-- =============================================================================
-- FICHA 4 - RESOLUÇÃO COMPLETA E VALIDADA (SQLCHECK)
-- Base de Dados - ISEC / DEIS 2026/2027
-- =============================================================================

-- -----------------------------------------------------------------------------
-- PERGUNTA 3 (VALIDADA ✅)
-- Código SQLCheck: FDKZRRJCNNGAGKC
-- -----------------------------------------------------------------------------
SELECT L.Titulo, A.Nome, L.Genero, L.Paginas
FROM Livros L
JOIN Autores A ON L.Codigo_Autor = A.Codigo_Autor
WHERE EXTRACT(YEAR FROM L.Data_Edicao) = 2023
  AND A.Nome LIKE '%Santos%'
ORDER BY L.Data_Edicao, L.Preco_Tabela;

CALL SQLCHECK('FDKZRRJCNNGAGKC');


-- -----------------------------------------------------------------------------
-- PERGUNTA 4
-- Código SQLCheck: FDSLHMYDUZDBHBF
-- NOTA: O gabarito usa 'HH24:MI:SS AM' (ex: 13:13:02 PM).
-- -----------------------------------------------------------------------------
SELECT TO_CHAR(SYSDATE, 'DDTH, Month, YYYY') AS "Data Atual",
       TO_CHAR(SYSDATE, 'HH24:MI:SS AM') AS "Hora Atual"
FROM DUAL;

CALL SQLCHECK('FDSLHMYDUZDBHBF');


-- -----------------------------------------------------------------------------
-- PERGUNTA 5 (VALIDADA ✅)
-- Código SQLCheck: FDQVQBUEJUOPIPW
-- -----------------------------------------------------------------------------
SELECT L.Titulo AS "Titulo", 
       A.Nome AS "NOME", 
       L.Preco_Tabela AS "Preço",
       TO_CHAR(L.Data_Edicao, 'DD Mon YYYY') AS DATA_EDICAO
FROM Livros L
JOIN Autores A ON L.Codigo_Autor = A.Codigo_Autor
WHERE SYSDATE - L.Data_Edicao < 90
ORDER BY L.Titulo;

CALL SQLCHECK('FDQVQBUEJUOPIPW');


-- -----------------------------------------------------------------------------
-- PERGUNTA 6 (VALIDADA ✅)
-- Código SQLCheck: FDFITVLFTISTJFN
-- -----------------------------------------------------------------------------
SELECT DISTINCT L.Titulo, L.Preco_Tabela, L.Genero
FROM Livros L
JOIN Contem C ON L.Codigo_Livro = C.Codigo_Livro
JOIN Vendas V ON C.Codigo_Venda = V.Codigo_Venda
JOIN Clientes CL ON V.Codigo_Cliente = CL.Codigo_Cliente
WHERE CL.Morada LIKE '%Coimbra%'
  AND V.Data_Venda BETWEEN TO_DATE('14-07-2024', 'DD-MM-YYYY') 
                       AND TO_DATE('30-09-2025', 'DD-MM-YYYY')
ORDER BY L.Titulo;

CALL SQLCHECK('FDFITVLFTISTJFN');


-- -----------------------------------------------------------------------------
-- PERGUNTA 7
-- Código SQLCheck: FDDUVTYGQKOXKDO
-- -----------------------------------------------------------------------------
SELECT DISTINCT 
       TO_CHAR(L.Data_Edicao, 'YYYY-MM') AS ANO_MES,
       L.Titulo AS TITULO
FROM Livros L
JOIN Contem C ON L.Codigo_Livro = C.Codigo_Livro
JOIN Vendas V ON C.Codigo_Venda = V.Codigo_Venda
WHERE UPPER(L.Genero) = 'ROMANCE'
  AND TO_CHAR(L.Data_Edicao, 'YYYY-MM') = TO_CHAR(V.Data_Venda, 'YYYY-MM')
ORDER BY ANO_MES, TITULO;

CALL SQLCHECK('FDDUVTYGQKOXKDO');


-- -----------------------------------------------------------------------------
-- PERGUNTA 8
-- Código SQLCheck: FDHWIHZHNFFLLML
-- NOTA: Inverno de 2024 começa a 21-Dez-2024 e vai até 21-Mar-2025.
-- -----------------------------------------------------------------------------
SELECT DISTINCT A.Nome, A.Genero_Preferido, L.Titulo
FROM Autores A
JOIN Livros L ON A.Codigo_Autor = L.Codigo_Autor
WHERE L.Paginas < 100
  AND L.Data_Edicao BETWEEN DATE '2024-12-21' AND DATE '2025-03-21'
ORDER BY A.Nome, L.Titulo;

CALL SQLCHECK('FDHWIHZHNFFLLML');


-- -----------------------------------------------------------------------------
-- PERGUNTA 9 (VALIDADA ✅)
-- Código SQLCheck: FDHHHXWIUZXXMRW
-- -----------------------------------------------------------------------------
SELECT 
    L.Genero,
    L.Titulo AS "Titulo",
    TO_CHAR(L.Data_Edicao, 'DD-MM-YYYY') AS Data_Edicao,
    TRUNC(MONTHS_BETWEEN(SYSDATE, L.Data_Edicao) / 12) AS "Num. de anos"
FROM Livros L
JOIN Editoras E ON L.Codigo_Editora = E.Codigo_Editora
JOIN Autores A ON L.Codigo_Autor = A.Codigo_Autor
WHERE UPPER(E.Nome) = 'EDITORIAL PRESENÇA'
  AND UPPER(L.Genero) IN ('POLICIAL', 'AVENTURA')
  AND UPPER(L.Genero) = UPPER(A.Genero_Preferido)
ORDER BY L.Genero, L.Titulo;

CALL SQLCHECK('FDHHHXWIUZXXMRW');


-- -----------------------------------------------------------------------------
-- PERGUNTA 10 (VALIDADA ✅)
-- Código SQLCheck: FDAKPXLJDOILNNB
-- -----------------------------------------------------------------------------
SELECT DISTINCT CL.Nome, CL.Idade
FROM Clientes CL
JOIN Vendas V ON CL.Codigo_Cliente = V.Codigo_Cliente
WHERE TO_CHAR(V.Data_Venda, 'DY', 'NLS_DATE_LANGUAGE=ENGLISH') = 'SAT'
  AND EXTRACT(DAY FROM V.Data_Venda) <= 7
  AND TO_NUMBER(TO_CHAR(V.Data_Venda, 'HH24')) >= 12
ORDER BY CL.Nome ASC;

CALL SQLCHECK('FDAKPXLJDOILNNB');


-- -----------------------------------------------------------------------------
-- PERGUNTA 11 (VALIDADA ✅)
-- Código SQLCheck: FDRNWQPKZJSDOZL
-- -----------------------------------------------------------------------------
SELECT CL.Nome, CL.Idade
FROM Clientes CL
WHERE CL.Idade < 30
  AND NOT EXISTS (
      SELECT 1
      FROM Vendas V
      WHERE V.Codigo_Cliente = CL.Codigo_Cliente
  )
ORDER BY CL.Nome ASC;

CALL SQLCHECK('FDRNWQPKZJSDOZL');


-- -----------------------------------------------------------------------------
-- PERGUNTA 12
-- Código SQLCheck: FDWCPAULXOOOPYH
-- NOTA: O enunciado exige 'Utilize MINUS' (sem UNION).
-- -----------------------------------------------------------------------------
SELECT a.nome AS NOME, a.genero_preferido AS GENERO_PREFERIDO
FROM autores a

MINUS

SELECT a.nome AS NOME, a.genero_preferido AS GENERO_PREFERIDO
FROM autores a
JOIN livros l ON l.codigo_autor = a.codigo_autor
WHERE EXTRACT(YEAR FROM l.data_edicao) <> EXTRACT(YEAR FROM SYSDATE) - 1

ORDER BY NOME;

CALL SQLCHECK('FDWCPAULXOOOPYH');
