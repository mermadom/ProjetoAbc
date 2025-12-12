unit uAbastecimentoController;

interface

uses
  System.SysUtils, System.Generics.Collections, System.Classes,
  uAbastecimento, uAbastecimentoRepository, uDatabaseConnection, System.IniFiles;

type
  TAbastecimentoController = class
  private
    FAbastRepo: TAbastecimentoRepository;
  public
    constructor Create;
    destructor Destroy; override;

    function GetAll(DataInicio: TDateTime = 0; DataFim: TDateTime = 0): TObjectList<TAbastecimento>;
    function GetById(ID: Integer): TAbastecimento;
    function Insert(Abastecimento: TAbastecimento): Boolean;
    function GetTotalDia(Data: TDateTime): Double;
    function GetImpostoDia(Data: TDateTime): Double;
    function CalcularImposto(ValorTotal: Double): Double;
  end;

implementation

{ TAbastecimentoController }

constructor TAbastecimentoController.Create;
begin
  inherited Create;
  FAbastRepo := TAbastecimentoRepository.Create;
end;

destructor TAbastecimentoController.Destroy;
begin
  FAbastRepo.Free;
  inherited Destroy;
end;

function TAbastecimentoController.GetAll(DataInicio: TDateTime = 0; 
  DataFim: TDateTime = 0): TObjectList<TAbastecimento>;
begin
  Result := FAbastRepo.GetAll(DataInicio, DataFim);
end;

function TAbastecimentoController.GetById(ID: Integer): TAbastecimento;
begin
  Result := FAbastRepo.GetById(ID);
end;

function TAbastecimentoController.Insert(Abastecimento: TAbastecimento): Boolean;
begin
  Result := FAbastRepo.Insert(Abastecimento);
end;

function TAbastecimentoController.GetTotalDia(Data: TDateTime): Double;
begin
  Result := FAbastRepo.GetTotalDia(Data);
end;

function TAbastecimentoController.GetImpostoDia(Data: TDateTime): Double;
begin
  Result := FAbastRepo.GetImpostoDia(Data);
end;

function TAbastecimentoController.CalcularImposto(ValorTotal: Double): Double;
var
  TaxRate: Double;
  IniFile: TIniFile;
  AppPath: string;
begin
  AppPath := ExtractFilePath(ParamStr(0));
  IniFile := TIniFile.Create(AppPath + 'Config.ini');
  try
    TaxRate := IniFile.ReadFloat('SYSTEM', 'TaxRate', 0.13);
  finally
    IniFile.Free;
  end;
  Result := ValorTotal * TaxRate;
end;

end.

