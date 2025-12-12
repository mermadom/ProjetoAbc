unit uBomba;

interface

type
  TBomba = class
  private
    FID: Integer;
    FNumeroBomba: Integer;
    FTanqueID: Integer;
    FTipoCombustivel: string;
    FEstoqueTanque: Double;
  public
    property ID: Integer read FID write FID;
    property NumeroBomba: Integer read FNumeroBomba write FNumeroBomba;
    property TanqueID: Integer read FTanqueID write FTanqueID;
    property TipoCombustivel: string read FTipoCombustivel write FTipoCombustivel;
    property EstoqueTanque: Double read FEstoqueTanque write FEstoqueTanque;
    
    constructor Create;
  end;

implementation

constructor TBomba.Create;
begin
  inherited Create;
  FID := 0;
  FNumeroBomba := 0;
  FTanqueID := 0;
  FTipoCombustivel := '';
  FEstoqueTanque := 0;
end;

end.
