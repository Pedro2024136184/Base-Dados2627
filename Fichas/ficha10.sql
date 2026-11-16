-- =============================================================================
-- FICHA 10 - RESOLUÇÃO COMPLETA E VALIDADA
-- Base de Dados - ISEC / DEIS 2026/2027
-- Foco: Sequências (SEQUENCES), Vistas (VIEWS) e Dicionário de Dados (DATA DICTIONARY)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- PERGUNTA 3
-- Código: FKGFNXWCTITWNME
-- Enunciado: Tendo em atenção o código abaixo:
--   CREATE SEQUENCE exp_sequencia;
--   SELECT exp_sequencia.CURRVAL FROM dual;
--   SELECT exp_sequencia.NEXTVAL FROM dual;
--   SELECT exp_sequencia.NEXTVAL FROM dual;
--   SELECT exp_sequencia.NEXTVAL from dual;
--   SELECT exp_sequencia.CURRVAL FROM dual;
--   DROP SEQUENCE exp_sequencia;
-- Comente cada uma das linhas de código e justifique o seu output.
-- -----------------------------------------------------------------------------
-- Explicação teórica para o Moodle:
-- 1. CREATE SEQUENCE exp_sequencia;
--    Cria a sequência exp_sequencia com as propriedades por omissão (inicia em 1,
--    incremento de 1, sem valor máximo, sem ciclo).
-- 2. SELECT exp_sequencia.CURRVAL FROM dual;
--    Gera um ERRO (ORA-08002: sequence EXP_SEQUENCIA.CURRVAL is not yet defined in this session).
--    O pseudocódigo CURRVAL apenas pode ser consultado após ter sido executado pelo menos
--    um NEXTVAL na sessão atual para inicializar a sequência.
-- 3. SELECT exp_sequencia.NEXTVAL FROM dual;
--    Inicializa a sequência na sessão e devolve o seu primeiro valor: 1.
-- 4. SELECT exp_sequencia.NEXTVAL FROM dual;
--    Avança a sequência em 1 unidade e devolve o valor: 2.
-- 5. SELECT exp_sequencia.NEXTVAL from dual;
--    Avança a sequência em 1 unidade e devolve o valor: 3.
-- 6. SELECT exp_sequencia.CURRVAL FROM dual;
--    Devolve o valor corrente da sequência na sessão (sem a incrementar): 3.
-- 7. DROP SEQUENCE exp_sequencia;
--    Elimina a sequência da base de dados.

CREATE SEQUENCE exp_sequencia;
SELECT exp_sequencia.NEXTVAL FROM dual;
SELECT exp_sequencia.NEXTVAL FROM dual;
SELECT exp_sequencia.NEXTVAL FROM dual;
SELECT exp_sequencia.CURRVAL FROM dual;
DROP SEQUENCE exp_sequencia;

EXEC SQLCHECK('FKGFNXWCTITWNME');


-- -----------------------------------------------------------------------------
-- PERGUNTA 4
-- Código: FKNJNXHDQJLUSPV
-- Enunciado: Faça uma cópia da tabela editoras para uma nova tabela EDITORAS_BACKUP.
-- Use o comando CREATE TABLE com subconsulta.
-- -----------------------------------------------------------------------------
CREATE TABLE EDITORAS_BACKUP AS
SELECT *
FROM EDITORAS;

EXEC SQLCHECK('FKNJNXHDQJLUSPV');


-- -----------------------------------------------------------------------------
-- PERGUNTA 5
-- Código: FKYEXNXEUROHELV
-- Enunciado: Adicione à tabela EDITORAS_BACKUP as mesmas restrições da tabela original.
-- (A tabela original EDITORAS tem uma restrição PRIMARY KEY na coluna Codigo_Editora).
-- -----------------------------------------------------------------------------
ALTER TABLE EDITORAS_BACKUP ADD (
    CONSTRAINT PK_EDITORAS_BACKUP PRIMARY KEY (Codigo_Editora)
);

EXEC SQLCHECK('FKYEXNXEUROHELV');


