unit uTanqueRepository;

interface

uses
  System.SysUtils, System.Generics.Collections, FireDAC.Comp.Client,
  FireDAC.Stan.Param, Data.DB, uTanque, uDatabaseConnection, uRepositorioUtils;

type
  TTanqueRepository = class
  private
    FConnection: TFDConnection;
  public
    constructor Create;
    function GetAll: TObjectList<TTanque>;
    function GetById(ID: Integer): TTanque;
    function AtualizarEstoque(TanqueID: Integer; Litros: Double): Boolean;
    function Insert(Tanque: TTanque): Boolean;
    function Update(Tanque: TTanque): Boolean;
    function Delete(ID: Integer): Boolean;
  end;

implementation

{ TTanqueRepository }

constructor TTanqueRepository.Create;
begin
  inherited Create;
  FConnection := TDatabaseConnection.GetInstance.Connection;
end;

function TTanqueRepository.GetAll: TObjectList<TTanque>;
var
  Query: TFDQuery;
  Tanque: TTanque;
begin
  Result := TObjectList<TTanque>.Create;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConnection;
    Query.SQL.Text := 'SELECT ID, TIPO_COMBUSTIVEL, CAPACIDADE_LITROS, ESTOQUE_ATUAL ' +
                      'FROM TANQUES ORDER BY ID';
    Query.Open;
    
    while not Query.Eof do
    begin
      Tanque := TTanque.Create;
      Tanque.ID := Query.FieldByName('ID').AsInteger;
      Tanque.TipoCombustivel := Query.FieldByName('TIPO_COMBUSTIVEL').AsString;
      Tanque.CapacidadeLitros := Query.FieldByName('CAPACIDADE_LITROS').AsFloat;
      Tanque.EstoqueAtual := Query.FieldByName('ESTOQUE_ATUAL').AsFloat;
      Result.Add(Tanque);
      Query.Next;
    end;
  finally
    Query.Free;
  end;
end;

function TTanqueRepository.GetById(ID: Integer): TTanque;
var
  Query: TFDQuery;
begin
  Result := nil;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConnection;
    Query.SQL.Text := 'SELECT ID, TIPO_COMBUSTIVEL, CAPACIDADE_LITROS, ESTOQUE_ATUAL ' +
                      'FROM TANQUES WHERE ID = :ID';
    Query.ParamByName('ID').AsInteger := ID;
    Query.Open;
    
    if not Query.IsEmpty then
    begin
      Result := TTanque.Create;
      Result.ID := Query.FieldByName('ID').AsInteger;
      Result.TipoCombustivel := Query.FieldByName('TIPO_COMBUSTIVEL').AsString;
      Result.CapacidadeLitros := Query.FieldByName('CAPACIDADE_LITROS').AsFloat;
      Result.EstoqueAtual := Query.FieldByName('ESTOQUE_ATUAL').AsFloat;
    end;
  finally
    Query.Free;
  end;
end;

function TTanqueRepository.AtualizarEstoque(TanqueID: Integer; Litros: Double): Boolean;
var
  Query: TFDQuery;
begin
  Result := False;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConnection;
    Query.SQL.Text := 'UPDATE TANQUES SET ESTOQUE_ATUAL = ESTOQUE_ATUAL - :Litros WHERE ID = :ID';
    Query.ParamByName('Litros').AsFloat := Litros;
    Query.ParamByName('ID').AsInteger := TanqueID;
    Query.ExecSQL;
    Result := True;
  finally
    Query.Free;
  end;
end;

function TTanqueRepository.Insert(Tanque: TTanque): Boolean;
var
  Query: TFDQuery;
begin
  Result := False;
  Query := TFDQuery.Create(nil);
  try
    try
      // Validar dados
      if Trim(Tanque.TipoCombustivel) = '' then
        raise Exception.Create('Tipo de combustível não pode estar vazio');
      
      if Tanque.CapacidadeLitros <= 0 then
        raise Exception.Create('Capacidade deve ser maior que 0');
      
      if Tanque.EstoqueAtual < 0 then
        raise Exception.Create('Estoque não pode ser negativo');
      
      if Tanque.EstoqueAtual > Tanque.CapacidadeLitros then
        raise Exception.Create('Estoque não pode ser maior que a capacidade');
      
      FConnection.StartTransaction;
      
      Tanque.ID := TRepositorioUtils.GetNextID(FConnection, 'GEN_TANQUES_ID');
      
      Query.Connection := FConnection;
      Query.SQL.Text := 'INSERT INTO TANQUES (ID, TIPO_COMBUSTIVEL, CAPACIDADE_LITROS, ESTOQUE_ATUAL) ' +
                        'VALUES (:ID, :TipoCombustivel, :CapacidadeLitros, :EstoqueAtual)';
      Query.ParamByName('ID').AsInteger := Tanque.ID;
      Query.ParamByName('TipoCombustivel').AsString := Trim(Tanque.TipoCombustivel);
      Query.ParamByName('CapacidadeLitros').AsFloat := Tanque.CapacidadeLitros;
      Query.ParamByName('EstoqueAtual').AsFloat := Tanque.EstoqueAtual;
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

function TTanqueRepository.Update(Tanque: TTanque): Boolean;
var
  Query: TFDQuery;
begin
  Result := False;
  Query := TFDQuery.Create(nil);
  try
    try
      // Validar dados
      if Trim(Tanque.TipoCombustivel) = '' then
        raise Exception.Create('Tipo de combustível não pode estar vazio');
      
      if Tanque.CapacidadeLitros <= 0 then
        raise Exception.Create('Capacidade deve ser maior que 0');
      
      if Tanque.EstoqueAtual > Tanque.CapacidadeLitros then
        raise Exception.Create('Estoque não pode ser maior que a capacidade');
      
      FConnection.StartTransaction;
      
      Query.Connection := FConnection;
      Query.SQL.Text := 'UPDATE TANQUES SET TIPO_COMBUSTIVEL = :TipoCombustivel, ' +
                        'CAPACIDADE_LITROS = :CapacidadeLitros, ESTOQUE_ATUAL = :EstoqueAtual ' +
                        'WHERE ID = :ID';
      Query.ParamByName('ID').AsInteger := Tanque.ID;
      Query.ParamByName('TipoCombustivel').AsString := Trim(Tanque.TipoCombustivel);
      Query.ParamByName('CapacidadeLitros').AsFloat := Tanque.CapacidadeLitros;
      Query.ParamByName('EstoqueAtual').AsFloat := Tanque.EstoqueAtual;
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

function TTanqueRepository.Delete(ID: Integer): Boolean;
var
  Query: TFDQuery;
begin
  Result := False;
  Query := TFDQuery.Create(nil);
  try
    try
      if ID <= 0 then
        raise Exception.Create('ID do tanque é inválido');
      
      FConnection.StartTransaction;
      
      // Verificar se há bombas associadas ao tanque
      Query.Connection := FConnection;
      Query.SQL.Text := 'SELECT COUNT(*) AS QTD FROM BOMBAS WHERE TANQUE_ID = :ID';
      Query.ParamByName('ID').AsInteger := ID;
      Query.Open;
      
      if Query.FieldByName('QTD').AsInteger > 0 then
        raise Exception.Create('Não é possível excluir o tanque. Há bombas associadas a este tanque.');
      
      Query.Close;
      
      // Excluir o tanque
      Query.SQL.Text := 'DELETE FROM TANQUES WHERE ID = :ID';
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
