object BombaForm: TBombaForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Cadastro de Bombas'
  ClientHeight = 550
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
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 900
    Height = 110
    Align = alTop
    TabOrder = 0
    object lblTitle: TLabel
      Left = 16
      Top = 16
      Width = 144
      Height = 20
      Caption = 'Cadastro de Bombas'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblNumeroBomba: TLabel
      Left = 16
      Top = 50
      Width = 88
      Height = 15
      Caption = 'N'#250'mero Bomba:'
    end
    object lblTanque: TLabel
      Left = 500
      Top = 50
      Width = 41
      Height = 15
      Caption = 'Tanque:'
    end
    object edtNumeroBomba: TEdit
      Left = 110
      Top = 50
      Width = 360
      Height = 23
      TabOrder = 0
    end
    object cbxTanque: TComboBox
      Left = 560
      Top = 50
      Width = 320
      Height = 23
      Style = csDropDownList
      TabOrder = 1
    end
  end
  object pnlMiddle: TPanel
    Left = 0
    Top = 110
    Width = 900
    Height = 350
    Align = alClient
    TabOrder = 1
    object dbgBombas: TDBGrid
      Left = 16
      Top = 16
      Width = 868
      Height = 320
      DataSource = dsBombas
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -12
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
      OnCellClick = dbgBombasCellClick
      OnKeyUp = dbgBombasKeyUp
      Columns = <
        item
          Expanded = False
          FieldName = 'NumeroBomba'
          Title.Caption = 'N'#250'mero da Bomba'
          Width = 120
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'TipoCombustivel'
          Title.Caption = 'Tipo de Combust'#237'vel'
          Width = 150
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'EstoqueTanque'
          Title.Caption = 'Estoque do Tanque (Litros)'
          Width = 150
          Visible = True
        end>
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 460
    Width = 900
    Height = 90
    Align = alBottom
    TabOrder = 2
    object btnAdicionar: TButton
      Left = 50
      Top = 10
      Width = 100
      Height = 30
      Caption = 'Adicionar'
      TabOrder = 0
      OnClick = btnAdicionarClick
    end
    object btnEditar: TButton
      Left = 170
      Top = 10
      Width = 100
      Height = 30
      Caption = 'Editar'
      TabOrder = 1
      OnClick = btnEditarClick
    end
    object btnExcluir: TButton
      Left = 290
      Top = 10
      Width = 100
      Height = 30
      Caption = 'Excluir'
      TabOrder = 2
      OnClick = btnExcluirClick
    end
    object btnAtualizar: TButton
      Left = 410
      Top = 10
      Width = 100
      Height = 30
      Caption = 'Atualizar'
      TabOrder = 3
      OnClick = btnAtualizarClick
    end
    object btnLimpar: TButton
      Left = 530
      Top = 10
      Width = 100
      Height = 30
      Caption = 'Limpar'
      TabOrder = 4
      OnClick = btnLimparClick
    end
  end
  object dsBombas: TDataSource
    Left = 168
    Top = 65528
  end
end