-- -----------------------------------------------------------------------------
-- PERGUNTA 6
-- Código: FKYDNPXFPBWPIRC
-- Enunciado: Crie uma sequência, seq_editback que será utilizada para inserir
-- os valores de código_editora na tabela editoras_backup. A sequência deve começar
-- em 11 e avançar de 1 em 1. Não deverá voltar ao princípio quando terminar e
-- não deverá estar limitada a nenhum valor máximo.
-- -----------------------------------------------------------------------------
CREATE SEQUENCE seq_editback
    START WITH 11
    INCREMENT BY 1
    NOMAXVALUE
    NOCYCLE;

EXEC SQLCHECK('FKYDNPXFPBWPIRC');


-- -----------------------------------------------------------------------------
-- PERGUNTA 7
-- Código: FKIVZGPGIOZKVZL
-- Enunciado: Insira os dados da editora na tabela editoras_backup (usando a sequência seq_editback).
-- Nome: D.Quixote | Nº contribuinte: 901111111 | Morada: Rua Cidade de Córdova, n.2 2610-038 Alfragide, Portugal | Telefone: 707252252 | Fax: 707252253
-- -----------------------------------------------------------------------------
INSERT INTO EDITORAS_BACKUP (Codigo_Editora, Nome, N_Contribuinte, Morada, Telefone)
VALUES (
    seq_editback.NEXTVAL,
    'D.Quixote',
    901111111,
    'Rua Cidade de Córdova, n.2 2610-038 Alfragide, Portugal',
    '707252252'
);
COMMIT;

EXEC SQLCHECK('FKIVZGPGIOZKVZL');


-- -----------------------------------------------------------------------------
-- PERGUNTA 8
-- Código: FKAQCEVHKASRDLO
-- Enunciado: Insira os dados da editora na tabela editoras_backup (usando a sequência seq_editback).
-- Nome: Almedina | Nº contribuinte: 901212121 | Morada: Rua Fernandes Tomás, n.º 76 a 80, 3000-167 Coimbra, Portugal | Telefone: 239851903 | Fax: 239851904
-- -----------------------------------------------------------------------------
INSERT INTO EDITORAS_BACKUP (Codigo_Editora, Nome, N_Contribuinte, Morada, Telefone)
VALUES (
    seq_editback.NEXTVAL,
    'Almedina',
    901212121,
    'Rua Fernandes Tomás, n.º 76 a 80, 3000-167 Coimbra, Portugal',
    '239851903'
);
COMMIT;

EXEC SQLCHECK('FKAQCEVHKASRDLO');


-- -----------------------------------------------------------------------------
-- PERGUNTA 9
-- Código: FKNNXQTIRKBLACD
-- Enunciado: Verifique qual o valor actual de seq_editback e avance para o seu
-- próximo valor. Confirme o valor actual.
-- -----------------------------------------------------------------------------
SELECT seq_editback.CURRVAL FROM dual;
SELECT seq_editback.NEXTVAL FROM dual;
SELECT seq_editback.CURRVAL FROM dual;

EXEC SQLCHECK('FKNNXQTIRKBLACD');


-- -----------------------------------------------------------------------------
-- PERGUNTA 10
-- Código: FKEPPMCJBROFZHT
-- Enunciado: Apague a sequência seq_editback.
-- -----------------------------------------------------------------------------
DROP SEQUENCE seq_editback;

EXEC SQLCHECK('FKEPPMCJBROFZHT');


-- -----------------------------------------------------------------------------
-- PERGUNTA 11
-- Código: FKZBSHOOZEWQOTY
-- Enunciado: Faça uma cópia da tabela LIVROS para uma nova tabela LIVROS_BACKUP.
-- Use o comando CREATE TABLE com subconsulta.
-- -----------------------------------------------------------------------------
CREATE TABLE LIVROS_BACKUP AS
SELECT *
FROM LIVROS;

EXEC SQLCHECK('FKZBSHOOZEWQOTY');


-- -----------------------------------------------------------------------------
-- PERGUNTA 12
-- Código: FKNAOLLKSLABNKG
-- Enunciado: A pesquisa por livros de informática é bastante recorrente nas folhas
-- de exercícios anteriores. Para evitar a necessidade de estar repetidamente a incluir
-- esta restrição crie a vista LIVROS_INFORMATICA que apenas mostre esses livros
-- existentes na tabela LIVROS_BACKUP.
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW LIVROS_INFORMATICA AS
SELECT *
FROM LIVROS_BACKUP
WHERE UPPER(Genero) = 'INFORMÁTICA';

EXEC SQLCHECK('FKNAOLLKSLABNKG');


