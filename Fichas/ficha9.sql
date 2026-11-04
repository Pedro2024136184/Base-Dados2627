-- =============================================================================
-- FICHA 9 - RESOLUÇÃO COMPLETA E VALIDADA
-- Base de Dados - ISEC / DEIS 2026/2027
-- Foco: DDL (CREATE TABLE, ALTER TABLE, CONSTRAINTS) e DML (INSERT, UPDATE, DELETE)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- EXERCÍCIO 3 (Pergunta 3)
-- Código: FIMKDSHCMXEHLZV
-- Enunciado: Crie a tabela AUTORES_BACKUP, análoga à tabela AUTORES contendo
-- as seguintes restrições: O nome e o genero preferido devem ser em maiúsculas;
-- e o n_contribuinte tem que ter 9 dígitos.
-- -----------------------------------------------------------------------------
DROP TABLE AUTORES_BACKUP CASCADE CONSTRAINTS;

CREATE TABLE AUTORES_BACKUP (
    Codigo_Autor     NUMBER(6),
    Nome             VARCHAR2(100) NOT NULL,
    N_Contribuinte   NUMBER(9),
    Morada           VARCHAR2(100),
    Data_Nascimento  DATE,
    Genero_Preferido VARCHAR2(40),
    Nacionalidade    VARCHAR2(60),
    
    CONSTRAINT PK_AUTORES_BACKUP PRIMARY KEY (Codigo_Autor),
    CONSTRAINT CK_AUTORESBKP_NOME CHECK (Nome = UPPER(Nome)),
    CONSTRAINT CK_AUTORESBKP_GEN CHECK (Genero_Preferido = UPPER(Genero_Preferido)),
    CONSTRAINT CK_AUTORESBKP_NIF CHECK (N_Contribuinte BETWEEN 100000000 AND 999999999)
);

EXEC SQLCHECK('FIMKDSHCMXEHLZV');


-- -----------------------------------------------------------------------------
-- EXERCÍCIO 4 (Pergunta 4)
-- Código: FIHOBDADOXWUMIK
-- Enunciado: Pretende-se que passe a ser possível aos clientes da livraria
-- avaliarem os livros que esta disponibiliza. A avaliação consistirá na atribuição
-- de um número de estrelas compreendido entre 1 e 5. Crie a nova tabela AVALIACOES.
-- -----------------------------------------------------------------------------
DROP TABLE AVALIACOES CASCADE CONSTRAINTS;

CREATE TABLE AVALIACOES (
    Codigo_Livro   NUMBER(9) NOT NULL,
    Codigo_Cliente NUMBER(6) NOT NULL,
    Nota           NUMBER(1) NOT NULL,
    
    CONSTRAINT PK_AVALIACOES PRIMARY KEY (Codigo_Livro, Codigo_Cliente),
    CONSTRAINT FK_AVALIACOES_LIVROS FOREIGN KEY (Codigo_Livro) REFERENCES LIVROS (Codigo_Livro),
    CONSTRAINT FK_AVALIACOES_CLIENTES FOREIGN KEY (Codigo_Cliente) REFERENCES CLIENTES (Codigo_Cliente),
    CONSTRAINT CK_AVALIACOES_NOTA CHECK (Nota BETWEEN 1 AND 5)
);

EXEC SQLCHECK('FIHOBDADOXWUMIK');


-- -----------------------------------------------------------------------------
-- EXERCÍCIO 5 (Pergunta 5)
-- Código: FIVSWIFEZBRHNWH
-- Enunciado: Faça uma cópia da tabela LIVROS para uma nova tabela LIVROS_BACKUP.
-- Use o comando CREATE TABLE com subconsulta. Na cópia de valores transforme os
-- géneros dos livros para maiúsculas.
-- -----------------------------------------------------------------------------
DROP TABLE LIVROS_BACKUP CASCADE CONSTRAINTS;

CREATE TABLE LIVROS_BACKUP AS
SELECT
    Codigo_Livro,
    Titulo,
    ISBN,
    UPPER(Genero) AS Genero,
    Preco_Tabela,
    Paginas,
    Unidades_Vendidas,
    Codigo_Editora,
    Codigo_Autor,
    Data_Edicao
FROM LIVROS;

EXEC SQLCHECK('FIVSWIFEZBRHNWH');


