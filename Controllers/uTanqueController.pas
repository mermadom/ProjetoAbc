unit uTanqueController;

interface

uses
  System.SysUtils, System.Generics.Collections, System.Classes,
  uTanque, uTanqueRepository;

type
  TTanqueController = class
  private
    FTanqueRepo: TTanqueRepository;
  public
    constructor Create;
    destructor Destroy; override;

    function GetAll: TObjectList<TTanque>;
    function GetById(ID: Integer): TTanque;
    function AtualizarEstoque(TanqueID: Integer; Litros: Double): Boolean;
    function Insert(Tanque: TTanque): Boolean;
    function Update(Tanque: TTanque): Boolean;
    function Delete(ID: Integer): Boolean;
  end;

implementation

{ TTanqueController }

constructor TTanqueController.Create;
begin
  inherited Create;
  FTanqueRepo := TTanqueRepository.Create;
end;

destructor TTanqueController.Destroy;
begin
  FTanqueRepo.Free;
  inherited Destroy;
end;

function TTanqueController.GetAll: TObjectList<TTanque>;
begin
  Result := FTanqueRepo.GetAll;
end;

function TTanqueController.GetById(ID: Integer): TTanque;
begin
  Result := FTanqueRepo.GetById(ID);
end;

function TTanqueController.AtualizarEstoque(TanqueID: Integer; Litros: Double): Boolean;
begin
  Result := FTanqueRepo.AtualizarEstoque(TanqueID, Litros);
end;

function TTanqueController.Insert(Tanque: TTanque): Boolean;
begin
  Result := FTanqueRepo.Insert(Tanque);
end;

function TTanqueController.Update(Tanque: TTanque): Boolean;
begin
  Result := FTanqueRepo.Update(Tanque);
end;

function TTanqueController.Delete(ID: Integer): Boolean;
begin
  Result := FTanqueRepo.Delete(ID);
end;

end.
