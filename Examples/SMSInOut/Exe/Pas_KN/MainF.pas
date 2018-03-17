unit MainF;

interface

uses
  Windows,
  UserF,
  ShtDwnU,
  SendSU,
  Messages,
  SysUtils,
  IniFiles,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  ExtCtrls,
  StdCtrls,
  ComCtrls;

const
  CEngineHandleMessage = wm_User + $101;

type
  TMessageType = (mtAdd,
                  mtAddRing,
                  mtConnect,
                  mtInitialize,
                  mtIsAdd,
                  mtIsAddRing,
                  mtIsConnect,
                  mtIsInitialize,
                  mtIsLogOn,
                  mtIsRegister,
                  mtLock,
                  mtLogOff,
                  mtLogOn,
                  mtNone,
                  mtRegister,
                  mtRem,
                  mtRemRing,
                  mtSend,
                  mtUnLock);

  TMainForm = class(TForm)
    ActionsBevel      : TBevel;
    HardCloseButton   : TButton;
    SMSInOutMemo      : TMemo;
    SMSInOutPanel     : TPanel;
    SMSInOutStatusBar : TStatusBar;
    NumberLabel: TLabel;
    NumberEdit: TEdit;
    TextLabel: TLabel;
    TextEdit: TEdit;
    SendButton: TButton;
    CountLabel: TLabel;

    procedure FormClose(Sender : TObject; var Action : TCloseAction);
    procedure FormCreate(Sender : TObject);
    procedure FormResize(Sender : TObject);
    procedure HardCloseButtonClick(Sender : TObject);
    procedure SendButtonClick(Sender : TObject);
    procedure TextEditChange(Sender : TObject);
  private
    { Private-Deklarationen }
    FAwaitedResult    : TMessageType;
    FClosed           : Boolean;
    FClosing          : Boolean;
    FEngineHandle     : LongInt;
    FInitializing     : Boolean;
    FPasswordDone     : Boolean;
    FSending          : Boolean;
    FShutdownEnabled  : Boolean;
    FShutdownPassword : String;
    FUserKnown        : Boolean;
    FUserName         : String;
    FUserText         : String;

    procedure AccessCopyData(var AMessage : TwmCopyData); message wm_CopyData;
    procedure HandleEngineHandle(var AMessage : TMessage); message CEngineHandleMessage;

    function GetParam(const AParam : String) : String;

    procedure EvaluateMessage(const AMessage : String);
    procedure MakeError;
    procedure MakeSuccess;
    procedure MakeWarning;
    procedure SendMessage(const AMessageType : TMessageType; const AMessageParams : String);
    procedure SetCaption(const ACaption : String);
    procedure SetStatus(const AStatus : String);
    procedure WriteText(const AText : String);

    procedure Add(const AParam : String);
    procedure AddRing(const AParam : String);
    procedure Connect(const AParam : String);
    procedure Initialize(const AParam : String);
    procedure IsAdd(const AParam : String);
    procedure IsAddRing(const AParam : String);
    procedure IsConnect(const AParam : String);
    procedure IsInitialize(const AParam : String);
    procedure IsLogOn(const AParam : String);
    procedure IsRegister(const AParam : String);
    procedure Lock(const AParam : String);
    procedure LogOff(const AParam : String);
    procedure LogOn(const AParam : String);
    procedure None(const AParam : String);
    procedure Register(const AParam : String);
    procedure Rem(const AParam : String);
    procedure RemRing(const AParam : String);
    procedure Send(const AParam : String);
    procedure UnLock(const AParam : String);
  public
    { Public-Deklarationen }
  end;

var
  MainForm : TMainForm;

implementation

const
  CCaption = 'SMS-In-Out';

{$R *.dfm}

procedure TMainForm.FormClose(Sender : TObject; var Action : TCloseAction);
var
  IniFile : TIniFile;
