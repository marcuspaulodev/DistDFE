﻿object frconfig: Tfrconfig
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Configura'#231#245'es'
  ClientHeight = 350
  ClientWidth = 654
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Conexão: TGroupBox
    Left = 8
    Top = 8
    Width = 638
    Height = 73
    Caption = 'Conex'#227'o'
    TabOrder = 0
    object HOST: TLabel
      Left = 8
      Top = 20
      Width = 22
      Height = 13
      Caption = 'Host'
    end
    object Label1: TLabel
      Left = 144
      Top = 20
      Width = 36
      Height = 13
      Caption = 'Usu'#225'rio'
    end
    object Label2: TLabel
      Left = 280
      Top = 20
      Width = 30
      Height = 13
      Caption = 'Senha'
    end
    object Label3: TLabel
      Left = 416
      Top = 20
      Width = 46
      Height = 13
      Caption = 'Database'
    end
    object Edit1: TEdit
      Left = 8
      Top = 39
      Width = 121
      Height = 21
      TabOrder = 0
    end
    object Edit2: TEdit
      Left = 144
      Top = 39
      Width = 121
      Height = 21
      TabOrder = 1
    end
    object Edit3: TEdit
      Left = 280
      Top = 39
      Width = 121
      Height = 21
      TabOrder = 2
    end
    object Edit4: TEdit
      Left = 416
      Top = 39
      Width = 121
      Height = 21
      TabOrder = 3
    end
    object Button1: TButton
      Left = 548
      Top = 37
      Width = 75
      Height = 25
      Caption = 'Conectar'
      TabOrder = 4
    end
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 87
    Width = 638
    Height = 82
    Caption = 'Certificado Digital'
    TabOrder = 1
    object Label4: TLabel
      Left = 8
      Top = 29
      Width = 79
      Height = 13
      Caption = 'N'#250'mero de S'#233'rie'
    end
    object SpeedButton1: TSpeedButton
      Left = 272
      Top = 47
      Width = 23
      Height = 22
      Glyph.Data = {
        36040000424D3604000000000000360000002800000010000000100000000100
        20000000000000040000C40E0000C40E00000000000000000000FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF000E5A3E320F5B3FFF126244FF0E5A3E5AFFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF0015614436176346FF29855FFF449C77FF3D7F65FFFFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF001E6A4C38216D4FFF368F6BFF52A583FF98C5B2FF256F52FFFFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF002B7859FF459A79FF63B092FF9EC9B8FF357E61FF27745543FFFFFF00FFFF
        FF00FFFFFF0050505048505050B1505050E7505050E7505050B1505050489898
        98FF56A688FF74BAA0FFA3CDBDFF3D8768FF317F5E41FFFFFF00FFFFFF005656
        561B565656967F7F7FFFC9C9C9FFECECECFFECECECFFC9C9C9FF7F7F7FFF5F5F
        5FEA606060D0AAD2C2FF45906FFF3B8A673DFFFFFF00FFFFFF00FFFFFF005C5C
        5C96AEAEAEFFFAFAFAFFF8F8F8FFF4F4F4FFF4F4F4FFF8F8F8FFFAFAFAFFA9A9
        A9FF5F5F5FE9989898FFFFFFFF00FFFFFF00FFFFFF00FFFFFF006363635A9393
        93FFF8F8F8FFEEEEEEFFEDEDEDFFEDEDEDFFEDEDEDFFEDEDEDFFEFEFEFFFF6F6
        F6FF888888FF6363635AFFFFFF00FFFFFF00FFFFFF00FFFFFF006B6B6BC3D6D6
        D6FFEEEEEEFFE6E6E6FFE6E6E6FFE6E6E6FFE6E6E6FFE6E6E6FFE6E6E6FFF0F0
        F0FFD6D6D6FF6B6B6BC3FFFFFF00FFFFFF00FFFFFF00FFFFFF00737373F9F1F1
        F1FFE0E0E0FFDEDEDEFFDEDEDEFFDEDEDEFFDEDEDEFFDEDEDEFFDEDEDEFFE1E1
        E1FFEFEFEFFF737373F3FFFFFF00FFFFFF00FFFFFF00FFFFFF007B7B7BF9F1F1
        F1FFDCDCDCFFD7D7D7FFD7D7D7FFD7D7D7FFD7D7D7FFD7D7D7FFD7D7D7FFDDDD
        DDFFEDEDEDFF7B7B7BF0FFFFFF00FFFFFF00FFFFFF00FFFFFF00838383C3DBDB
        DBFFE4E4E4FFD0D0D0FFCFCFCFFFCFCFCFFFCFCFCFFFCFCFCFFFD1D1D1FFE8E8
        E8FFDCDCDCFF838383C3FFFFFF00FFFFFF00FFFFFF00FFFFFF008A8A8A5AB1B1
        B1FFF3F3F3FFD6D6D6FFCCCCCCFFCACACAFFCACACAFFCCCCCCFFD8D8D8FFF3F3
        F3FFA6A6A6FF8A8A8A5AFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF009191
        9196CCCCCCFFF4F4F4FFE6E6E6FFD9D9D9FFD9D9D9FFE6E6E6FFF4F4F4FFC7C7
        C7FF91919196FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF009797
        972797979796B8B8B8FFDFDFDFFFF1F1F1FFF1F1F1FFDFDFDFFFB8B8B8FF9797
        97969797971BFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF009D9D9D549D9D9DBA9D9D9DED9D9D9DED9D9D9DBA9D9D9D54FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00}
    end
    object Label5: TLabel
      Left = 312
      Top = 29
      Width = 30
      Height = 13
      Caption = 'Senha'
    end
    object Label6: TLabel
      Left = 446
      Top = 29
      Width = 96
      Height = 13
      Caption = 'Data de Vencimento'
    end
    object Edit5: TEdit
      Left = 8
      Top = 48
      Width = 257
      Height = 21
      TabOrder = 0
    end
    object Edit6: TEdit
      Left = 312
      Top = 47
      Width = 121
      Height = 21
      TabOrder = 1
    end
    object DateEdit1: TDateEdit
      Left = 446
      Top = 48
      Width = 121
      Height = 21
      NumGlyphs = 2
      TabOrder = 2
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 175
    Width = 638
    Height = 98
    Caption = 'Autor'
    TabOrder = 2
  end
end
