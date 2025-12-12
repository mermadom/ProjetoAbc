unit uBombaRepository;

interface

uses
  System.SysUtils, System.Generics.Collections, FireDAC.Comp.Client,
  FireDAC.Stan.Param, Data.DB, uBomba,uDatabaseConnection, uRepositorioUtils;

type
  TBombaRepository = class
  private
    FConnection: TFDConnection;
  public
    constructor Create;
    function GetAll: TObjectList<TBomba>;
    function GetById(ID: Integer): TBomba;
    function GetEstoqueTanque(BombaID: Integer): Double;
    function Insert(Bomba: TBomba): Boolean;
    function Update(Bomba: TBomba): Boolean;
    function Delete(ID: Integer): Boolean;
  end;

implementation

{ TBombaRepository }

constructor TBombaRepository.Create;
begin
  inherited Create;
  FConnection := TDatabaseConnection.GetInstance.Connection;
end;

function TBombaRepository.GetAll: TObjectList<TBomba>;
var
  Query: TFDQuery;
  Bomba: TBomba;
begin
  Result := TObjectList<TBomba>.Create;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConnection;
    Query.SQL.Text := 'SELECT B.ID, B.NUMERO_BOMBA, B.TANQUE_ID, ' +
                      'T.TIPO_COMBUSTIVEL, T.ESTOQUE_ATUAL ' +
                      'FROM BOMBAS B ' +
                      'INNER JOIN TANQUES T ON B.TANQUE_ID = T.ID ' +
                      'ORDER BY B.NUMERO_BOMBA';
    Query.Open;
    
    while not Query.Eof do
    begin
      Bomba := TBomba.Create;
      Bomba.ID := Query.FieldByName('ID').AsInteger;
      Bomba.NumeroBomba := Query.FieldByName('NUMERO_BOMBA').AsInteger;
      Bomba.TanqueID := Query.FieldByName('TANQUE_ID').AsInteger;
      Bomba.TipoCombustivel := Query.FieldByName('TIPO_COMBUSTIVEL').AsString;
      Bomba.EstoqueTanque := Query.FieldByName('ESTOQUE_ATUAL').AsFloat;
      Result.Add(Bomba);
      Query.Next;
    end;
  finally
    Query.Free;
  end;
end;

function TBombaRepository.GetById(ID: Integer): TBomba;
var
  Query: TFDQuery;
begin
  Result := nil;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConnection;
    Query.SQL.Text := 'SELECT B.ID, B.NUMERO_BOMBA, B.TANQUE_ID, ' +
                      'T.TIPO_COMBUSTIVEL, T.ESTOQUE_ATUAL ' +
                      'FROM BOMBAS B ' +
                      'INNER JOIN TANQUES T ON B.TANQUE_ID = T.ID ' +
                      'WHERE B.ID = :ID';
    Query.ParamByName('ID').AsInteger := ID;
    Query.Open;
    
    if not Query.IsEmpty then
    begin
      Result := TBomba.Create;
      Result.ID := Query.FieldByName('ID').AsInteger;
      Result.NumeroBomba := Query.FieldByName('NUMERO_BOMBA').AsInteger;
      Result.TanqueID := Query.FieldByName('TANQUE_ID').AsInteger;
      Result.TipoCombustivel := Query.FieldByName('TIPO_COMBUSTIVEL').AsString;
      Result.EstoqueTanque := Query.FieldByName('ESTOQUE_ATUAL').AsFloat;
    end;
  finally
    Query.Free;
  end;
end;

function TBombaRepository.GetEstoqueTanque(BombaID: Integer): Double;
var
  Query: TFDQuery;
begin
  Result := 0;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConnection;
    Query.SQL.Text := 'SELECT T.ESTOQUE_ATUAL FROM TANQUES T ' +
                      'INNER JOIN BOMBAS B ON B.TANQUE_ID = T.ID ' +
                      'WHERE B.ID = :BombaID';
    Query.ParamByName('BombaID').AsInteger := BombaID;
    Query.Open;
    
    if not Query.IsEmpty then
      Result := Query.FieldByName('ESTOQUE_ATUAL').AsFloat;
  finally
    Query.Free;
  end;