-- -----------------------------------------------------------------------------
-- PERGUNTA 13
-- Código: FKPWADILYCFLUJD
-- Enunciado: Analise o código abaixo, execute-o e indique as suas implicações na base de dados:
--   INSERT INTO livros_informatica (codigo_livro, titulo,isbn, genero) VALUES (500,'Uma noite de Verão', 8000000001,'Informática');
--   INSERT INTO livros_informatica (codigo_livro, titulo,isbn, genero) VALUES (501,'O céu é azul',8000000002,'Romance');
--   INSERT INTO livros_backup (codigo_livro, codigo_editora, codigo_autor,titulo,isbn, genero) VALUES  (502,2, 2,'Longe de tudo',8000000003,'Informática');
-- -----------------------------------------------------------------------------
-- Explicação teórica para o Moodle:
-- - Livro 500: É inserido com sucesso na tabela subjacente LIVROS_BACKUP através da vista
--   LIVROS_INFORMATICA. Como tem género 'Informática', fica visível na vista e na tabela base.
-- - Livro 501: Como a vista NÃO foi criada com WITH CHECK OPTION, o Oracle permite a inserção
--   de um livro com género 'Romance'. O registo é inserido em LIVROS_BACKUP, mas NÃO aparece
--   na vista LIVROS_INFORMATICA pois não cumpre a condição do WHERE da vista.
-- - Livro 502: É inserido diretamente na tabela base LIVROS_BACKUP. Como tem género 'Informática',
--   passa a estar visível na vista LIVROS_INFORMATICA (visto que a vista reflete dinamicamente a tabela).

INSERT INTO livros_informatica (codigo_livro, titulo, isbn, genero)
VALUES (500, 'Uma noite de Verão', 8000000001, 'Informática');

INSERT INTO livros_informatica (codigo_livro, titulo, isbn, genero)
VALUES (501, 'O céu é azul', 8000000002, 'Romance');

INSERT INTO livros_backup (codigo_livro, codigo_editora, codigo_autor, titulo, isbn, genero)
VALUES (502, 2, 2, 'Longe de tudo', 8000000003, 'Informática');

COMMIT;

EXEC SQLCHECK('FKPWADILYCFLUJD');


-- -----------------------------------------------------------------------------
-- PERGUNTA 14
-- Código: FKAQXPRMLGWNPXE
-- Enunciado: Apague todos os registos introduzidos na tabela LIVROS_BACKUP nos
-- exercícios anteriores desta ficha.
-- -----------------------------------------------------------------------------
DELETE FROM LIVROS_BACKUP
WHERE Codigo_Livro IN (500, 501, 502);
COMMIT;

EXEC SQLCHECK('FKAQXPRMLGWNPXE');


-- -----------------------------------------------------------------------------
-- PERGUNTA 15
-- Código: FKJZDYONFMBBLTS
-- Enunciado: Apague a vista LIVROS_INFORMATICA.
-- -----------------------------------------------------------------------------
DROP VIEW LIVROS_INFORMATICA;

EXEC SQLCHECK('FKJZDYONFMBBLTS');


-- -----------------------------------------------------------------------------
-- PERGUNTA 16
-- Código: FKUAXXVPLXQVHWW
-- Enunciado: Construa a vista autor_livro contendo o nome e o título dos livros
-- editados por eles, utilizando a tabela de autores e a de livros_backup.
-- Os dados de ambos os campos devem ser apresentados em maiúsculas.
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW AUTOR_LIVRO AS
SELECT UPPER(a.Nome) AS Nome, UPPER(l.Titulo) AS Titulo
FROM AUTORES a
JOIN LIVROS_BACKUP l ON a.Codigo_Autor = l.Codigo_Autor;

EXEC SQLCHECK('FKUAXXVPLXQVHWW');


-- -----------------------------------------------------------------------------
-- PERGUNTA 17
-- Código: FKUZJQEQHXZGJJH
-- Enunciado: Visualize todos os dados da vista construída.
-- -----------------------------------------------------------------------------
SELECT *
FROM AUTOR_LIVRO;

EXEC SQLCHECK('FKUZJQEQHXZGJJH');


-- -----------------------------------------------------------------------------
-- PERGUNTA 18
-- Código: FKDGLKJRGRCADEV
-- Enunciado: De seguida apague todos os registos da tabela LIVROS_BACKUP.
-- -----------------------------------------------------------------------------
DELETE FROM LIVROS_BACKUP;
COMMIT;

