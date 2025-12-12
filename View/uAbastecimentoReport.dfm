object AbastecimentoReportForm: TAbastecimentoReportForm
  Left = 0
  Top = 0
  Caption = 'Relat'#243'rio de Abastecimentos'
  ClientHeight = 600
  ClientWidth = 1000
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnClose = FormClose
  OnCreate = FormCreate
  TextHeight = 15
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 1000
    Height = 60
    Align = alTop
    TabOrder = 0
    object lblTitle: TLabel
      Left = 10
      Top = 15
      Width = 338
      Height = 35
      Caption = 'Relat'#243'rio de Abastecimentos'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -25
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object btnFechar: TButton
      Left = 900
      Top = 15
      Width = 90
      Height = 30
      Caption = 'Fechar'
      TabOrder = 0
      OnClick = btnFecharClick
    end
  end
  object pnlMiddle: TPanel
    Left = 0
    Top = 60
    Width = 1000
    Height = 540
    Align = alClient
    TabOrder = 1
    object ReportAbastecimento: TRLReport
      Left = 0
      Top = -4
      Width = 794
      Height = 1123
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      object RLBand_Title: TRLBand
        Left = 38
        Top = 38
        Width = 718
        Height = 80
        BandType = btTitle
        object RLLabel_TitleReport: TRLLabel
          Left = 3
          Top = 19
          Width = 567
          Height = 29
          Caption = 'RELAT'#211'RIO GERENCIAL DE ABASTECIMENTOS'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -24
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object RLLabel_SubTitle: TRLLabel
          Left = 3
          Top = 54
          Width = 342
          Height = 16
          Caption = 'Abastecimentos agrupados por Data/Tanque/Bomba/Litros'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
      end
      object RLBand_Header: TRLBand
        Left = 38
        Top = 118
        Width = 718
        Height = 35
        BandType = btColumnHeader
        object RLLabel_ColData: TRLLabel
          Left = 3
          Top = 12
          Width = 62
          Height = 20
          Caption = 'DATA'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object RLLabel_ColTanque: TRLLabel
          Left = 73
          Top = 12
          Width = 79
          Height = 20
          Alignment = taRightJustify
          Caption = 'TANQUE'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object RLLabel_ColBomba: TRLLabel
          Left = 159
          Top = 12
          Width = 58
          Height = 22
          Alignment = taRightJustify
          Caption = 'BOMBA'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object RLLabel_ColLitros: TRLLabel
          Left = 222
          Top = 12
          Width = 80
          Height = 20
          Alignment = taRightJustify
          Caption = 'LITROS'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object RLLabel_ColValorTotal: TRLLabel
          Left = 306
          Top = 12
          Width = 99
          Height = 21
          Alignment = taRightJustify
          Caption = 'TOTAL'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object RLLabel_ColValorImposto: TRLLabel
          Left = 524
          Top = 12
          Width = 148
          Height = 20
          Alignment = taRightJustify
          Caption = 'TOTAL C/ IMPOSTO'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object RLLabel_ColImposto: TRLLabel
          Left = 411
          Top = 11
          Width = 107
          Height = 21
          Alignment = taRightJustify
          Caption = 'IMPOSTO'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
      end
      object RLBand_Detail: TRLBand
        Left = 38
        Top = 153
        Width = 718
        Height = 25
        BeforePrint = RLBand_DetailBeforePrint
        object RLDBText_Data: TRLDBText
          Left = 6
          Top = 5
          Width = 59
          Height = 20
          DataField = 'DataAbastecimento'
          DisplayMask = 'dd/mm/yyyy'
          Text = ''
        end
        object RLDBText_Tanque: TRLDBText
          Left = 73
          Top = 5
          Width = 79
          Height = 20
          Alignment = taRightJustify
          DataField = 'TipoCombustivel'
          Text = ''
        end
        object RLDBText_Bomba: TRLDBText
          Left = 160
          Top = 5
          Width = 58
          Height = 20
          Alignment = taRightJustify
          DataField = 'Bomba'
          Text = ''
        end
        object RLDBText_Litros: TRLDBText
          Left = 224
          Top = 5
          Width = 80
          Height = 20
          Alignment = taRightJustify
          DataField = 'Litros'
          DisplayMask = '0.00'
          Text = ''
        end
        object RLDBText_ValorTotal: TRLDBText
          Left = 308
          Top = 5
          Width = 99
          Height = 20
          Alignment = taRightJustify
          DataField = 'ValorTotal'
          DisplayMask = 'R$#,##0.00'
          Text = ''
        end
        object RLDBText_ValorImposto: TRLDBText
          Left = 413
          Top = 5
          Width = 107
          Height = 20
          Alignment = taRightJustify
          DataField = 'Imposto'
          DisplayMask = 'R$#,##0.00'
          Text = ''
        end
        object RLDBText_ValorComImposto: TRLDBText
          Left = 526
          Top = 5
          Width = 148
          Height = 20
          Alignment = taRightJustify
          DataField = 'ValorComImposto'
          DisplayMask = 'R$#,##0.00'
          Text = ''
        end
      end
      object RLBand_Summary: TRLBand
        Left = 38
        Top = 178
        Width = 718
        Height = 50
        BandType = btSummary
        object RLLabel_TotalLabel: TRLLabel
          Left = 221
          Top = 15
          Width = 81
          Height = 16
          Caption = 'Valor Total: '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object RlLabelTotal: TRLLabel
          Left = 308
          Top = 16
          Width = 99
          Height = 16
          Alignment = taRightJustify
        end
        object RLLabelTotalImposto: TRLLabel
          Left = 413
          Top = 16
          Width = 107
          Height = 16
          Alignment = taRightJustify
        end
        object RLLabelTotalComImposto: TRLLabel
          Left = 526
          Top = 16
          Width = 148
          Height = 16
          Alignment = taRightJustify
          Caption = 'RLLabelTotalImposto'
        end
      end
    end
  end
end
