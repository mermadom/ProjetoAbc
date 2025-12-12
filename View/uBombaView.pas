unit uBombaView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Grids, Vcl.DBGrids, Data.DB, FireDAC.Comp.Client, FireDAC.Comp.DataSet,
  System.Generics.Collections,
  uBomba, uBombaController, uTanque, uTanqueController;

type
  TBombaForm = class(TForm)
    pnlTop: TPanel;
    pnlMiddle: TPanel;
    pnlBottom: TPanel;
    lblTitle: TLabel;
    lblNumeroBomba: TLabel;
    lblTanque: TLabel;
    edtNumeroBomba: TEdit;
    cbxTanque: TComboBox;
    btnAdicionar: TButton;
    btnAtualizar: TButton;
    btnEditar: TButton;
    btnExcluir: TButton;
    btnLimpar: TButton;
    dbgBombas: TDBGrid;
    dsBombas: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnAdicionarClick(Sender: TObject);
    procedure btnAtualizarClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure dbgBombasCellClick(Column: TColumn);
    procedure dbgBombasKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FBombaController: TBombaController;
    FTanqueController: TTanqueController;
    FMemTable: TFDMemTable;
    FBombaIDSelecionada: Integer;
    procedure CarregarBombas;
    procedure CarregarTanques;
    procedure LimparCampos;
    function ValidarCampos: Boolean;
    procedure CarregarDadosSelecionado;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}


function TBombaForm.ValidarCampos : Boolean;
var
  NumeroBomba: Integer;
begin
  Result := False;

  if not TryStrToInt(edtNumeroBomba.Text, NumeroBomba) or (NumeroBomba <= 0) then
  begin
    ShowMessage('Informe um número de bomba válido!');
    edtNumeroBomba.SetFocus;
    Exit;
  end;

  if cbxTanque.ItemIndex < 0 then
  begin
    ShowMessage('Selecione um tanque!');
    cbxTanque.SetFocus;
    Exit;
  end;

  Result := True;
end;


procedure TBombaForm.FormCreate(Sender: TObject);
begin
  FBombaController := TBombaController.Create;
  FTanqueController := TTanqueController.Create;

  // Configurar MemTable
  FMemTable := TFDMemTable.Create(Self);
  FMemTable.FieldDefs.Add('ID', ftInteger);
  FMemTable.FieldDefs.Add('NumeroBomba', ftInteger);
  FMemTable.FieldDefs.Add('TipoCombustivel', ftString, 20);
  FMemTable.FieldDefs.Add('EstoqueTanque', ftFloat);
  FMemTable.CreateDataSet;
  dsBombas.DataSet := FMemTable;

  FBombaIDSelecionada := 0;
  CarregarTanques;
  CarregarBombas;
end;

procedure TBombaForm.FormDestroy(Sender: TObject);
begin
  if Assigned(FBombaController) then
    FBombaController.Free;
  if Assigned(FTanqueController) then
    FTanqueController.Free;
end;

procedure TBombaForm.CarregarTanques;
var
  Tanques: TObjectList<TTanque>;
  Tanque: TTanque;
begin
  cbxTanque.Clear;
  Tanques := FTanqueController.GetAll;
  try
    for Tanque in Tanques do
    begin
      cbxTanque.AddItem(Format('ID: %d - %s (%.0f L)', [Tanque.ID, Tanque.TipoCombustivel, Tanque.CapacidadeLitros]), TObject(Tanque.ID));
    end;
  finally
    Tanques.Free;
  end;
end;

procedure TBombaForm.CarregarBombas;
var
  Bombas: TObjectList<TBomba>;
  Bomba: TBomba;
begin
  FMemTable.DisableControls;
  try
    FMemTable.EmptyDataSet;
    Bombas := FBombaController.GetAll;
    try
      for Bomba in Bombas do
      begin
        FMemTable.Append;
        FMemTable.FieldByName('ID').AsInteger := Bomba.ID;
        FMemTable.FieldByName('NumeroBomba').AsInteger := Bomba.NumeroBomba;
        FMemTable.FieldByName('TipoCombustivel').AsString := Bomba.TipoCombustivel;
        FMemTable.FieldByName('EstoqueTanque').AsFloat := Bomba.EstoqueTanque;
        FMemTable.Post;
      end;
    finally
      Bombas.Free;
    end;
  finally
    FMemTable.EnableControls;
  end;
end;

procedure TBombaForm.CarregarDadosSelecionado;
var
  Bomba: TBomba;
  I: Integer;
