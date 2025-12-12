unit uDatabaseConnection;

interface

uses
  System.SysUtils, System.IniFiles, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, FireDAC.Comp.Client, Data.DB,
  FireDAC.DApt;

type
  TDatabaseConnection = class
  private
    class var FInstance: TDatabaseConnection;
    FConnection: TFDConnection;
    FDriverLink: TFDPhysFBDriverLink;
    
    function GetConnection: TFDConnection;
    
    constructor Create;
    procedure LoadConfiguration;
  public
    class function GetInstance: TDatabaseConnection;
    class procedure ReleaseInstance;
    
    property Connection: TFDConnection read GetConnection;

    destructor Destroy; override;
  end;

implementation

uses
  Vcl.Dialogs;

{ TDatabaseConnection }

function TDatabaseConnection.GetConnection: TFDConnection;
begin
  Result := FConnection;
end;

constructor TDatabaseConnection.Create;
begin
  inherited Create;
  
  FDriverLink := TFDPhysFBDriverLink.Create(nil);
  FDriverLink.VendorLib := ExtractFilePath(ParamStr(0)) + 'fbclient.dll';
  
  FConnection := TFDConnection.Create(nil);
  FConnection.DriverName := 'FB';

  LoadConfiguration;
  
  try
    FConnection.Connected := True;
  except
    on E: Exception do
      raise Exception.Create('Erro ao conectar ao banco de dados: ' + E.Message);
  end;
end;

destructor TDatabaseConnection.Destroy;
begin
  if Assigned(FConnection) then
  begin
    FConnection.Connected := False;
    FConnection.Free;
  end;
  
  if Assigned(FDriverLink) then
    FDriverLink.Free;
    
  inherited;
end;

class function TDatabaseConnection.GetInstance: TDatabaseConnection;
begin
  if not Assigned(FInstance) then
    FInstance := TDatabaseConnection.Create;
  Result := FInstance;
end;

class procedure TDatabaseConnection.ReleaseInstance;
begin
  if Assigned(FInstance) then
  begin
    FInstance.Free;
    FInstance := nil;
  end;
end;

procedure TDatabaseConnection.LoadConfiguration;
var
  IniFile: TIniFile;
  AppPath: string;
begin
  AppPath := ExtractFilePath(ParamStr(0));
  IniFile := TIniFile.Create(AppPath + 'Config.ini');
  try
    FConnection.Params.Clear;
    FConnection.Params.DriverID := 'FB';
    FConnection.Params.Database := IniFile.ReadString('DATABASE', 'Database', '');
    FConnection.Params.UserName := IniFile.ReadString('DATABASE', 'UserName', 'SYSDBA');
    FConnection.Params.Password := IniFile.ReadString('DATABASE', 'Password', 'masterkey');
  finally
    IniFile.Free;
  end;
end;


initialization

finalization
  TDatabaseConnection.ReleaseInstance;

end.
