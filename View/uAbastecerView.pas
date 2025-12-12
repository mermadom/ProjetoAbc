unit uAbastecerView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Data.DB, Vcl.Grids, Vcl.DBGrids, FireDAC.Comp.Client, FireDAC.Comp.DataSet,
  FireDAC.Stan.Param, System.Generics.Collections,
  uBomba, uTanque, uAbastecimento,
  uAbastecimentoController, uBombaController, uTanqueController,
  uValidacao, Vcl.Mask;

type
  TAbastecerForm = class(TForm)
    pnlTop: TPanel;
    pnlMiddle: TPanel;
    lblTitle: TLabel;
    lblBomba: TLabel;
    lblLitros: TLabel;
    lblValor: TLabel;
    lblImposto: TLabel;
    lblValorFinal: TLabel;
    cmbBomba: TComboBox;
    edtLitros: TEdit;
    edtValorUnitario: TEdit;
    btnRegistrar: TButton;
    btnAtualizar: TButton;
    lblHistorico: TLabel;
    dbgAbastecimentos: TDBGrid;
    dsAbastecimentos: TDataSource;
    edtImposto: TMaskEdit;
    edtValorFinal: TMaskEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnRegistrarClick(Sender: TObject);
    procedure btnAtualizarClick(Sender: TObject);
    procedure edtValorUnitarioChange(Sender: TObject);
    procedure edtLitrosKeyPress(Sender: TObject; var Key: Char);
    procedure edtValorUnitarioKeyPress(Sender: TObject; var Key: Char);
  private
    FAbastecimentoController: TAbastecimentoController;
    FBombaController: TBombaController;
    FTanqueController: TTanqueController;
    FMemTable: TFDMemTable;
    procedure CarregarBombas;
    procedure CarregarAbastecimentos;
    procedure CalcularImposto;
    procedure LimparCampos;
    function ValidarCampos: Boolean;
    function ValidarEstoqueBomba(BombaID: Integer; Litros: Double): Boolean;
  public
    { Public declarations }
  end;

implementation

uses
  uMainForm;

{$R *.dfm}

procedure TAbastecerForm.FormCreate(Sender: TObject);
begin
  try
    // Inicializar controllers
    FAbastecimentoController := TAbastecimentoController.Create;
    FBombaController := TBombaController.Create;
    FTanqueController := TTanqueController.Create;
    
    // Configurar MemTable para DBGrid
    FMemTable := TFDMemTable.Create(Self);
    FMemTable.FieldDefs.Add('ID', ftInteger);
    FMemTable.FieldDefs.Add('Bomba', ftInteger);
    FMemTable.FieldDefs.Add('Combustivel', ftString, 20);
    FMemTable.FieldDefs.Add('Data/Hora', ftDateTime);
    FMemTable.FieldDefs.Add('Litros', ftFloat);
    FMemTable.FieldDefs.Add('Valor Total', ftCurrency);
    FMemTable.FieldDefs.Add('Imposto', ftCurrency);
    FMemTable.FieldDefs.Add('Valor c/ Imposto', ftCurrency);
    FMemTable.CreateDataSet;
    dsAbastecimentos.DataSet := FMemTable;
    
    // Carregar dados iniciais
    CarregarBombas;
    CarregarAbastecimentos;
  except
    on E: Exception do
      ShowMessage('Erro ao inicializar AbastecerForm: ' + E.Message);
  end;
end;

procedure TAbastecerForm.FormDestroy(Sender: TObject);
begin
  // Limpar a referência na MainForm
  if Assigned(MainForm) and (MainForm.FAbastecerForm = Self) then
    MainForm.FAbastecerForm := nil;
    
  if Assigned(FAbastecimentoController) then
    FAbastecimentoController.Free;
  if Assigned(FBombaController) then
    FBombaController.Free;
  if Assigned(FTanqueController) then
    FTanqueController.Free;
end;

procedure TAbastecerForm.CarregarBombas;
var
  Bombas: TObjectList<TBomba>;
  Bomba: TBomba;
begin
  cmbBomba.Items.Clear;
  Bombas := FBombaController.GetAll;
  try
    for Bomba in Bombas do
    begin
      cmbBomba.Items.AddObject(
        Format('Bomba %d - %s (Estoque: %.2f L)', 
        [Bomba.NumeroBomba, Bomba.TipoCombustivel, Bomba.EstoqueTanque]),
        TObject(Bomba.ID)
      );
    end;
    if cmbBomba.Items.Count > 0 then
      cmbBomba.ItemIndex := 0;
  finally
    Bombas.Free;
  end;
end;

procedure TAbastecerForm.CarregarAbastecimentos;
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
        FMemTable.FieldByName('Combustivel').AsString := Abast.TipoCombustivel;
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

procedure TAbastecerForm.CalcularImposto;
var
  ValorTotal,ValorUnitario,Litros, Imposto, ValorFinal: Double;
begin
  ValorUnitario := 0;
  Litros := 0;
  TryStrToFloat(edtValorUnitario.Text, ValorUnitario);
  TryStrToFloat(edtLitros.Text, Litros);
  ValorTotal := ValorUnitario * Litros;
  if TryStrToFloat(edtValorUnitario.Text, ValorUnitario) then
  begin
    Imposto := FAbastecimentoController.CalcularImposto(ValorTotal);
    ValorFinal := ValorTotal + Imposto;
    edtImposto.EditMask := '';
    edtValorFinal.EditMask := '';
    edtImposto.Text := FormatFloat('R$#,##0.00', Imposto);
    edtValorFinal.Text := FormatFloat('R$#,##0.00', ValorFinal);
  end
  else
  begin
    edtImposto.Text := '0.00';
    edtValorFinal.Text := '0.00';
  end;
