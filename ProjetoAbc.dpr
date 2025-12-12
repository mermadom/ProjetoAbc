program ProjetoAbc;

uses
  Vcl.Forms,
  uMainForm in 'View\uMainForm.pas' {MainForm},
  uAbastecerView in 'View\uAbastecerView.pas' {AbastecerForm},
  uTanqueView in 'View\uTanqueView.pas' {TanqueForm},
  uBombaView in 'View\uBombaView.pas' {BombaForm},
  uRelatorioView in 'View\uRelatorioView.pas' {RelatorioForm},
  uDatabaseConnection in 'Connection\uDatabaseConnection.pas',
  uTanque in 'Models\uTanque.pas',
  uBomba in 'Models\uBomba.pas',
  uAbastecimento in 'Models\uAbastecimento.pas',
  uTanqueRepository in 'Repositories\uTanqueRepository.pas',
  uBombaRepository in 'Repositories\uBombaRepository.pas',
  uAbastecimentoRepository in 'Repositories\uAbastecimentoRepository.pas',
  uAbastecimentoController in 'Controllers\uAbastecimentoController.pas',
  uBombaController in 'Controllers\uBombaController.pas',
  uTanqueController in 'Controllers\uTanqueController.pas',
  uValidacao in 'Utils\uValidacao.pas',
  Vcl.Themes,
  Vcl.Styles,
  uRepositorioUtils in 'Repositories\uRepositorioUtils.pas',
  uAbastecimentoReport in 'View\uAbastecimentoReport.pas' {AbastecimentoReportForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Amethyst Kamri');
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
