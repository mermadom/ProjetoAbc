object TanqueForm: TTanqueForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Cadastro de Tanques'
  ClientHeight = 550
  ClientWidth = 850
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
    Width = 850
    Height = 150
    Align = alTop
    TabOrder = 0
    object lblTitle: TLabel
      Left = 16
      Top = 16
      Width = 145
      Height = 20
      Caption = 'Cadastro de Tanques'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblTipoCombustivel: TLabel
      Left = 16
      Top = 50
      Width = 96
      Height = 15
      Caption = 'Tipo Combust'#237'vel:'
    end
    object lblCapacidade: TLabel
      Left = 450
      Top = 50
      Width = 65
      Height = 15
      Caption = 'Capacidade:'
    end
    object lblEstoque: TLabel
      Left = 16
      Top = 90
      Width = 62
      Height = 15
      Caption = 'Estoque (L):'
    end
    object edtTipoCombustivel: TComboBox
      Left = 140
      Top = 50
      Width = 290
      Height = 23
      Style = csDropDownList
      TabOrder = 0
      Items.Strings = (
        'Gasolina'
        'Diesel'
        'Etanol'
        'Gasolina Aditivada'
        'Diesel S10'
        'Diesel S500'
        'Biodiesel'
        'GNV')
    end
    object edtCapacidade: TEdit
      Left = 530
      Top = 50
      Width = 290
      Height = 23
      TabOrder = 1
    end
    object edtEstoque: TEdit
      Left = 140
      Top = 90
      Width = 290
      Height = 23
      TabOrder = 2
    end
  end
  object pnlMiddle: TPanel
    Left = 0
    Top = 150
    Width = 850
    Height = 310
    Align = alClient
    TabOrder = 1
    object dbgTanques: TDBGrid
      Left = 16
      Top = 24
      Width = 818
      Height = 320
      DataSource = dsTanques
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -12
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
      OnCellClick = dbgTanquesCellClick
      OnKeyUp = dbgTanquesKeyUp
      Columns = <
        item
          Expanded = False
          FieldName = 'TipoCombustivel'
          Title.Caption = 'Tipo de Combustivel'
          Width = 150
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Capacidade'
          Title.Caption = 'Capacidade (Litros)'
          Width = 120
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Estoque'
          Title.Caption = 'Estoque Atual (Litros)'
          Width = 120
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Percentual'
          Width = 100
          Visible = True
        end>
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 460
    Width = 850
    Height = 90
    Align = alBottom
    TabOrder = 2
    object btnAdicionar: TButton
      Left = 100
      Top = 10
      Width = 100
      Height = 30
      Caption = 'Adicionar'
      TabOrder = 0
      OnClick = btnAdicionarClick
    end
    object btnEditar: TButton
      Left = 220
      Top = 10
      Width = 100
      Height = 30
      Caption = 'Editar'
      TabOrder = 1
      OnClick = btnEditarClick
    end
    object btnExcluir: TButton
      Left = 340
      Top = 10
      Width = 100
      Height = 30
      Caption = 'Excluir'
      TabOrder = 2
      OnClick = btnExcluirClick
    end
    object btnAtualizar: TButton
      Left = 460
      Top = 10
      Width = 100
      Height = 30
      Caption = 'Atualizar'
      TabOrder = 3
      OnClick = btnAtualizarClick
    end
    object btnLimpar: TButton
      Left = 580
      Top = 10
      Width = 100
      Height = 30
      Caption = 'Limpar'
      TabOrder = 4
      OnClick = btnLimparClick
    end
  end
  object dsTanques: TDataSource
    Left = 16
    Top = 16
  end
end
