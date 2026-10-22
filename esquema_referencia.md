# Referência Rápida do Esquema de Base de Dados (Livraria - ISEC 2026/2027)

Fonte: [202626_BD_P00_Tabela_v1.pdf](202626_BD_P00_Tabela_v1.pdf)  
DDL Completo: [schema.sql](schema.sql)

---

## 1. Tabelas e Colunas

| Tabela | Colunas (PK a negrito, FK assinalada) | Descrição / Papel |
| :--- | :--- | :--- |
| **`AUTORES`** | **`Codigo_Autor`** (PK), `Nome`, `N_Contribuinte`, `Morada`, `Data_Nascimento`, `Genero_Preferido`, `Nacionalidade` | Cadastro de autores |
| **`EDITORAS`** | **`Codigo_Editora`** (PK), `Nome`, `N_Contribuinte`, `Morada`, `Telefone`, `Email` | Editoras que publicam livros |
| **`LIVROS`** | **`Codigo_Livro`** (PK), `Titulo`, `ISBN`, `Genero`, `Preco_Tabela`, `Paginas`, `Unidades_Vendidas`, `Codigo_Editora` (FK), `Codigo_Autor` (FK), `Data_Edicao` | Livros do catálogo |
| **`CLIENTES`** | **`Codigo_Cliente`** (PK), `Nome`, `N_Contribuinte`, `Morada`, `Telefone`, `Email`, `Idade` | Clientes da livraria |
| **`LOJAS`** | **`Codigo_Loja`** (PK), `Nome`, `Morada`, `Latitude`, `Longitude`, `Email` | Lojas físicas da rede |
| **`VENDAS`** | **`Codigo_Venda`** (PK), `Data_Venda`, `Num_Total_Livros`, `Total_Venda`, `Codigo_Cliente` (FK), `Codigo_Loja` (FK) | Cabeçalho das vendas efetuadas |
| **`CONTEM`** | **`Codigo_Venda`** (PK, FK), **`Codigo_Livro`** (PK, FK), `Quantidade`, `Preco_unitario`, `Desconto` | Linhas detalhadas de cada venda |
| **`EXISTE`** | **`Codigo_Loja`** (PK, FK), **`Codigo_Livro`** (PK, FK), `Quant_Em_Stock` | Inventário/stock disponível de livros em cada loja |
| **`ENCOMENDAS`** | **`Codigo_encomenda`** (PK), `Codigo_Loja` (FK), `Codigo_Livro` (FK), `Data_Encomenda`, `Quantidade`, `Data_Prev_Entrega` | Pedidos de livros feitos para uma loja |
| **`TRANSFERENCIAS`** | **`Codigo_Transferencia`** (PK), `Data_Transferencia`, `Quantidade`, `Codigo_Livro` (FK), `Loja_Origem` (FK), `Loja_Destino` (FK) | Transferências de exemplares entre lojas |

---

## 2. Mapa de Ligações / Chaves Estrangeiras (JOINs frequentes)

* **Livro $\leftrightarrow$ Autor**:
  `LIVROS.Codigo_Autor = AUTORES.Codigo_Autor`
* **Livro $\leftrightarrow$ Editora**:
  `LIVROS.Codigo_Editora = EDITORAS.Codigo_Editora`
* **Venda $\leftrightarrow$ Cliente**:
  `VENDAS.Codigo_Cliente = CLIENTES.Codigo_Cliente`
* **Venda $\leftrightarrow$ Loja**:
  `VENDAS.Codigo_Loja = LOJAS.Codigo_Loja`
* **Venda $\leftrightarrow$ Itens Vendidos (CONTEM)**:
  `VENDAS.Codigo_Venda = CONTEM.Codigo_Venda`
* **Itens Vendidos $\leftrightarrow$ Livro**:
  `CONTEM.Codigo_Livro = LIVROS.Codigo_Livro`
* **Stock de Livro na Loja (EXISTE)**:
  `EXISTE.Codigo_Loja = LOJAS.Codigo_Loja AND EXISTE.Codigo_Livro = LIVROS.Codigo_Livro`
* **Encomenda $\leftrightarrow$ Loja / Livro**:
  `ENCOMENDAS.Codigo_Loja = LOJAS.Codigo_Loja`  
  `ENCOMENDAS.Codigo_Livro = LIVROS.Codigo_Livro`
* **Transferência $\leftrightarrow$ Lojas / Livro**:
  `TRANSFERENCIAS.Loja_Origem = LOJAS_ORIGEM.Codigo_Loja`  
  `TRANSFERENCIAS.Loja_Destino = LOJAS_DESTINO.Codigo_Loja`  
  `TRANSFERENCIAS.Codigo_Livro = LIVROS.Codigo_Livro`

---

## 3. Regras de Negócio e Restrições do Enunciado

1. Um livro é escrito por um, e apenas um autor (`LIVROS.Codigo_Autor` NOT NULL).
2. Um autor pode ter vários livros ou nenhum na livraria (pode requerer `LEFT JOIN` se quisermos todos os autores).
3. Todos os livros são editados por uma e apenas uma editora (`LIVROS.Codigo_Editora` NOT NULL).
4. Uma editora edita vários livros.
5. Uma venda é realizada a um e apenas um cliente (`VENDAS.Codigo_Cliente` NOT NULL).
6. Um cliente pode efetuar múltiplas vendas (ou nenhuma).
7. Uma venda possui pelo menos um livro associado (registado na tabela `CONTEM`).
8. O mesmo livro pode constar em várias vendas.
