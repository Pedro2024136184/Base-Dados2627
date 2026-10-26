# Bases de Dados (LEI - ISEC 2026/2027)

Repositório de estudo e materiais da unidade curricular de **Bases de Dados** da Licenciatura em Engenharia Informática (DEIS - ISEC).

---

## 📁 Estrutura de Pastas

```text
BD27/
├── 📚 Apontamentos/          # Cadernos de apontamentos e resumo de sintaxe Oracle SQL
├── 🏛️ Esquema_Livraria/      # Esquema relacional oficial das fichas (PDF, DDL .sql e guia .md)
├── ✍️ Exercicios/            # Exercícios práticos de modelação Entidade-Relacionamento (ER)
├── 📝 Fichas/                # Resoluções completas das fichas práticas de SQL (Ficha 1 a 9)
├── 📖 Teorica/               # Slides das aulas teóricas (T01 a T04)
├── 💻 TeoricaPratica/        # Slides teórico-práticos (TP01 a TP12) e script do esquema EMP/DEP
└── 🎯 Testes/                # Testes e exames de anos anteriores (ER e SQL) com resoluções
```

---

## 📌 Descrição dos Conteúdos

### 1. `Apontamentos/`
- **`Apontamentos_BD_...pdf`**: Apontamentos globais e notas teóricas da matéria.
- **`resumo_sintaxe_oracle_sql.md`**: Guia rápido de sintaxe Oracle SQL (DML, DDL, funções, junções, operadores e exemplos).

### 2. `Esquema_Livraria/`
Esquema da Base de Dados da **Livraria** utilizado na generalidade das fichas práticas:
- **`202626_BD_P00_Tabela_v1.pdf`**: Enunciado e especificação dos requisitos e tabelas.
- **`schema.sql`**: Script DDL completo em Oracle SQL (`DROP` e `CREATE TABLE` com PKs, FKs e restrições).
- **`esquema_referencia.md`**: Tabela rápida de entidades, atributos e chaves estrangeiras para consulta durante exercícios.

### 3. `Exercicios/`
Exercícios de modelação e desenho conceptual:
- **`Exercicio1_Veiculos.html` / `.pdf`**: Exercício de Notação de Chen e Regras de Transformação (Identificação de Veículos).
- **`Exercicio2_Aeroporto.html` / `.pdf`**: Exercício de Notação de Chen e Regras de Transformação (Sistema de Aviação e Aeroporto).

### 4. `Fichas/`
Resoluções em ficheiros `.sql` prontas para execução e validação no **SQLCheck**:
- `ficha1.sql`: Projeção simples e ordenação (`SELECT`, `ORDER BY`).
- `ficha2.sql`: Restrição e filtros (`WHERE`, `BETWEEN`, `IN`, `LIKE`, `IS NULL`).
- `ficha3.sql`: Funções de linha (`UPPER`, `LOWER`, `ROUND`, `TRUNC`, `TO_CHAR`, datas).
- `ficha4.sql`: Junções de tabelas (`INNER JOIN`, `LEFT JOIN`, `NATURAL JOIN`, `ON`).
- `ficha5.sql`: Operadores de conjuntos (`UNION`, `INTERSECT`, `MINUS`).
- `ficha7.sql`: Funções de grupo e agregação (`COUNT`, `SUM`, `AVG`, `GROUP BY`, `HAVING`).
- `ficha8.sql`: Subqueries escalares e de linha única (`IN`, `EXISTS`, subconsultas).
- `ficha9.sql`: Subqueries avançadas e correlacionadas.
- `ficha_SQL_F3.sql`: Consultas sobre o esquema `EMP`/`DEP` das aulas teórico-práticas.

### 5. `Teorica/`
Slides das aulas teóricas cobrindo:
- `T01`: Introdução aos Sistemas de Bases de Dados.
- `T02`: Modelo Entidade-Relacionamento (Partes 1, 2 e 3).
- `T03`: Índices (B-Tree, Bitmap).
- `T04`: Clusters de tabelas.

### 6. `TeoricaPratica/`
Slides teórico-práticos (TP01 a TP12) e código de apoio:
- **`Script_TP_PT_moodle.sql`**: Script oficial de criação das tabelas clássicas `EMP`, `DEP` e `DESCONTOS`.
- Slides de TP01 a TP12 cobrindo DML, DDL (`CREATE TABLE`, `ALTER TABLE`, constraints) e consultas passo a passo.

### 7. `Testes/`
Organizados por vertente de avaliação:
- **`ER/`**:
  - `2022_2023_ER.pdf`: Teste de Modelação Entidade-Relacionamento 2022/2023.
  - `202324_ER_MC_v1.pdf`: Teste de Modelação Entidade-Relacionamento 2023/2024.
  - `202425_ER_Final.pdf`: Teste de Modelação Entidade-Relacionamento 2024/2025.
- **`SQL/`**:
  - `201516_LEI_BD_SQL_Teste2_16-12-15.pdf`: Teste 2 de SQL de 2015/2016.
  - `201920_LEI_BD_SQL_Teste2_v1.05.pdf` & `201920_LEI_BD_SQL_Teste2_resolucao.sql`: Exame de SQL 2019/2020 e respetiva resolução.
  - `202324_SQL_v1.04_PT_Final.pdf` & `202324_SQL_v1.04_resolucao.sql`: Teste de SQL 2023/2024 e respetiva resolução.
