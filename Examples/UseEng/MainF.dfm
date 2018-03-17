object MainForm: TMainForm
  Left = 192
  Top = 107
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'UseEng'
  ClientHeight = 233
  ClientWidth = 410
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object EngineHandleLabel: TLabel
    Left = 8
    Top = 8
    Width = 100
    Height = 13
    Caption = 'Engine-Hwnd: (none)'
  end
  object Button1: TButton
    Left = 328
    Top = 200
    Width = 75
    Height = 25
    Caption = '&Send'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 8
    Top = 32
    Width = 393
    Height = 161
    TabOrder = 1
  end
end
