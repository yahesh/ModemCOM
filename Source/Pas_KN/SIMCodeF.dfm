object SIMCodeForm: TSIMCodeForm
  Left = 191
  Top = 103
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Enter "SIM XXX"'
  ClientHeight = 113
  ClientWidth = 297
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = [fsBold]
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object SIMCodeLabel: TLabel
    Left = 8
    Top = 8
    Width = 272
    Height = 13
    Caption = 'Please Enter The "SIM XXX" Of Your SIM Card.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object BottomButtonsBevel: TBevel
    Left = 8
    Top = 56
    Width = 281
    Height = 10
    Shape = bsBottomLine
  end
  object SIMCodeEdit: TEdit
    Left = 8
    Top = 32
    Width = 121
    Height = 21
    PasswordChar = #176
    TabOrder = 0
  end
  object CancelButton: TButton
    Left = 216
    Top = 80
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = CancelButtonClick
  end
  object OKButton: TButton
    Left = 136
    Top = 80
    Width = 75
    Height = 25
    Caption = '&OK'
    Default = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = OKButtonClick
  end
end