-- -----------------------------------------------------------------------------
-- EXERCÍCIO 6 (Pergunta 6)
-- Código: FIWDSAAFTURTOBD
-- Enunciado: Como ao criar a nova tabela LIVROS_BACKUP as restrições não são
-- copiadas, altere a tabela de modo a incluir as restrições que existiam na
-- tabela LIVROS original. Use o comando ALTER TABLE.
-- -----------------------------------------------------------------------------
ALTER TABLE LIVROS_BACKUP ADD (
    CONSTRAINT PK_LIVROS_BACKUP PRIMARY KEY (Codigo_Livro),
    CONSTRAINT FK_LIVROSBKP_AUTORES FOREIGN KEY (Codigo_Autor) REFERENCES AUTORES (Codigo_Autor),
    CONSTRAINT FK_LIVROSBKP_EDITORAS FOREIGN KEY (Codigo_Editora) REFERENCES EDITORAS (Codigo_Editora)
);

EXEC SQLCHECK('FIWDSAAFTURTOBD');


-- -----------------------------------------------------------------------------
-- EXERCÍCIO 7 (Pergunta 7)
-- Código: FIWPQNDGVXWHPYW
-- Enunciado: Insira, na tabela LIVROS_BACKUP, o novo livro do Ricardo Martins,
-- cujo título é ‘Informática para todos’ e que foi editado hoje pela editora Leya.
-- O livro custa 24€ e tem 430 páginas, ISBN 132434 e código 501.
-- -----------------------------------------------------------------------------
INSERT INTO LIVROS_BACKUP (
    Codigo_Livro,
    Titulo,
    ISBN,
    Genero,
    Preco_Tabela,
    Paginas,
    Unidades_Vendidas,
    Codigo_Editora,
    Codigo_Autor,
    Data_Edicao
)
VALUES (
    501,
    'Informática para todos',
    '132434',
    'INFORMÁTICA',
    24,
    430,
    0,
    (SELECT Codigo_Editora FROM EDITORAS WHERE UPPER(Nome) = 'LEYA'),
    (SELECT Codigo_Autor FROM AUTORES WHERE UPPER(Nome) LIKE 'RICARDO MARTIN%'),
    SYSDATE
);
COMMIT;

EXEC SQLCHECK('FIWPQNDGVXWHPYW');


-- -----------------------------------------------------------------------------
-- EXERCÍCIO 8 (Pergunta 8)
-- Código: FIOPTRMHMAGJQPD
-- Enunciado: Insira na tabela AUTORES_BACKUP um novo autor ‘José de Magalhães’
-- com o código 95 e contribuinte 776655441.
-- -----------------------------------------------------------------------------
INSERT INTO AUTORES_BACKUP (
    Codigo_Autor,
    Nome,
    N_Contribuinte
)
VALUES (
    95,
    UPPER('José de Magalhães'),
    776655441
);
COMMIT;

EXEC SQLCHECK('FIOPTRMHMAGJQPD');


-- -----------------------------------------------------------------------------
-- EXERCÍCIO 9 (Pergunta 9)
-- Código: FIIRJOPIQBAQRWZ
-- Enunciado: Apague, da tabela LIVROS_BACKUP, o livro de código 501.
-- -----------------------------------------------------------------------------
DELETE FROM LIVROS_BACKUP
WHERE Codigo_Livro = 501;
COMMIT;

EXEC SQLCHECK('FIIRJOPIQBAQRWZ');


-- -----------------------------------------------------------------------------
-- EXERCÍCIO 10 (Pergunta 10)
-- Código: FICPRRCJEXZNSQR
-- Enunciado: Actualize, na tabela LIVROS_BACKUP, os preços dos livros de aventuras
-- de modo a que estes sofram um aumento em 10%.
-- -----------------------------------------------------------------------------
UPDATE LIVROS_BACKUP
SET Preco_Tabela = Preco_Tabela * 1.10
WHERE UPPER(Genero) = 'AVENTURA';
COMMIT;

EXEC SQLCHECK('FICPRRCJEXZNSQR');


