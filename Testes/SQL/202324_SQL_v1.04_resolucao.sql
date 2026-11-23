-- =============================================================================
-- TESTE SQL 2023/2024 - RESOLUÇÃO COMPLETA
-- Ficheiro correspondente ao enunciado: 202324_SQL_v1.04_PT_Final.pdf
-- Esquema: Telecomunicações Móveis (CONTRACT, PHONE, PHONECALL, INVOICE)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- PERGUNTA 1 (20%)
-- Chamadas recebidas no mês passado associadas a 'José Gonçalves', efetuadas por
-- clientes de Coimbra com contrato, com duração > 2 min. Ordenar por nome cliente.
-- -----------------------------------------------------------------------------
SELECT c.name             AS "Nome Cliente",
       c.nif              AS "Nif",
       p.phoneNumber      AS "PHONENUMBER",
       pc.destPhoneNumber AS "DESTPHONENUMBER"
FROM contract c
JOIN phone p ON c.idContract = p.idContract
JOIN phonecall pc ON p.idPhone = pc.idPhone
WHERE UPPER(c.address) LIKE '%COIMBRA%'
  AND pc.duration > 2
  AND TO_CHAR(pc.callDate, 'MM-YYYY') = '11-2023'
  AND pc.destPhoneNumber IN (
      SELECT p2.phoneNumber
      FROM phone p2
      JOIN contract c2 ON p2.idContract = c2.idContract
      WHERE UPPER(c2.name) = 'JOSÉ GONÇALVES'
  )
ORDER BY c.name ASC;


-- -----------------------------------------------------------------------------
-- PERGUNTA 2 (20%)
-- Clientes com contrato em 2022: chamadas > 2 min por mês de 2022.
-- Excluir se chamadas < 5 ou minutos < 100 (manter se >= 5 AND >= 100).
-- -----------------------------------------------------------------------------
SELECT c.name                          AS "Nome Cliente",
       TO_CHAR(pc.callDate, 'YYYY-MM') AS "ANO_MES",
       COUNT(*)                        AS "NUM_CHAMADAS",
       SUM(pc.duration)                AS "NUM_TOTAL_MINUTOS"
FROM CONTRACT c
JOIN PHONE p ON c.idContract = p.idContract
JOIN PHONECALL pc ON p.idPhone = pc.idPhone
WHERE TO_CHAR(c.startDate, 'YYYY') = '2022'
  AND TO_CHAR(pc.callDate, 'YYYY') = '2022'
  AND pc.duration > 2
GROUP BY c.name, TO_CHAR(pc.callDate, 'YYYY-MM')
HAVING COUNT(*) >= 5 
   AND SUM(pc.duration) >= 100
ORDER BY "NUM_CHAMADAS" DESC, "NUM_TOTAL_MINUTOS" ASC;


-- -----------------------------------------------------------------------------
-- PERGUNTA 3 (20%)
-- Para cada cliente, número de destino para o qual efetuou mais chamadas após as 20h.
-- Ordenar descendentemente por nome do cliente.
-- -----------------------------------------------------------------------------
SELECT c.name             AS "Nome do cliente de origem",
       pc.destPhoneNumber AS "NUMERO DE destino"
FROM CONTRACT c
JOIN PHONE p ON c.idContract = p.idContract
JOIN PHONECALL pc ON p.idPhone = pc.idPhone
WHERE TO_CHAR(pc.callDate, 'HH24') >= '20'
GROUP BY c.idContract, c.name, pc.destPhoneNumber
HAVING COUNT(*) >= ALL (
    SELECT COUNT(*)
    FROM PHONE p2
    JOIN PHONECALL pc2 ON p2.idPhone = pc2.idPhone
    WHERE p2.idContract = c.idContract
      AND TO_CHAR(pc2.callDate, 'HH24') >= '20'
    GROUP BY pc2.destPhoneNumber
)
ORDER BY c.name DESC;


-- -----------------------------------------------------------------------------
-- PERGUNTA 4 (20%)
-- DDL: Criar a tabela INVOICE com todas as restrições ilustradas e de negócio:
-- value >= 0, toDate > fromDate, invoiceDate > toDate.
-- -----------------------------------------------------------------------------
CREATE TABLE INVOICE (
    idInvoice    NUMBER,
    invoiceDate  DATE,
    fromDate     DATE,
    toDate       DATE,
    value        NUMBER,
    idContract   NUMBER,
    CONSTRAINT pk_invoice PRIMARY KEY (idInvoice),
    CONSTRAINT fk_invoice_contract FOREIGN KEY (idContract) REFERENCES CONTRACT (idContract),
    CONSTRAINT ck_invoice_value CHECK (value >= 0),
    CONSTRAINT ck_invoice_dates CHECK (toDate > fromDate),
    CONSTRAINT ck_invoice_invdate CHECK (invoiceDate > toDate)
);


-- -----------------------------------------------------------------------------
-- PERGUNTA 5 (20%)
-- DML: Registar a fatura 77865 para o contrato 9 (Ana Marques) referente à 
-- totalidade do mês passado (novembro de 2023), calculando a soma do custo das chamadas.
-- -----------------------------------------------------------------------------
-- Opção A (Recomendada: INSERT com SELECT e cálculo dinâmico):
INSERT INTO INVOICE (idInvoice, invoiceDate, fromDate, toDate, value, idContract)
SELECT 77865,
       SYSDATE,
       TO_DATE('01-11-2023', 'DD-MM-YYYY'),
       TO_DATE('30-11-2023', 'DD-MM-YYYY'),
       NVL(SUM(pc.cost), 0),
       9
FROM PHONE p
JOIN PHONECALL pc ON p.idPhone = pc.idPhone
WHERE p.idContract = 9
  AND TO_CHAR(pc.callDate, 'MM-YYYY') = '11-2023';

-- Opção B (Alternativa com VALUES e subquery escalar):
-- INSERT INTO INVOICE (idInvoice, invoiceDate, fromDate, toDate, value, idContract)
-- VALUES (
--     77865,
--     SYSDATE,
--     TO_DATE('01-11-2023', 'DD-MM-YYYY'),
--     TO_DATE('30-11-2023', 'DD-MM-YYYY'),
--     (
--         SELECT NVL(SUM(pc.cost), 0)
--         FROM PHONE p
--         JOIN PHONECALL pc ON p.idPhone = pc.idPhone
--         WHERE p.idContract = 9
--           AND TO_CHAR(pc.callDate, 'MM-YYYY') = '11-2023'
--     ),
--     9
-- );
