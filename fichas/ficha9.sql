-- =============================================================================
-- FICHA 9 - RESOLUÇÃO PREPARADA
-- Base de Dados - ISEC / DEIS 2026/2027
-- Foco: DDL (CREATE TABLE, ALTER TABLE, CONSTRAINTS) e DML (INSERT, UPDATE, DELETE)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- EXERCÍCIO 3
-- SQLCheck base: FIMKDSHCMXEHLZV
-- Descrição: Criação da tabela AUTORES_BACKUP com constraints (PK, UK, CK)
-- -----------------------------------------------------------------------------
CREATE TABLE AUTORES_BACKUP (
    Codigo_Autor     NUMBER(6),
    Nome             VARCHAR2(100) NOT NULL,
    N_Contribuinte   NUMBER(9),
    Morada           VARCHAR2(100),
    Data_Nascimento  DATE,
    Genero_Preferido VARCHAR2(40),
    Nacionalidade    VARCHAR2(60),
    
    CONSTRAINT AUTORESBKP_CODAUTOR_PK PRIMARY KEY (Codigo_Autor),
    CONSTRAINT AUTORESBKP_UK UNIQUE (N_Contribuinte),
    CONSTRAINT AUTORESBKP_NOME_CK CHECK (Nome = UPPER(Nome)),
    CONSTRAINT AUTORESBKP_GENEROPREF_CK CHECK (Genero_Preferido = UPPER(Genero_Preferido)),
    CONSTRAINT AUTORESBKP_NIF_CK CHECK (N_Contribuinte BETWEEN 100000000 AND 999999999)
);

EXEC SQLCHECK('FIMKDSHCMXEHLZV');


-- -----------------------------------------------------------------------------
-- EXERCÍCIO 4
-- SQLCheck base: FIHOBDADOXWUMIK
-- Descrição: Criação da tabela AVALIACOES com chaves estrangeiras e restrição de nota 1 a 5
-- -----------------------------------------------------------------------------
CREATE TABLE AVALIACOES (
    Codigo_Livro NUMBER(4),
    Codigo_Cliente NUMBER(4),
    Nota NUMBER(1) NOT NULL,
    
    CONSTRAINT AVALIACOES_PK PRIMARY KEY (Codigo_Livro, Codigo_Cliente),
    CONSTRAINT AVALIACOES_CODLIVRO_FK FOREIGN KEY (Codigo_Livro) REFERENCES LIVROS (Codigo_Livro),
    CONSTRAINT AVALIACOES_CODCLIENTE_FK FOREIGN KEY (Codigo_Cliente) REFERENCES CLIENTES (Codigo_Cliente),
    CONSTRAINT AVALIACOES_NOTA_CK CHECK (Nota BETWEEN 1 AND 5)
);

EXEC SQLCHECK('FIHOBDADOXWUMIK');


-- -----------------------------------------------------------------------------
-- EXERCÍCIO 5
-- SQLCheck base: FIVSWIFEZBRHNWH
-- Descrição: Criação de LIVROS_BACKUP a partir de LIVROS com Genero em maiúsculas
-- -----------------------------------------------------------------------------
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
-- EXERCÍCIO 6
-- SQLCheck base: FIWDSAAFTURTOBD
-- Descrição: Adicionar constraints (PK e FKs) à tabela LIVROS_BACKUP
-- -----------------------------------------------------------------------------
ALTER TABLE LIVROS_BACKUP ADD (
    CONSTRAINT LIVROSBKP_CODLIVRO_PK PRIMARY KEY (Codigo_Livro),
    CONSTRAINT LIVROSBKP_CODAUTOR_FK FOREIGN KEY (Codigo_Autor) REFERENCES AUTORES (Codigo_Autor),
    CONSTRAINT LIVROSBKP_CODEDITORA_FK FOREIGN KEY (Codigo_Editora) REFERENCES EDITORAS (Codigo_Editora)
);

EXEC SQLCHECK('FIWDSAAFTURTOBD');


-- -----------------------------------------------------------------------------
-- EXERCÍCIO 7
-- SQLCheck base: FIWPQNDGVXWHPYW
-- Descrição: Inserir novo livro com subconsultas para editora 'Leya' e autor 'Ricardo Martins'
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
    'INFORMATICA',
    24,
    430,
    0,
    (SELECT Codigo_Editora FROM EDITORAS WHERE Nome = 'Leya'),
    (SELECT Codigo_Autor FROM AUTORES WHERE Nome = 'Ricardo Martins'),
    SYSDATE
);

