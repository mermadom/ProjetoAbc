unit uMainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Imaging.pngimage,uAbastecerView;

type
  TMainForm = class(TForm)
    MainMenu1: TMainMenu;
    Menu_Operacoes: TMenuItem;
    Menu_Abastecimento: TMenuItem;
    Menu_Cadastros: TMenuItem;
    Menu_Tanques: TMenuItem;
    Menu_Bombas: TMenuItem;
    Menu_Relatorios: TMenuItem;
    Menu_Relatorio_Resumo: TMenuItem;
    Menu_Sair: TMenuItem;
    pnlPrincipal: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure Menu_AbastecimentoClick(Sender: TObject);
    procedure Menu_TanquesClick(Sender: TObject);
    procedure Menu_BombasClick(Sender: TObject);
    procedure Menu_SairClick(Sender: TObject);
    procedure Menu_Relatorio_ResumoClick(Sender: TObject);
    procedure btnAbastecimentoClick(Sender: TObject);
    procedure btnTanquesClick(Sender: TObject);
    procedure btnBombasClick(Sender: TObject);
    procedure btnRelatoriosClick(Sender: TObject);
  private
    { Private declarations }
    procedure AbrirTelaAbastecimento;
    procedure AbrirTelaTanques;
    procedure AbrirTelaBombas;
    procedure AbrirTelaRelatorioPrincipal;
  public
    { Public declarations }
    FAbastecerForm: TAbastecerForm;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
uTanqueView, uBombaView, uRelatorioView;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FAbastecerForm := nil;
end;

procedure TMainForm.Menu_AbastecimentoClick(Sender: TObject);
begin
  AbrirTelaAbastecimento;
end;

procedure TMainForm.Menu_TanquesClick(Sender: TObject);
begin
  AbrirTelaTanques;
end;

procedure TMainForm.Menu_BombasClick(Sender: TObject);
begin
  AbrirTelaBombas;
end;

procedure TMainForm.Menu_Relatorio_ResumoClick(Sender: TObject);
begin
  AbrirTelaRelatorioPrincipal;
end;


procedure TMainForm.Menu_SairClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.btnAbastecimentoClick(Sender: TObject);
begin
  AbrirTelaAbastecimento;
end;

procedure TMainForm.btnTanquesClick(Sender: TObject);
begin
  AbrirTelaTanques;
end;

procedure TMainForm.btnBombasClick(Sender: TObject);
begin
  AbrirTelaBombas;
end;

procedure TMainForm.btnRelatoriosClick(Sender: TObject);
begin
  AbrirTelaRelatorioPrincipal;
end;

procedure TMainForm.AbrirTelaAbastecimento;
begin
  try
    if Assigned(FAbastecerForm) then
    begin
      FAbastecerForm.BringToFront;
      Exit;
    end;

    pnlPrincipal.Visible := False;
    FAbastecerForm := TAbastecerForm.Create(Self);
    FAbastecerForm.Show;
  except
    on E: Exception do
    begin
      ShowMessage('Erro ao abrir tela de abastecimento: ' + E.Message);
    end;
  end;
end;

procedure TMainForm.AbrirTelaTanques;
var
  frmTanques: TTanqueForm;
begin
  frmTanques := TTanqueForm.Create(Application);
  try
    frmTanques.ShowModal;
  finally
    frmTanques.Free;
  end;
end;

procedure TMainForm.AbrirTelaBombas;
var
  frmBombas: TBombaForm;
begin
  frmBombas := TBombaForm.Create(Application);
  try
    frmBombas.ShowModal;
  finally
    frmBombas.Free;
  end;
end;

procedure TMainForm.AbrirTelaRelatorioPrincipal;
var
  frmRelatorio: TRelatorioForm;
begin
  frmRelatorio := TRelatorioForm.Create(Application);
  try
    frmRelatorio.ShowModal;
  finally
    frmRelatorio.Free;
  end;
end;

end.
