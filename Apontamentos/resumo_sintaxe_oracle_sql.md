# Guia de Sintaxe e Métodos - Oracle SQL (ISEC / Bases de Dados)

---

## 1. Estrutura e Ordem de Execução de uma Query

No código escreve-se obrigatoriamente nesta ordem:
```sql
SELECT   [DISTINCT] colunas, funcoes_agregadas
FROM     tabela1 t1
JOIN     tabela2 t2 ON t1.id = t2.id
WHERE    condicoes_de_linhas_individuais
GROUP BY colunas_obrigatorias_do_select
HAVING   condicoes_de_agregacoes
ORDER BY colunas [ASC | DESC];
```

### Ordem Lógica com que o Oracle executa:
1. `FROM` + `JOIN` (junta e cruza tabelas)
2. `WHERE` (filtra linhas individuais - SEM agregações)
3. `GROUP BY` (agrupa as linhas resultantes)
4. `HAVING` (filtra os grupos agregados)
5. `SELECT` (projeta as colunas e expressões)
6. `ORDER BY` (ordena o resultado final)

### As Duas Regras de Ouro:
1. **Regra do `GROUP BY`**:
   Se usares funções de agregação (`COUNT`, `SUM`, `AVG`, `MAX`, `MIN`) no `SELECT`, **todas** as outras colunas que aparecem no `SELECT` têm de constar no `GROUP BY`.
2. **Regra do `WHERE` vs `HAVING`**:
   - `WHERE`: filtra antes de agrupar. **Nunca pode ter `SUM()` ou `COUNT()`**.
   - `HAVING`: filtra depois de agrupar (ex: `HAVING COUNT(*) >= 5`).
   - **Aliases**: Nunca uses a alcunha de uma coluna (ex: `AS "Total"`) no `WHERE` ou no `HAVING`. Deves repetir a expressão matemática ou a função de agregação.

---

## 2. Manipulação de Datas em Oracle

| Objetivo | Sintaxe Oracle Correta | Erro Comum a Evitar |
| :--- | :--- | :--- |
| **Data atual do sistema** | `SYSDATE` | `NOW()` ou `CURRENT_DATE()` |
| **Ano passado** | `EXTRACT(YEAR FROM data) = EXTRACT(YEAR FROM SYSDATE) - 1` | `ADD_YEARS(...)` (não existe) |
| **Mês passado** | `TO_CHAR(data, 'YYYYMM') = TO_CHAR(ADD_MONTHS(SYSDATE, -1), 'YYYYMM')` | Subtrair 30 dias |
| **Mesmo ano e mês de outra data** | `TO_CHAR(d1, 'YYYY-MM') = TO_CHAR(d2, 'YYYY-MM')` | Comparar só o mês |
| **Primeiro dia do mês passado** | `TRUNC(ADD_MONTHS(SYSDATE, -1), 'MM')` | Strings manuais |
| **Último dia do mês passado** | `LAST_DAY(ADD_MONTHS(SYSDATE, -1))` | Strings manuais |
| **Horas do dia (ex: após as 20h)** | `TO_NUMBER(TO_CHAR(data_hora, 'HH24')) >= 20` | Comparação direta de texto |

---

## 3. Texto, Strings e Aspas

* **Valores de texto (literais):** sempre com aspas simples `'...'`
  * Exemplo: `WHERE nome = 'José Gonçalves'`
* **Cabeçalhos de colunas (Aliases):** sempre com aspas duplas `"..."` se tiverem espaços ou maiúsculas/minúsculas.
  * Exemplo: `SELECT nome AS "Nome do Cliente"`
  * *Nunca uses aspas simples num alias*: `AS 'Nome'` causa erro em Oracle.
* **Ignorar maiúsculas/minúsculas (obrigatório nos testes do ISEC):**
  * `WHERE UPPER(morada) LIKE '%COIMBRA%'`
  * `%` = zero ou mais carateres.
  * `_` = exatamente um caráter.

---

## 4. Subconsultas: Métodos Fundamentais

### A. Subconsulta Simples (`IN` / `NOT IN`)
Usada quando se compara uma coluna com uma lista de valores de outra tabela:
```sql
SELECT nome, nif
FROM clientes
WHERE id_cliente IN (
    SELECT id_cliente
    FROM vendas
    WHERE total_venda > 500
);
```

