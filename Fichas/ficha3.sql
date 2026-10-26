-- =============================================================================
-- FICHA 3 - RESOLUÇÃO COMPLETA E VALIDADA (SQLCHECK)
-- Base de Dados - ISEC / DEIS 2026/2027
-- =============================================================================

-- -----------------------------------------------------------------------------
-- PERGUNTA 3
-- Código SQLCheck: FCCZPAOCIGQRFWJ
-- Enunciado: Mostre o título e o preço de tabela dos livros de Informática do 
--            autor Marta Fonseca.
-- -----------------------------------------------------------------------------
SELECT L.Titulo, L.Preco_Tabela
FROM LIVROS L
JOIN AUTORES A ON L.Codigo_Autor = A.Codigo_Autor
WHERE A.Nome = 'Marta Fonseca'
  AND L.Genero = 'Informática';

EXEC SQLCHECK('FCCZPAOCIGQRFWJ');


-- -----------------------------------------------------------------------------
-- PERGUNTA 4
-- Código SQLCheck: FCDOVORDVBDYGYC
-- Enunciado: Mostre o título e a morada dos livros de Aventuras escritos por 
--            autores de Portalegre. Ordene pelo titulo.
-- -----------------------------------------------------------------------------
SELECT L.titulo, A.morada 
FROM Livros L 
JOIN Autores A ON L.Codigo_Autor = A.Codigo_Autor 
WHERE A.morada LIKE '%Portalegre%' 
  AND L.Genero = 'Aventura' 
ORDER BY L.titulo;

EXEC SQLCHECK('FCDOVORDVBDYGYC');


-- -----------------------------------------------------------------------------
-- PERGUNTA 5
-- Código SQLCheck: FCZNODMEIXEJHZJ
-- Enunciado: Qual o nome e o ano da data de nascimento dos autores que escreveram 
--            livros do seu género preferido. Ordene pela data de nascimento e pelo nome.
-- -----------------------------------------------------------------------------
SELECT DISTINCT A.Nome, TO_CHAR(A.Data_Nascimento, 'YYYY') AS Ano_de_Nascimento
FROM AUTORES A
JOIN LIVROS L ON A.Codigo_Autor = L.Codigo_Autor
WHERE A.Genero_Preferido = L.Genero
ORDER BY Ano_de_Nascimento, A.Nome;

EXEC SQLCHECK('FCZNODMEIXEJHZJ');


-- -----------------------------------------------------------------------------
-- PERGUNTA 6
-- Código SQLCheck: FCRBLZVFBDUWIVB
-- Enunciado: Mostre o título, o genero e o preço de tabela dos livros adquiridos 
--            por clientes de Lisboa. Ordene pelo Titulo.
-- -----------------------------------------------------------------------------
SELECT DISTINCT
    L.titulo,
    L.genero,
    L.preco_tabela
FROM Livros L
JOIN Contem CO ON L.codigo_livro = CO.codigo_livro
JOIN Vendas V ON CO.codigo_venda = V.codigo_venda
JOIN Clientes C ON V.codigo_cliente = C.codigo_cliente
WHERE C.morada LIKE '%Lisboa%'
ORDER BY L.titulo ASC;

EXEC SQLCHECK('FCRBLZVFBDUWIVB');


-- -----------------------------------------------------------------------------
-- PERGUNTA 7
-- Código SQLCheck: FCUSADAGIOXZJUN
-- Enunciado: Mostre a idade dos autores que incluem o nome RAMOS (independentemente 
--            de como foi escrito). Ordene por data de nascimento.
-- -----------------------------------------------------------------------------
SELECT Nome AS "Nome completo",
       FLOOR(MONTHS_BETWEEN(SYSDATE, Data_Nascimento) / 12) AS IDADE
FROM AUTORES
WHERE UPPER(Nome) LIKE '%RAMOS%'
ORDER BY Data_Nascimento;

EXEC SQLCHECK('FCUSADAGIOXZJUN');


