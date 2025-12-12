unit uTanqueView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Grids, Vcl.DBGrids, Data.DB, FireDAC.Comp.Client, FireDAC.Comp.DataSet,
  System.Generics.Collections,
  uTanque, uTanqueController;

type
  TTanqueForm = class(TForm)
    pnlTop: TPanel;
    pnlMiddle: TPanel;
    pnlBottom: TPanel;
    lblTitle: TLabel;
    lblTipoCombustivel: TLabel;
    lblCapacidade: TLabel;
    lblEstoque: TLabel;
    edtTipoCombustivel: TComboBox;
    edtCapacidade: TEdit;
    edtEstoque: TEdit;
    btnAdicionar: TButton;
    btnAtualizar: TButton;
    btnEditar: TButton;
    btnExcluir: TButton;
    btnLimpar: TButton;
    dbgTanques: TDBGrid;
    dsTanques: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnAdicionarClick(Sender: TObject);
    procedure btnAtualizarClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure dbgTanquesCellClick(Column: TColumn);
    procedure dbgTanquesKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FTanqueController: TTanqueController;
    FMemTable: TFDMemTable;
    FTanqueIDSelecionado: Integer;
    procedure CarregarTanques;
    procedure LimparCampos;
    procedure CarregarDadosSelecionado;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TTanqueForm.FormCreate(Sender: TObject);
begin
  FTanqueController := TTanqueController.Create;
  
  // Configurar MemTable
  FMemTable := TFDMemTable.Create(Self);
  FMemTable.FieldDefs.Add('ID', ftInteger);
  FMemTable.FieldDefs.Add('TipoCombustivel', ftString, 20);
  FMemTable.FieldDefs.Add('Capacidade', ftFloat);
  FMemTable.FieldDefs.Add('Estoque', ftFloat);
  FMemTable.FieldDefs.Add('Percentual', ftString, 10);
  FMemTable.CreateDataSet;
  dsTanques.DataSet := FMemTable;
  
  FTanqueIDSelecionado := 0;
  CarregarTanques;
end;

procedure TTanqueForm.FormDestroy(Sender: TObject);
begin
  if Assigned(FTanqueController) then
    FTanqueController.Free;
end;

procedure TTanqueForm.CarregarTanques;
var
  Tanques: TObjectList<TTanque>;
  Tanque: TTanque;
  Percentual: Double;
begin
  FMemTable.DisableControls;
  try
    FMemTable.EmptyDataSet;
    Tanques := FTanqueController.GetAll;
    try
      for Tanque in Tanques do
      begin
        FMemTable.Append;
        FMemTable.FieldByName('ID').AsInteger := Tanque.ID;
        FMemTable.FieldByName('TipoCombustivel').AsString := Tanque.TipoCombustivel;
        FMemTable.FieldByName('Capacidade').AsFloat := Tanque.CapacidadeLitros;
        FMemTable.FieldByName('Estoque').AsFloat := Tanque.EstoqueAtual;
        
        if Tanque.CapacidadeLitros > 0 then
          Percentual := (Tanque.EstoqueAtual / Tanque.CapacidadeLitros) * 100
        else
          Percentual := 0;
        
        FMemTable.FieldByName('Percentual').AsString := FormatFloat('0.0%', Percentual / 100);
        FMemTable.Post;
      end;
    finally
      Tanques.Free;
    end;
  finally
    FMemTable.EnableControls;
  end;
end;

procedure TTanqueForm.CarregarDadosSelecionado;
var
  Tanque: TTanque;
begin
  if FTanqueIDSelecionado <= 0 then
    Exit;
  
  Tanque := FTanqueController.GetById(FTanqueIDSelecionado);
  try
    if Assigned(Tanque) then
    begin
      edtTipoCombustivel.ItemIndex := edtTipoCombustivel.Items.IndexOf(Tanque.TipoCombustivel);
      edtCapacidade.Text := FloatToStr(Tanque.CapacidadeLitros);
      edtEstoque.Text := FloatToStr(Tanque.EstoqueAtual);
    end;
  finally
    if Assigned(Tanque) then
      Tanque.Free;
  end;
end;

procedure TTanqueForm.LimparCampos;
begin
  edtTipoCombustivel.ItemIndex := -1;
  edtCapacidade.Clear;
  edtEstoque.Clear;
  edtTipoCombustivel.SetFocus;
end;

procedure TTanqueForm.btnAdicionarClick(Sender: TObject);
var
  Tanque: TTanque;
  Capacidade: Double;
