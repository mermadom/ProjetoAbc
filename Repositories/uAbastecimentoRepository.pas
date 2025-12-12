unit uAbastecimentoRepository;

interface

uses
  System.SysUtils, System.Generics.Collections, FireDAC.Comp.Client,
  FireDAC.Stan.Param, Data.DB, uAbastecimento, uDatabaseConnection, Vcl.Dialogs,
  uRepositorioUtils;

type
  TAbastecimentoRepository = class
  private
    FConnection: TFDConnection;
  public
    constructor Create;
    function GetAll(DataInicio: TDateTime = 0; DataFim: TDateTime = 0): TObjectList<TAbastecimento>;
    function GetById(ID: Integer): TAbastecimento;
    function Insert(Abastecimento: TAbastecimento): Boolean;
    function GetTotalDia(Data: TDateTime): Double;
    function GetImpostoDia(Data: TDateTime): Double;
  end;

implementation

{ TAbastecimentoRepository }

constructor TAbastecimentoRepository.Create;
begin
  inherited Create;
  FConnection := TDatabaseConnection.GetInstance.Connection;
end;

function TAbastecimentoRepository.GetAll(DataInicio: TDateTime = 0; 
  DataFim: TDateTime = 0): TObjectList<TAbastecimento>;
var
  Query: TFDQuery;
  Abastecimento: TAbastecimento;
  SQL: string;
begin
  Result := TObjectList<TAbastecimento>.Create;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConnection;
    
    SQL := 'SELECT A.ID, A.BOMBA_ID, B.NUMERO_BOMBA, T.TIPO_COMBUSTIVEL, ' +
           'A.DATA_HORA, A.LITROS, A.VALOR_TOTAL, A.IMPOSTO, A.VALOR_COM_IMPOSTO ' +
           'FROM ABASTECIMENTOS A ' +
           'INNER JOIN BOMBAS B ON A.BOMBA_ID = B.ID ' +
           'INNER JOIN TANQUES T ON B.TANQUE_ID = T.ID ';
    
    if (DataInicio > 0) and (DataFim > 0) then
      SQL := SQL + 'WHERE A.DATA_HORA BETWEEN :DataInicio AND :DataFim ';
    
    SQL := SQL + 'ORDER BY A.DATA_HORA DESC';
    
    Query.SQL.Text := SQL;
    
    if (DataInicio > 0) and (DataFim > 0) then
    begin
      Query.ParamByName('DataInicio').AsDateTime := DataInicio;
      Query.ParamByName('DataFim').AsDateTime := DataFim;
    end;
    
    Query.Open;
    
    while not Query.Eof do
    begin
      Abastecimento := TAbastecimento.Create;
      Abastecimento.ID := Query.FieldByName('ID').AsInteger;
      Abastecimento.BombaID := Query.FieldByName('BOMBA_ID').AsInteger;
      Abastecimento.NumeroBomba := Query.FieldByName('NUMERO_BOMBA').AsInteger;
      Abastecimento.TipoCombustivel := Query.FieldByName('TIPO_COMBUSTIVEL').AsString;
      Abastecimento.DataHora := Query.FieldByName('DATA_HORA').AsDateTime;
      Abastecimento.Litros := Query.FieldByName('LITROS').AsFloat;
      Abastecimento.ValorTotal := Query.FieldByName('VALOR_TOTAL').AsFloat;
      Abastecimento.Imposto := Query.FieldByName('IMPOSTO').AsFloat;
      Abastecimento.ValorComImposto := Query.FieldByName('VALOR_COM_IMPOSTO').AsFloat;
      Result.Add(Abastecimento);
      Query.Next;
    end;
  finally
    Query.Free;
  end;
end;

function TAbastecimentoRepository.GetById(ID: Integer): TAbastecimento;
var
  Query: TFDQuery;
begin
  Result := nil;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConnection;
    Query.SQL.Text := 'SELECT A.ID, A.BOMBA_ID, B.NUMERO_BOMBA, T.TIPO_COMBUSTIVEL, ' +
                      'A.DATA_HORA, A.LITROS, A.VALOR_TOTAL, A.IMPOSTO, A.VALOR_COM_IMPOSTO ' +
                      'FROM ABASTECIMENTOS A ' +
                      'INNER JOIN BOMBAS B ON A.BOMBA_ID = B.ID ' +
                      'INNER JOIN TANQUES T ON B.TANQUE_ID = T.ID ' +
                      'WHERE A.ID = :ID';
    Query.ParamByName('ID').AsInteger := ID;
    Query.Open;
    
    if not Query.IsEmpty then
    begin
      Result := TAbastecimento.Create;
      Result.ID := Query.FieldByName('ID').AsInteger;
      Result.BombaID := Query.FieldByName('BOMBA_ID').AsInteger;
      Result.NumeroBomba := Query.FieldByName('NUMERO_BOMBA').AsInteger;
      Result.TipoCombustivel := Query.FieldByName('TIPO_COMBUSTIVEL').AsString;
      Result.DataHora := Query.FieldByName('DATA_HORA').AsDateTime;
      Result.Litros := Query.FieldByName('LITROS').AsFloat;
      Result.ValorTotal := Query.FieldByName('VALOR_TOTAL').AsFloat;
      Result.Imposto := Query.FieldByName('IMPOSTO').AsFloat;
      Result.ValorComImposto := Query.FieldByName('VALOR_COM_IMPOSTO').AsFloat;
    end;
  finally
    Query.Free;
  end;
