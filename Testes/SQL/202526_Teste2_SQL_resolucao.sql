-- =============================================================================
-- TESTE SQL 2025/2026 - RESOLUÇÃO COMPLETA
-- Ficheiro correspondente ao enunciado: 202526_Teste2_SQL_PT.pdf
-- Esquema: TVE / Tipo UBER (CLIENT, REQUEST, DRIVER, RIDEOPTION, RIDE)
-- Data do Teste: 03.12.2025 | Duração: 60 min
-- =============================================================================

-- -----------------------------------------------------------------------------
-- PERGUNTA 1 (20%)
-- Viagens terminadas em setembro de 2025, tarifa Economy, custo > 10€, marca Dacia.
-- Clientes ordenados descendentemente por nome e data de nascimento.
-- Conceitos-chave: DISTINCT para não repetir clientes, cálculo de idade com MONTHS_BETWEEN.
-- -----------------------------------------------------------------------------
SELECT DISTINCT c.name                                                          AS "Client Name",
       c.birthDate                                                              AS "BIRTHDATE",
       TRUNC(MONTHS_BETWEEN(TO_DATE('03-12-2025', 'DD-MM-YYYY'), c.birthDate) / 12) AS "Age"
FROM CLIENT c
JOIN REQUEST re    ON c.idClient = re.idClient
JOIN RIDEOPTION ro ON re.idRequest = ro.idRequest
JOIN DRIVER d      ON ro.idDriver = d.idDriver
JOIN RIDE r        ON ro.idRide = r.idRide
WHERE ro.cost > 10
  AND UPPER(d.brand) = 'DACIA'
  AND UPPER(ro.fareType) = 'ECONOMY'
  AND TO_CHAR(r.endDateTime, 'MM-YYYY') = '09-2025'
ORDER BY c.name DESC, c.birthDate DESC;


-- -----------------------------------------------------------------------------
-- PERGUNTA 2 (20%)
-- Comissão da plataforma: 25% (condutor recebe 75% = cost * 0.75).
-- Viagens terminadas em 2024 (ano passado) com partida em Coimbra.
-- Excluir quem fez menos de 10 viagens (manter COUNT(*) >= 10 no HAVING).
-- Ordenar por Earned Value DESC e Average Value DESC.
-- -----------------------------------------------------------------------------
SELECT d.idDriver                    AS "Id Driver",
       d.name                        AS "Name",
       d.brand                       AS "Vehicle Brand",
       ROUND(SUM(ro.cost * 0.75), 2) AS "Earned Value",
       ROUND(AVG(ro.cost * 0.75), 2) AS "Average Value"
FROM DRIVER d
JOIN RIDEOPTION ro ON d.idDriver = ro.idDriver
JOIN REQUEST re    ON ro.idRequest = re.idRequest
JOIN RIDE r        ON ro.idRide = r.idRide
WHERE TO_CHAR(r.endDateTime, 'YYYY') = '2024'
  AND UPPER(re.addressOrign) LIKE '%COIMBRA%'
GROUP BY d.idDriver, d.name, d.brand
HAVING COUNT(*) >= 10
ORDER BY "Earned Value" DESC, "Average Value" DESC;


-- -----------------------------------------------------------------------------
-- PERGUNTA 3 (20%)
-- Cliente(s) que fez mais viagens com tarifa Premium e duração > 10 min.
-- Conceitos-chave: Cálculo de minutos (dias * 24 * 60) e Máximo Global com >= ALL.
-- -----------------------------------------------------------------------------
SELECT c.name   AS "Client Name",
       COUNT(*) AS "NUM_RIDES"
FROM CLIENT c
JOIN REQUEST req   ON c.idClient = req.idClient
JOIN RIDEOPTION ro ON req.idRequest = ro.idRequest
JOIN RIDE r        ON ro.idRide = r.idRide
WHERE UPPER(ro.fareType) = 'PREMIUM'
  AND (r.endDateTime - r.pickupDateTime) * 24 * 60 > 10
  -- Nota: Se considerado pela estimativa do pedido: AND ro.expectedDuration > 10
GROUP BY c.idClient, c.name
HAVING COUNT(*) >= ALL (
    SELECT COUNT(*)
    FROM REQUEST req2
    JOIN RIDEOPTION ro2 ON req2.idRequest = ro2.idRequest
    JOIN RIDE r2        ON ro2.idRide = r2.idRide
    WHERE UPPER(ro2.fareType) = 'PREMIUM'
      AND (r2.endDateTime - r2.pickupDateTime) * 24 * 60 > 10
    GROUP BY req2.idClient
);


-- -----------------------------------------------------------------------------
-- PERGUNTA 4 (20%)
-- DDL: Criação da tabela RIDEOPTION com PK, FKs e restrições CHECK de não negatividade.
-- -----------------------------------------------------------------------------
CREATE TABLE RIDEOPTION (
    idRide            NUMBER,
    idRequest         NUMBER        NOT NULL,
    idDriver          NUMBER        NOT NULL,
    rideDateTime      DATE,
    fareType          VARCHAR2(20),
    cost              NUMBER,
    pickupDateTime    DATE,
    expectedDuration  NUMBER,

    CONSTRAINT pk_rideoption          PRIMARY KEY (idRide),
    CONSTRAINT fk_rideoption_request  FOREIGN KEY (idRequest) REFERENCES REQUEST (idRequest),
    CONSTRAINT fk_rideoption_driver   FOREIGN KEY (idDriver) REFERENCES DRIVER (idDriver),
    CONSTRAINT ck_rideoption_cost     CHECK (cost >= 0),
    CONSTRAINT ck_rideoption_duration CHECK (expectedDuration >= 0)
);


-- -----------------------------------------------------------------------------
-- PERGUNTA 5 (20%)
-- DML: Atualizar o starRating dos condutores de veículos 'eletric' com starRating < 2,
-- calculando a média das avaliações (numStars) de todas as viagens terminadas por esse condutor.
-- Conceito-chave: UPDATE com Subquery Correlacionada.
-- -----------------------------------------------------------------------------
UPDATE DRIVER d
SET d.starRating = (
    SELECT ROUND(AVG(r.numStars), 2)
    FROM RIDEOPTION ro
    JOIN RIDE r ON ro.idRide = r.idRide
    WHERE ro.idDriver = d.idDriver
      AND r.numStars IS NOT NULL
)
WHERE UPPER(d.type) = 'ELETRIC'
  AND d.starRating < 2;

COMMIT;