-- -----------------------------------------------------------------------------
-- EXERCÍCIO 11 (Pergunta 11)
-- Código: FIEODNHKMSMNTLU
-- Enunciado: Apague da tabela LIVROS_BACKUP, os livros de informática que têm um
-- preço inferior à média dos preços de informática.
-- -----------------------------------------------------------------------------
DELETE FROM LIVROS_BACKUP
WHERE UPPER(Genero) = 'INFORMÁTICA'
  AND Preco_Tabela < (
      SELECT AVG(Preco_Tabela)
      FROM LIVROS_BACKUP
      WHERE UPPER(Genero) = 'INFORMÁTICA'
  );
COMMIT;

EXEC SQLCHECK('FIEODNHKMSMNTLU');


-- -----------------------------------------------------------------------------
-- EXERCÍCIO 12 (Pergunta 12)
-- Código: FIOEYCKLDAOZUDH
-- Enunciado: Adicione à tabela AUTORES_BACKUP a coluna NLIVROS do tipo NUMBER
-- (obrigatória, valor por defeito 0, apenas valores entre 0 e 150).
-- -----------------------------------------------------------------------------
ALTER TABLE AUTORES_BACKUP ADD (
    NLivros NUMBER DEFAULT 0 NOT NULL,
    CONSTRAINT CK_AUTORESBKP_NLIVROS CHECK (NLivros BETWEEN 0 AND 150)
);

EXEC SQLCHECK('FIOEYCKLDAOZUDH');


-- -----------------------------------------------------------------------------
-- EXERCÍCIO 13 (Pergunta 13)
-- Código: FIHNAYIMPMXLVXM
-- Enunciado: Actualize o campo NLIVROS adicionado no ponto anterior, com a
-- informação do número de livros que cada autor escreveu.
-- -----------------------------------------------------------------------------
UPDATE AUTORES_BACKUP AUB
SET AUB.NLIVROS = (
    SELECT COUNT(LB.Codigo_Livro)
    FROM LIVROS_BACKUP LB
    WHERE LB.Codigo_Autor = AUB.Codigo_Autor
);
COMMIT;

EXEC SQLCHECK('FIHNAYIMPMXLVXM');


-- -----------------------------------------------------------------------------
-- EXERCÍCIO 14 (Pergunta 14)
-- Código: FIFXMNVNPKRRWSE
-- Enunciado: Actualize o campo GENERO_PREFERIDO da tabela AUTORES_BACKUP de modo
-- a referir-se ao género do último livro que o autor escreveu.
-- -----------------------------------------------------------------------------
UPDATE AUTORES_BACKUP AUB
SET AUB.GENERO_PREFERIDO = (
    SELECT Genero
    FROM LIVROS_BACKUP LB
    WHERE LB.Codigo_Autor = AUB.Codigo_Autor 
      AND LB.Data_Edicao = (
          SELECT MAX(Data_Edicao)
          FROM LIVROS_BACKUP
          WHERE Codigo_Autor = AUB.Codigo_Autor
      ) 
      AND ROWNUM = 1
)
WHERE EXISTS (
    SELECT 1
    FROM LIVROS_BACKUP LB2
    WHERE LB2.Codigo_Autor = AUB.Codigo_Autor
);
COMMIT;

EXEC SQLCHECK('FIFXMNVNPKRRWSE');


-- -----------------------------------------------------------------------------
-- EXERCÍCIO 15 (Pergunta 15)
-- Código: FICEENQOVBIP@YP
-- Enunciado: Crie uma réplica da tabela EDITORAS, usando o comando CREATE TABLE
-- com subconsulta, chamando à nova tabela EDITORAS_BACKUP.
-- -----------------------------------------------------------------------------
DROP TABLE EDITORAS_BACKUP CASCADE CONSTRAINTS;

CREATE TABLE EDITORAS_BACKUP AS
SELECT *
FROM EDITORAS;

EXEC SQLCHECK('FICEENQOVBIP@YP');


-- -----------------------------------------------------------------------------
-- EXERCÍCIO 16 (Pergunta 16)
-- Código: FINGKRDPDFLJAHJ
-- Enunciado: Apague da base de dados a tabela EDITORAS_BACKUP.
-- -----------------------------------------------------------------------------
DROP TABLE EDITORAS_BACKUP CASCADE CONSTRAINTS;

EXEC SQLCHECK('FINGKRDPDFLJAHJ');