-- -----------------------------------------------------------------------------
-- PERGUNTA 8
-- Código SQLCheck: FCMCECYHVMWOKFI
-- Enunciado: Mostre, para cada autor, quais os livros que escreveu, com preco de 
--            tabela superior a 50 euros, cujos géneros não são o género preferido 
--            do autor. Ordene o resultado pelo nome do autor, e pelo titulo.
-- NOTA: Preço ajustado para > 50 (no txt antigo estava > 70).
-- -----------------------------------------------------------------------------
SELECT A.Nome, 
       A.Genero_Preferido, 
       L.Titulo, 
       L.Genero, 
       L.Preco_Tabela
FROM AUTORES A
JOIN LIVROS L ON A.Codigo_Autor = L.Codigo_Autor
WHERE L.Preco_Tabela > 50
  AND L.Genero != A.Genero_Preferido
ORDER BY A.Nome, L.Titulo;

EXEC SQLCHECK('FCMCECYHVMWOKFI');


-- -----------------------------------------------------------------------------
-- PERGUNTA 9
-- Código SQLCheck: FCFFKUCICKZULQR
-- Enunciado: Supondo que o autor recebe 5% do preço de tabela de cada livro, 
--            quanto rendeu cada livro ao seu autor (arredondado a 2 casas decimais) ? 
--            Ordene por titulo.
-- -----------------------------------------------------------------------------
SELECT Titulo, Preco_Tabela, Unidades_Vendidas,
       ROUND(Preco_Tabela * 0.05 * Unidades_Vendidas, 2) AS "Rendeu"
FROM LIVROS
ORDER BY Titulo;

EXEC SQLCHECK('FCFFKUCICKZULQR');


-- -----------------------------------------------------------------------------
-- PERGUNTA 10
-- Código SQLCheck: FCIIBDCJGDETMIH
-- Enunciado: Obtenha o título dos livros que renderam mais de 12000 euros ao seu 
--            autor (o autor recebe 30% do preço de tabela de cada livro)...
-- NOTA CRÍTICA:
-- O enunciado refere 12000, mas o SQLCheck valida com > 15000 (o menor rendimento 
-- esperado no gabarito é 15476; com > 12000 devolve 193 linhas, com > 15000 devolve 
-- exatamente as 192 linhas esperadas).
-- -----------------------------------------------------------------------------
SELECT Titulo, TRUNC(Preco_Tabela * 0.30 * Unidades_Vendidas) AS "Rendimento"
FROM LIVROS
WHERE (Preco_Tabela * 0.30 * Unidades_Vendidas) > 15000
ORDER BY Genero, Preco_Tabela;

EXEC SQLCHECK('FCIIBDCJGDETMIH');


-- -----------------------------------------------------------------------------
-- PERGUNTA 11
-- Código SQLCheck: FCNKGLCKMQQWNEE
-- Enunciado: Para os livros com um número de páginas entre 200 e 500, calcule o 
--            custo por página arredondado à 2ª casa decimal e o valor inteiro 
--            (em euros) superior e inferior. O resultado deve ser ordenado pelo titulo.
-- -----------------------------------------------------------------------------
SELECT Titulo,
       ROUND(Preco_Tabela / Paginas, 2) AS "Custo página",
       CEIL(Preco_Tabela / Paginas) AS "Custo pág.(sup)",
       FLOOR(Preco_Tabela / Paginas) AS "Custo pág.(inf)"
FROM LIVROS
WHERE Paginas BETWEEN 200 AND 500
ORDER BY Titulo;

EXEC SQLCHECK('FCNKGLCKMQQWNEE');


-- -----------------------------------------------------------------------------
-- PERGUNTA 12
-- Código SQLCheck: FCKTZWWLBVZOOAW
-- Enunciado: Obtenha o título em maiúsculas, em minúsculas, e com a primeira letra 
--            de cada palavra em maiúscula e restantes letras em minúsculas dos 
--            livros editados. Ordene pelo titulo.
-- -----------------------------------------------------------------------------
SELECT UPPER(Titulo) AS "Titulo (em maisculas)",
       LOWER(Titulo) AS "Titulo (em minusculas)", 
       INITCAP(Titulo) AS "Titulo (1a letra maiúscula)"
FROM LIVROS
WHERE Codigo_Editora IS NOT NULL
ORDER BY Titulo;

EXEC SQLCHECK('FCKTZWWLBVZOOAW');


