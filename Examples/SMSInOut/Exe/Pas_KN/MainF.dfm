object MainForm: TMainForm
  Left = 192
  Top = 108
  Width = 482
  Height = 480
  Caption = 'SMSInOut'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object SMSInOutMemo: TMemo
    Left = 0
    Top = 0
    Width = 474
    Height = 336
    Align = alClient
    Enabled = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object SMSInOutPanel: TPanel
    Left = 0
    Top = 336
    Width = 474
    Height = 97
    Align = alBottom
    TabOrder = 1
    object ActionsBevel: TBevel
      Left = 368
      Top = 5
      Width = 9
      Height = 81
      Shape = bsLeftLine
    end
    object NumberLabel: TLabel
      Left = 10
      Top = 8
      Width = 86
      Height = 13
      Caption = 'Receiver-Number:'
    end
    object TextLabel: TLabel
      Left = 10
      Top = 48
      Width = 24
      Height = 13
      Caption = 'Text:'
    end
    object CountLabel: TLabel
      Left = 376
      Top = 72
      Width = 18
      Height = 13
      Caption = '160'
    end
    object HardCloseButton: TButton
      Left = 376
      Top = 8
      Width = 89
      Height = 25
      Caption = '&Hard Close'
      TabOrder = 3
      Visible = False
      OnClick = HardCloseButtonClick
    end
    object NumberEdit: TEdit
      Left = 10
      Top = 24
      Width = 121
      Height = 21
      TabOrder = 0
    end
    object TextEdit: TEdit
      Left = 10
      Top = 64
      Width = 351
      Height = 21
      MaxLength = 160
      TabOrder = 1
      OnChange = TextEditChange
    end
    object SendButton: TButton
      Left = 376
      Top = 40
      Width = 89
      Height = 25
      Caption = '&Send'
      TabOrder = 2
      OnClick = SendButtonClick
    end
  end
  object SMSInOutStatusBar: TStatusBar
    Left = 0
    Top = 433
    Width = 474
    Height = 19
    Panels = <
      item
        Width = 0
      end>
  end
end
