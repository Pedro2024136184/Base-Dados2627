-- =============================================================================
-- FICHA 1 - RESOLUÇÃO COMPLETA E VALIDADA (SQLCHECK)
-- Base de Dados - ISEC / DEIS 2026/2027
-- =============================================================================

-- -----------------------------------------------------------------------------
-- PERGUNTA 3
-- Código SQLCheck: FAGPCJOARWZIBAC
-- Enunciado: Seleccione toda a informação relativa aos autores.
-- Explicação: Basta um SELECT * da tabela AUTORES sem filtros.
-- -----------------------------------------------------------------------------
SELECT * 
FROM autores;

EXEC SQLCHECK('FAGPCJOARWZIBAC');


-- -----------------------------------------------------------------------------
-- PERGUNTA 4
-- Código SQLCheck: FAGYZCRBGBCWCUV
-- Enunciado: Mostre o título dos livros publicados. Ordene pelo titulo.
-- Explicação: Projeção do atributo 'titulo' da tabela LIVROS, ordenado por 'titulo'.
-- -----------------------------------------------------------------------------
SELECT titulo 
FROM livros 
ORDER BY titulo;

EXEC SQLCHECK('FAGYZCRBGBCWCUV');


-- -----------------------------------------------------------------------------
-- PERGUNTA 5
-- Código SQLCheck: FAMAEROCRNTEDQZ
-- Enunciado: Seleccione todos os géneros de livros editados, evitando as 
--            repetições. Ordene pelo género.
-- Output esperado: 1 coluna (GENERO) com 8 linhas distintas:
--                  Aventura, Comédia, Drama, Fição, Informática, Policial, Romance, Thriller.
--
-- NOTA IMPORTANTE SOBRE O ERRO "Esperadas 1 colunas, retornadas 3":
-- O SQLCheck valida a ÚLTIMA query executada na sessão. Se executares a query do ex 6
-- (que tem 3 colunas) e logo a seguir o SQLCheck do ex 5, dá este erro. 
-- Para passar: seleciona e executa APENAS este SELECT antes do EXEC SQLCHECK.
-- -----------------------------------------------------------------------------
SELECT DISTINCT genero 
FROM livros 
ORDER BY genero;

EXEC SQLCHECK('FAMAEROCRNTEDQZ');


-- -----------------------------------------------------------------------------
-- PERGUNTA 6
-- Código SQLCheck: FADKKVMDVNGQEKX
-- Enunciado: Seleccione o título, o genero e o preco de tabela dos livros cujo 
--            preço de tabela esteja entre 30 e 40. Ordene pelo preço de tabela.
--
-- Output esperado: 3 colunas: TITULO, GENERO, PRECO (68 linhas)
--
-- CORREÇÕES EM RELAÇÃO AO FICHA1.TXT ANTERIOR:
-- 1. Aliases explícitos: TITULO, GENERO, PRECO (em maiúsculas).
-- 2. Condição de preço: Preco_Tabela >= 30 AND Preco_Tabela < 40 
--    (ou Preco_Tabela > 30 AND Preco_Tabela < 40).
-- 3. Critério de desempate na ordenação: ORDER BY Preco_Tabela, Titulo
--    (essencial para o SQLCheck não falhar em livros com o mesmo preço).
-- -----------------------------------------------------------------------------
SELECT Titulo       AS TITULO,
       Genero       AS GENERO,
       Preco_Tabela AS PRECO
FROM livros
WHERE Preco_Tabela >= 30
  AND Preco_Tabela < 40
ORDER BY Preco_Tabela, Titulo;

EXEC SQLCHECK('FADKKVMDVNGQEKX');
