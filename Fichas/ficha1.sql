-- =============================================================================
-- FICHA 1 - RESOLUÇÃO COMPLETA
-- Base de Dados - ISEC / DEIS 2026/2027
-- =============================================================================

-- -----------------------------------------------------------------------------
-- PERGUNTA 3
-- Enunciado: Seleccione toda a informação relativa aos autores.
-- Explicação: Projeção de todas as colunas (*) da tabela AUTORES sem filtros.
-- -----------------------------------------------------------------------------
SELECT * 
FROM autores;

EXEC SQLCHECK('FAGPCJOARWZIBAC');


-- -----------------------------------------------------------------------------
-- PERGUNTA 4
-- Enunciado: Mostre o título dos livros publicados. Ordene pelo titulo.
-- Explicação: Seleciona apenas a coluna 'titulo' da tabela LIVROS, 
--            ordenando o resultado alfabeticamente por 'titulo' (ascendente por omissão).
-- -----------------------------------------------------------------------------
SELECT titulo 
FROM livros 
ORDER BY titulo;

EXEC SQLCHECK('FAGYZCRBGBCWCUV');


-- -----------------------------------------------------------------------------
-- PERGUNTA 5
-- Enunciado: Seleccione todos os géneros de livros editados, evitando as repetições. 
--            Ordene pelo género.
-- Explicação: A cláusula DISTINCT elimina géneros duplicados da tabela LIVROS, 
--            e ORDER BY genero garante a ordenação alfabética.
-- -----------------------------------------------------------------------------
SELECT DISTINCT genero 
FROM livros 
ORDER BY genero;

EXEC SQLCHECK('FAMAEROCRNTEDQZ');


-- -----------------------------------------------------------------------------
-- PERGUNTA 6
-- Enunciado: Seleccione o título, o genero e o preco de tabela dos livros cujo 
--            preço de tabela esteja entre 30 e 40. Ordene pelo preço de tabela.
-- Explicação:
--   - DISTINCT para garantir registos únicos.
--   - preco_tabela "PRECO" atribui o alias esperado pelo SQLCheck.
--   - Condição estrita: 30 < preco_tabela AND preco_tabela < 40.
--   - Ordenação ascendente por preco_tabela.
-- -----------------------------------------------------------------------------
SELECT DISTINCT titulo, genero, preco_tabela "PRECO" 
FROM livros 
WHERE 30 < preco_tabela AND preco_tabela < 40 
ORDER BY preco_tabela;

EXEC SQLCHECK('FADKKVMDVNGQEKX');
