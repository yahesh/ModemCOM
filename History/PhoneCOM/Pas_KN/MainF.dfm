object MainForm: TMainForm
  Left = 192
  Top = 107
  Width = 799
  Height = 514
  Caption = 'PhoneCOM'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object OutputMemo: TMemo
    Left = 185
    Top = 0
    Width = 606
    Height = 486
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object ControlsPanel: TPanel
    Left = 0
    Top = 0
    Width = 185
    Height = 486
    Align = alLeft
    TabOrder = 0
    object InitializeButton: TButton
      Left = 8
      Top = 8
      Width = 169
      Height = 25
      Caption = 'I&nitialize Siemens TC35i'
      TabOrder = 0
      OnClick = InitializeButtonClick
    end
    object AddNumberEdit: TEdit
      Left = 8
      Top = 88
      Width = 169
      Height = 21
      TabOrder = 2
    end
    object AddNumberButton: TButton
      Left = 8
      Top = 112
      Width = 75
      Height = 25
      Caption = 'A&dd Number'
      TabOrder = 3
      OnClick = AddNumberButtonClick
    end
    object SendMessageTextEdit: TEdit
      Left = 8
      Top = 192
      Width = 169
      Height = 21
      TabOrder = 5
    end
    object SendMessageButton: TButton
      Left = 8
      Top = 216
      Width = 75
      Height = 25
      Caption = 'S&end Message'
      TabOrder = 6
      OnClick = SendMessageButtonClick
    end
    object SendMessageNumberEdit: TEdit
      Left = 8
      Top = 168
      Width = 169
      Height = 21
      TabOrder = 4
    end
    object LoadAcceptedNumbersButton: TButton
      Left = 8
      Top = 304
      Width = 169
      Height = 25
      Caption = 'L&oad Accepted Numbers'
      TabOrder = 7
      OnClick = LoadAcceptedNumbersButtonClick
    end
    object SaveAcceptedNumbersButton: TButton
      Left = 8
      Top = 336
      Width = 169
      Height = 25
      Caption = 'S&ave Accepted Numbers'
      TabOrder = 8
      OnClick = SaveAcceptedNumbersButtonClick
    end
    object RingButton: TButton
      Left = 104
      Top = 216
      Width = 75
      Height = 25
      Caption = 'R&ing'
      TabOrder = 9
      OnClick = RingButtonClick
    end
    object ShutdownButton: TButton
      Left = 8
      Top = 40
      Width = 169
      Height = 25
      Caption = 'S&hutdown Siemens TC35i'
      TabOrder = 1
      OnClick = ShutdownButtonClick
    end
    object SendATCodeEdit: TEdit
      Left = 8
      Top = 392
      Width = 169
      Height = 21
      TabOrder = 10
    end
    object SendATCodeButton: TButton
      Left = 8
      Top = 416
      Width = 89
      Height = 25
      Caption = 'Send &AT-Code'
      TabOrder = 11
      OnClick = SendATCodeButtonClick
    end
  end
  object ReadLogTimer: TTimer
    Enabled = False
    Interval = 500
    OnTimer = ReadLogTimerTimer
    Left = 144
    Top = 248
  end
end
