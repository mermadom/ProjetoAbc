unit uRelatorioView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Grids, Vcl.DBGrids, Data.DB, FireDAC.Comp.Client, FireDAC.Comp.DataSet,
  System.Generics.Collections,
  uTanque, uAbastecimento,
  uAbastecimentoController, uTanqueController, Vcl.ComCtrls, 
  uDatabaseConnection, FireDAC.Stan.Param, uAbastecimentoReport;

type
  TRelatorioForm = class(TForm)
    pnlMiddle: TPanel;
    pnlBottom: TPanel;
    lblEstoque: TLabel;
    memoEstoque: TMemo;
    dbgHistorico: TDBGrid;
    dsHistorico: TDataSource;
    lblHistorico: TLabel;
    btnFechar: TButton;
    btnAtualizar: TButton;
    pnlTop: TPanel;
    lblTitle: TLabel;
    DataIni: TDateTimePicker;
    DataFim: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    BtnGerarRelatorio: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure btnAtualizarClick(Sender: TObject);
    procedure BtnGerarRelatorioClick(Sender: TObject);
  private
    FAbastecimentoController: TAbastecimentoController;
    FTanqueController: TTanqueController;
    FMemTable: TFDMemTable;
    procedure AtualizarEstoque;
    procedure CarregarHistorico;
    function ValidaRel : Boolean;
  public

  end;

implementation

{$R *.dfm}

procedure TRelatorioForm.FormCreate(Sender: TObject);
begin
  FAbastecimentoController := TAbastecimentoController.Create;
  FTanqueController := TTanqueController.Create;
  // Configurar MemTable para histórico
  FMemTable := TFDMemTable.Create(Self);
  FMemTable.FieldDefs.Add('ID', ftInteger);
  FMemTable.FieldDefs.Add('Bomba', ftInteger);
  FMemTable.FieldDefs.Add('Combustível', ftString, 20);
  FMemTable.FieldDefs.Add('Data/Hora', ftDateTime);
  FMemTable.FieldDefs.Add('Litros', ftFloat);
  FMemTable.FieldDefs.Add('Valor Total', ftFloat);
  FMemTable.FieldDefs.Add('Imposto', ftFloat);
  FMemTable.FieldDefs.Add('Valor c/ Imposto', ftFloat);
  FMemTable.CreateDataSet;
  dsHistorico.DataSet := FMemTable;
  
  // Atualizar dados
  AtualizarEstoque;
  CarregarHistorico;

end;

function TRelatorioForm.ValidaRel: Boolean;
begin
  Result := False;
  if (DataIni.Date > DataFim.Date) then
  begin
    raise Exception.Create('A data inicial não pode ser maior que a data final.');
  end;

  Result := True;
end;

procedure TRelatorioForm.FormDestroy(Sender: TObject);
begin
  if Assigned(FAbastecimentoController) then
    FAbastecimentoController.Free;
  if Assigned(FTanqueController) then
    FTanqueController.Free;
end;


procedure TRelatorioForm.AtualizarEstoque;
var
  Tanques: TObjectList<TTanque>;
  Tanque: TTanque;
begin
  memoEstoque.Clear;
  memoEstoque.Lines.Add('=== ESTADO DOS TANQUES ===');
  memoEstoque.Lines.Add('');
  
  Tanques := FTanqueController.GetAll;
  try
    for Tanque in Tanques do
    begin
      memoEstoque.Lines.Add(
        Format('%s: %.2f L / %.2f L (%.1f%%)', 
        [Tanque.TipoCombustivel, Tanque.EstoqueAtual, Tanque.CapacidadeLitros,
         (Tanque.EstoqueAtual / Tanque.CapacidadeLitros) * 100])
      );
    end;
  finally
    Tanques.Free;
  end;
end;

procedure TRelatorioForm.CarregarHistorico;
var
  Abastecimentos: TObjectList<TAbastecimento>;
  Abast: TAbastecimento;
