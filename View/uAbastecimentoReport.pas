unit uAbastecimentoReport;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Data.DB, FireDAC.Comp.Client, RLReport;

type
  TAbastecimentoReportForm = class(TForm)
    pnlTop: TPanel;
    lblTitle: TLabel;
    btnFechar: TButton;
    pnlMiddle: TPanel;
    ReportAbastecimento: TRLReport;
    RLBand_Title: TRLBand;
    RLLabel_TitleReport: TRLLabel;
    RLLabel_SubTitle: TRLLabel;
    RLBand_Header: TRLBand;
    RLLabel_ColData: TRLLabel;
    RLLabel_ColTanque: TRLLabel;
    RLLabel_ColBomba: TRLLabel;
    RLLabel_ColLitros: TRLLabel;
    RLLabel_ColValorTotal: TRLLabel;
    RLLabel_ColValorImposto: TRLLabel;
    RLBand_Detail: TRLBand;
    RLDBText_Data: TRLDBText;
    RLDBText_Tanque: TRLDBText;
    RLDBText_Bomba: TRLDBText;
    RLDBText_Litros: TRLDBText;
    RLDBText_ValorTotal: TRLDBText;
    RLDBText_ValorImposto: TRLDBText;
    RLBand_Summary: TRLBand;
    RLLabel_TotalLabel: TRLLabel;
    RlLabelTotal: TRLLabel;
    RLLabel_ColImposto: TRLLabel;
    RLDBText_ValorComImposto: TRLDBText;
    RLLabelTotalImposto: TRLLabel;
    RLLabelTotalComImposto: TRLLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RLBand_DetailBeforePrint(Sender: TObject; var PrintIt: Boolean);
  private
    FQuery: TFDQuery;
    FDataSource: TDataSource;
    FTotalGeral: Double;
    FTotalImposto : Double;
    FTotalComImposto : Double;
    procedure ConfigurarRelatorio;
    procedure CalcularTotalGeral;
  public
    procedure ExibirRelatorio(Query: TFDQuery);
  end;

implementation

{$R *.dfm}

procedure TAbastecimentoReportForm.FormCreate(Sender: TObject);
begin
  FDataSource := TDataSource.Create(Self);
  FTotalGeral := 0;
  FTotalComImposto := 0;
  FTotalImposto := 0;
  ConfigurarRelatorio;
end;

procedure TAbastecimentoReportForm.RLBand_DetailBeforePrint(Sender: TObject;
  var PrintIt: Boolean);
begin
  //RLDBText_Data.DataSource := FDataSource;
  //ShowMessage('TEste');
end;

procedure TAbastecimentoReportForm.ConfigurarRelatorio;
begin
  ReportAbastecimento.DataSource := FDataSource;
  //RLBand_Detail.DataSource := FDataSource;
end;

procedure TAbastecimentoReportForm.CalcularTotalGeral;
begin
  FTotalGeral := 0;
  if Assigned(FQuery) and not FQuery.IsEmpty then
  begin
    FQuery.First;
    while not FQuery.Eof do
    begin
      FTotalComImposto := FTotalComImposto + FQuery.FieldByName('ValorComImposto').AsFloat;
      FTotalImposto := FTotalImposto + FQuery.FieldByName('Imposto').AsFloat;
      FTotalGeral := FTotalGeral + FQuery.FieldByName('ValorTotal').AsFloat;
      FQuery.Next;
    end;
    FQuery.First;
  end;
end;

procedure TAbastecimentoReportForm.ExibirRelatorio(Query: TFDQuery);
begin
  FQuery := Query;
  FDataSource.DataSet := FQuery;
  ReportAbastecimento.DataSource := FDataSource;
  RLDBText_Data.DataSource := FDataSource;
  RLDBText_Tanque.DataSource := FDataSource;
  RLDBText_Bomba.DataSource := FDataSource;
  RLDBText_Litros.DataSource := FDataSource;
  RLDBText_ValorTotal.DataSource := FDataSource;
  RLDBText_ValorImposto.DataSource := FDataSource;
  RLDBText_ValorComImposto.DataSource := FDataSource;

  //RLBand_Detail.DataSource := FDataSource;
  
  // Calcular o total geral antes de exibir
  CalcularTotalGeral;
  RlLabelTotal.Caption := 'R$ ' + FormatFloat('#,##0.00',FTotalGeral);
  RLLabelTotalImposto.Caption := 'R$ ' + FormatFloat('#,##0.00',FTotalImposto);
  RLLabelTotalComImposto.Caption := 'R$ ' + FormatFloat('#,##0.00',FTotalComImposto);
  ReportAbastecimento.Preview;
  //ShowModal;
end;

procedure TAbastecimentoReportForm.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TAbastecimentoReportForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

end.
