unit MainF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, SendSU;

const
  CEngineHandleMessage = wm_User + $101;

type
  TMainForm = class(TForm)
    EngineHandleLabel: TLabel;
    Button1: TButton;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
    FEngineHandle : LongWord;

    procedure AccessCopyData(var AMessage : TwmCopyData); message wm_CopyData;
    procedure HandleEngineHandle(var AMessage : TMessage); message CEngineHandleMessage;
    procedure WriteEngineHandleLabelCaption;
  public
    { Public-Deklarationen }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

{ TForm1 }

procedure TMainForm.HandleEngineHandle(var AMessage: TMessage);
begin
  if (AMessage.Msg = CEngineHandleMessage) then
  begin
    FEngineHandle := AMessage.WParam;

    WriteEngineHandleLabelCaption;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FEngineHandle := 0;

  WriteEngineHandleLabelCaption;
end;

procedure TMainForm.WriteEngineHandleLabelCaption;
begin
  EngineHandleLabel.Caption := 'Engine-Hwnd:' + #32;

  if (FEngineHandle > 0) then
    EngineHandleLabel.Caption := EngineHandleLabel.Caption + '$' + IntToHex(FEngineHandle, 1) + 'h'
  else
    EngineHandleLabel.Caption := EngineHandleLabel.Caption + '(none)';
end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  if (FEngineHandle <> 0) then
    SendStringMessage(FEngineHandle, Self.Handle, Memo1.Text);
end;

procedure TMainForm.AccessCopyData(var AMessage: TwmCopyData);
var
  MessageText    : String;
  MessageSender : THandleLongWord;
begin
  GetMessageData(AMessage, MessageText, MessageSender);

  if (MessageSender = FEngineHandle) then
    ShowMessage('Engine:' + #13#10 + MessageText)
  else
    ShowMessage('Unknown:' + #13#10 + MessageText);
end;

end.