### B. Subconsulta Correlacionada ("O Mais / O Menor / Top 1 por Categoria")
A subconsulta interna faz referência à linha da consulta externa (`L1.genero = L2.genero`):
```sql
-- Livro mais caro de cada género
SELECT L1.titulo, L1.genero, L1.preco_tabela
FROM livros L1
WHERE L1.preco_tabela = (
    SELECT MAX(L2.preco_tabela)
    FROM livros L2
    WHERE L2.genero = L1.genero
);
```

### C. Existência (`EXISTS` / `NOT EXISTS`)
Mais eficiente e imune a problemas com valores `NULL`:
```sql
SELECT c.nome
FROM clientes c
WHERE NOT EXISTS (
    SELECT 1
    FROM vendas v
    WHERE v.id_cliente = c.id_cliente
);
```

---

## 5. DDL: Criação e Alteração de Tabelas (`CREATE` e `ALTER`)

### A. Molde Completo de `CREATE TABLE` (Vale 4 valores / 20%)
```sql
CREATE TABLE INVOICE (
    idInvoice    NUMBER(6),
    idContract   NUMBER(6)       NOT NULL,
    invoiceDate  DATE            DEFAULT SYSDATE,
    fromDate     DATE            NOT NULL,
    toDate       DATE            NOT NULL,
    value        NUMBER(8,2)     NOT NULL,

    -- Restrições com nomes explícitos:
    CONSTRAINT pk_invoice          PRIMARY KEY (idInvoice),
    CONSTRAINT fk_invoice_contract FOREIGN KEY (idContract) REFERENCES CONTRACT (idContract),
    CONSTRAINT ck_invoice_value    CHECK (value >= 0),
    CONSTRAINT ck_invoice_periodo  CHECK (toDate > fromDate),
    CONSTRAINT ck_invoice_emissao  CHECK (invoiceDate > toDate)
);
```

### B. Adicionar Constraints com `ALTER TABLE`
Em Oracle, ao adicionar múltiplas restrições com um comando, **é obrigatório usar parênteses**:
```sql
ALTER TABLE BATTLE ADD (
    CONSTRAINT pk_battle_id     PRIMARY KEY (idBattle),
    CONSTRAINT fk_battle_clan1  FOREIGN KEY (idClan1) REFERENCES CLAN (idClan),
    CONSTRAINT fk_battle_clan2  FOREIGN KEY (idClan2) REFERENCES CLAN (idClan),
    CONSTRAINT ck_battle_prize  CHECK (coinsPrize > 0)
);
```

---

## 6. DML: Manipulação de Dados (`INSERT`, `UPDATE`, `DELETE`)

### A. `INSERT` a partir de um `SELECT`
```sql
INSERT INTO INVOICE (idInvoice, idContract, invoiceDate, fromDate, toDate, value)
SELECT 77865,
       9,
       SYSDATE,
       TRUNC(ADD_MONTHS(SYSDATE, -1), 'MM'),
       LAST_DAY(ADD_MONTHS(SYSDATE, -1)),
       NVL(SUM(cost), 0)
FROM PHONECALL pc
JOIN PHONE p ON pc.idPhone = p.idPhone
WHERE p.idContract = 9
  AND TO_CHAR(pc.callDate, 'YYYYMM') = TO_CHAR(ADD_MONTHS(SYSDATE, -1), 'YYYYMM');
```

### B. `UPDATE` com Subconsulta
```sql
UPDATE LIVROS L
SET L.preco_tabela = L.preco_tabela * 1.10
WHERE L.codigo_editora = 12
  AND (
      SELECT NVL(SUM(c.quantidade), 0)
      FROM CONTEM c
      WHERE c.codigo_livro = L.codigo_livro
  ) < 5;
```

### C. `DELETE` com Subconsulta
```sql
DELETE FROM PLAYERATTACK
WHERE idBattle IN (
    SELECT idBattle FROM BATTLE WHERE UPPER(location) = 'SOUTH BAY'
)
AND (idPlayer1 = 15 OR idPlayer2 = 15);
```

---

## 7. Funções Auxiliares Muito Frequentes

* `NVL(valor, substituto_se_null)`: evita problemas de nulos em somas (ex: `NVL(SUM(custo), 0)`).
* `ROUND(valor, 2)`: arredonda casas decimais.
* `COUNT(*)` vs `COUNT(coluna)`: `COUNT(*)` conta todas as linhas; `COUNT(coluna)` ignora nulos.
* `COUNT(DISTINCT coluna)`: conta elementos únicos sem repetições.