begin
  // Validar campos
  if edtTipoCombustivel.ItemIndex < 0 then
  begin
    ShowMessage('Por favor, selecione o tipo de combustível!');
    edtTipoCombustivel.SetFocus;
    Exit;
  end;
  
  if not TryStrToFloat(edtCapacidade.Text, Capacidade) or (Capacidade <= 0) then
  begin
    ShowMessage('Por favor, informe uma capacidade válida (maior que 0)!');
    edtCapacidade.SetFocus;
    Exit;
  end;
  
  Tanque := TTanque.Create;
  try
    Tanque.TipoCombustivel := edtTipoCombustivel.Text;
    Tanque.CapacidadeLitros := Capacidade;
    Tanque.EstoqueAtual := 0; // Inicia com estoque zerado // Inicia com estoque zerado
    
    try
      if FTanqueController.Insert(Tanque) then
      begin
        ShowMessage('Tanque registrado com sucesso!');
        LimparCampos;
        CarregarTanques;
      end
      else
        ShowMessage('Erro ao registrar tanque!');
    except
      on E: Exception do
        ShowMessage('Erro ao registrar tanque: ' + E.Message);
    end;
  finally
    Tanque.Free;
  end;
end;

procedure TTanqueForm.btnAtualizarClick(Sender: TObject);
begin
  CarregarTanques;
  LimparCampos;
  FTanqueIDSelecionado := 0;
end;

procedure TTanqueForm.btnEditarClick(Sender: TObject);
var
  Tanque: TTanque;
  Capacidade,Estoque: Double;
begin
  if FTanqueIDSelecionado <= 0 then
  begin
    ShowMessage('Por favor, selecione um tanque na tabela para editar!');
    Exit;
  end;
  
  // Validar campos
  if edtTipoCombustivel.ItemIndex < 0 then
  begin
    ShowMessage('Por favor, selecione o tipo de combustível!');
    edtTipoCombustivel.SetFocus;
    Exit;
  end;

  if not TryStrToFloat(edtCapacidade.Text, Capacidade) or (Capacidade <= 0) then
  begin
    ShowMessage('Por favor, informe uma capacidade válida (maior que 0)!');
    edtCapacidade.SetFocus;
    Exit;
  end;

  if not TryStrToFloat(edtEstoque.Text, Estoque) or (Estoque <= 0) then
  begin
    ShowMessage('Por favor, informe uma quantidade de estoque válida (maior que 0)!');
    edtCapacidade.SetFocus;
    Exit;
  end;

  Tanque := FTanqueController.GetById(FTanqueIDSelecionado);
  try
    if Assigned(Tanque) then
    begin
      Tanque.TipoCombustivel := edtTipoCombustivel.Text;
      Tanque.CapacidadeLitros := Capacidade;
      Tanque.EstoqueAtual :=  Estoque;
      try
        if FTanqueController.Update(Tanque) then
        begin
          ShowMessage('Tanque atualizado com sucesso!');
          LimparCampos;
          CarregarTanques;
          FTanqueIDSelecionado := 0;
        end
        else
          ShowMessage('Erro ao atualizar tanque!');
      except
        on E: Exception do
          ShowMessage('Erro ao atualizar tanque: ' + E.Message);
      end;
    end;
  finally
    if Assigned(Tanque) then
      Tanque.Free;
  end;
end;

procedure TTanqueForm.btnExcluirClick(Sender: TObject);
begin
  if FTanqueIDSelecionado <= 0 then
  begin
    ShowMessage('Por favor, selecione um tanque na tabela para excluir!');
    Exit;
  end;
  
  if MessageDlg('Tem certeza que deseja excluir este tanque?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;
  
  try
    if FTanqueController.Delete(FTanqueIDSelecionado) then
    begin
      ShowMessage('Tanque excluído com sucesso!');
      LimparCampos;
      CarregarTanques;
      FTanqueIDSelecionado := 0;
    end
    else
      ShowMessage('Erro ao excluir tanque!');
  except
    on E: Exception do
      ShowMessage('Erro ao excluir tanque: ' + E.Message);
  end;
end;

procedure TTanqueForm.btnLimparClick(Sender: TObject);
begin
  LimparCampos;
  FTanqueIDSelecionado := 0;
end;

procedure TTanqueForm.dbgTanquesCellClick(Column: TColumn);
begin
  if FMemTable.RecordCount > 0 then
  begin
    FTanqueIDSelecionado := FMemTable.FieldByName('ID').AsInteger;
    CarregarDadosSelecionado;
  end;
end;

procedure TTanqueForm.dbgTanquesKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  // Navegar com setas do teclado (cima, baixo)
  if (Key = VK_UP) or (Key = VK_DOWN) then
  begin
    if FMemTable.RecordCount > 0 then
    begin
      FTanqueIDSelecionado := FMemTable.FieldByName('ID').AsInteger;
      CarregarDadosSelecionado;
    end;
  end;
end;

end.