begin
  HardCloseButton.Visible := true;

  IniFile := TIniFile.Create('SMSInOutDLL.ini');
  try
    IniFile.WriteInteger('SMSInOutDLL', 'SMSInOutExeHandle', 0);
  finally
    IniFile.Free;
    IniFile := nil;
  end;

  if not(FClosing) then
  begin
    FInitializing := false;
    FSending      := false;

    FClosing := true;
    None('');
    SetCaption('Closing');
  end;
  if not(FClosed) then
    Action := caNone;
end;

procedure TMainForm.FormCreate(Sender : TObject);
var
  IniFile : TIniFile;
begin
  FPasswordDone := false;

  FAwaitedResult := mtNone;
  FClosed        := false;
  FClosing       := false;
  FEngineHandle  := 0;
  FInitializing  := false;
  FSending       := false;
  FUserKnown     := false;

  FShutdownEnabled := InputQuery('Shutdown-Password', 'Enter A Shutdown-Password Or Press <Cancel> To Disable The Shutdown-Fuctionality:', FShutdownPassword);

  IniFile := TIniFile.Create('SMSInOutDLL.ini');
  try
    IniFile.WriteInteger('SMSInOutDLL', 'SMSInOutExeHandle', Self.Handle);
  finally
    IniFile.Free;
    IniFile := nil;
  end;

  SetCaption('Engine' + #58#32 + 'pending');
  SetStatus('Waiting for Engine-Handle');

  FPasswordDone := true;
end;

procedure TMainForm.FormResize(Sender : TObject);
begin
  ActionsBevel.Left    := SMSInOutPanel.ClientWidth - HardCloseButton.Width - 20;
  HardCloseButton.Left := SMSInOutPanel.ClientWidth - HardCloseButton.Width - 10;
  NumberEdit.Left      := 10;
  SendButton.Left      := SMSInOutPanel.ClientWidth - SendButton.Width - 10;
  TextEdit.Left        := 10;
  TextEdit.Width       := Width - (Width - ActionsBevel.Left) - 20;

  CountLabel.Left := SendButton.Left;    

  if (Width < (ActionsBevel.Width + NumberEdit.Width + HardCloseButton.Width + 40)) then
    Width := ActionsBevel.Width + NumberEdit.Width + HardCloseButton.Width + 40;
end;

procedure TMainForm.HardCloseButtonClick(Sender : TObject);
begin
  FClosed := true;
  Close;
end;

procedure TMainForm.SendButtonClick(Sender : TObject);
var
  Proceed : Boolean;
begin
  if not(FSending) then
  begin
    if (Length(NumberEdit.Text) > 0) then
    begin
      Proceed := (Length(TextEdit.Text) > 0);
      if not Proceed then
        Proceed := (MessageDlg('Question: No Text Entered.' + #13#10 + 'Proceed?', mtConfirmation, [mbYes, mbNo], 0) = mrYes);

      if Proceed then
      begin
        FClosing      := false;
        FInitializing := false;

        FSending := true;
        None('');
      end;
    end
    else
      MessageDlg('Error: No Receiver-Number Entered', mtError, [mbOK], 0);
  end
  else
    MessageDlg('Error: Still Sending Another Message', mtError, [mbOK], 0);
end;

procedure TMainForm.TextEditChange(Sender : TObject);
begin
  CountLabel.Caption := IntToStr(160 - Length(TextEdit.Text));
end;

procedure TMainForm.AccessCopyData(var AMessage : TwmCopyData);
var
  MessageSender : THandleLongWord;
  MessageText   : String;
begin
  if FPasswordDone then
  begin
    if GetMessageData(AMessage, MessageText, MessageSender) then
    begin
      if (MessageSender = FEngineHandle) then
        EvaluateMessage(MessageText)
      else
      begin
        WriteText(MessageText);

        MessageText := Copy(MessageText, Succ(Pos(#58, MessageText)), Length(MessageText) - Pos(#48, MessageText));
        MessageText := Copy(MessageText, Succ(Pos(#58, MessageText)), Length(MessageText) - Pos(#48, MessageText));
        if ((AnsiLowerCase(Trim(Copy(MessageText, 1, Pos(#32, MessageText)))) = 'shutdown') and
            (Trim(Copy(MessageText, Succ(Pos(#32, MessageText)), Length(MessageText) - Pos(#32, MessageText))) = FShutdownPassword) and
            FShutdownEnabled) then
        begin
          if (MessageDlg('Shutdown queried. Proceed?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
            DoShutdown;
        end;
      end;
    end;
  end;
end;

procedure TMainForm.HandleEngineHandle(var AMessage : TMessage);
begin
  if FPasswordDone then
  begin
    if (FEngineHandle = 0) then
    begin
      if (AMessage.Msg = CEngineHandleMessage) then
      begin
        FEngineHandle := AMessage.WParam;

        FInitializing  := true;
        None('');
        SetCaption('Engine' + #58#32 + IntToHex(FEngineHandle, 0) + #104);
      end;
    end;
  end;
end;

function TMainForm.GetParam(const AParam : String) : String;
var
  Index : LongInt;
begin
  SetLength(Result, Length(AParam) * 2 + 2);
  for Index := 1 to Length(AParam) do
  begin
    Result[Index * 2 + 0] := #47;
    Result[Index * 2 + 1] := AParam[Index];
  end;

  Result[1]              := #34;
  Result[Length(Result)] := #34;
end;

procedure TMainForm.EvaluateMessage(const AMessage : String);
var
  TempMessage : String;
begin
  TempMessage := Trim(Copy(AMessage, 1, Pred(Pos(#58, AMessage))));
  if (Length(TempMessage) > 0) then
  begin
    if (TempMessage[1] = #46) then
    begin
      TempMessage := AnsiLowerCase(Trim(Copy(TempMessage, 2, Pred(Length(TempMessage)))));

      if (TempMessage = 'add') and (FAwaitedResult = mtAdd) then
        Add(Copy(AMessage, Pos(#58, AMessage) + Length(#58), Succ(Length(AMessage) - (Pos(#58, AMessage) + Length(#58)))));
      if (TempMessage = 'addring') and (FAwaitedResult = mtAddRing) then
        AddRing(Copy(AMessage, Pos(#58, AMessage) + Length(#58), Succ(Length(AMessage) - (Pos(#58, AMessage) + Length(#58)))));
      if (TempMessage = 'connect') and (FAwaitedResult = mtConnect) then
        Connect(Copy(AMessage, Pos(#58, AMessage) + Length(#58), Succ(Length(AMessage) - (Pos(#58, AMessage) + Length(#58)))));
      if (TempMessage = 'initialize') and (FAwaitedResult = mtInitialize) then
        Initialize(Copy(AMessage, Pos(#58, AMessage) + Length(#58), Succ(Length(AMessage) - (Pos(#58, AMessage) + Length(#58)))));
      if (TempMessage = 'isadd') and (FAwaitedResult = mtIsAdd) then
        IsAdd(Copy(AMessage, Pos(#58, AMessage) + Length(#58), Succ(Length(AMessage) - (Pos(#58, AMessage) + Length(#58)))));
      if (TempMessage = 'isaddring') and (FAwaitedResult = mtIsAddRing) then
        IsAddRing(Copy(AMessage, Pos(#58, AMessage) + Length(#58), Succ(Length(AMessage) - (Pos(#58, AMessage) + Length(#58)))));
      if (TempMessage = 'isconnect') and (FAwaitedResult = mtIsConnect) then
        IsConnect(Copy(AMessage, Pos(#58, AMessage) + Length(#58), Succ(Length(AMessage) - (Pos(#58, AMessage) + Length(#58)))));
      if (TempMessage = 'isinitialize') and (FAwaitedResult = mtIsInitialize) then
        IsInitialize(Copy(AMessage, Pos(#58, AMessage) + Length(#58), Succ(Length(AMessage) - (Pos(#58, AMessage) + Length(#58)))));
      if (TempMessage = 'islogon') and (FAwaitedResult = mtIsLogOn) then
        IsLogOn(Copy(AMessage, Pos(#58, AMessage) + Length(#58), Succ(Length(AMessage) - (Pos(#58, AMessage) + Length(#58)))));
      if (TempMessage = 'isregister') and (FAwaitedResult = mtIsRegister) then
        IsRegister(Copy(AMessage, Pos(#58, AMessage) + Length(#58), Succ(Length(AMessage) - (Pos(#58, AMessage) + Length(#58)))));
      if (TempMessage = 'lock') and (FAwaitedResult = mtLock) then
        Lock(Copy(AMessage, Pos(#58, AMessage) + Length(#58), Succ(Length(AMessage) - (Pos(#58, AMessage) + Length(#58)))));
      if (TempMessage = 'logoff') and (FAwaitedResult = mtLogOff) then
        LogOff(Copy(AMessage, Pos(#58, AMessage) + Length(#58), Succ(Length(AMessage) - (Pos(#58, AMessage) + Length(#58)))));
      if (TempMessage = 'logon') and (FAwaitedResult = mtLogOn) then
        LogOn(Copy(AMessage, Pos(#58, AMessage) + Length(#58), Succ(Length(AMessage) - (Pos(#58, AMessage) + Length(#58)))));
      if (TempMessage = 'rem') and (FAwaitedResult = mtRem) then
        Rem(Copy(AMessage, Pos(#58, AMessage) + Length(#58), Succ(Length(AMessage) - (Pos(#58, AMessage) + Length(#58)))));
      if (TempMessage = 'remring') and (FAwaitedResult = mtRemRing) then
        RemRing(Copy(AMessage, Pos(#58, AMessage) + Length(#58), Succ(Length(AMessage) - (Pos(#58, AMessage) + Length(#58)))));
      if (TempMessage = 'register') and (FAwaitedResult = mtRegister) then
        Register(Copy(AMessage, Pos(#58, AMessage) + Length(#58), Succ(Length(AMessage) - (Pos(#58, AMessage) + Length(#58)))));
      if (TempMessage = 'send') and (FAwaitedResult = mtSend) then
        Send(Copy(AMessage, Pos(#58, AMessage) + Length(#58), Succ(Length(AMessage) - (Pos(#58, AMessage) + Length(#58)))));
      if (TempMessage = 'unlock') and (FAwaitedResult = mtUnLock) then
        UnLock(Copy(AMessage, Pos(#58, AMessage) + Length(#58), Succ(Length(AMessage) - (Pos(#58, AMessage) + Length(#58)))));
    end;
  end;
end;

procedure TMainForm.MakeError;
begin
  if FInitializing or FSending then
  begin
    SetStatus('Initialization Failed');
    WriteText(#91 + 'Error Occured While Initializing Engine' + #93);
  end
  else
  begin
    SetStatus('DeInitialization Failed');
    WriteText(#91 + 'Error Occured While DeInitializing Engine' + #93);

    FClosed := true;
  end;
end;

procedure TMainForm.MakeSuccess;
begin
  SetStatus('Engine ready');
  WriteText(#91 + 'Initialization successful' + #93);
end;

procedure TMainForm.MakeWarning;
begin
  if FInitializing then
  begin
    SetStatus('Engine ready [Account not locked]');
    WriteText(#91 + 'Initialization successful' + #93);
    WriteText(#91 + 'Warning: Account could not be locked!' + #93);
    MessageDlg('Account could not be locked!', mtWarning, [mbOK], 0);
  end
  else
  begin
    SetStatus('[Account not logged off]');
    WriteText(#91 + 'DeInitialization successful' + #93);
    WriteText(#91 + 'Warning: Account could not be logged of!' + #93);
    MessageDlg('Account could not be logged off!', mtWarning, [mbOK], 0);
  end;
end;

procedure TMainForm.SendMessage(const AMessageType : TMessageType; const AMessageParams : String);
var
  MessageText : String;
begin
  if (FEngineHandle <> 0) then
  begin
    FAwaitedResult := AMessageType;

    MessageText := '';
    case FAwaitedResult of
      mtAdd          : MessageText := MessageText + '?add';
      mtAddRing      : MessageText := MessageText + '?addring';
      mtConnect      : MessageText := MessageText + '?connect';
      mtInitialize   : MessageText := MessageText + '?initialize';
      mtIsAdd        : MessageText := MessageText + '?isadd';
      mtIsAddRing    : MessageText := MessageText + '?isaddring';
      mtIsConnect    : MessageText := MessageText + '?isconnect';
      mtIsInitialize : MessageText := MessageText + '?isinitialize';
      mtIsLogOn      : MessageText := MessageText + '?islogon';
      mtIsRegister   : MessageText := MessageText + '?isregister';
      mtLock         : MessageText := MessageText + '?lock';
      mtLogOn        : MessageText := MessageText + '?logon';
      mtLogOff       : MessageText := MessageText + '?logoff';
      mtRegister     : MessageText := MessageText + '?register';
      mtRem          : MessageText := MessageText + '?rem';
      mtRemRing      : MessageText := MessageText + '?remring';
      mtSend         : MessageText := MessageText + '?send';
      mtUnLock       : MessageText := MessageText + '?unlock';
    end;
    MessageText := MessageText + #32 + AMessageParams;

    SetStatus('Sending Message' + #58#32 + MessageText);
    Application.ProcessMessages;
    SendStringMessage(FEngineHandle, Self.Handle, MessageText);
  end;
end;

procedure TMainForm.SetCaption(const ACaption : String);
begin
  Caption := CCaption + #32#45#32#91 + ACaption + #93;
end;

procedure TMainForm.SetStatus(const AStatus : String);
begin
  SMSInOutStatusBar.Panels[0].Text := AStatus;
end;

procedure TMainForm.WriteText(const AText : String);
begin
  SMSInOutMemo.Lines.Add(AText);

  SMSInOutMemo.SelStart  := Length(SMSInOutMemo.Lines.Text);
  SMSInOutMemo.SelLength := 0;
end;

procedure TMainForm.Add(const AParam : String);
begin
  if (Trim(AParam) = '0') then
  begin
    MakeError;
  end
  else
  begin
    SendMessage(mtIsAddRing, '"' + ExtractFilePath(Application.ExeName) + 'SMSInOut.dll" 1')
  end;
end;

procedure TMainForm.AddRing(const AParam : String);
begin
  if (Trim(AParam) = '0') then
  begin
    MakeError;
  end
  else
  begin
    SendMessage(mtIsConnect, '')
  end;
end;

procedure TMainForm.Connect(const AParam : String);
begin
  if (Trim(AParam) = '0') then
  begin
    MakeError;
  end
  else
  begin
    SendMessage(mtIsInitialize, '');
  end;
end;

procedure TMainForm.Initialize(const AParam : String);
begin
  if (Trim(AParam) = '0') then
  begin
    MakeError;
  end
  else
  begin
    SendMessage(mtLock, '');
  end;
end;

procedure TMainForm.IsAdd(const AParam : String);
begin
  if (Trim(AParam) = '0') then
  begin
    if FInitializing then
    begin
      SendMessage(mtAdd, '"' + ExtractFilePath(Application.ExeName) + 'SMSInOut.dll" 2 ""')
    end
    else
    begin
      SendMessage(mtIsAddRing, '"' + ExtractFilePath(Application.ExeName) + 'SMSInOut.dll" 1')
    end;
  end
  else
  begin
    if FInitializing then
    begin
      SendMessage(mtIsAddRing, '"' + ExtractFilePath(Application.ExeName) + 'SMSInOut.dll" 1');
    end
    else
    begin
       SendMessage(mtRem, '"' + ExtractFilePath(Application.ExeName) + 'SMSInOut.dll" 2 ""');
   end;
  end;
end;

procedure TMainForm.IsAddRing(const AParam : String);
begin
  if (Trim(AParam) = '0') then
  begin
    if FInitializing then
    begin
      SendMessage(mtAddRing, '"' + ExtractFilePath(Application.ExeName) + 'SMSInOut.dll" 1');
    end
    else
    begin
      SendMessage(mtLock, '');
    end;
  end
  else
  begin
    if FInitializing then
    begin
      SendMessage(mtIsConnect, '');
    end
    else
    begin
      SendMessage(mtRemRing, '"' + ExtractFilePath(Application.ExeName) + 'SMSInOut.dll" 1');
    end;
  end;
end;

procedure TMainForm.IsConnect(const AParam : String);
begin
  if (Trim(AParam) = '0') then
  begin
    SendMessage(mtConnect, '');
  end
  else
  begin
    SendMessage(mtIsInitialize, '');
  end;
end;

procedure TMainForm.IsInitialize(const AParam : String);
begin
  if (Trim(AParam) = '0') then
  begin
    SendMessage(mtInitialize, '');
  end
  else
  begin
    SendMessage(mtLock, '');
  end;
end;

procedure TMainForm.IsLogOn(const AParam : String);
begin
  if (Trim(AParam) = '0') then
  begin
    SendMessage(mtLogOn, GetParam(FUserName) + #32 + GetParam(FUserText));
  end
  else
  begin
    if FSending then
      SendMessage(mtSend, GetParam(NumberEdit.Text) + #32 + GetParam(TextEdit.Text))
    else
      SendMessage(mtUnLock, '');
  end;
end;

procedure TMainForm.IsRegister(const AParam : String);
begin
  if (Trim(AParam) = '0') then
  begin
    SendMessage(mtRegister, GetParam(FUserName) + #32 + GetParam(FUserText));
  end
  else
  begin
    SendMessage(mtIsLogOn, '');
  end;
end;

procedure TMainForm.Lock(const AParam : String);
begin
  if (Trim(AParam) = '0') then
  begin
    FInitializing := false;

    MakeWarning;
  end
  else
  begin
    if FInitializing then
    begin
      FInitializing := false;

      MakeSuccess;
    end
    else
    begin
      SendMessage(mtLogOff, '');
    end;
  end;
end;

procedure TMainForm.LogOff(const AParam : String);
begin
  FClosed := true;

  if (Trim(AParam) = '0') then
  begin
    MakeWarning;
  end
  else
  begin
    Close;
  end;
end;

procedure TMainForm.LogOn(const AParam : String);
begin
  if (Trim(AParam) = '0') then
  begin
    MakeError;
  end
  else
  begin
    if FSending then
      SendMessage(mtSend, GetParam(NumberEdit.Text) + #32 + GetParam(TextEdit.Text))
    else
      SendMessage(mtUnLock, '');
  end;
end;

procedure TMainForm.None(const AParam : String);
begin
  if FInitializing and not(FClosing or FSending) then
    FUserKnown := GetUserData(FUserName, FUserText);
    
  if FUserKnown then
    SendMessage(mtIsRegister, GetParam(FUserName) + #32 + GetParam(AParam))
  else
    MakeError;
end;

procedure TMainForm.Register(const AParam : String);
begin
  if (Trim(AParam) = '0') then
  begin
    MakeError;
  end
  else
  begin
    SendMessage(mtLogOn, GetParam(FUserName) + #32 + GetParam(FUserText));
  end;
end;

procedure TMainForm.Rem(const AParam : String);
begin
  if (Trim(AParam) = '0') then
  begin
    MakeError;
  end
  else
  begin
    SendMessage(mtIsAddRing, '"' + ExtractFilePath(Application.ExeName) + 'SMSInOut.dll" 1')
  end;
end;

procedure TMainForm.RemRing(const AParam : String);
begin
  if (Trim(AParam) = '0') then
  begin
    MakeError;
  end
  else
  begin
    SendMessage(mtLock, '');
  end;
end;

procedure TMainForm.Send(const AParam : String);
begin
  FSending := false;

  if (Trim(AParam) = '0') then
  begin
    MessageDlg('Error: Not Able To Submit Message To Send-Queue', mtError, [mbOK], 0);
  end
  else
  begin
    MessageDlg('Info: Able To Submit Message To Send-Queue', mtInformation, [mbOK], 0);
  end;
end;

procedure TMainForm.UnLock(const AParam : String);
begin
  if (Trim(AParam) = '0') then
  begin
    MakeError;
  end
  else
  begin
    SendMessage(mtIsAdd, '"' + ExtractFilePath(Application.ExeName) + 'SMSInOut.dll" 2 ""');
  end;
end;

end.
