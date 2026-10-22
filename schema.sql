-- =============================================================================
-- ESQUEMA DA BASE DE DADOS - LIVRARIA (ISEC DEIS 2026/2027)
-- Ficheiro gerado a partir de: 202626_BD_P00_Tabela_v1.pdf
-- Dialeto: Oracle SQL (Varchar2, Number, Date)
-- =============================================================================

-- Eliminação prévia das tabelas (caso existam)
DROP TABLE TRANSFERENCIAS CASCADE CONSTRAINTS;
DROP TABLE ENCOMENDAS CASCADE CONSTRAINTS;
DROP TABLE EXISTE CASCADE CONSTRAINTS;
DROP TABLE CONTEM CASCADE CONSTRAINTS;
DROP TABLE VENDAS CASCADE CONSTRAINTS;
DROP TABLE LIVROS CASCADE CONSTRAINTS;
DROP TABLE LOJAS CASCADE CONSTRAINTS;
DROP TABLE CLIENTES CASCADE CONSTRAINTS;
DROP TABLE EDITORAS CASCADE CONSTRAINTS;
DROP TABLE AUTORES CASCADE CONSTRAINTS;

-- -----------------------------------------------------------------------------
-- 1. AUTORES
-- -----------------------------------------------------------------------------
CREATE TABLE AUTORES (
    Codigo_Autor        NUMBER(6)       NOT NULL,
    Nome                VARCHAR2(100)   NOT NULL,
    N_Contribuinte      NUMBER(9),
    Morada              VARCHAR2(100),
    Data_Nascimento     DATE,
    Genero_Preferido    VARCHAR2(40),
    Nacionalidade       VARCHAR2(60),
    CONSTRAINT PK_AUTORES PRIMARY KEY (Codigo_Autor)
);

-- -----------------------------------------------------------------------------
-- 2. EDITORAS
-- -----------------------------------------------------------------------------
CREATE TABLE EDITORAS (
    Codigo_Editora      NUMBER(6)       NOT NULL,
    Nome                VARCHAR2(100)   NOT NULL,
    N_Contribuinte      NUMBER(9),
    Morada              VARCHAR2(100),
    Telefone            VARCHAR2(20),
    Email               VARCHAR2(80),
    CONSTRAINT PK_EDITORAS PRIMARY KEY (Codigo_Editora)
);

-- -----------------------------------------------------------------------------
-- 3. CLIENTES
-- -----------------------------------------------------------------------------
CREATE TABLE CLIENTES (
    Codigo_Cliente      NUMBER(6)       NOT NULL,
    Nome                VARCHAR2(100)   NOT NULL,
    N_Contribuinte      NUMBER(9),
    Morada              VARCHAR2(100),
    Telefone            VARCHAR2(20),
    Email               VARCHAR2(80),
    Idade               NUMBER(3),
    CONSTRAINT PK_CLIENTES PRIMARY KEY (Codigo_Cliente)
);

-- -----------------------------------------------------------------------------
-- 4. LOJAS
-- -----------------------------------------------------------------------------
CREATE TABLE LOJAS (
    Codigo_Loja         NUMBER(4)       NOT NULL,
    Nome                VARCHAR2(100)   NOT NULL,
    Morada              VARCHAR2(100),
    Latitude            NUMBER,
    Longitude           NUMBER,
    Email               VARCHAR2(80),
    CONSTRAINT PK_LOJAS PRIMARY KEY (Codigo_Loja)
);

-- -----------------------------------------------------------------------------
-- 5. LIVROS
-- -----------------------------------------------------------------------------
CREATE TABLE LIVROS (
    Codigo_Livro        NUMBER(9)       NOT NULL,
    Titulo              VARCHAR2(100)   NOT NULL,
    ISBN                VARCHAR2(20),
    Genero              VARCHAR2(40),
    Preco_Tabela        NUMBER(6,2),
    Paginas             NUMBER(4),
    Unidades_Vendidas   NUMBER(8),
    Codigo_Editora      NUMBER(6)       NOT NULL,
    Codigo_Autor        NUMBER(6)       NOT NULL,
    Data_Edicao         DATE,
    CONSTRAINT PK_LIVROS PRIMARY KEY (Codigo_Livro),
    CONSTRAINT FK_LIVROS_EDITORAS FOREIGN KEY (Codigo_Editora) REFERENCES EDITORAS (Codigo_Editora),
    CONSTRAINT FK_LIVROS_AUTORES FOREIGN KEY (Codigo_Autor) REFERENCES AUTORES (Codigo_Autor)
);

