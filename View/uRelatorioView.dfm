object RelatorioForm: TRelatorioForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Relat'#243'rio Abastecimentos'
  ClientHeight = 600
  ClientWidth = 900
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object pnlMiddle: TPanel
    Left = 0
    Top = 150
    Width = 900
    Height = 380
    Align = alClient
    TabOrder = 0
    object lblEstoque: TLabel
      Left = 16
      Top = 16
      Width = 106
      Height = 15
      Caption = 'Estado dos Tanques'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblHistorico: TLabel
      Left = 450
      Top = 16
      Width = 159
      Height = 15
      Caption = 'Hist'#243'rico de Abastecimentos'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object memoEstoque: TMemo
      Left = 16
      Top = 40
      Width = 400
      Height = 320
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
    object dbgHistorico: TDBGrid
      Left = 450
      Top = 40
      Width = 430
      Height = 320
      DataSource = dsHistorico
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -12
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          FieldName = 'ID'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Bomba'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Combust'#195#173'vel'
          Title.Caption = 'Combust'#237'vel'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Data/Hora'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Litros'
          Visible = True
        end>
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 530
    Width = 900
    Height = 70
    Align = alBottom
    TabOrder = 1
    object btnAtualizar: TButton
      Left = 650
      Top = 15
      Width = 100
      Height = 40
      Caption = 'Atualizar'
      TabOrder = 0
      OnClick = btnAtualizarClick
    end
    object btnFechar: TButton
      Left = 770
      Top = 15
      Width = 100
      Height = 40
      Caption = 'Fechar'
      TabOrder = 1
      OnClick = btnFecharClick
    end
  end
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 900
    Height = 150
    Align = alTop
    TabOrder = 2
    object lblTitle: TLabel
      Left = 16
      Top = 16
      Width = 71
      Height = 20
      Caption = 'Relat'#243'rios'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label1: TLabel
      Left = 16
      Top = 54
      Width = 61
      Height = 15
      Caption = 'Data Inicial'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 120
      Top = 54
      Width = 54
      Height = 15
      Caption = 'Data Final'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object DataIni: TDateTimePicker
      Left = 16
      Top = 75
      Width = 89
      Height = 23
      Date = 46003.000000000000000000
      Time = 0.534944895836815700
      TabOrder = 0
    end
    object DataFim: TDateTimePicker
      Left = 120
      Top = 75
      Width = 89
      Height = 23
      Date = 46003.000000000000000000
      Time = 0.534944895836815700
      TabOrder = 1
    end
    object BtnGerarRelatorio: TButton
      Left = 224
      Top = 73
      Width = 105
      Height = 25
      Caption = 'Gerar Relat'#243'rio'
      TabOrder = 2
      OnClick = BtnGerarRelatorioClick
    end
  end
  object dsHistorico: TDataSource
    Left = 208
  end
end
