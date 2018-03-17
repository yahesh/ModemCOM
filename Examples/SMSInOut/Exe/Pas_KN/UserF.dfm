object UserForm: TUserForm
  Left = 192
  Top = 108
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Enter Admin-User-Data...'
  ClientHeight = 157
  ClientWidth = 225
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object UserNameLabel: TLabel
    Left = 16
    Top = 8
    Width = 105
    Height = 13
    Caption = 'Admin-User-Name:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object UserTextLabel: TLabel
    Left = 16
    Top = 56
    Width = 98
    Height = 13
    Caption = 'Admin-User-Text:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object DividerBevel: TBevel
    Left = 8
    Top = 104
    Width = 209
    Height = 9
    Shape = bsTopLine
  end
  object UserNameEdit: TEdit
    Left = 16
    Top = 24
    Width = 193
    Height = 21
    TabOrder = 0
  end
  object UserTextEdit: TEdit
    Left = 16
    Top = 72
    Width = 193
    Height = 21
    PasswordChar = '#'
    TabOrder = 1
  end
  object OKBitBtn: TBitBtn
    Left = 16
    Top = 120
    Width = 75
    Height = 25
    Caption = '&OK'
    TabOrder = 2
    OnClick = OKBitBtnClick
    Kind = bkOK
  end
  object CancelBitBtn: TBitBtn
    Left = 136
    Top = 120
    Width = 75
    Height = 25
    Caption = '&Cancel'
    TabOrder = 3
    OnClick = CancelBitBtnClick
    Kind = bkCancel
  end
end
