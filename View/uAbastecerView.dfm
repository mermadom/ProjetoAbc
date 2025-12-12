object AbastecerForm: TAbastecerForm
  Left = 0
  Top = 0
  Align = alClient
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'Abastecer'
  ClientHeight = 374
  ClientWidth = 852
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  FormStyle = fsMDIChild
  Visible = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 852
    Height = 185
    Align = alTop
    TabOrder = 0
    object lblTitle: TLabel
      Left = 16
      Top = 16
      Width = 190
      Height = 20
      Caption = 'Registro de Abastecimento'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblBomba: TLabel
      Left = 16
      Top = 50
      Width = 41
      Height = 15
      Caption = 'Bomba:'
    end
    object lblLitros: TLabel
      Left = 16
      Top = 82
      Width = 32
      Height = 15
      Caption = 'Litros:'
    end
    object lblValor: TLabel
      Left = 16
      Top = 114
      Width = 40
      Height = 15
      Caption = 'Valor/L:'
    end
    object lblImposto: TLabel
      Left = 480
      Top = 50
      Width = 47
      Height = 15
      Caption = 'Imposto:'
    end
    object lblValorFinal: TLabel
      Left = 480
      Top = 82
      Width = 57
      Height = 15
      Caption = 'Valor Final:'
    end
    object cmbBomba: TComboBox
      Left = 96
      Top = 50
      Width = 320
      Height = 23
      TabOrder = 0
    end
    object edtLitros: TEdit
      Left = 96
      Top = 82
      Width = 320
      Height = 23
      TabOrder = 1
      OnChange = edtValorUnitarioChange
      OnKeyPress = edtLitrosKeyPress
    end
    object edtValorUnitario: TEdit
      Left = 96
      Top = 114
      Width = 320
      Height = 23
      TabOrder = 2
      OnChange = edtValorUnitarioChange
      OnKeyPress = edtValorUnitarioKeyPress
    end
    object btnRegistrar: TButton
      Left = 560
      Top = 114
      Width = 140
      Height = 40
      Caption = 'Registrar'
      TabOrder = 3
      OnClick = btnRegistrarClick
    end
    object btnAtualizar: TButton
      Left = 720
      Top = 114
      Width = 140
      Height = 40
      Caption = 'Atualizar'
      TabOrder = 4
      OnClick = btnAtualizarClick
    end
    object edtImposto: TMaskEdit
      Left = 560
      Top = 50
      Width = 300
      Height = 23
      EditMask = 'R$#.##;0;0'
      MaxLength = 6
      TabOrder = 5
      Text = ''
    end
    object edtValorFinal: TMaskEdit
      Left = 560
      Top = 79
      Width = 298
      Height = 23
      EditMask = 'R$#.##;0;0'
      MaxLength = 6
      TabOrder = 6
      Text = ''
    end
  end
  object pnlMiddle: TPanel
    Left = 0
    Top = 185
    Width = 852
    Height = 189
    Align = alClient
    TabOrder = 1
    object lblHistorico: TLabel
      Left = 16
      Top = 16
      Width = 152
      Height = 15
      Caption = 'Hist'#243'rico de Abastecimentos'
    end
    object dbgAbastecimentos: TDBGrid
      Left = 16
      Top = 40
      Width = 868
      Height = 250
      DataSource = dsAbastecimentos
      ReadOnly = True
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -12
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          FieldName = 'Bomba'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Combustivel'
          Title.Caption = 'Combust'#237'vel'
          Width = 90
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Data/Hora'
          Width = 86
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Litros'
          Width = 82
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Valor Total'
          Width = 109
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Imposto'
          Width = 117
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Valor c/ Imposto'
          Width = 149
          Visible = True
        end>
    end
  end
  object dsAbastecimentos: TDataSource
    Left = 16
    Top = 16
  end
end
