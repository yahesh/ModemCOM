unit MainF;

interface

uses
  Windows, SysUtils, Classes, Controls, Forms, Dialogs, PhoneU, StdCtrls,
  ExtCtrls{, ShellAPI};

type
  TMainForm = class(TForm)
    OutputMemo: TMemo;
    ControlsPanel: TPanel;
    InitializeButton: TButton;
    AddNumberEdit: TEdit;
    AddNumberButton: TButton;
    SendMessageTextEdit: TEdit;
    SendMessageButton: TButton;
    SendMessageNumberEdit: TEdit;
    LoadAcceptedNumbersButton: TButton;
    SaveAcceptedNumbersButton: TButton;
    RingButton: TButton;
    ShutdownButton: TButton;
    ReadLogTimer: TTimer;
    SendATCodeEdit: TEdit;
    SendATCodeButton: TButton;

    procedure FormCreate(Sender: TObject);
    procedure InitializeButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AddNumberButtonClick(Sender: TObject);
    procedure SendMessageButtonClick(Sender: TObject);
    procedure LoadAcceptedNumbersButtonClick(Sender: TObject);
    procedure SaveAcceptedNumbersButtonClick(Sender: TObject);
    procedure RingButtonClick(Sender: TObject);
    procedure ShutdownButtonClick(Sender: TObject);
    procedure ReadLogTimerTimer(Sender: TObject);
    procedure SendATCodeButtonClick(Sender: TObject);
  private
    { Private-Deklarationen }
    FAcceptedNumbers : TStringList;
    FLogFile         : LongWord;
    FPhoneEngine     : TPhoneEngine;

    procedure Add(const ANumber : String; const AEvent : String; const AParameter : String);
    procedure Delete(const ANumber : String; const AEvent : String; const AParameter : String);
    {procedure Open(const ANumber : String; const AEvent : String; const AParameter : String);}
    procedure Say(const ANumber : String; const AEvent : String; const AParameter : String);
    procedure OnRing(const ANumber : String; const AEvent : String; const AParameter : String);
    procedure OnUnknownEvent(const ANumber : String; const AEvent : String; const AParameter : String);
    procedure OnUnknownNumber(const ANumber : String; const AEvent : String; const AParameter : String);
  public
    { Public-Deklarationen }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
var
  OfStruct : TOfStruct;
