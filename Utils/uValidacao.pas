unit uValidacao;

interface

uses
  System.SysUtils, Vcl.StdCtrls;

type
  TValidacao = class
  public
    /// <summary>
    /// Valida entrada numérica (números decimais)
    /// Permite: 0-9 e separador decimal (apenas uma vez)
    /// Permite: Backspace e Delete para edição
    /// Bloqueia: Letras e caracteres especiais
    /// </summary>
    class procedure ValidarEntradaNumerica(Sender: TObject; var Key: Char);
  end;

implementation

class procedure TValidacao.ValidarEntradaNumerica(Sender: TObject; var Key: Char);
var
  Edit: TEdit;
  DecimalSeparator: Char;
begin
  Edit := Sender as TEdit;
  DecimalSeparator := FormatSettings.DecimalSeparator;


  if CharInSet(Key, ['0'..'9']) then
    Exit;
  
  // Permitir backspace e delete
  if CharInSet(Key,[#8, #127]) then
    Exit;
  
  // Permitir separador decimal (apenas uma vez)
  if (Key = DecimalSeparator) and (Pos(DecimalSeparator, Edit.Text) = 0) then
    Exit;
  
  // Cancelar qualquer outra tecla
  Key := #0;
end;

end.
