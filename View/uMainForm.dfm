object MainForm: TMainForm
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Posto ABC - Sistema de Gerenciamento de Abastecimento'
  ClientHeight = 623
  ClientWidth = 947
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  FormStyle = fsMDIForm
  Menu = MainMenu1
  Position = poScreenCenter
  Visible = True
  OnCreate = FormCreate
  TextHeight = 15
  object pnlPrincipal: TPanel
    Left = 0
    Top = 0
    Width = 947
    Height = 623
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
  end
  object MainMenu1: TMainMenu
    Left = 104
    Top = 80
    object Menu_Operacoes: TMenuItem
      Caption = '&Opera'#231#245'es'
      object Menu_Abastecimento: TMenuItem
        Caption = '&Abastecer'
        OnClick = Menu_AbastecimentoClick
      end
    end
    object Menu_Cadastros: TMenuItem
      Caption = '&Cadastros'
      object Menu_Tanques: TMenuItem
        Caption = '&Tanques'
        OnClick = Menu_TanquesClick
      end
      object Menu_Bombas: TMenuItem
        Caption = '&Bombas'
        OnClick = Menu_BombasClick
      end
    end
    object Menu_Relatorios: TMenuItem
      Caption = '&Relat'#243'rios'
      object Menu_Relatorio_Resumo: TMenuItem
        Caption = '&Resumo de Abastecimentos'
        OnClick = Menu_Relatorio_ResumoClick
      end
    end
    object Menu_Sair: TMenuItem
      Caption = '&Sair'
      OnClick = Menu_SairClick
    end
  end
end