begin
  if FBombaIDSelecionada <= 0 then
    Exit;
  
  Bomba := FBombaController.GetById(FBombaIDSelecionada);
  try
    if Assigned(Bomba) then
    begin
      edtNumeroBomba.Text := IntToStr(Bomba.NumeroBomba);
      
      // Selecionar o tanque no ComboBox
      for I := 0 to cbxTanque.GetCount - 1 do
      begin
        if Integer(cbxTanque.Items.Objects[I]) = Bomba.TanqueID then
        begin
          cbxTanque.ItemIndex := I;
          Break;
        end;
      end;
    end;
  finally
    if Assigned(Bomba) then
      Bomba.Free;
  end;
end;

procedure TBombaForm.LimparCampos;
begin
  edtNumeroBomba.Clear;
  cbxTanque.ItemIndex := -1;
  edtNumeroBomba.SetFocus;
end;

procedure TBombaForm.btnAdicionarClick(Sender: TObject);
var
  Bomba: TBomba;
  NumeroBomba: Integer;
  TanqueID: Integer;
begin
  if not ValidarCampos then
    Exit;

  Bomba := TBomba.Create;
  try
    TryStrToInt(edtNumeroBomba.Text, NumeroBomba);
    TanqueID := Integer(cbxTanque.Items.Objects[cbxTanque.ItemIndex]);
    
    Bomba.NumeroBomba := NumeroBomba;
    Bomba.TanqueID := TanqueID;

    try
      if FBombaController.Insert(Bomba) then
      begin
        ShowMessage('Bomba registrada com sucesso!');
        LimparCampos;
        CarregarBombas;
      end
      else
        ShowMessage('Erro ao registrar bomba!');
    except
      on E: Exception do
        ShowMessage('Erro ao registrar bomba: ' + E.Message);
    end;
  finally
    Bomba.Free;
  end;
end;

procedure TBombaForm.btnAtualizarClick(Sender: TObject);
begin
  CarregarTanques;
  CarregarBombas;
  LimparCampos;
  FBombaIDSelecionada := 0;
end;

procedure TBombaForm.btnEditarClick(Sender: TObject);
var
  Bomba: TBomba;
  NumeroBomba: Integer;
  TanqueID: Integer;
begin
  if FBombaIDSelecionada <= 0 then
  begin
    ShowMessage('Por favor, selecione uma bomba na tabela para editar!');
    Exit;
  end;
  
  if not ValidarCampos then
    Exit;

  Bomba := FBombaController.GetById(FBombaIDSelecionada);
  try
    if Assigned(Bomba) then
    begin
      TryStrToInt(edtNumeroBomba.Text, NumeroBomba);
      TanqueID := Integer(cbxTanque.Items.Objects[cbxTanque.ItemIndex]);
      
      Bomba.NumeroBomba := NumeroBomba;
      Bomba.TanqueID := TanqueID;
      
      try
        if FBombaController.Update(Bomba) then
        begin
          ShowMessage('Bomba atualizada com sucesso!');
          LimparCampos;
          CarregarBombas;
          FBombaIDSelecionada := 0;
        end
        else
          ShowMessage('Erro ao atualizar bomba!');
      except
        on E: Exception do
          ShowMessage('Erro ao atualizar bomba: ' + E.Message);
      end;
    end;
  finally
    if Assigned(Bomba) then
      Bomba.Free;
  end;
end;

procedure TBombaForm.btnExcluirClick(Sender: TObject);
begin
  if FBombaIDSelecionada <= 0 then
  begin
    ShowMessage('Por favor, selecione uma bomba na tabela para excluir!');
    Exit;
  end;
  
  if MessageDlg('Tem certeza que deseja excluir esta bomba?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;
  
  try
    if FBombaController.Delete(FBombaIDSelecionada) then
    begin
      ShowMessage('Bomba excluída com sucesso!');
      LimparCampos;
      CarregarBombas;
      FBombaIDSelecionada := 0;
    end
    else
      ShowMessage('Erro ao excluir bomba!');
  except
    on E: Exception do
      ShowMessage('Erro ao excluir bomba: ' + E.Message);
  end;
end;

procedure TBombaForm.btnLimparClick(Sender: TObject);
begin
  LimparCampos;
  FBombaIDSelecionada := 0;
end;

procedure TBombaForm.dbgBombasCellClick(Column: TColumn);
begin
  if FMemTable.RecordCount > 0 then
  begin
    FBombaIDSelecionada := FMemTable.FieldByName('ID').AsInteger;
    CarregarDadosSelecionado;
  end;
end;


procedure TBombaForm.dbgBombasKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  // Navegar com setas do teclado (cima, baixo)
  if (Key = VK_UP) or (Key = VK_DOWN) then
  begin
    if FMemTable.RecordCount > 0 then
    begin
      FBombaIDSelecionada := FMemTable.FieldByName('ID').AsInteger;
      CarregarDadosSelecionado;
    end;
  end;
end;

end.