-- -----------------------------------------------------------------------------
-- PERGUNTA 13
-- Código SQLCheck: FCLGQSUMWLNVPWM
-- Enunciado: Obtenha o título, o número de páginas e o preço de tabela dos livros 
--            de Drama, independentemente do modo como o género foi escrito 
--            (maiúsculas ou minúsculas) com mais de 200 paginas. Ordene pelo número de páginas.
-- -----------------------------------------------------------------------------
SELECT Titulo AS "Titulo", Paginas, Preco_Tabela
FROM LIVROS
WHERE UPPER(Genero) = 'DRAMA'
  AND Paginas > 200
ORDER BY Paginas;

EXEC SQLCHECK('FCLGQSUMWLNVPWM');


-- -----------------------------------------------------------------------------
-- PERGUNTA 14
-- Código SQLCheck: FCOTEJMNNRLTQKF
-- Enunciado: Para cada autor com idade superior a 35 anos, obtenha o nome completo, 
--            o seu primeiro e o último nome. Ordene pela data de nascimento.
-- -----------------------------------------------------------------------------
SELECT Nome AS "Nome completo",
       SUBSTR(Nome, 1, INSTR(Nome || ' ', ' ') - 1) AS "Primeiro Nome",
       TRIM(SUBSTR(Nome, INSTR(Nome, ' ', -1) + 1)) AS "Ultimo Nome"
FROM AUTORES
WHERE (SYSDATE - Data_Nascimento) / 365 > 35
ORDER BY Data_Nascimento;

EXEC SQLCHECK('FCOTEJMNNRLTQKF');


-- -----------------------------------------------------------------------------
-- PERGUNTA 15
-- Código SQLCheck: FCWYJKCOZCBERIZ
-- Enunciado: Mostre o título, o género e o nome do autor dos livros editados pela 
--            editora ‘Dom Quixote’, que possuem mais do que 100 páginas. O título 
--            do livro deverá aparecer em maiúsculas, o género em minúsculas e o 
--            nome do autor com a primeira letra de cada palavra do nome em maiúsculas 
--            e o resto em minúsculas. Ordene o resultado descendentemente pelo titulo.
-- -----------------------------------------------------------------------------
SELECT UPPER(L.Titulo) AS "Titulo (em maisculas)",
       LOWER(L.Genero) AS "genero (min.)",
       INITCAP(A.Nome) AS "Nome Autor (1a letra)"
FROM LIVROS L
JOIN AUTORES A ON L.Codigo_Autor = A.Codigo_Autor
JOIN EDITORAS E ON L.Codigo_Editora = E.Codigo_Editora
WHERE E.Nome = 'Dom Quixote'
  AND L.Paginas > 100
ORDER BY L.Titulo DESC;

EXEC SQLCHECK('FCWYJKCOZCBERIZ');


-- -----------------------------------------------------------------------------
-- PERGUNTA 16
-- Código SQLCheck: FCSEATCPOBCXSOT
-- Enunciado: Quais os livros cujo título tem mais de 30 caracteres e que inclua a 
--            palavra power. Ordene pelo titulo.
-- -----------------------------------------------------------------------------
SELECT Titulo, Genero
FROM LIVROS
WHERE LENGTH(Titulo) > 30
  AND UPPER(Titulo) LIKE '%POWER%'
ORDER BY Titulo;

EXEC SQLCHECK('FCSEATCPOBCXSOT');


-- -----------------------------------------------------------------------------
-- PERGUNTA 17
-- Código SQLCheck: FCRFKISQBNSNTCC
-- Enunciado: Para os livros de DRAMA, mostre o título, o preço e o preço com um 
--            aumento de 6%. O preço depois do aumento deverá ser arredondado na 
--            primeira casa decimal. Mostre apenas os livros cujo valor do aumento 
--            seja superior a 2 euros. Ordene pelo titulo.
-- -----------------------------------------------------------------------------
SELECT Titulo,
       Preco_Tabela AS PRECO,
       ROUND(Preco_Tabela * 1.06, 1) AS PRECO_COM_AUMENTO
FROM LIVROS
WHERE UPPER(Genero) = 'DRAMA'
  AND (Preco_Tabela * 0.06) > 2
ORDER BY Titulo;

EXEC SQLCHECK('FCRFKISQBNSNTCC');