EXEC SQLCHECK('FIWPQNDGVXWHPYW');


-- -----------------------------------------------------------------------------
-- EXERCÍCIO 8
-- SQLCheck base: FIOPTRMHMAGJQPD
-- Descrição: Inserir autor na tabela AUTORES_BACKUP
-- -----------------------------------------------------------------------------
INSERT INTO AUTORES_BACKUP (
    Codigo_Autor,
    Nome,
    N_Contribuinte
)
VALUES (
    95,
    'JOSÉ DE MAGALHÃES',
    776655441
);

EXEC SQLCHECK('FIOPTRMHMAGJQPD');


-- -----------------------------------------------------------------------------
-- EXERCÍCIO 9
-- SQLCheck base: FIIRJOPIQBAQRWZ
-- Descrição: Eliminar livro inserido (código 501)
-- -----------------------------------------------------------------------------
DELETE FROM LIVROS_BACKUP
WHERE Codigo_Livro = 501;

EXEC SQLCHECK('FIIRJOPIQBAQRWZ');


-- -----------------------------------------------------------------------------
-- EXERCÍCIO 10
-- SQLCheck base: FICPRRCJEXZNSQR
-- Descrição: Aumentar preço em 10% para livros de 'AVENTURA'
-- -----------------------------------------------------------------------------
UPDATE LIVROS_BACKUP
SET Preco_Tabela = Preco_Tabela * 1.10
WHERE Genero = 'AVENTURA';

EXEC SQLCHECK('FICPRRCJEXZNSQR');


-- -----------------------------------------------------------------------------
-- EXERCÍCIO 11
-- SQLCheck base: FIEODNHKMSMNTLU
-- Descrição: Apagar livros de 'INFORMÁTICA' abaixo da média de preço desse género
-- -----------------------------------------------------------------------------
DELETE FROM LIVROS_BACKUP
WHERE Genero = 'INFORMÁTICA' 
  AND Preco_Tabela < (
      SELECT AVG(Preco_Tabela)
      FROM LIVROS_BACKUP
      WHERE Genero = 'INFORMÁTICA'
  );

EXEC SQLCHECK('FIEODNHKMSMNTLU');


-- -----------------------------------------------------------------------------
-- EXERCÍCIO 12
-- SQLCheck base: FIOEYCKLDAOZUDH
-- Descrição: Adicionar coluna NLivros (DEFAULT 0 NOT NULL, CHECK entre 0 e 150)
-- -----------------------------------------------------------------------------
ALTER TABLE AUTORES_BACKUP ADD (
    NLivros NUMBER DEFAULT 0 NOT NULL,
    CONSTRAINT AUTORESBKP_NLIVROS_CK CHECK (NLivros BETWEEN 0 AND 150)
);

EXEC SQLCHECK('FIOEYCKLDAOZUDH');


-- -----------------------------------------------------------------------------
-- EXERCÍCIO 13
-- SQLCheck base: FIHNAYIMPMXLVXM
-- Descrição: Atualizar NLivros com a contagem de livros de cada autor
-- -----------------------------------------------------------------------------
UPDATE AUTORES_BACKUP AUB
SET AUB.NLIVROS = (
    SELECT COUNT(LB.Codigo_Livro)
    FROM LIVROS_BACKUP LB
    WHERE LB.Codigo_Autor = AUB.Codigo_Autor
);

EXEC SQLCHECK('FIHNAYIMPMXLVXM');


-- -----------------------------------------------------------------------------
-- EXERCÍCIO 14
-- SQLCheck base: FIFXMNVNPKRRWSE
-- Descrição: Atualizar genero_preferido para o género do livro mais recente editado
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
);

EXEC SQLCHECK('FIFXMNVNPKRRWSE');


-- -----------------------------------------------------------------------------
-- EXERCÍCIO 15
-- SQLCheck base: FICEENQOVBIP@YP
-- Descrição: Criar cópia completa de EDITORAS
-- -----------------------------------------------------------------------------
CREATE TABLE EDITORAS_BACKUP AS
SELECT *
FROM EDITORAS;