end;

function TAbastecimentoRepository.Insert(Abastecimento: TAbastecimento): Boolean;
var
  Query: TFDQuery;
begin
  Result := False;
  Query := TFDQuery.Create(nil);
  try
    try
      FConnection.StartTransaction;
      
      Abastecimento.ID := TRepositorioUtils.GetNextID(FConnection, 'GEN_ABASTECIMENTOS_ID');
      
      Query.Connection := FConnection;
      Query.SQL.Text := 'INSERT INTO ABASTECIMENTOS (ID, BOMBA_ID, DATA_HORA, LITROS, ' +
                        'VALOR_TOTAL, IMPOSTO, VALOR_COM_IMPOSTO) ' +
                        'VALUES (:ID, :BombaID, :DataHora, :Litros, :ValorTotal, ' +
                        ':Imposto, :ValorComImposto)';
      Query.ParamByName('ID').AsInteger := Abastecimento.ID;
      Query.ParamByName('BombaID').AsInteger := Abastecimento.BombaID;
      Query.ParamByName('DataHora').AsDateTime := Abastecimento.DataHora;
      Query.ParamByName('Litros').AsFloat := Abastecimento.Litros;
      Query.ParamByName('ValorTotal').AsFloat := Abastecimento.ValorTotal;
      Query.ParamByName('Imposto').AsFloat := Abastecimento.Imposto;
      Query.ParamByName('ValorComImposto').AsFloat := Abastecimento.ValorComImposto;
      Query.ExecSQL;
      
      // Atualizar estoque do tanque
      Query.SQL.Text := 'UPDATE TANQUES SET ESTOQUE_ATUAL = ESTOQUE_ATUAL - :Litros ' +
                        'WHERE ID = (SELECT TANQUE_ID FROM BOMBAS WHERE ID = :BombaID)';
      Query.ParamByName('Litros').AsFloat := Abastecimento.Litros;
      Query.ParamByName('BombaID').AsInteger := Abastecimento.BombaID;
      Query.ExecSQL;
      
      FConnection.Commit;
      Result := True;
    except
      on E: Exception do
      begin
        FConnection.Rollback;
        ShowMessage('Erro ao registrar abastecimento: ' + E.Message);
      end;
    end;
  finally
    Query.Free;
  end;
end;

function TAbastecimentoRepository.GetTotalDia(Data: TDateTime): Double;
var
  Query: TFDQuery;
  DataInicio, DataFim: TDateTime;
begin
  Result := 0;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConnection;
    
    DataInicio := Trunc(Data);
    DataFim := DataInicio + 1;
    
    Query.SQL.Text := 'SELECT SUM(VALOR_COM_IMPOSTO) AS TOTAL FROM ABASTECIMENTOS ' +
                      'WHERE DATA_HORA >= :DataInicio AND DATA_HORA < :DataFim';
    Query.ParamByName('DataInicio').AsDateTime := DataInicio;
    Query.ParamByName('DataFim').AsDateTime := DataFim;
    Query.Open;
    
    if not Query.IsEmpty then
      Result := Query.FieldByName('TOTAL').AsFloat;
  finally
    Query.Free;
  end;
end;

function TAbastecimentoRepository.GetImpostoDia(Data: TDateTime): Double;
var
  Query: TFDQuery;
  DataInicio, DataFim: TDateTime;
begin
  Result := 0;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConnection;
    
    DataInicio := Trunc(Data);
    DataFim := DataInicio + 1;
    
    Query.SQL.Text := 'SELECT SUM(IMPOSTO) AS TOTAL_IMPOSTO FROM ABASTECIMENTOS ' +
                      'WHERE DATA_HORA >= :DataInicio AND DATA_HORA < :DataFim';
    Query.ParamByName('DataInicio').AsDateTime := DataInicio;
    Query.ParamByName('DataFim').AsDateTime := DataFim;
    Query.Open;
    
    if not Query.IsEmpty then
      Result := Query.FieldByName('TOTAL_IMPOSTO').AsFloat;
  finally
    Query.Free;
  end;
end;

end.
