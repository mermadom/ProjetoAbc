unit uRepositorioUtils;

interface

uses
  System.SysUtils, FireDAC.Comp.Client;

type
  TRepositorioUtils = class
  public
    /// <summary>
    /// Obtém o próximo ID disponível usando um generator do Firebird
    /// </summary>
    /// <param name="Connection">Conexão com o banco de dados</param>
    /// <param name="GeneratorName">Nome do generator (ex: 'GEN_ABASTECIMENTOS_ID')</param>
    class function GetNextID(Connection: TFDConnection; const GeneratorName: string): Integer;
    
    /// <summary>
    /// Verifica se um registro existe na tabela
    /// </summary>
    /// <param name="Connection">Conexão com o banco de dados</param>
    /// <param name="TableName">Nome da tabela</param>
    /// <param name="ID">ID do registro</param>
    class function RegistroExiste(Connection: TFDConnection; const TableName: string; ID: Integer): Boolean;
  end;

implementation

class function TRepositorioUtils.GetNextID(Connection: TFDConnection; const GeneratorName: string): Integer;
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := Connection;
    Query.SQL.Text := Format('SELECT GEN_ID(%s, 1) FROM RDB$DATABASE', [GeneratorName]);
    Query.Open;
    Result := Query.Fields[0].AsInteger;
  finally
    Query.Free;
  end;
end;

class function TRepositorioUtils.RegistroExiste(Connection: TFDConnection; const TableName: string; ID: Integer): Boolean;
var
  Query: TFDQuery;
begin
  Result := False;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := Connection;
    Query.SQL.Text := Format('SELECT COUNT(*) FROM %s WHERE ID = :ID', [TableName]);
    Query.ParamByName('ID').AsInteger := ID;
    Query.Open;
    Result := Query.Fields[0].AsInteger > 0;
  finally
    Query.Free;
  end;
end;

end.