end;

function TBombaRepository.Insert(Bomba: TBomba): Boolean;
var
  Query: TFDQuery;
begin
  Result := False;
  Query := TFDQuery.Create(nil);
  try
    try
      // Validar dados
      if Bomba.NumeroBomba <= 0 then
        raise Exception.Create('Número da bomba deve ser maior que 0');
      
      if Bomba.TanqueID <= 0 then
        raise Exception.Create('ID do tanque é obrigatório');
      
      FConnection.StartTransaction;
      
      Bomba.ID := TRepositorioUtils.GetNextID(FConnection, 'GEN_BOMBAS_ID');
      
      Query.Connection := FConnection;
      Query.SQL.Text := 'INSERT INTO BOMBAS (ID, NUMERO_BOMBA, TANQUE_ID) ' +
                        'VALUES (:ID, :NumeroBomba, :TanqueID)';
      Query.ParamByName('ID').AsInteger := Bomba.ID;
      Query.ParamByName('NumeroBomba').AsInteger := Bomba.NumeroBomba;
      Query.ParamByName('TanqueID').AsInteger := Bomba.TanqueID;
      Query.ExecSQL;
      
      FConnection.Commit;
      Result := True;
    except
      on E: Exception do
      begin
        FConnection.Rollback;
        raise;
      end;
    end;
  finally
    Query.Free;
  end;
end;

function TBombaRepository.Update(Bomba: TBomba): Boolean;
var
  Query: TFDQuery;
begin
  Result := False;
  Query := TFDQuery.Create(nil);
  try
    try
      // Validar dados
      if Bomba.NumeroBomba <= 0 then
        raise Exception.Create('Número da bomba deve ser maior que 0');
      
      if Bomba.TanqueID <= 0 then
        raise Exception.Create('ID do tanque é obrigatório');
      
      FConnection.StartTransaction;
      
      Query.Connection := FConnection;
      Query.SQL.Text := 'UPDATE BOMBAS SET NUMERO_BOMBA = :NumeroBomba, TANQUE_ID = :TanqueID ' +
                        'WHERE ID = :ID';
      Query.ParamByName('ID').AsInteger := Bomba.ID;
      Query.ParamByName('NumeroBomba').AsInteger := Bomba.NumeroBomba;
      Query.ParamByName('TanqueID').AsInteger := Bomba.TanqueID;
      Query.ExecSQL;
      
      FConnection.Commit;
      Result := True;
    except
      on E: Exception do
      begin
        FConnection.Rollback;
        raise;
      end;
    end;
  finally
    Query.Free;
  end;
end;

function TBombaRepository.Delete(ID: Integer): Boolean;
var
  Query: TFDQuery;
begin
  Result := False;
  Query := TFDQuery.Create(nil);
  try
    try
      if ID <= 0 then
        raise Exception.Create('ID da bomba é inválido');
      
      FConnection.StartTransaction;
      
      // Verificar se há abastecimentos associados à bomba
      Query.Connection := FConnection;
      Query.SQL.Text := 'SELECT COUNT(*) AS QTD FROM ABASTECIMENTOS WHERE BOMBA_ID = :ID';
      Query.ParamByName('ID').AsInteger := ID;
      Query.Open;
      
      if Query.FieldByName('QTD').AsInteger > 0 then
        raise Exception.Create('Não é possível excluir a bomba. Há abastecimentos registrados para esta bomba.');
      
      Query.Close;
      
      // Excluir a bomba
      Query.SQL.Text := 'DELETE FROM BOMBAS WHERE ID = :ID';
      Query.ParamByName('ID').AsInteger := ID;
      Query.ExecSQL;
      
      FConnection.Commit;
      Result := True;
    except
      on E: Exception do
      begin
        FConnection.Rollback;
        raise;
      end;
    end;
  finally
    Query.Free;
  end;
end;

end.