begin
  FMemTable.DisableControls;
  try
    FMemTable.EmptyDataSet;
    Abastecimentos := FAbastecimentoController.GetAll;
    try
      for Abast in Abastecimentos do
      begin
        FMemTable.Append;
        FMemTable.FieldByName('ID').AsInteger := Abast.ID;
        FMemTable.FieldByName('Bomba').AsInteger := Abast.NumeroBomba;
        FMemTable.FieldByName('Combustível').AsString := Abast.TipoCombustivel;
        FMemTable.FieldByName('Data/Hora').AsDateTime := Abast.DataHora;
        FMemTable.FieldByName('Litros').AsFloat := Abast.Litros;
        FMemTable.FieldByName('Valor Total').AsFloat := Abast.ValorTotal;
        FMemTable.FieldByName('Imposto').AsFloat := Abast.Imposto;
        FMemTable.FieldByName('Valor c/ Imposto').AsFloat := Abast.ValorComImposto;
        FMemTable.Post;
      end;
    finally
      Abastecimentos.Free;
    end;
  finally
    FMemTable.EnableControls;
  end;
end;

procedure TRelatorioForm.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TRelatorioForm.BtnGerarRelatorioClick(Sender: TObject);
var
  Query: TFDQuery;
  ReportForm: TAbastecimentoReportForm;
  DataInicio: TDateTime;
  DataFim: TDateTime;
begin
  try
    if not ValidaRel then
    begin
      Exit;
    end;

    DataInicio := DataIni.Date;
    DataFim := Self.DataFim.Date + 1 - 1/86400; // Até o final do dia

    Query := TFDQuery.Create(nil);
    try
      Query.Connection := TDatabaseConnection.GetInstance.Connection;
      Query.SQL.Text := 
        'SELECT CAST(A.DATA_HORA AS DATE) AS DataAbastecimento, ' +
        '       T.TIPO_COMBUSTIVEL AS TipoCombustivel, ' +
        '       B.NUMERO_BOMBA AS Bomba, ' +
        '       SUM(A.LITROS) AS Litros, ' +
        '       SUM(A.VALOR_TOTAL) AS ValorTotal, ' +
        '       SUM(A.IMPOSTO) AS Imposto, ' +
        '       SUM(A.VALOR_COM_IMPOSTO) AS ValorComImposto ' +
        'FROM ABASTECIMENTOS A ' +
        'INNER JOIN BOMBAS B ON A.BOMBA_ID = B.ID ' +
        'INNER JOIN TANQUES T ON B.TANQUE_ID = T.ID ' +
        'WHERE CAST(A.DATA_HORA AS DATE) >= :DataInicio ' +
        '  AND CAST(A.DATA_HORA AS DATE) <= :DataFim ' +
        ' GROUP BY CAST(A.DATA_HORA AS DATE),T.TIPO_COMBUSTIVEL,B.NUMERO_BOMBA'+
        ' ORDER BY CAST(A.DATA_HORA AS DATE) DESC, T.TIPO_COMBUSTIVEL, B.NUMERO_BOMBA ';

      Query.ParamByName('DataInicio').AsDateTime := DataInicio;
      Query.ParamByName('DataFim').AsDateTime := DataFim;
      Query.Open;

      if Query.IsEmpty then
      begin
        ShowMessage('Nenhum abastecimento encontrado no período selecionado.');
        Exit;
      end;

      ReportForm := TAbastecimentoReportForm.Create(nil);
      try
        ReportForm.ExibirRelatorio(Query);
      finally
        ReportForm.Free;
      end;
    finally
      Query.Free;
    end;

  except on E: Exception do
    begin
      ShowMessage('Erro ao gerar relatório: ' + E.Message);
    end;
  end;
end;

procedure TRelatorioForm.btnAtualizarClick(Sender: TObject);
begin
  AtualizarEstoque;
  CarregarHistorico;
end;

end.