EXEC SQLCHECK('FICEENQOVBIP@YP');


-- -----------------------------------------------------------------------------
-- EXERCÍCIO 16
-- SQLCheck base: FINGKRDPDFLJAHJ
-- Descrição: Eliminar tabela EDITORAS_BACKUP com cascade constraints
-- -----------------------------------------------------------------------------
DROP TABLE EDITORAS_BACKUP CASCADE CONSTRAINTS;

EXEC SQLCHECK('FINGKRDPDFLJAHJ');


-- -----------------------------------------------------------------------------
-- EXERCÍCIO 17
-- SQLCheck base: FIUGYBDQVYSOBWK
-- Descrição: Atualizar unidades_vendidas em LIVROS_BACKUP a partir da tabela CONTEM
-- -----------------------------------------------------------------------------
UPDATE LIVROS_BACKUP LB
SET LB.UNIDADES_VENDIDAS = (
    SELECT NVL(SUM(C.Quantidade), 0)
    FROM CONTEM C
    WHERE C.Codigo_Livro = LB.Codigo_Livro
);

EXEC SQLCHECK('FIUGYBDQVYSOBWK');


-- -----------------------------------------------------------------------------
-- EXERCÍCIO 18
-- SQLCheck base: FIESCYJRNGNLCRF
-- Descrição: Criar cópia de VENDAS
-- -----------------------------------------------------------------------------
CREATE TABLE VENDAS_BACKUP AS
SELECT *
FROM VENDAS;

EXEC SQLCHECK('FIESCYJRNGNLCRF');


-- -----------------------------------------------------------------------------
-- EXERCÍCIO 19
-- SQLCheck base: FIJSWHKSFPRCDYL
-- Descrição: Atualizar total_venda em VENDAS_BACKUP a partir de CONTEM
-- -----------------------------------------------------------------------------
UPDATE VENDAS_BACKUP VB
SET VB.TOTAL_VENDA = (
    SELECT NVL(SUM(C.QUANTIDADE * C.PRECO_UNITARIO), 0)
    FROM CONTEM C
    WHERE C.Codigo_Venda = VB.Codigo_Venda
);

EXEC SQLCHECK('FIJSWHKSFPRCDYL');


-- -----------------------------------------------------------------------------
-- EXERCÍCIO 20
-- SQLCheck base: FIYMCRPTHXYNEEN
-- Descrição: Criar cópia de ENCOMENDAS
-- -----------------------------------------------------------------------------
CREATE TABLE ENCOMENDAS_BACKUP AS
SELECT *
FROM ENCOMENDAS;

EXEC SQLCHECK('FIYMCRPTHXYNEEN');


-- -----------------------------------------------------------------------------
-- EXERCÍCIO 21
-- SQLCheck base: FINTXRSCOGLNLJK
-- Descrição: Apagar encomendas de setembro do ano corrente
-- -----------------------------------------------------------------------------
DELETE FROM ENCOMENDAS_BACKUP
WHERE TO_CHAR(Data_Encomenda, 'MM-YYYY') = '09-' || TO_CHAR(SYSDATE, 'YYYY');

EXEC SQLCHECK('FINTXRSCOGLNLJK');


-- -----------------------------------------------------------------------------
-- EXERCÍCIO 22
-- SQLCheck base: FIPOSAZDDWTYMQS
-- Descrição: Apagar encomendas do livro mais caro do autor 'Bernardo Matos'
-- -----------------------------------------------------------------------------
DELETE FROM ENCOMENDAS_BACKUP
WHERE Codigo_Livro IN (
    SELECT Codigo_Livro
    FROM LIVROS_BACKUP LB
    WHERE LB.Codigo_Autor = (SELECT Codigo_Autor FROM AUTORES_BACKUP WHERE Nome = 'Bernardo Matos') 
      AND LB.PRECO_TABELA = (
          SELECT MAX(PRECO_TABELA)
          FROM LIVROS_BACKUP
          WHERE Codigo_Autor = (SELECT Codigo_Autor FROM AUTORES_BACKUP WHERE Nome = 'Bernardo Matos')
      )
);

EXEC SQLCHECK('FIPOSAZDDWTYMQS');