-- -----------------------------------------------------------------------------
-- 6. VENDAS
-- -----------------------------------------------------------------------------
CREATE TABLE VENDAS (
    Codigo_Venda        NUMBER(9)       NOT NULL,
    Data_Venda          DATE,
    Num_Total_Livros    NUMBER(3),
    Total_Venda         NUMBER(8,2),
    Codigo_Cliente      NUMBER(6)       NOT NULL,
    Codigo_Loja         NUMBER(4)       NOT NULL,
    CONSTRAINT PK_VENDAS PRIMARY KEY (Codigo_Venda),
    CONSTRAINT FK_VENDAS_CLIENTES FOREIGN KEY (Codigo_Cliente) REFERENCES CLIENTES (Codigo_Cliente),
    CONSTRAINT FK_VENDAS_LOJAS FOREIGN KEY (Codigo_Loja) REFERENCES LOJAS (Codigo_Loja)
);

-- -----------------------------------------------------------------------------
-- 7. CONTEM (Linhas/itens de venda)
-- -----------------------------------------------------------------------------
CREATE TABLE CONTEM (
    Codigo_Venda        NUMBER(9)       NOT NULL,
    Codigo_Livro        NUMBER(9)       NOT NULL,
    Quantidade          NUMBER(2,0)     DEFAULT 1,
    Preco_unitario      NUMBER(6,2),
    Desconto            NUMBER(5,2)     DEFAULT 0,
    CONSTRAINT PK_CONTEM PRIMARY KEY (Codigo_Venda, Codigo_Livro),
    CONSTRAINT FK_CONTEM_VENDAS FOREIGN KEY (Codigo_Venda) REFERENCES VENDAS (Codigo_Venda),
    CONSTRAINT FK_CONTEM_LIVROS FOREIGN KEY (Codigo_Livro) REFERENCES LIVROS (Codigo_Livro)
);

-- -----------------------------------------------------------------------------
-- 8. EXISTE (Stock por loja)
-- -----------------------------------------------------------------------------
CREATE TABLE EXISTE (
    Codigo_Loja         NUMBER(4)       NOT NULL,
    Codigo_Livro        NUMBER(9)       NOT NULL,
    Quant_Em_Stock      NUMBER(2)       DEFAULT 0,
    CONSTRAINT PK_EXISTE PRIMARY KEY (Codigo_Loja, Codigo_Livro),
    CONSTRAINT FK_EXISTE_LOJAS FOREIGN KEY (Codigo_Loja) REFERENCES LOJAS (Codigo_Loja),
    CONSTRAINT FK_EXISTE_LIVROS FOREIGN KEY (Codigo_Livro) REFERENCES LIVROS (Codigo_Livro)
);

-- -----------------------------------------------------------------------------
-- 9. ENCOMENDAS
-- -----------------------------------------------------------------------------
CREATE TABLE ENCOMENDAS (
    Codigo_encomenda    NUMBER(6)       NOT NULL,
    Codigo_Loja         NUMBER(4)       NOT NULL,
    Codigo_Livro        NUMBER(9)       NOT NULL,
    Data_Encomenda      DATE,
    Quantidade          NUMBER(3),
    Data_Prev_Entrega   DATE,
    CONSTRAINT PK_ENCOMENDAS PRIMARY KEY (Codigo_encomenda),
    CONSTRAINT FK_ENCOMENDAS_LOJAS FOREIGN KEY (Codigo_Loja) REFERENCES LOJAS (Codigo_Loja),
    CONSTRAINT FK_ENCOMENDAS_LIVROS FOREIGN KEY (Codigo_Livro) REFERENCES LIVROS (Codigo_Livro)
);

-- -----------------------------------------------------------------------------
-- 10. TRANSFERENCIAS
-- -----------------------------------------------------------------------------
CREATE TABLE TRANSFERENCIAS (
    Codigo_Transferencia NUMBER(6)      NOT NULL,
    Data_Transferencia   VARCHAR2(60),
    Quantidade           VARCHAR2(30),
    Codigo_Livro         NUMBER(9)      NOT NULL,
    Loja_Origem          NUMBER(4)      NOT NULL,
    Loja_Destino         NUMBER(4)      NOT NULL,
    CONSTRAINT PK_TRANSFERENCIAS PRIMARY KEY (Codigo_Transferencia),
    CONSTRAINT FK_TRANSF_LIVROS FOREIGN KEY (Codigo_Livro) REFERENCES LIVROS (Codigo_Livro),
    CONSTRAINT FK_TRANSF_LOJA_ORIGEM FOREIGN KEY (Loja_Origem) REFERENCES LOJAS (Codigo_Loja),
    CONSTRAINT FK_TRANSF_LOJA_DESTINO FOREIGN KEY (Loja_Destino) REFERENCES LOJAS (Codigo_Loja)
);
