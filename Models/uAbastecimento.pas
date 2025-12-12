unit uAbastecimento;

interface

uses
  System.SysUtils;

type
  TAbastecimento = class
  private
    FID: Integer;
    FBombaID: Integer;
    FNumeroBomba: Integer;
    FTipoCombustivel: string;
    FDataHora: TDateTime;
    FLitros: Double;
    FValorTotal: Double;
    FImposto: Double;
    FValorComImposto: Double;
  public
    property ID: Integer read FID write FID;
    property BombaID: Integer read FBombaID write FBombaID;
    property NumeroBomba: Integer read FNumeroBomba write FNumeroBomba;
    property TipoCombustivel: string read FTipoCombustivel write FTipoCombustivel;
    property DataHora: TDateTime read FDataHora write FDataHora;
    property Litros: Double read FLitros write FLitros;
    property ValorTotal: Double read FValorTotal write FValorTotal;
    property Imposto: Double read FImposto write FImposto;
    property ValorComImposto: Double read FValorComImposto write FValorComImposto;
    
    constructor Create;
  end;

implementation

constructor TAbastecimento.Create;
begin
  inherited Create;
  FID := 0;
  FBombaID := 0;
  FNumeroBomba := 0;
  FTipoCombustivel := '';
  FDataHora := Now;
  FLitros := 0;
  FValorTotal := 0;
  FImposto := 0;
  FValorComImposto := 0;
end;

end.
