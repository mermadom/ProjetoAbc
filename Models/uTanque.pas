unit uTanque;

interface

type
  TTanque = class
  private
    FID: Integer;
    FTipoCombustivel: string;
    FCapacidadeLitros: Double;
    FEstoqueAtual: Double;
  public
    property ID: Integer read FID write FID;
    property TipoCombustivel: string read FTipoCombustivel write FTipoCombustivel;
    property CapacidadeLitros: Double read FCapacidadeLitros write FCapacidadeLitros;
    property EstoqueAtual: Double read FEstoqueAtual write FEstoqueAtual;
    
    constructor Create;
  end;

implementation

constructor TTanque.Create;
begin
  inherited Create;
  FID := 0;
  FTipoCombustivel := '';
  FCapacidadeLitros := 0;
  FEstoqueAtual := 0;
end;

end.
