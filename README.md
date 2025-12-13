# Sistema de Gerenciamento de Abastecimento - Posto ABC

Sistema desenvolvido em Delphi 12 com Firebird 2.5 para gerenciar abastecimentos de combustível em postos de gasolina.

## Arquitetura

O projeto foi desenvolvido seguindo o padrão **MVC (Model-View-Controller)** com as seguintes camadas:

### Models (Entidades)
Localizados em `Models/`:
- **uTanque.pas**: Entidade representando tanques de combustível
- **uBomba.pas**: Entidade representando bombas de abastecimento
- **uAbastecimento.pas**: Entidade representando registros de abastecimentos

### Connection (Singleton)
Localizados em `Connection/`:
- **uDatabaseConnection.pas**: Gerencia a conexão única com o banco de dados Firebird
  - Implementa padrão Singleton
  - Carrega configurações do arquivo Config.ini
  - Realiza a conexão com o banco de dados existente

### Controllers (Lógica de Negócio)
Localizados em `Controllers/`:
- **uAbastecimentoController.pas**: Lógica para gerenciar abastecimentos
- **uBombaController.pas**: Lógica para gerenciar bombas
- **uTanqueController.pas**: Lógica para gerenciar tanques

### Repositories (Camada de Dados)
Localizados em `Repositories/`:
- **uTanqueRepository.pas**: Operações CRUD para tanques
- **uBombaRepository.pas**: Operações CRUD para bombas
- **uAbastecimentoRepository.pas**: Operações CRUD para abastecimentos
- **uRepositorioUtils.pas**: Utilitários compartilhados entre repositórios

### Views (Interface de Usuário)
Localizados em `View/`:
- **uMainForm.pas/dfm**: Formulário principal com menu de navegação
- **uAbastecerView.pas/dfm**: Tela para registrar novo abastecimento
- **uTanqueView.pas/dfm**: Tela para gerenciar tanques
- **uBombaView.pas/dfm**: Tela para gerenciar bombas
- **uRelatorioView.pas/dfm**: Tela com relatórios e resumos
- **uAbastecimentoReport.pas/dfm**: Tela de histórico de abastecimentos

### Utils
Localizados em `Utils/`:
- **uValidacao.pas**: Funções de validação de dados

## Funcionalidades

1. **Registro de Abastecimentos**
   - Seleção de bomba (exibe tipo de combustível e estoque)
   - Entrada de litros e valor total
   - Cálculo automático de imposto (13%)
   - Validação de estoque disponível

2. **Gerenciamento de Tanques**
   - Visualização do estoque em tempo real
   - Visualização da capacidade total
   - Percentual de ocupação
   - Tipo de combustível armazenado

3. **Gerenciamento de Bombas**
   - Visualização das bombas disponíveis
   - Identificação do tanque associado
   - Tipo de combustível por bomba

4. **Histórico de Abastecimentos**
   - Visualização em grid de todos os abastecimentos
   - Exibe: bomba, combustível, data/hora, litros, valores
   - Relatório detalhado de transações

5. **Resumo Diário**
   - Total faturado no dia
   - Total de impostos coletados
   - Análise de estoque por período

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

O banco de dados pré-configurado já contém:
- 2 Tanques: Gasolina e Diesel (10.000L cada)
- 4 Bombas: 2 para gasolina (bombas 1 e 2), 2 para diesel (bombas 3 e 4)

## Configuração

### Arquivo Config.ini

O arquivo **Config.ini** na raiz do projeto contém as configurações de conexão com o banco de dados:

```ini
[DATABASE]
Database=C:\PostoABC\PostoABC.fdb
Server=localhost
Port=3050
UserName=SYSDBA
Password=masterkey
Protocol=Local

[SYSTEM]
TaxRate=0,13
```

**Parâmetros:**
- **Database**: Caminho do arquivo do banco de dados Firebird (.FDB) - Local padrão: `C:\PostoABC\PostoABC.fdb`
- **Server**: Endereço do servidor Firebird (localhost para conexão local)
- **Port**: Porta do serviço Firebird (padrão 3050)
- **UserName**: Usuário para autenticação no banco
- **Password**: Senha do usuário
- **Protocol**: Protocolo de conexão (Local para banco local, TCP para remoto)
- **TaxRate**: Alíquota de imposto em formato decimal (0,13 = 13%)

### Pré-requisitos