EXEC SQLCHECK('FKDGLKJRGRCADEV');


-- -----------------------------------------------------------------------------
-- PERGUNTA 19
-- Código: FKBMGXFSRZOUQYF
-- Enunciado: Volte a visualizar os dados da vista. O que aconteceu?
-- -----------------------------------------------------------------------------
-- Explicação teórica para o Moodle:
-- A consulta à vista AUTOR_LIVRO devolve 0 linhas (vista vazia).
-- Como uma vista não armazena dados físicos próprios e efetua uma junção dinâmica
-- entre AUTORES e LIVROS_BACKUP, ao terem sido eliminados todos os registos de LIVROS_BACKUP,
-- não existem linhas correspondentes para satisfazer a junção.

SELECT *
FROM AUTOR_LIVRO;

EXEC SQLCHECK('FKBMGXFSRZOUQYF');


-- -----------------------------------------------------------------------------
-- PERGUNTA 20
-- Código: FKASZYETZHOLOEE
-- Enunciado: Apague a tabela LIVROS_BACKUP.
-- -----------------------------------------------------------------------------
DROP TABLE LIVROS_BACKUP CASCADE CONSTRAINTS;

EXEC SQLCHECK('FKASZYETZHOLOEE');


-- -----------------------------------------------------------------------------
-- PERGUNTA 21
-- Código: FKGRFMEUNATDSFN
-- Enunciado: Volte a visualizar os dados da vista. O que aconteceu?
-- -----------------------------------------------------------------------------
-- Explicação teórica para o Moodle:
-- Ocorre um erro de execução (ORA-04063: view "AUTOR_LIVRO" has errors).
-- Como a tabela base LIVROS_BACKUP foi apagada (DROP TABLE), a vista perdeu o seu objeto
-- de suporte e passou ao estado INVALID no dicionário de dados (USER_OBJECTS), deixando de
-- poder ser consultada.

SELECT *
FROM AUTOR_LIVRO;

EXEC SQLCHECK('FKGRFMEUNATDSFN');


-- -----------------------------------------------------------------------------
-- PERGUNTA 22
-- Código: FKNWSKQVNMPQGVI
-- Enunciado: Construa a vista livros_vendidos contendo o nome da loja (NOME_LOJA),
-- o título do livro, o nome do autor (NOME_AUTOR) e quantidade de livros vendidos
-- por cada. Esta informação deve ser ordenada descendentemente pela quantidade de
-- livros vendidos, o titulo e o nome da loja.
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW LIVROS_VENDIDOS AS
SELECT lj.Nome AS NOME_LOJA,
       l.Titulo AS TITULO,
       a.Nome AS NOME_AUTOR,
       SUM(c.Quantidade) AS QUANTIDADE
FROM LOJAS lj
JOIN VENDAS v ON lj.Codigo_Loja = v.Codigo_Loja
JOIN CONTEM c ON v.Codigo_Venda = c.Codigo_Venda
JOIN LIVROS l ON c.Codigo_Livro = l.Codigo_Livro
JOIN AUTORES a ON l.Codigo_Autor = a.Codigo_Autor
GROUP BY lj.Nome, l.Titulo, a.Nome
ORDER BY SUM(c.Quantidade) DESC, l.Titulo, lj.Nome;

EXEC SQLCHECK('FKNWSKQVNMPQGVI');


-- -----------------------------------------------------------------------------
-- PERGUNTA 23
-- Código: FKTDWYWWPTIMSOZ
-- Enunciado: Visualize as tabelas existentes criadas pelo utilizador.
-- -----------------------------------------------------------------------------
SELECT table_name
FROM user_tables;

EXEC SQLCHECK('FKTDWYWWPTIMSOZ');


-- -----------------------------------------------------------------------------
-- PERGUNTA 24
-- Código: FKFEPNHXETKIOZG
-- Enunciado: Visualize todas as constraints existentes na tabela CONTEM.
-- -----------------------------------------------------------------------------
SELECT constraint_name, constraint_type, search_condition, r_constraint_name, status
FROM user_constraints
WHERE table_name = 'CONTEM';

EXEC SQLCHECK('FKFEPNHXETKIOZG');
