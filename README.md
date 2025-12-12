# Sistema de Gerenciamento de Abastecimento - Posto ABC

Sistema desenvolvido em Delphi 12 com Firebird 2.5 para gerenciar abastecimentos de combustível.

## Arquitetura

O projeto foi desenvolvido seguindo o padrão **MVC (Model-View-Controller)** com as seguintes camadas:

### Models (Entidades)
Localizados em `Models/`:
- **uTanque.pas**: Entidade representando tanques de combustível
- **uBomba.pas**: Entidade representando bombas de abastecimento
- **uAbastecimento.pas**: Entidade representando registros de abastecimentos

### Connection (Singleton)
- **uDatabaseConnection.pas**: Gerencia a conexão única com o banco de dados Firebird
  - Implementa padrão Singleton
  - Carrega configurações do arquivo Config.ini
  - Inicializa o esquema do banco de dados automaticamente

### Repositories (Camada de Dados)
Localizados em `Repositories/`:
- **uTanqueRepository.pas**: Operações CRUD para tanques
- **uBombaRepository.pas**: Operações CRUD para bombas
- **uAbastecimentoRepository.pas**: Operações CRUD para abastecimentos

### View & Controller
- **principal.pas/dfm**: Formulário principal com interface e lógica de controle

## Funcionalidades

1. **Registro de Abastecimentos**
   - Seleção de bomba (exibe tipo de combustível e estoque)
   - Entrada de litros e valor total
   - Cálculo automático de imposto (13%)
   - Validação de estoque disponível

2. **Histórico de Abastecimentos**
   - Visualização em grid de todos os abastecimentos
   - Exibe: bomba, combustível, data/hora, litros, valores

3. **Resumo Diário**
   - Total faturado no dia
   - Total de impostos coletados

4. **Controle de Estoque**
   - Visualização em tempo real do estoque dos tanques
   - Percentual de ocupação
   - Atualização automática após cada abastecimento

## Estrutura do Banco de Dados

### Tabelas

**TANQUES**
- ID (Integer, PK)
- TIPO_COMBUSTIVEL (VARCHAR 20)
- CAPACIDADE_LITROS (NUMERIC 15,2)
- ESTOQUE_ATUAL (NUMERIC 15,2)

**BOMBAS**
- ID (Integer, PK)
- NUMERO_BOMBA (Integer)
- TANQUE_ID (Integer, FK -> TANQUES)

**ABASTECIMENTOS**
- ID (Integer, PK)
- BOMBA_ID (Integer, FK -> BOMBAS)
- DATA_HORA (Timestamp)
- LITROS (NUMERIC 15,2)
- VALOR_TOTAL (NUMERIC 15,2)
- IMPOSTO (NUMERIC 15,2)
- VALOR_COM_IMPOSTO (NUMERIC 15,2)

### Dados Iniciais

O sistema cria automaticamente:
- 2 Tanques: Gasolina e Diesel (10.000L cada)
- 4 Bombas: 2 para gasolina (bombas 1 e 2), 2 para diesel (bombas 3 e 4)

## Configuração

O arquivo **Config.ini** contém:

```ini
[DATABASE]
Database=C:\Users\lucas\Documents\Embarcadero\Studio\23.0\PostoABC\Database\PROJETOABC.FDB
Server=localhost
Port=3050
UserName=SYSDBA
Password=masterkey
Protocol=Local

[SYSTEM]
TaxRate=0.13
```

## Como Executar

1. Abra o projeto **ProjetoAbc.dproj** no Delphi 12
2. Compile o projeto (Shift+F9)
3. Execute (F9)

O banco de dados será inicializado automaticamente na primeira execução se não existir.

## Regras de Negócio

1. **Imposto**: Todo abastecimento tem 13% de imposto sobre o valor total
2. **Estoque**: O sistema impede abastecimentos quando o estoque é insuficiente
3. **Rastreabilidade**: Cada abastecimento registra:
   - Bomba utilizada
   - Quantidade de litros
   - Valor total
   - Imposto calculado
   - Valor final com imposto
   - Data e hora exata

## Estrutura de Arquivos

```
PostoABC/
├── Models/
│   ├── uTanque.pas
│   ├── uBomba.pas
│   └── uAbastecimento.pas
├── Repositories/
│   ├── uTanqueRepository.pas
│   ├── uBombaRepository.pas
│   └── uAbastecimentoRepository.pas
├── Database/
│   ├── PROJETOABC.FDB
│   └── CreateSchema.sql
├── uDatabaseConnection.pas
├── principal.pas
├── principal.dfm
├── ProjetoAbc.dpr
├── ProjetoAbc.dproj
├── Config.ini
└── fbclient.dll
```

## Tecnologias Utilizadas

- **Delphi 12 Athens**
- **Firebird 2.5**
- **FireDAC** (componentes de acesso a dados)
- **VCL** (interface visual)

## Padrões de Projeto Implementados

1. **Singleton**: TDatabaseConnection
2. **Repository Pattern**: Camada de acesso a dados
3. **MVC**: Separação de responsabilidades
4. **Dependency Management**: Repositórios criados no FormCreate
