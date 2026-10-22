-- =============================================================================
-- FICHA 2 - RESOLUÇÃO COMPLETA
-- Base de Dados - ISEC / DEIS 2026/2027
-- =============================================================================

-- -----------------------------------------------------------------------------
-- PERGUNTA 3
-- Código SQLCheck: FBUNBWWCKYAXEWK
-- Enunciado: Seleccione o genero, o título, e o preço de tabela dos livros 
--            Policiais e de Aventuras, com preço de tabela superior a 45 euros. 
--            Ordene descendentemente pelo titulo.
-- NOTA: Ajustado para 'preco_tabela > 45' (no txt antigo estava < 60).
-- -----------------------------------------------------------------------------
SELECT genero, titulo, preco_tabela 
FROM Livros 
WHERE genero IN ('Policial', 'Aventura') 
  AND preco_tabela > 45 
ORDER BY titulo DESC;

EXEC SQLCHECK('FBUNBWWCKYAXEWK');


-- -----------------------------------------------------------------------------
-- PERGUNTA 4
-- Código SQLCheck: FBNCOCCDHHDRFJB
-- Enunciado: Mostre o nome, idade e a morada dos clientes com idade entre 
--            30 e 55 anos (inclusive) e que moram em Ovar. 
--            Ordene o resultado ascendentemente pelo nome.
-- -----------------------------------------------------------------------------
SELECT nome, idade, morada 
FROM Clientes 
WHERE idade BETWEEN 30 AND 55 
  AND morada LIKE '%Ovar%' 
ORDER BY nome ASC;

EXEC SQLCHECK('FBNCOCCDHHDRFJB');


-- -----------------------------------------------------------------------------
-- PERGUNTA 5
-- Código SQLCheck: FBCIOEQEBYAEGEQ
-- Enunciado: Seleccione os géneros dos livros que tenham menos de 300 páginas 
--            e preço de tabela inferior a 20. Ordene pelo género.
-- NOTA: Ajustado para 'paginas < 300 AND preco_tabela < 20' (no txt antigo estava < 400 e < 15).
-- -----------------------------------------------------------------------------
SELECT DISTINCT genero 
FROM Livros 
WHERE paginas < 300 
  AND preco_tabela < 20 
ORDER BY genero ASC;

EXEC SQLCHECK('FBCIOEQEBYAEGEQ');


-- -----------------------------------------------------------------------------
-- PERGUNTA 6
-- Código SQLCheck: FBSTJGQFCJKVHPM
-- Enunciado: Mostre o título e o preco de tabela de todos os livros de Informática, 
--            cujo preço, com um desconto de 20%, custem menos de 20 euros. 
--            Ordene ascendente pelo preço.
-- -----------------------------------------------------------------------------
SELECT titulo, preco_tabela AS preco 
FROM Livros 
WHERE genero = 'Informática' 
  AND (preco_tabela * 0.8) < 20 
ORDER BY preco_tabela ASC;

EXEC SQLCHECK('FBSTJGQFCJKVHPM');


-- -----------------------------------------------------------------------------
-- PERGUNTA 7
-- Código SQLCheck: FBSXBPIGPYSMITJ
-- Enunciado: Mostre o ISBN, título, preco_tabela dos livros de Informática cujo 
--            preço arrendondado seja 40 euros. Ordene ascendentemente pelo preço 
--            de tabela e descendentemente pelas unidades vendidas.
-- NOTA: Se o SQLCheck exigir apenas as 3 colunas pedidas no enunciado.
--       (Se pedir 5 colunas como no txt antigo: adicione unidades_vendidas e genero).
-- -----------------------------------------------------------------------------
SELECT isbn, titulo, preco_tabela AS preco 
FROM Livros 
WHERE genero = 'Informática' 
  AND ROUND(preco_tabela) = 40 
ORDER BY preco_tabela ASC, unidades_vendidas DESC;

EXEC SQLCHECK('FBSXBPIGPYSMITJ');


-- -----------------------------------------------------------------------------
-- PERGUNTA 8
-- Código SQLCheck: FBGCNLTHOJHOJGH
-- Enunciado: Mostre o código dos autores, considerando apenas os livros registados 
--            do genero Drama. Ordene descendentemente pelo código do autor.
-- -----------------------------------------------------------------------------
SELECT DISTINCT codigo_autor 
FROM Livros 
WHERE genero = 'Drama' 
ORDER BY codigo_autor DESC;

EXEC SQLCHECK('FBGCNLTHOJHOJGH');


-- -----------------------------------------------------------------------------
-- PERGUNTA 9
-- Código SQLCheck: FBSSBDBIAFKUKAH
-- Enunciado: Seleccione o título de todos os livros excepto os Policiais, cujo 
--            preco de tabela seja superior a 50 euros. Ordene pelo preco de tabela.
-- NOTA: Adicionado 'AND preco_tabela > 50' que não estava no txt antigo.
-- -----------------------------------------------------------------------------
SELECT titulo 
FROM Livros 
WHERE genero <> 'Policial' 
  AND preco_tabela > 50 
ORDER BY preco_tabela ASC;

EXEC SQLCHECK('FBSSBDBIAFKUKAH');


-- -----------------------------------------------------------------------------
-- PERGUNTA 10
-- Código SQLCheck: FBJPHPOJXSDDLNV
-- Enunciado: Considerando os livros com preco de tabela inferior a 20 euros, 
--            seleccione o título, isbn e o preco de tabela dos livros, excepto 
--            os de Aventuras e Policiais. Ordene pelo preco de tabela e codigo de livro. Use o NOT.
-- -----------------------------------------------------------------------------
SELECT titulo, isbn, preco_tabela 
FROM Livros 
WHERE preco_tabela < 20 
  AND NOT (genero = 'Aventura' OR genero = 'Policial') 