begin
  FAcceptedNumbers := TStringList.Create;

  FPhoneEngine := TPhoneEngine.Create;

  FPhoneEngine.CaseSensitive  := false;
  FPhoneEngine.IgnoreUser     := true;
  FPhoneEngine.LogFileName    := ChangeFileExt(Application.ExeName, '.log');
  FPhoneEngine.LogFileActive  := true;
  FPhoneEngine.LogSimCode     := false;
  FPhoneEngine.OnUnknownEvent := OnUnknownEvent;
  FPhoneEngine.PortName       := 'COM1';
  FPhoneEngine.SyncPortEvents := true;

  FPhoneEngine.CreatePortConnection;

  FPhoneEngine.AddEvent(Add, 'add', 0);
  FPhoneEngine.AddEvent(Delete, 'delete', 0);
  {FPhoneEngine.AddEvent(Open, 'open', 0)};
  FPhoneEngine.AddEvent(Say, 'say', 0);
  FPhoneEngine.AddEvent(OnRing, #0, 0);

  FLogFile := OpenFile(PChar(FPhoneEngine.LogFileName), OfStruct, fmOpenRead);

  ReadLogTimer.Enabled := true;
end;

procedure TMainForm.InitializeButtonClick(Sender: TObject);
begin
  FPhoneEngine.InitializeSiemensTC35I('', true);
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FAcceptedNumbers.Free;

  FPhoneEngine.DestroyPortConnection;
  FPhoneEngine.Free;

  CloseHandle(FLogFile);
  DeleteFile(ChangeFileExt(Application.ExeName, '.log'));
end;

procedure TMainForm.AddNumberButtonClick(Sender: TObject);
begin
  FAcceptedNumbers.Add(AnsiLowerCase(Trim(AddNumberEdit.Text)));

  AddNumberEdit.Text := '';
end;

procedure TMainForm.SendMessageButtonClick(Sender: TObject);
begin
  FPhoneEngine.InterpretMessage(SendMessageNumberEdit.Text, SendMessageTextEdit.Text);

  SendMessageTextEdit.Text := '';
end;

procedure TMainForm.LoadAcceptedNumbersButtonClick(Sender: TObject);
begin
  FAcceptedNumbers.LoadFromFile(ExtractFilePath(Application.ExeName) + 'accepted.dat');
end;

procedure TMainForm.SaveAcceptedNumbersButtonClick(Sender: TObject);
begin
  FAcceptedNumbers.SaveToFile(ExtractFilePath(Application.ExeName) + 'accepted.dat');
end;

procedure TMainForm.OnRing(const ANumber : String; const AEvent : String; const AParameter : String);
begin
  if (FAcceptedNumbers.IndexOf(AnsiLowerCase(Trim(ANumber))) >= 0) then
    OutputMemo.Lines.Add(ANumber + ' phoned at ' + DateTimeToStr(Now))
  else
    OnUnknownNumber(ANumber, AEvent, AParameter);
end;

procedure TMainForm.RingButtonClick(Sender: TObject);
begin
  FPhoneEngine.InterpretMessage(SendMessageNumberEdit.Text, #0);
end;

procedure TMainForm.OnUnknownEvent(const ANumber : String; const AEvent : String; const AParameter : String);
begin
  if (FAcceptedNumbers.IndexOf(AnsiLowerCase(Trim(ANumber))) >= 0) then
    OutputMemo.Lines.Add('UNKNOWN EVENT: ' + ANumber + ' sent "' + AEvent + '" with "' + AParameter + '" at ' + DateTimeToStr(Now))
  else
    OnUnknownNumber(ANumber, AEvent, Trim(AEvent + #32 + AParameter));
end;

procedure TMainForm.OnUnknownNumber(const ANumber : String; const AEvent : String; const AParameter : String);
begin
  if (AParameter = #0) then
    OutputMemo.Lines.Add('UNKNOWN NUMBER: ' + ANumber + ' tried to phone at ' + DateTimeToStr(Now))
  else
    OutputMemo.Lines.Add('UNKNOWN NUMBER: ' + ANumber + ' tried to send "' + AParameter + '" at ' + DateTimeToStr(Now));
end;

procedure TMainForm.Add(const ANumber : String; const AEvent : String; const AParameter : String);
begin
  if (FAcceptedNumbers.IndexOf(AnsiLowerCase(Trim(ANumber))) >= 0) then
    OutputMemo.Lines.Add(ANumber + ' added ' + AnsiLowerCase(Trim(AParameter)) + ' to accepted numbers at ' + DateTimeToStr(Now))
  else
    OutputMemo.Lines.Add('ERROR: ' + ANumber + ' added ' + AnsiLowerCase(Trim(AParameter)) + ' to accepted numbers at ' + DateTimeToStr(Now));
end;

procedure TMainForm.Delete(const ANumber : String; const AEvent : String; const AParameter : String);
begin
  while (FAcceptedNumbers.IndexOf(AnsiLowerCase(Trim(ANumber))) >= 0) do
    FAcceptedNumbers.Delete(FAcceptedNumbers.IndexOf(AnsiLowerCase(Trim(AParameter))));

  if (FAcceptedNumbers.IndexOf(AnsiLowerCase(Trim(ANumber))) < 0) then
    OutputMemo.Lines.Add(ANumber + ' deleted ' + AnsiLowerCase(Trim(AParameter)) + ' from accepted numbers at ' + DateTimeToStr(Now))
  else
    OutputMemo.Lines.Add('ERROR: ' + ANumber + ' deleted ' + AnsiLowerCase(Trim(AParameter)) + ' from accepted numbers at ' + DateTimeToStr(Now));
end;

procedure TMainForm.ShutdownButtonClick(Sender: TObject);
begin
  FPhoneEngine.ShutdownSiemensTC35I;
end;

procedure TMainForm.Say(const ANumber : String; const AEvent : String; const AParameter : String);
begin
  if (FAcceptedNumbers.IndexOf(AnsiLowerCase(Trim(ANumber))) >= 0) then
    ShowMessage(ANumber + ' says:' + #13#10#13#10 + AParameter)
  else
    OnUnknownNumber(ANumber, AEvent, AParameter);
end;

{procedure TMainForm.Open(const ANumber : String; const AEvent : String; const AParameter : String);
begin
  if (FAcceptedNumbers.IndexOf(AnsiLowerCase(Trim(AParameter))) >= 0) then
  begin
    if FileExists(Trim(AParameter)) then
      ShellExecute(0, 'open', PChar(Trim(AParameter)), 0, 0, sw_Show)
    else
      ShellExecute(0, 'open', 'iexplore', PChar(Trim(AParameter)), 0, sw_Show);
  end
  else
    OnUnknownNumber(ANumber, AParameter);
end;}

procedure TMainForm.ReadLogTimerTimer(Sender: TObject);
var
  FileDiff   : Int64;
  ReadBuffer : String;
  ReadCount  : LongWord;
begin
  FileDiff := FileSize(FLogFile) - SetFilePointer(FLogFile, 0, nil, 1);
  if (FileDiff > 0) then
  begin
    SetLength(ReadBuffer, FileDiff);
    ReadFile(FLogFile, ReadBuffer[1], FileDiff, ReadCount, nil);

    OutputMemo.Text := OutputMemo.Text + ReadBuffer;
    OutputMemo.SelStart := Length(OutputMemo.Text);
    OutputMemo.SelLength := 0;
  end;
end;

procedure TMainForm.SendATCodeButtonClick(Sender : TObject);
begin
  FPhoneEngine.WaitForInput(SendATCodeEdit.Text);

  OutputMemo.SelStart := Length(OutputMemo.Text);
  OutputMemo.SelLength := 0;
end;

end.
