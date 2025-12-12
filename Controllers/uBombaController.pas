unit uBombaController;

interface

uses
  System.SysUtils, System.Generics.Collections, System.Classes,
  uBomba, uBombaRepository;

type
  TBombaController = class
  private
    FBombaRepo: TBombaRepository;
  public
    constructor Create;
    destructor Destroy; override;

    function GetAll: TObjectList<TBomba>;
    function GetById(ID: Integer): TBomba;
    function GetEstoqueTanque(BombaID: Integer): Double;
    function Insert(Bomba: TBomba): Boolean;
    function Update(Bomba: TBomba): Boolean;
    function Delete(ID: Integer): Boolean;
  end;

implementation

{ TBombaController }

constructor TBombaController.Create;
begin
  inherited Create;
  FBombaRepo := TBombaRepository.Create;
end;

destructor TBombaController.Destroy;
begin
  FBombaRepo.Free;
  inherited Destroy;
end;

function TBombaController.GetAll: TObjectList<TBomba>;
begin
  Result := FBombaRepo.GetAll;
end;

function TBombaController.GetById(ID: Integer): TBomba;
begin
  Result := FBombaRepo.GetById(ID);
end;

function TBombaController.GetEstoqueTanque(BombaID: Integer): Double;
begin
  Result := FBombaRepo.GetEstoqueTanque(BombaID);
end;

function TBombaController.Insert(Bomba: TBomba): Boolean;
begin
  Result := FBombaRepo.Insert(Bomba);
end;

function TBombaController.Update(Bomba: TBomba): Boolean;
begin
  Result := FBombaRepo.Update(Bomba);
end;

function TBombaController.Delete(ID: Integer): Boolean;
begin
  Result := FBombaRepo.Delete(ID);
end;

end.