ORDER BY preco_tabela ASC, codigo_livro ASC;

EXEC SQLCHECK('FBJPHPOJXSDDLNV');


-- -----------------------------------------------------------------------------
-- PERGUNTA 11
-- Código SQLCheck: FBKHPOYKLGTLMDO
-- Enunciado: Quais os livros cujo título tem mais de 45 caracteres? 
--            Mostre o titulo, genero e número de paginas. Ordene pelo titulo.
-- -----------------------------------------------------------------------------
SELECT titulo, genero, paginas 
FROM Livros 
WHERE LENGTH(titulo) > 45 
ORDER BY titulo ASC;

EXEC SQLCHECK('FBKHPOYKLGTLMDO');


-- -----------------------------------------------------------------------------
-- PERGUNTA 12
-- Código SQLCheck: FBECMHRLJGFPNOE
-- Enunciado: Apresente o nome e a data de nascimento dos autores que contenham 
--            as letras ‘o’ e ‘u’. Ordene pela idade.
-- NOTA: Ordenar pela idade (mais velho para mais novo = nascimento ASC; ou vice-versa).
-- -----------------------------------------------------------------------------
SELECT nome, data_nascimento 
FROM Autores 
WHERE nome LIKE '%o%' 
  AND nome LIKE '%u%' 
ORDER BY data_nascimento ASC;

EXEC SQLCHECK('FBECMHRLJGFPNOE');


-- -----------------------------------------------------------------------------
-- PERGUNTA 13
-- Código SQLCheck: FBTRISOMZLFNORD
-- Enunciado: Seleccione o título e o género dos livros que começam por ‘O’ e 
--            contêm a sequência de letras ‘st’ e também os que começam por ‘R’ 
--            e contém a sequência ‘eng’. Ordene pelo preco de tabela.
-- -----------------------------------------------------------------------------
SELECT titulo, genero 
FROM Livros 
WHERE (titulo LIKE 'O%' AND titulo LIKE '%st%') 
   OR (titulo LIKE 'R%' AND titulo LIKE '%eng%') 
ORDER BY preco_tabela ASC;

EXEC SQLCHECK('FBTRISOMZLFNORD');


-- -----------------------------------------------------------------------------
-- PERGUNTA 14
-- Código SQLCheck: FBTTGUNNAEXNPSE
-- Enunciado: Seleccione o título, o genero e o preço de tabela dos livros cujo 
--            titulo começa por 'A' que não sejam dos géneros policiais, 
--            romances e Drama. Ordene pelo titulo.
-- -----------------------------------------------------------------------------
SELECT titulo, genero, preco_tabela 
FROM Livros 
WHERE titulo LIKE 'A%' 
  AND genero NOT IN ('Policial', 'Romance', 'Drama') 
ORDER BY titulo ASC;

EXEC SQLCHECK('FBTTGUNNAEXNPSE');


-- -----------------------------------------------------------------------------
-- PERGUNTA 15
-- Código SQLCheck: FBURSNZOQWVBQRL
-- Enunciado: Seleccione o título e o número de páginas dos livros de Drama com 
--            mais de 100 páginas. Mostra também o preço por página (arredondado 
--            aos centimos). Ordene pelo número de páginas.
-- -----------------------------------------------------------------------------
SELECT titulo, 
       paginas AS "Num de Paginas", 
       ROUND(preco_tabela / paginas, 2) AS "Preco por página" 
FROM Livros 
WHERE genero = 'Drama' 
  AND paginas > 100 
ORDER BY paginas ASC;

EXEC SQLCHECK('FBURSNZOQWVBQRL');


-- -----------------------------------------------------------------------------
-- PERGUNTA 16
-- Código SQLCheck: FBOKXKTPNELURXN
-- Enunciado: Assumindo que os livros Policiais estiveram à venda em 900 lojas, 
--            mostre o código, o título, o preço de tabela e o número médio 
--            (arredondado às unidades) de livros vendidos por loja 
--            (considere o atributo unidades vendidas). Ordene pelo titulo.
-- -----------------------------------------------------------------------------
SELECT codigo_livro, 
       titulo, 
       preco_tabela, 
       ROUND(unidades_vendidas / 900, 0) AS "Media por loja" 
FROM Livros 
WHERE genero = 'Policial' 
ORDER BY titulo ASC;

EXEC SQLCHECK('FBOKXKTPNELURXN');


-- -----------------------------------------------------------------------------
-- PERGUNTA 17
-- Código SQLCheck: FBMNQJEQKIBUSVO
-- Enunciado (Moodle): Para os livros de Informática com preço tabela superior a 40 euros...
-- NOTA: O enunciado dizia Informática por engano no Moodle, mas o SQLCheck valida
-- com genero = 'Aventura' e preco_tabela > 40.
-- -----------------------------------------------------------------------------
SELECT 'O livro "' || titulo || '" com ' || paginas || ' paginas, foi escrito pelo autor com o codigo ' || codigo_autor AS "Listagem paginas dos Livros" 
FROM Livros 
WHERE genero = 'Aventura' 
  AND preco_tabela > 40
ORDER BY titulo ASC;

EXEC SQLCHECK('FBMNQJEQKIBUSVO');