-- -----------------------------------------------------------------------------
-- EXERCÍCIO 17 (Pergunta 17)
-- Código: FIUGYBDQVYSOBWK
-- Enunciado: Actualize o atributo UNIDADES_VENDIDAS da tabela de LIVROS_BACKUP
-- com a informação referente às vendas registadas pela livraria.
-- -----------------------------------------------------------------------------
UPDATE LIVROS_BACKUP LB
SET LB.UNIDADES_VENDIDAS = (
    SELECT NVL(SUM(C.Quantidade), 0)
    FROM CONTEM C
    WHERE C.Codigo_Livro = LB.Codigo_Livro
);
COMMIT;

EXEC SQLCHECK('FIUGYBDQVYSOBWK');


-- -----------------------------------------------------------------------------
-- EXERCÍCIO 18 (Pergunta 18)
-- Código: FIESCYJRNGNLCRF
-- Enunciado: Crie a tabela VENDAS_BACKUP, réplica da tabela VENDAS. Use o
-- comando CREATE TABLE com subconsulta.
-- -----------------------------------------------------------------------------
DROP TABLE VENDAS_BACKUP CASCADE CONSTRAINTS;

CREATE TABLE VENDAS_BACKUP AS
SELECT *
FROM VENDAS;

EXEC SQLCHECK('FIESCYJRNGNLCRF');


-- -----------------------------------------------------------------------------
-- EXERCÍCIO 19 (Pergunta 19)
-- Código: FIJSWHKSFPRCDYL
-- Enunciado: Actualize o atributo TOTAL_VENDA da tabela VENDAS_BACKUP com a
-- informação referente ao produto da quantidade pelo preço unitário de venda.
-- -----------------------------------------------------------------------------
UPDATE VENDAS_BACKUP VB
SET VB.TOTAL_VENDA = (
    SELECT NVL(SUM(C.QUANTIDADE * C.PRECO_UNITARIO), 0)
    FROM CONTEM C
    WHERE C.Codigo_Venda = VB.Codigo_Venda
);
COMMIT;

EXEC SQLCHECK('FIJSWHKSFPRCDYL');


-- -----------------------------------------------------------------------------
-- EXERCÍCIO 20 (Pergunta 20)
-- Código: FIYMCRPTHXYNEEN
-- Enunciado: Crie a tabela ENCOMENDAS_BACKUP, réplica da tabela ENCOMENDAS.
-- Use o comando CREATE TABLE com subconsulta.
-- -----------------------------------------------------------------------------
DROP TABLE ENCOMENDAS_BACKUP CASCADE CONSTRAINTS;

CREATE TABLE ENCOMENDAS_BACKUP AS
SELECT *
FROM ENCOMENDAS;

EXEC SQLCHECK('FIYMCRPTHXYNEEN');


-- -----------------------------------------------------------------------------
-- EXERCÍCIO 21 (Pergunta 21)
-- Código: FINTXRSCOGLNLJK
-- Enunciado: Remova, da tabela ENCOMENDAS_BACKUP, todas as encomendas efectuadas
-- no mês de Setembro deste ano.
-- -----------------------------------------------------------------------------
DELETE FROM ENCOMENDAS_BACKUP
WHERE TO_CHAR(Data_Encomenda, 'MM-YYYY') = '09-' || TO_CHAR(SYSDATE, 'YYYY');
COMMIT;

EXEC SQLCHECK('FINTXRSCOGLNLJK');


-- -----------------------------------------------------------------------------
-- EXERCÍCIO 22 (Pergunta 22)
-- Código: FIPOSAZDDWTYMQS
-- Enunciado: Remova, da tabela ENCOMENDAS_BACKUP, todas as encomendas referentes
-- ao livro mais caro (PRECO_TABELA) do autor Bernardo Matos.
-- -----------------------------------------------------------------------------
DELETE FROM ENCOMENDAS_BACKUP
WHERE Codigo_Livro IN (
    SELECT l.Codigo_Livro
    FROM LIVROS_BACKUP l, AUTORES a
    WHERE l.Codigo_Autor = a.Codigo_Autor
      AND UPPER(a.Nome) = 'BERNARDO MATOS' 
      AND l.Preco_Tabela = (
          SELECT MAX(l2.Preco_Tabela)
          FROM LIVROS_BACKUP l2, AUTORES a2
          WHERE l2.Codigo_Autor = a2.Codigo_Autor
            AND UPPER(a2.Nome) = 'BERNARDO MATOS'
      )
);
COMMIT;

EXEC SQLCHECK('FIPOSAZDDWTYMQS');