end;

procedure TAbastecerForm.edtValorUnitarioChange(Sender: TObject);
begin
  CalcularImposto;
end;

function TAbastecerForm.ValidarCampos: Boolean;
var
  Litros, ValorTotal: Double;
  BombaID: Integer;
  EstoqueAtual: Double;
begin
  Result := False;
  
  if cmbBomba.ItemIndex < 0 then
  begin
    ShowMessage('Selecione uma bomba!');
    Exit;
  end;
  
  if not TryStrToFloat(edtLitros.Text, Litros) or (Litros <= 0) then
  begin
    ShowMessage('Informe uma quantidade válida de litros!');
    edtLitros.SetFocus;
    Exit;
  end;
  
  if not TryStrToFloat(edtValorUnitario.Text, ValorTotal) or (ValorTotal <= 0) then
  begin
    ShowMessage('Informe um valor unitário válido!');
    edtValorUnitario.SetFocus;
    Exit;
  end;
  
  // Verificar estoque
  BombaID := Integer(cmbBomba.Items.Objects[cmbBomba.ItemIndex]);
  EstoqueAtual := FBombaController.GetEstoqueTanque(BombaID);
  
  if Litros > EstoqueAtual then
  begin
    ShowMessage(Format('Estoque insuficiente! Disponível: %.2f L', [EstoqueAtual]));
    Exit;
  end;
  
  Result := True;
end;

procedure TAbastecerForm.LimparCampos;
begin
  edtLitros.Clear;
  edtValorUnitario.Clear;
  edtImposto.Clear;
  edtValorFinal.Clear;
  if cmbBomba.Items.Count > 0 then
    cmbBomba.ItemIndex := 0;
  edtLitros.SetFocus;
end;

procedure TAbastecerForm.btnRegistrarClick(Sender: TObject);
var
  Abastecimento: TAbastecimento;
  BombaID: Integer;
  Litros,ValorUnitario, ValorTotal, Imposto, ValorFinal: Double;
begin
  if not ValidarCampos then
    Exit;
  
  BombaID := Integer(cmbBomba.Items.Objects[cmbBomba.ItemIndex]);
  Litros := StrToFloat(edtLitros.Text);
  ValorUnitario := StrToFloat(edtValorUnitario.Text);

  // Validar estoque antes de prosseguir
  if not ValidarEstoqueBomba(BombaID, Litros) then
    Exit;

  Imposto := StrToFloat(StringReplace(StringReplace(edtImposto.EditText,'R$','',[rfReplaceAll]),'.','',[rfReplaceAll]));
  ValorFinal := StrToFloat(StringReplace( StringReplace(edtValorFinal.EditText,'R$','',[rfReplaceAll]),'.','',[rfReplaceAll]) );

  edtImposto.Text := FormatFloat('R$#,##0.00', Imposto);
  edtValorFinal.Text := FormatFloat('R$#,##0.00', ValorFinal);
  Abastecimento := TAbastecimento.Create;
  try
    Abastecimento.BombaID := BombaID;
    Abastecimento.DataHora := Now;
    Abastecimento.Litros := Litros;
    Abastecimento.ValorTotal := Litros * ValorUnitario;
    Abastecimento.Imposto := Imposto;
    Abastecimento.ValorComImposto := ValorFinal;
    
    if FAbastecimentoController.Insert(Abastecimento) then
    begin
      ShowMessage('Abastecimento registrado com sucesso!');
      LimparCampos;
      btnAtualizarClick(nil);
    end
    else
      ShowMessage('Erro ao registrar abastecimento!');
  finally
    Abastecimento.Free;
  end;
end;

procedure TAbastecerForm.btnAtualizarClick(Sender: TObject);
begin
  CarregarBombas;
  CarregarAbastecimentos;
end;

procedure TAbastecerForm.edtLitrosKeyPress(Sender: TObject; var Key: Char);
begin
  TValidacao.ValidarEntradaNumerica(Sender, Key);
end;

procedure TAbastecerForm.edtValorUnitarioKeyPress(Sender: TObject; var Key: Char);
begin
  TValidacao.ValidarEntradaNumerica(Sender, Key);
end;

function TAbastecerForm.ValidarEstoqueBomba(BombaID: Integer; Litros: Double): Boolean;
var
  Bomba: TBomba;
  EstoqueAtual: Double;
  TipoCombustivel: string;
begin
  Result := False;
  
  try
    // Obter informações da bomba
    Bomba := FBombaController.GetById(BombaID);
    if not Assigned(Bomba) then
    begin
      ShowMessage('Erro: Bomba não encontrada!');
      Exit;
    end;
    
    // Obter estoque atual do tanque
    EstoqueAtual := FBombaController.GetEstoqueTanque(BombaID);
    TipoCombustivel := Bomba.TipoCombustivel;
    
    // Validar se há estoque suficiente
    if Litros > EstoqueAtual then
    begin
      ShowMessage(
        Format(
          'Operação bloqueada!%s%s' +
          'Estoque insuficiente de %s.%s%s' +
          'Solicitado: %.2f L%s' +
          'Disponível: %.2f L%s%s' +
          'Diferença: %.2f L',
          [
            #13#10, #13#10,
            TipoCombustivel,
            #13#10, #13#10,
            Litros,
            #13#10,
            EstoqueAtual,
            #13#10, #13#10,
            Litros - EstoqueAtual
          ]
        )
      );
      Exit;
    end;
    
    // Validar se a quantidade é positiva
    if Litros <= 0 then
    begin
      ShowMessage('A quantidade de litros deve ser maior que zero!');
      Exit;
    end;
    
    Result := True;
  finally
    if Assigned(Bomba) then
      Bomba.Free;
  end;
end;

end.
