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
  OnShow = FormShow
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
      PasswordChar = '*'
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
      OnClick = Button1Click
    end
  end
  inline frameOKCancel1: TframeOKCancel
    Left = 0
    Top = 309
    Width = 654
    Height = 41
    Align = alBottom
    AutoSize = True
    TabOrder = 1
    ExplicitTop = 309
    ExplicitWidth = 654
    inherited Panel1: TPanel
      Width = 654
      ExplicitWidth = 654
      inherited BitBtn1: TBitBtn
        Caption = '&OK'
        Default = False
        OnClick = frameOKCancel1BitBtn1Click
      end
      inherited BitBtn2: TBitBtn
        Caption = '&Cancelar'
      end
    end
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 88
    Width = 638
    Height = 81
    Caption = 'Consultas'
    TabOrder = 2
    object Label4: TLabel
      Left = 9
      Top = 32
      Width = 181
      Height = 13
      Caption = 'Intervalo Entre Consultas (Segundos)'
    end
    object Edit5: TEdit
      Left = 8
      Top = 52
      Width = 121
      Height = 21
      NumbersOnly = True
      TabOrder = 0
    end
  end
  object ACBrNFe1: TACBrNFe
    Configuracoes.Geral.SSLLib = libNone
    Configuracoes.Geral.SSLCryptLib = cryNone
    Configuracoes.Geral.SSLHttpLib = httpNone
    Configuracoes.Geral.SSLXmlSignLib = xsNone
    Configuracoes.Geral.FormatoAlerta = 'TAG:%TAGNIVEL% ID:%ID%/%TAG%(%DESCRICAO%) - %MSG%.'
    Configuracoes.Geral.VersaoQRCode = veqr000
    Configuracoes.Arquivos.OrdenacaoPath = <>
    Configuracoes.WebServices.UF = 'SP'
    Configuracoes.WebServices.AguardarConsultaRet = 0
    Configuracoes.WebServices.QuebradeLinha = '|'
    Configuracoes.RespTec.IdCSRT = 0
    Left = 592
    Top = 144
  end
  object qr1: TZReadOnlyQuery
    Connection = frPrincipal.db0
    Params = <>
    Left = 592
    Top = 104
  end
  object z1: TZSQLProcessor
    Params = <>
    Connection = frPrincipal.db0
    Delimiter = ';'
    Left = 600
    Top = 192
  end
end