1. **Firebird**: Instalado e rodando na máquina (ou acesso remoto configurado)
2. **Delphi 12**: IDE para compilar o projeto
3. **Pasta do Banco**: Criar o diretório `C:\PostoABC\` se não existir
4. **Arquivo de Banco de Dados**: Seguir as instruções abaixo para criar o banco

## Criando o Banco de Dados

### Opção 1: Usando o Script SQL (Recomendado)

Se você já tem um arquivo FDB existente ou deseja criar do zero:

1. Abra o **Firebird isql** ou uma ferramenta SQL compatible (como DBeaver, HeidiSQL ou IBExpert)
2. Conecte ao servidor Firebird
3. Execute o script SQL localizado em `Database\script_geracao_sql.sql`
4. O banco será criado automaticamente com tabelas e dados iniciais

### Opção 2: Usando Ferramentas Visuais

**Com DBeaver (Recomendado):**
1. Baixe e instale o [DBeaver Community](https://dbeaver.io/)
2. Crie uma nova conexão Firebird apontando para `C:\PostoABC\PostoABC.fdb`
3. Abra o arquivo `Database\script_geracao_sql.sql`
4. Execute o script (Ctrl + Enter)

**Com IBExpert:**
1. Abra o IBExpert
2. Crie um novo database em `C:\PostoABC\PostoABC.fdb`
3. Abra e execute o script `Database\script_geracao_sql.sql`

### Opção 3: Linha de Comando (isql)

```cmd
isql -u SYSDBA -p masterkey
CREATE DATABASE 'C:\PostoABC\PostoABC.fdb';
-- Depois, execute o script:
INPUT Database\script_geracao_sql.sql;
```

### Verificando a Criação

Após criar o banco, verifique:
- Se o arquivo `C:\PostoABC\PostoABC.fdb` existe
- Se contém as tabelas: TANQUES, BOMBAS, ABASTECIMENTOS
- Se possui os dados iniciais (2 tanques e 4 bombas)

## Como Executar

1. Abra o projeto **ProjetoAbc.dproj** no Delphi 12
2. Verifique se o Firebird está em execução
3. Verifique se o banco de dados foi criado em `C:\PostoABC\PostoABC.fdb`
4. Compile o projeto: **Ctrl + Shift + F9** ou **Build > Build All**
5. Execute a aplicação: **F9** ou **Run > Run**

## Estrutura de Diretórios

```
ProjetoAbc/
├── Connection/              # Gerenciamento de conexão com BD
├── Controllers/             # Lógica de negócio
├── Database/                # Scripts SQL e arquivo FDB
├── Models/                  # Entidades de dados
├── Repositories/            # Acesso a dados (CRUD)
├── Utils/                   # Funções utilitárias
├── View/                    # Formulários e interfaces
├── Config.ini              # Configurações da aplicação
├── ProjetoAbc.dpr          # Arquivo principal do projeto
├── ProjetoAbc.dproj        # Configuração do projeto Delphi
└── README.md               # Este arquivo
```

## Banco de Dados

O projeto utiliza um banco de dados Firebird localizado em:
`C:\PostoABC\PostoABC.fdb`

**Importante**: O banco de dados não é criado automaticamente em tempo de execução. Consulte a seção **Criando o Banco de Dados** acima para instruções de criação.

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

## Tecnologias Utilizadas

- **Delphi 12 Athens**
- **Firebird**
- **FireDAC** (componentes de acesso a dados)
- **VCL** (interface visual)

## Padrões de Projeto Implementados

1. **Singleton**: TDatabaseConnection
2. **Repository Pattern**: Camada de acesso a dados
3. **MVC**: Separação de responsabilidades
4. **Dependency Injection**: Repositórios injetados nos controllers
## Tela de Abastecimento
****<img width="957" height="665" alt="image" src="https://github.com/user-attachments/assets/990942c2-aa84-4ad4-8c11-bb5490d3a3a5" />

## Tela de Cadastro de Tanques
<img width="878" height="578" alt="image" src="https://github.com/user-attachments/assets/a1250dd4-74f4-47cd-82a6-221f19752d96" />

## Tela de Cadastro de Bombas 
<img width="913" height="581" alt="image" src="https://github.com/user-attachments/assets/e683e37f-a7f0-4dd2-9cbc-374edf0aaa2f" />

## Tela de Relatório 
<img width="906" height="628" alt="image" src="https://github.com/user-attachments/assets/6e746129-4ec0-4df2-b6a7-48f057a54a5d" />

## Relatório gerado 
<img width="905" height="426" alt="image" src="https://github.com/user-attachments/assets/721d20c2-5b26-44e6-b445-6211dd79ee63" />








