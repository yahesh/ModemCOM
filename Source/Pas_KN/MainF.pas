unit MainF;

// DON'T DELETE THIS COMMENT !!!

{--------------------------------------------}
{ Unit:      MainF.pas                       }
{ Version:   1.01                            }
{                                            }
{ Coder:     Yahe <hello@yahe.sh>            }
{                                            }
{ I'm NOT Liable For Damages Of ANY Kind !!! }
{--------------------------------------------}

// DON'T DELETE THIS COMMENT !!!

interface

{$I PhoneI.inc}

{.$Define UseFiles}

uses
  Windows,
  UsersU,
  SysUtils,
  StdCtrls,
  ShellAPI,
  SendSU,
  PhoneU,
  Messages,
  Forms,
  ExtCtrls,
  Dialogs,
  Controls,
  Classes,
  Buttons;

const
  CEngineHandleMessage = wm_User + $101;
  CTaskBarText         = '|Shorei| ModemCOM - Engine';
  CTaskBarMessage      = wm_User + $303;

  CVersionInfoText = 'ModemCOM 1.1.2.6';

type
  TEventRecord = record
    EventParamCount : Byte;
    EventText       : String;
  end;

  TStringArray   = array of String;
  TIconType      = (itAllFine, itError, itWorking);
  TEventFunction = function (const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String of Object;
  TEventArray    = array of TEventFunction;

  TMainForm = class(TForm)
    CloseBitBtn       : TBitBtn;
    HideBitBtn        : TBitBtn;
    MainImage         : TImage;
    MainTimer         : TTimer;
    ResponsesBevel    : TBevel;
    ResponsesMemo     : TMemo;
    SendBitBtn        : TBitBtn;
    SendCommandsLabel : TLabel;
    SendCommandsMemo  : TMemo;

    procedure CloseBitBtnClick(Sender : TObject);
    procedure FormCreate(Sender : TObject);
    procedure FormDestroy(Sender : TObject);
    procedure HideBitBtnClick(Sender : TObject);
    procedure MainTimerTimer(Sender : TObject);
    procedure SendBitBtnClick(Sender : TObject);
  private
    { Private-Deklarationen }
    FPhoneEngine : TPhoneEngine;
    FUserList    : TUserList;

    FAutoConnect  : Boolean;
    FAutoEnter    : Boolean;
    FAutoEnterPin : String;
    FAutoInit     : Boolean;

    FCurrentStatus : TIconType;
    FStartedUp     : Boolean;
    FNotReceived   : Byte;
    FReceived      : Boolean;
    FTaskBarText   : String;

    procedure AccessCopyData(var AMessage : TwmCopyData); message wm_CopyData;
    procedure BroadcastMessage(const AMessage : LongWord; const ALParam : LongInt; const AWParam : LongInt);
    procedure DoMove(var AMessage : TwmNcHitTest); message wm_NcHitTest;
    procedure EngineHandleEvents(var AMessage : TMessage); message CEngineHandleMessage;
    procedure LoadCurrentIcon(const AStatus : TIconType);
    procedure LoadOptions;
    procedure LoadUsers;
    procedure PutToTaskBar;
    procedure QueryEndSessionEvents(var AMessage : TMessage); message wm_QueryEndSession;
    procedure SaveOptions;
    procedure SaveUsers;
    procedure SetCurrentStatus(const AStatus : TIconType);
    procedure TakeFromTaskBar;
    procedure TaskBarEvents(var AMessage : TMessage); message CTaskBarMessage;
    procedure UpdateInTaskBar;
  public
    { Public-Deklarationen }
    FEventArray : TEventArray;

    function Add(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
    function AddRing(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
    function Connect(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
    function DisConnect(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
    function GetPort(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
    function Initialize(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
    function IsAdd(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
    function IsAddDLL(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
    function IsAddDLLMeth(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
    function IsAddMeth(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
    function IsAddText(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
    function IsAddRing(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
    function IsAddRingB(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
    function IsConnect(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
    function IsInitialize(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
    function IsLock(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
    function IsLogOn(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
    function IsRegister(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
    function Lock(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
    function LogOff(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
    function LogOn(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
    function Register(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
    function Rem(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
    function RemDLL(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
    function RemDLLMeth(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
    function RemMeth(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
    function RemText(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
    function RemRing(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
    function RemRingB(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
    function Send(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
    function SetPort(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
    function ShutDown(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
    function Test(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
    function Version(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
    function UnLock(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
  end;

var
  MainForm : TMainForm;

const
  CEventTexts : array [0..34] of TEventRecord = ((EventParamCount : 3; EventText : 'add'),
                                                 (EventParamCount : 2; EventText : 'addring'),
                                                 (EventParamCount : 0; EventText : 'connect'),
                                                 (EventParamCount : 0; EventText : 'disconnect'),
                                                 (EventParamCount : 0; EventText : 'getport'),
                                                 (EventParamCount : 0; EventText : 'initialize'),
                                                 (EventParamCount : 3; EventText : 'isadd'),
                                                 (EventParamCount : 1; EventText : 'isadddll'),
                                                 (EventParamCount : 2; EventText : 'isadddllmeth'),
                                                 (EventParamCount : 1; EventText : 'isaddmeth'),
                                                 (EventParamCount : 1; EventText : 'isaddtext'),
                                                 (EventParamCount : 2; EventText : 'isaddring'),
                                                 (EventParamCount : 0; EventText : 'isaddringb'),
                                                 (EventParamCount : 0; EventText : 'isconnect'),
                                                 (EventParamCount : 0; EventText : 'isinitialize'),
                                                 (EventParamCount : 0; EventText : 'islock'),
                                                 (EventParamCount : 0; EventText : 'islogon'),
                                                 (EventParamCount : 1; EventText : 'isregister'),
                                                 (EventParamCount : 0; EventText : 'lock'),
                                                 (EventParamCount : 0; EventText : 'logoff'),
                                                 (EventParamCount : 2; EventText : 'logon'),
                                                 (EventParamCount : 2; EventText : 'register'),
                                                 (EventParamCount : 3; EventText : 'rem'),
                                                 (EventParamCount : 1; EventText : 'remdll'),
                                                 (EventParamCount : 2; EventText : 'remdllmeth'),
                                                 (EventParamCount : 0; EventText : 'remmeth'),
                                                 (EventParamCount : 1; EventText : 'remtext'),
                                                 (EventParamCount : 2; EventText : 'remring'),
                                                 (EventParamCount : 0; EventText : 'remringb'),
                                                 (EventParamCount : 2; EventText : 'send'),
                                                 (EventParamCount : 1; EventText : 'setport'),
                                                 (EventParamCount : 0; EventText : 'shutdown'),
                                                 (EventParamCount : 1; EventText : 'test'),
                                                 (EventParamCount : 0; EventText : 'version'),
                                                 (EventParamCount : 0; EventText : 'unlock'));

implementation

{$IfnDef UseFiles}
uses
  Registry;

const
  CRegistryRoot = hKey_Local_Machine;
  CRegistryKey  = 'Software\Shorei\ModemCOM\';
  CUserDataKey  = 'users\';

  CAutoConnect   = 'aconnect';
  CAutoEnter     = 'aenter';
  CAutoEnterPin  = 'aenterpin';
  CAutoInit      = 'ainit';
  CDllMethod     = 'methodname';
  CDllName       = 'dllname';
  CMethodCount   = 'methcount';
  CMethodID      = 'methid';
  CMethodIsRing  = 'methisring';
  CMethodLibrary = 'methlib';
  CMethodText    = 'methodtext';
  CPortName      = 'portname';
  CPortSync      = 'portsync';
  CPrivilege     = 'privilege';
  CUserCount     = 'count';
  CUserLocked    = 'locked';
  CUserName      = 'user';
  CUserText      = 'text';
{$EndIf UseFiles}

{$R *.dfm}

procedure TMainForm.CloseBitBtnClick(Sender : TObject);
begin
  Self.Close;
end;

procedure TMainForm.FormCreate(Sender : TObject);
begin
  Application.ShowMainForm := false;
  Self.PutToTaskBar;
  Self.SetCurrentStatus(itWorking);

  Self.MainImage.Picture.Bitmap.Height := Self.ClientHeight;
  Self.MainImage.Picture.Bitmap.Width  := Self.ClientWidth;

  Self.MainImage.Picture.Bitmap.Canvas.Pen.Width := 3;

  Self.MainImage.Picture.Bitmap.Canvas.MoveTo(0, 0);
  Self.MainImage.Picture.Bitmap.Canvas.LineTo(Pred(Self.ClientWidth), 0);
  Self.MainImage.Picture.Bitmap.Canvas.LineTo(Pred(Self.ClientWidth), Pred(Self.ClientHeight));
  Self.MainImage.Picture.Bitmap.Canvas.LineTo(0, Pred(Self.ClientHeight));
  Self.MainImage.Picture.Bitmap.Canvas.LineTo(0, 0);

  Self.FAutoConnect  := false;
  Self.FAutoEnter    := false;
  Self.FAutoEnterPin := '';
  Self.FAutoInit     := false;

  Self.FStartedUp   := false;
  Self.FNotReceived := 0;
  Self.FReceived    := false;
  Self.FTaskBarText := CTaskBarText;

  SetLength(Self.FEventArray, Length(CEventTexts));
  Self.FEventArray[0]  := Self.Add;
  Self.FEventArray[1]  := Self.AddRing;
  Self.FEventArray[2]  := Self.Connect;
  Self.FEventArray[3]  := Self.DisConnect;
  Self.FEventArray[4]  := Self.GetPort;
  Self.FEventArray[5]  := Self.Initialize;
  Self.FEventArray[6]  := Self.IsAdd;
  Self.FEventArray[7]  := Self.IsAddDLL;
  Self.FEventArray[8]  := Self.IsAddDLLMeth;
  Self.FEventArray[9]  := Self.IsAddMeth;
  Self.FEventArray[10] := Self.IsAddText;
  Self.FEventArray[11] := Self.IsAddRing;
  Self.FEventArray[12] := Self.IsAddRingB;
  Self.FEventArray[13] := Self.IsConnect;
  Self.FEventArray[14] := Self.IsInitialize;
  Self.FEventArray[15] := Self.IsLock;
  Self.FEventArray[16] := Self.IsLogon;
  Self.FEventArray[17] := Self.IsRegister;
  Self.FEventArray[18] := Self.Lock;
  Self.FEventArray[19] := Self.LogOff;
  Self.FEventArray[20] := Self.LogOn;
  Self.FEventArray[21] := Self.Register;
  Self.FEventArray[22] := Self.Rem;
  Self.FEventArray[23] := Self.RemDLL;
  Self.FEventArray[24] := Self.RemDLLMeth;
  Self.FEventArray[25] := Self.RemMeth;
  Self.FEventArray[26] := Self.RemText;
  Self.FEventArray[27] := Self.RemRing;
  Self.FEventArray[28] := Self.RemRingB;
  Self.FEventArray[29] := Self.Send;
  Self.FEventArray[30] := Self.SetPort;
  Self.FEventArray[31] := Self.ShutDown;
  Self.FEventArray[32] := Self.Test;
  Self.FEventArray[33] := Self.Version;
  Self.FEventArray[34] := Self.UnLock;

  Self.FPhoneEngine := TPhoneEngine.Create;
  Self.FPhoneEngine.IgnoreUser    := false;
{$IfDef EnableLogCapability}
  Self.FPhoneEngine.LogFileName   := ParamStr(0) + '.log';
  Self.FPhoneEngine.LogSimCode    := false;
  Self.FPhoneEngine.LogFileActive := true;
{$EndIf EnableLogCapability}
  Self.LoadOptions;

  Self.FUserList := TUserList.Create;
  Self.LoadUsers;

  if Self.FAutoConnect then
  begin
    if Self.FPhoneEngine.CreatePortConnection then
    begin
      if Self.FAutoInit then
        Self.FStartedUp := Self.FPhoneEngine.InitializeSiemensTC35I(Self.FAutoEnterPin, not(Self.FAutoEnter));
    end;
  end;

  Self.SetCurrentStatus(itAllFine);

  Self.MainTimer.Enabled := true;
end;

procedure TMainForm.FormDestroy(Sender : TObject);
begin
  Self.SetCurrentStatus(itWorking);

  Self.MainTimer.Enabled := false;

  Self.SaveUsers;
  Self.FUserList.ClearAll;
  Self.FUserList.Free;

  Self.SaveOptions;
  Self.FPhoneEngine.Free;

  Self.BroadcastMessage(CEngineHandleMessage, 0, 0);
  Self.SetCurrentStatus(itAllFine);
  Self.TakeFromTaskBar;
end;

procedure TMainForm.HideBitBtnClick(Sender : TObject);
begin
  Self.Hide;
  Self.DeActivate;

  Application.ShowMainForm := false;
end;

procedure TMainForm.MainTimerTimer(Sender : TObject);
begin
  Self.BroadcastMessage(CEngineHandleMessage, 0, Self.Handle);

  if Self.FReceived then
  begin
    Self.FNotReceived := 0;
    Self.FReceived    := false;
  end
  else
  begin
    if (Self.FNotReceived >= 5) then
      MessageDlg('Error: not receiving own EngineHandle-Message' + #32#40#36 + IntToHex(CEngineHandleMessage, 0) + #104#41, mtError, [mbOK], 0);

    Inc(Self.FNotReceived);
  end;
end;

procedure TMainForm.SendBitBtnClick(Sender : TObject);
begin
  SendStringMessage(Self.Handle, Self.Handle, Self.SendCommandsMemo.Text);

  Self.SendCommandsMemo.Text := '';
end;

procedure TMainForm.AccessCopyData(var AMessage : TwmCopyData);
  function ExecuteEvent(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
  var
    EventNumber : LongInt;
    Index       : LongInt;
  begin
    Result := '';

    EventNumber := - 1;
    for Index := Low(CEventTexts) to High(CEventTexts) do
    begin
      if (AnsiLowerCase(Trim(AMessageEvent)) = AnsiLowerCase(Trim(CEventTexts[Index].EventText))) then
      begin
        EventNumber := Index;

        Break;
      end;
    end;

    if (EventNumber >= Low(CEventTexts)) and (EventNumber <= High(CEventTexts)) then
    begin
      if (Length(AMessageParams) >= CEventTexts[EventNumber].EventParamCount) then
      begin
        if (Length(Self.FEventArray) >= EventNumber) then
        begin
          if Assigned(Self.FEventArray[EventNumber]) then
            Result := Self.FEventArray[EventNumber](ASenderHandle, AMessageEvent, AMessageParams)
          else
            Result := 'ERROR: Empty Eventhandler For "' + AMessageEvent + '"';
        end
        else
          Result := 'ERROR: Unknown Eventhandler For "' + AMessageEvent + '"';
      end
      else
        Result := 'ERROR: Missing Parameter For Event "' + AMessageEvent + '"';
    end
    else
      Result := 'ERROR: Unknown Event "' + AMessageEvent + '"';
  end;

  function GetNextLine(var AText : String; var ANextLine : String) : Boolean;
  begin
    Result := false;

    ANextLine := '';
    if (Length(AText) > 0) then
    begin
      if (Pos(CDefaultLineDelimiter, AText) > 0) then
      begin
        ANextLine := Copy(AText, 1, Pred(Pos(CDefaultLineDelimiter, AText)));
        AText     := Copy(AText, Pos(CDefaultLineDelimiter, AText) + Length(CDefaultLineDelimiter), Succ(Length(AText) - Pos(CDefaultLineDelimiter, AText) - Length(CDefaultLineDelimiter)));
      end
      else
      begin
        ANextLine := AText;
        AText     := '';
      end;

      Result := true;
    end;
  end;

  function GetNextParam(var AText : String; var ANextParam : String) : Boolean;
  var
    Counter : LongInt;
    Done    : Boolean;
    Index   : LongInt;
    Marked  : Boolean;
    Opened  : Boolean;
    Started : Boolean;
  begin
    Result := false;

    AText := Trim(AText);

    if (Length(AText) > 0) then
    begin
      SetLength(ANextParam, Length(AText));

      Counter := 0;
      Done    := false;
      Index   := 1;
      Marked  := false;
      Opened  := false;
      Started := false;
      while not(Done) and not(Index > Length(AText)) do
      begin
        if Marked then
        begin
          Marked := false;

          Inc(Counter);
          ANextParam[Counter] := AText[Index];
        end
        else
        begin
          case AText[Index] of
            #32 :
            begin
              if Started then
              begin
                Done := not(Opened);

                if not(Done) then
                begin
                  Inc(Counter);
                  ANextParam[Counter] := AText[Index];
                end;
              end;
            end;

            #34 :
            begin
              Done := Opened;

              if not(Done) then
              begin
                Opened  := true;
                Started := true;
              end;
            end;

            #47 :
            begin
              Marked := Opened;

              if not(Marked) then
              begin
                Inc(Counter);
                ANextParam[Counter] := AText[Index];
              end;
            end;
          else
            Started := true;

            Inc(Counter);
            ANextParam[Counter] := AText[Index];
          end;
        end;

        Inc(Index);
      end;
      Result := Done or (Index > Length(AText));

      AText := Copy(AText, Index, Succ(Length(AText) - Index));
      SetLength(ANextParam, Counter);
    end;
  end;

const
  CStartChars = [#33, #63];
var
  DoResult      : Boolean;
  MessageEvent  : String;
  MessageLine   : String;
  MessageParams : TStringArray;
  MessageSender : THandleLongWord;
  MessageText   : String;
  ResultText    : String;
begin
  Self.SetCurrentStatus(itWorking);

  AMessage.Result := Ord(false);

  if GetMessageData(AMessage, MessageText, MessageSender) then
  begin
    MessageText := Trim(MessageText);
    while GetNextLine(MessageText, MessageLine) do
    begin
      ResultText := '';

      if (Length(MessageLine) > 0) then
      begin
        if (MessageLine[1] in CStartChars) then
        begin
          DoResult := (MessageLine[1] = #63);
          Delete(MessageLine, 1, 1);

          if GetNextParam(MessageLine, MessageEvent) then
          begin
            MessageEvent := AnsiLowerCase(Trim(MessageEvent));

            SetLength(MessageParams, 1);
            while GetNextParam(MessageLine, MessageParams[High(MessageParams)]) do
            begin
              MessageParams[High(MessageParams)] := MessageParams[High(MessageParams)];
              SetLength(MessageParams, Succ(Length(MessageParams)));
            end;
            SetLength(MessageParams, Pred(Length(MessageParams)));

            ResultText := ExecuteEvent(MessageSender, MessageEvent, MessageParams);
          end;

          if DoResult then
          begin
            if (MessageSender = 0) or
               (MessageSender = Self.Handle) then
              Self.ResponsesMemo.Lines.Add(#46 + ResultText)
            else
              SendStringMessage(MessageSender, Self.Handle, #46 + ResultText);
          end;
        end;
      end;
    end;

    AMessage.Result := Ord(true);
  end;

  Self.SetCurrentStatus(itAllFine);
end;

procedure TMainForm.BroadcastMessage(const AMessage : LongWord; const ALParam : LongInt; const AWParam : LongInt);
var
  WindowHandle : THandleLongWord;
begin
  WindowHandle := GetTopWindow(0);
  PostMessage(WindowHandle, AMessage, AWParam, ALParam);
  while not(GetNextWindow(WindowHandle, gw_HwndNext) = 0) do
  begin
    WindowHandle := GetNextWindow(WindowHandle, gw_HwndNext);
    PostMessage(WindowHandle, AMessage, AWParam, ALParam);
  end;
end;

procedure TMainForm.DoMove(var AMessage : TwmNcHitTest);
begin
  inherited;

  if AMessage.Result = htClient then
    AMessage.Result := htCaption;
end;

procedure TMainForm.LoadCurrentIcon(const AStatus : TIconType);
var
  ResourceStream : TResourceStream;
begin
  ResourceStream := TResourceStream.CreateFromID(hInstance, 100 + Ord(AStatus), rt_RCData);
  try
    Self.Icon.LoadFromStream(ResourceStream);
  finally
    ResourceStream.Free;
  end;

  Self.UpdateInTaskBar;
end;

procedure TMainForm.LoadOptions;
var
{$IfnDef UseFiles}
  Registry : TRegistry;
{$EndIf}
begin
{$IfnDef UseFiles}
  Registry := TRegistry.Create;
  try
    Registry.RootKey := CRegistryRoot;

    Registry.CloseKey;
    if Registry.OpenKey(CRegistryKey + #92, false) then
    begin
      Self.FPhoneEngine.PortName       := Registry.ReadString(CPortName);
      Self.FPhoneEngine.SyncPortEvents := Registry.ReadBool(CPortSync);

      Self.FAutoConnect  := Registry.ReadBool(CAutoConnect);
      Self.FAutoEnter    := Registry.ReadBool(CAutoEnter);
      Self.FAutoEnterPin := Registry.ReadString(CAutoEnterPin);
      Self.FAutoInit     := Registry.ReadBool(CAutoInit);
    end;
  finally
    Registry.Free;
    Registry := nil;
  end;
{$EndIf}
end;

procedure TMainForm.LoadUsers;
var
{$IfnDef UseFiles}
  Current       : TUserItem;
  CurrentB      : TModuleItem;
  Index         : LongInt;
  IndexB        : LongInt;
  MaxCount      : LongInt;
  MaxCountB     : LongInt;
  MethodLibrary : String;
  MethodID      : LongInt;
  MethodIsRing  : Boolean;
  MethodText    : String;
  Privilege     : TUserPrivilege;
  Registry      : TRegistry;
  UserLocked    : Boolean;
  UserName      : String;
  UserText      : String;
{$EndIf}
begin
  Self.FPhoneEngine.ClearEventList;
  Self.FUserList.ClearAll;

{$IfnDef UseFiles}
  Registry := TRegistry.Create;
  try
    Registry.RootKey := CRegistryRoot;

    Registry.CloseKey;
    if Registry.OpenKey(CRegistryKey + CUserDataKey + #92, false) then
      MaxCount := Registry.ReadInteger(CUserCount)
    else
      MaxCount := 0;

    for Index := 0 to Pred(MaxCount) do
    begin
      UserName := '';
      UserText := '';

      Registry.CloseKey;
      if Registry.OpenKey(CRegistryKey + CUserDataKey + #92, false) then
      begin
        UserName := Registry.ReadString(CUserName + IntToStr(Index));

        Registry.CloseKey;
        if Registry.OpenKey(CRegistryKey + CUserDataKey + AnsiLowerCase(Trim(UserName)) + #92, false) then
        begin
          MaxCountB  := Registry.ReadInteger(CMethodCount);
          Privilege  := TUserPrivilege(Registry.ReadInteger(CPrivilege));
          UserLocked := Registry.ReadBool(CUserLocked);
          UserText   := Registry.ReadString(CUserText);

          if (UserName <> '') and (USerText <> '') then
          begin
            Current := TUserItem(Self.FUserList.Items[FUserList.Add(UserName, UserText, Privilege)]);
            if (Current <> nil) then
            begin
              Current.LogOn(Current.UserText, Self.Handle);
              if Current.LoggedOn then
              begin
                if UserLocked then
                  Current.Lock
                else
                  Current.Unlock;

                for IndexB := 0 to Pred(MaxCountB) do
                begin
                  MethodLibrary := Registry.ReadString(CMethodLibrary + IntToStr(IndexB));
                  MethodID      := Registry.ReadInteger(CMethodID + IntToStr(IndexB));
                  MethodIsRing  := Registry.ReadBool(CMethodIsRing + IntToStr(IndexB));
                  MethodText    := Registry.ReadString(CMethodText + IntToStr(IndexB));

                  CurrentB := TModuleItem(Current.Methods.Items[Current.Methods.Add(MethodLibrary, MethodID, MethodText)]);
                  if (CurrentB <> nil) then
                    Self.FPhoneEngine.AddEvent(CurrentB.CallEvent, MethodIsRing, CurrentB.MethodText, LongInt(Current));
//                    Self.FPhoneEngine.AddEvent(CurrentB.ProcAddress, CurrentB.MethodText, LongInt(Current));
                end;

                Current.LogOff;
              end;
            end;
          end;
        end;
      end;
    end;
  finally
    Registry.Free;
    Registry := nil;
  end;
{$EndIf}
end;

procedure TMainForm.PutToTaskBar;
var
  NotifyIconData : TNotifyIconData;
begin
  try
    NotifyIconData.cbSize           := SizeOf(TNotifyIconData);
    NotifyIconData.Wnd              := Self.Handle;
    NotifyIconData.uID              := 1;
    NotifyIconData.uFlags           := Nif_Message or Nif_Icon or Nif_Tip;
    NotifyIconData.uCallbackMessage := CTaskBarMessage;
    NotifyIconData.hIcon            := Self.Icon.Handle;

    StrCopy(NotifyIconData.szTip, PChar(Self.FTaskBarText));
    Shell_NotifyIcon(Nim_Add, @NotifyIconData);
  except
  end;
end;

procedure TMainForm.TakeFromTaskBar;
var
  NotifyIconData : TNotifyIconData;
begin
  try
    NotifyIconData.cbSize := SizeOf(TNotifyIconData);
    NotifyIconData.Wnd    := Self.Handle;
    NotifyIconData.uID    := 1;

    Shell_NotifyIcon(Nim_Delete, @NotifyIconData);
  except
  end;
end;

procedure TMainForm.TaskBarEvents(var AMessage : TMessage);
begin
  if (AMessage.Msg = CTaskBarMessage) then
  begin
    case AMessage.LParamLo of
      wm_RButtonDown :
      begin
        Application.ShowMainForm := not(Application.ShowMainForm);

        if Application.ShowMainForm then
        begin
          Self.Hide;
          Self.DeActivate;
        end
        else
        begin
          Self.Show;
          Self.Activate;
          Self.BringToFront;
        end;
      end;
    end;
  end;
end;

procedure TMainForm.UpdateInTaskBar;
var
  NotifyIconData : TNotifyIconData;
begin
  try
    NotifyIconData.cbSize           := SizeOf(TNotifyIconData);
    NotifyIconData.Wnd              := Self.Handle;
    NotifyIconData.uID              := 1;
    NotifyIconData.uFlags           := Nif_Message or Nif_Icon or Nif_Tip;
    NotifyIconData.uCallbackMessage := CTaskBarMessage;
    NotifyIconData.hIcon            := Self.Icon.Handle;

    StrCopy(NotifyIconData.szTip, PChar(Self.FTaskBarText));
    Shell_NotifyIcon(Nim_Modify, @NotifyIconData);
  except
  end;
end;

procedure TMainForm.EngineHandleEvents(var AMessage : TMessage);
begin
  if (AMessage.Msg = CEngineHandleMessage) then
    Self.FReceived := (AMessage.WParam = Self.Handle);
end;

procedure TMainForm.QueryEndSessionEvents(var AMessage : TMessage);
begin
  if (AMessage.Msg = wm_QueryEndSession) then
  begin
    Self.FPhoneEngine.ShutdownSiemensTC35I;
    Self.FPhoneEngine.DestroyPortConnection;
    Self.FPhoneEngine.Free;
    Self.FPhoneEngine := nil;

    Self.Close;
  end;
end;

procedure TMainForm.SaveOptions;
var
{$IfnDef UseFiles}
  Registry : TRegistry;
{$EndIf}
begin
{$IfnDef UseFiles}
  Registry := TRegistry.Create;
  try
    Registry.RootKey := CRegistryRoot;

    Registry.CloseKey;
    if Registry.OpenKey(CRegistryKey + #92, true) then
    begin
      Registry.WriteString(CPortName, Self.FPhoneEngine.PortName);
      Registry.WriteBool(CPortSync, Self.FPhoneEngine.SyncPortEvents);

      Registry.WriteBool(CAutoConnect, Self.FAutoConnect);
      Registry.WriteBool(CAutoEnter, Self.FAutoEnter);
      Registry.WriteString(CAutoEnterPin, Self.FAutoEnterPin);
      Registry.WriteBool(CAutoInit, Self.FAutoInit);
    end;
  finally
    Registry.Free;
    Registry := nil;
  end;
{$EndIf}
end;

procedure TMainForm.SaveUsers;
var
{$IfnDef UseFiles}
  Current  : TUserItem;
  CurrentB : TModuleItem;
  Index    : LongInt;
  IndexB   : LongInt;
  Registry : TRegistry;
{$EndIf}
begin
{$IfnDef UseFiles}
  Registry := TRegistry.Create;
  try
    Registry.RootKey := CRegistryRoot;

    Registry.DeleteKey(CRegistryKey + CUserDataKey + #92);

    Registry.CloseKey;
    if Registry.OpenKey(CRegistryKey + CUserDataKey + #92, true) then
      Registry.WriteInteger(CUserCount, Self.FUserList.Count);

    for Index := 0 to Pred(FUserList.Count) do
    begin
      if (Self.FUserList.Items[Index] <> nil) then
      begin
        Current := TUserItem(Self.FUserList.Items[Index]);

        Registry.CloseKey;
        if Registry.OpenKey(CRegistryKey + CUserDataKey + #92, true) then
          Registry.WriteString(CUserName + IntToStr(Index), Current.UserName);

        Registry.CloseKey;
        if Registry.OpenKey(CRegistryKey + CUserDataKey + AnsiLowerCase(Trim(Current.UserName)) + #92, true) then
        begin
          Registry.WriteInteger(CPrivilege, Ord(Current.Privilege));
          Registry.WriteBool(CUserLocked, Current.Locked);
          Registry.WriteString(CUserText, Current.UserText);
        end;

        Registry.WriteInteger(CMethodCount, Current.Methods.Count);

        for IndexB := 0 to Pred(Current.Methods.Count) do
        begin
          if (Current.Methods.Items[IndexB] <> nil) then
          begin
            CurrentB := TModuleItem(Current.Methods.Items[IndexB]);

            Registry.WriteString(CMethodLibrary + IntToStr(IndexB), CurrentB.DllName);
            Registry.WriteInteger(CMethodID + IntToStr(IndexB), CurrentB.MethodID);
            Registry.WriteBool(CMethodIsRing + IntToStr(IndexB), (CurrentB.MethodText = #0));
            Registry.WriteString(CMethodText + IntToStr(IndexB), CurrentB.MethodText);
          end;
        end;
      end;
    end;
  finally
    Registry.Free;
    Registry := nil;
  end;
{$EndIf}
end;

procedure TMainForm.SetCurrentStatus(const AStatus : TIconType);
begin
  Self.FCurrentStatus := AStatus;
  Self.LoadCurrentIcon(Self.FCurrentStatus);
end;

function TMainForm.Add(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
var
  BoolResult : Boolean;
  Current    : TUserItem;
  CurrentB   : TModuleItem;
  ErrorCode  : LongInt;
  Index      : LongInt;
  ProcIndex  : LongInt;
begin
  BoolResult := false;

  if (Length(AMessageParams) >= 3) then
  begin
    Val(AMessageParams[1], ProcIndex, ErrorCode);

    if (ProcIndex >= 1) and (ErrorCode = 0) then
    begin
      Current := Self.FUserList.FindHandle(ASenderHandle);
      if (Current <> nil) then
      begin
        if Current.LoggedOn and
           not(Current.Locked) then
        begin
          if not(Current.Methods.IsAdd(AMessageParams[0], ProcIndex, AMessageParams[2])) then
          begin
            Index := Current.Methods.Add(AMessageParams[0], ProcIndex, AMessageParams[2]);
            if (Index >= 0) then
            begin
              CurrentB := Current.Methods[Index];
              if (CurrentB <> nil) then
                BoolResult := (@CurrentB.ProcAddress <> nil);

              if BoolResult then
                Self.FPhoneEngine.AddEvent(CurrentB.CallEvent, false, CurrentB.MethodText, LongInt(Current))
//                Self.FPhoneEngine.AddEvent(CurrentB.ProcAddress, false, CurrentB.MethodText, LongInt(Current))
              else
                Current.Methods.Delete(AMessageParams[0], ProcIndex, AMessageParams[2])
            end;
          end;
        end;
      end;
    end;
  end;

  if BoolResult then
    Self.SaveUsers;

  Result := AMessageEvent + #58#32 + IntToStr(Ord(BoolResult));
end;

function TMainForm.AddRing(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
var
  BoolResult : Boolean;
  Current    : TUserItem;
  CurrentB   : TModuleItem;
  ErrorCode  : LongInt;
  Index      : LongInt;
  ProcIndex  : LongInt;
begin
  BoolResult := false;

  if (Length(AMessageParams) >= 2) then
  begin
    Val(AMessageParams[1], ProcIndex, ErrorCode);

    if (ProcIndex >= 1) and (ErrorCode = 0) then
    begin
      Current := Self.FUserList.FindHandle(ASenderHandle);
      if (Current <> nil) then
      begin
        if Current.LoggedOn and
           not(Current.Locked) then
        begin
          if not(Current.Methods.IsAdd(AMessageParams[0], ProcIndex, #0)) then
          begin
            Index := Current.Methods.Add(AMessageParams[0], ProcIndex, #0);
            if (Index >= 0) then
            begin
              CurrentB := Current.Methods[Index];
              if (CurrentB <> nil) then
                BoolResult := (@CurrentB.ProcAddress <> nil);

              if BoolResult then
                Self.FPhoneEngine.AddEvent(CurrentB.CallEvent, true, '', LongInt(Current))
//                Self.FPhoneEngine.AddEvent(CurrentB.ProcAddress, true, '', LongInt(Current))
              else
                Current.Methods.Delete(AMessageParams[0], ProcIndex, #0)
            end;
          end;
        end;
      end;
    end;
  end;

  if BoolResult then
    Self.SaveUsers;

  Result := AMessageEvent + #58#32 + IntToStr(Ord(BoolResult));
end;

function TMainForm.Connect(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
var
  BoolResult : Boolean;
  Current    : TUserItem;
begin
  BoolResult := false;

  Current := Self.FUserList.FindHandle(ASenderHandle);
  if (Current <> nil) then
  begin
    if Current.LoggedOn and
       (Current.Privilege = upAdmin) then
      BoolResult := Self.FPhoneEngine.CreatePortConnection;
  end;

  Result := AMessageEvent + #58#32 + IntToStr(Ord(BoolResult));
end;

function TMainForm.DisConnect(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
var
  BoolResult : Boolean;
  Current    : TUserItem;
begin
  BoolResult := false;

  Current := Self.FUserList.FindHandle(ASenderHandle);
  if (Current <> nil) then
  begin
    if Current.LoggedOn and
       (Current.Privilege = upAdmin) then
      BoolResult := Self.FPhoneEngine.DestroyPortConnection;
  end;

  Result := AMessageEvent + #58#32 + IntToStr(Ord(BoolResult));
end;

function TMainForm.GetPort(const ASenderHandle : THandleLongWord; const AMessageEvent: String; const AMessageParams: TStringArray) : String;
var
  BoolResult : Boolean;
  Current    : TUserItem;
begin
  BoolResult := false;

  Current := Self.FUserList.FindHandle(ASenderHandle);
  if (Current <> nil) then
     BoolResult := Current.LoggedOn and ((Current.Privilege = upExtended) or (Current.Privilege = upAdmin));

  if BoolResult then
    Result := AMessageEvent + #58#32 + Self.FPhoneEngine.PortName
  else
    Result := AMessageEvent + #58#32 + IntToStr(Ord(BoolResult));
end;

function TMainForm.Initialize(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
var
  BoolResult : Boolean;
  Current    : TUserItem;
begin
  BoolResult := false;

  Current := Self.FUserList.FindHandle(ASenderHandle);
  if (Current <> nil) then
  begin
    if Current.LoggedOn and
       (Current.Privilege = upAdmin) then
    begin
      Self.FStartedUp := Self.FPhoneEngine.InitializeSiemensTC35I('', true);

      BoolResult := Self.FStartedUp;
    end;
  end;

  Result := AMessageEvent + #58#32 + IntToStr(Ord(BoolResult));
end;

function TMainForm.IsAdd(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
var
  BoolResult : Boolean;
  Current    : TUserItem;
  ErrorCode  : LongInt;
  ProcIndex  : LongInt;
begin
  BoolResult := false;

  if (Length(AMessageParams) >= 3) then
  begin
    Val(AMessageParams[1], ProcIndex, ErrorCode);

    Current := Self.FUserList.FindHandle(ASenderHandle);
    if (Current <> nil) then
    begin
      if Current.LoggedOn then
        BoolResult := Current.Methods.IsAdd(AMessageParams[0], ProcIndex, AMessageParams[2]);
    end;
  end;

  Result := AMessageEvent + #58#32 + IntToStr(Ord(BoolResult));
end;

function TMainForm.IsAddDLL(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
var
  BoolResult : Boolean;
  Current    : TUserItem;
begin
  BoolResult := false;

  if (Length(AMessageParams) >= 1) then
  begin
    Current := Self.FUserList.FindHandle(ASenderHandle);
    if (Current <> nil) then
    begin
      if Current.LoggedOn then
        BoolResult := Current.Methods.IsAddDll(AMessageParams[0]);
    end;
  end;

  Result := AMessageEvent + #58#32 + IntToStr(Ord(BoolResult));
end;

function TMainForm.IsAddDLLMeth(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
var
  BoolResult : Boolean;
  Current    : TUserItem;
  ErrorCode  : LongInt;
  ProcIndex  : LongInt;
begin
  BoolResult := false;

  if (Length(AMessageParams) >= 2) then
  begin
    Val(AMessageParams[1], ProcIndex, ErrorCode);

    Current := Self.FUserList.FindHandle(ASenderHandle);
    if (Current <> nil) then
    begin
      if Current.LoggedOn then
        BoolResult := Current.Methods.IsAddDllID(AMessageParams[0], ProcIndex);
    end;
  end;

  Result := AMessageEvent + #58#32 + IntToStr(Ord(BoolResult));
end;

function TMainForm.IsAddMeth(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
var
  BoolResult : Boolean;
  Current    : TUserItem;
  ErrorCode  : LongInt;
  ProcIndex  : LongInt;
begin
  BoolResult := false;

  if (Length(AMessageParams) >= 1) then
  begin
    Val(AMessageParams[0], ProcIndex, ErrorCode);

    Current := Self.FUserList.FindHandle(ASenderHandle);
    if (Current <> nil) then
    begin
      if Current.LoggedOn then
        BoolResult := Current.Methods.IsAddID(ProcIndex);
    end;
  end;

  Result := AMessageEvent + #58#32 + IntToStr(Ord(BoolResult));
end;

function TMainForm.IsAddText(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
var
  BoolResult : Boolean;
  Current    : TUserItem;
begin
  BoolResult := false;

  if (Length(AMessageParams) >= 1) then
  begin
    Current := Self.FUserList.FindHandle(ASenderHandle);
    if (Current <> nil) then
    begin
      if Current.LoggedOn then
        BoolResult := Current.Methods.IsAddText(AMessageParams[0]);
    end;
  end;

  Result := AMessageEvent + #58#32 + IntToStr(Ord(BoolResult));
end;

function TMainForm.IsAddRing(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
var
  BoolResult : Boolean;
  Current    : TUserItem;
  ErrorCode  : LongInt;
  ProcIndex  : LongInt;
begin
  BoolResult := false;

  if (Length(AMessageParams) >= 2) then
  begin
    Val(AMessageParams[1], ProcIndex, ErrorCode);

    Current := Self.FUserList.FindHandle(ASenderHandle);
    if (Current <> nil) then
    begin
      if Current.LoggedOn then
        BoolResult := Current.Methods.IsAdd(AMessageParams[0], ProcIndex, #0);
    end;
  end;

  Result := AMessageEvent + #58#32 + IntToStr(Ord(BoolResult));
end;

function TMainForm.IsAddRingB(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
var
  BoolResult : Boolean;
  Current    : TUserItem;
begin
  BoolResult := false;

  Current := Self.FUserList.FindHandle(ASenderHandle);
  if (Current <> nil) then
  begin
    if Current.LoggedOn then
      BoolResult := Current.Methods.IsAddText(#0);
  end;

  Result := AMessageEvent + #58#32 + IntToStr(Ord(BoolResult));
end;

function TMainForm.IsConnect(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
var
  BoolResult : Boolean;
  Current    : TUserItem;
begin
  BoolResult := false;

  Current := Self.FUserList.FindHandle(ASenderHandle);
  if (Current <> nil) then
  begin
    if Current.LoggedOn then
      BoolResult := Self.FPhoneEngine.PortConnectionEstablished;
  end;

  Result := AMessageEvent + #58#32 + IntToStr(Ord(BoolResult));
end;

function TMainForm.IsInitialize(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
var
  BoolResult : Boolean;
  Current    : TUserItem;
begin
  BoolResult := false;

  Current := Self.FUserList.FindHandle(ASenderHandle);
  if (Current <> nil) then
  begin
    if Current.LoggedOn then
      BoolResult := Self.FStartedUp;
  end;

  Result := AMessageEvent + #58#32 + IntToStr(Ord(BoolResult));
end;

function TMainForm.IsLock(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
var
  BoolResult : Boolean;
  Current    : TUserItem;
begin
  BoolResult := false;

  Current := Self.FUserList.FindHandle(ASenderHandle);
  if (Current <> nil) then
  begin
    if Current.LoggedOn then
      BoolResult := Current.Locked;
  end;

  Result := AMessageEvent + #58#32 + IntToStr(Ord(BoolResult));
end;

function TMainForm.IsLogOn(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
var
  BoolResult : Boolean;
  Current    : TUserItem;
begin
  BoolResult := false;

  Current := Self.FUserList.FindHandle(ASenderHandle);
  if (Current <> nil) then
    BoolResult := Current.LoggedOn;

  Result := AMessageEvent + #58#32 + IntToStr(Ord(BoolResult));
end;

function TMainForm.IsRegister(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
var
  BoolResult : Boolean;
begin
  BoolResult := false;

  if (Length(AMessageParams) >= 1) then
    BoolResult := Self.FUserList.IsAdd(AMessageParams[0]);

  Result := AMessageEvent + #58#32 + IntToStr(Ord(BoolResult));
end;

function TMainForm.Lock(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
var
  BoolResult : Boolean;
  Current    : TUserItem;
begin
  BoolResult := false;

  Current := Self.FUserList.FindHandle(ASenderHandle);
  if (Current <> nil) then
  begin
    if Current.LoggedOn then
    begin
      Current.Lock;

      BoolResult := Current.Locked;
    end;
  end;

  Result := AMessageEvent + #58#32 + IntToStr(Ord(BoolResult));
end;

function TMainForm.LogOff(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
var
  BoolResult : Boolean;
  Current    : TUserItem;
begin
  BoolResult := false;

  Current := Self.FUserList.FindHandle(ASenderHandle);
  if (Current <> nil) then
  begin
    if Current.LoggedOn then
    begin
      Current.LogOff;

      BoolResult := not(Current.LoggedOn);
    end;
  end;

  Result := AMessageEvent + #58#32 + IntToStr(Ord(BoolResult));
end;

function TMainForm.LogOn(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
var
  BoolResult : Boolean;
  Current    : TUserItem;
begin
  BoolResult := false;

  if (Length(AMessageParams) >= 2) then
  begin
    Current := Self.FUserList.FindHandle(ASenderHandle);
    if (Current = nil) then
    begin
      Current := Self.FUserList.FindName(AMessageParams[0]);
      if (Current <> nil) then
      begin
        if not(Current.LoggedOn) then
          BoolResult := Current.LogOn(AMessageParams[1], ASenderHandle);
      end;
    end;
  end;

  Result := AMessageEvent + #58#32 + IntToStr(Ord(BoolResult));
end;

function TMainForm.Register(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
var
  BoolResult : Boolean;
begin
  BoolResult := false;

  if (Length(AMessageParams) >= 2) then
  begin
    if (Length(AMessageParams) >= 3) and
       (ASenderHandle = Self.Handle) then
      BoolResult := (Self.FUserList.Add(AMessageParams[0], AMessageParams[1], TUserPrivilege(StrToIntDef(AMessageParams[2], Ord(upUser)))) >= 0)
    else
      BoolResult := (Self.FUserList.Add(AMessageParams[0], AMessageParams[1], upUser) >= 0);
  end;

  if BoolResult then
    Self.SaveUsers;

  Result := AMessageEvent + #58#32 + IntToStr(Ord(BoolResult));
end;

function TMainForm.Rem(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
var
  BoolResult : Boolean;
  Current    : TUserItem;
  CurrentB   : TModuleItemArray;
  CurrentC   : TModuleItem;
  ErrorCode  : LongInt;
  Index      : LongInt;
  ProcIndex  : LongInt;
begin
  BoolResult := false;

  if (Length(AMessageParams) >= 3) then
  begin
    Val(AMessageParams[1], ProcIndex, ErrorCode);

    Current := Self.FUserList.FindHandle(ASenderHandle);
    if (Current <> nil) then
    begin
      if Current.LoggedOn and
         not(Current.Locked) then
      begin
        SetLength(CurrentB, 0);
        CurrentB := Current.Methods.Find(AMessageParams[0], ProcIndex, AMessageParams[2]);
        if (Length(CurrentB) > 0) then
        begin
          for Index := Low(CurrentB) to High(CurrentB) do
          begin
            CurrentC := CurrentB[Index];
            if (CurrentC <> nil) then
            begin
              if Self.FPhoneEngine.IsKnownEventHandleText(CurrentC.CallEvent, false, AMessageParams[2], LongInt(Current)) then
//              if Self.FPhoneEngine.IsKnownEventHandleText(CurrentC.ProcAddress, false, AMessageParams[2], LongInt(Current)) then
                Self.FPhoneEngine.DeleteEventHandleText(CurrentC.CallEvent, false, AMessageParams[2], LongInt(Current));
//                Self.FPhoneEngine.DeleteEventHandleText(CurrentC.ProcAddress, false, AMessageParams[2], LongInt(Current));
            end;
          end;
          Current.Methods.Delete(AMessageParams[0], ProcIndex, AMessageParams[2]);

          BoolResult := not(Current.Methods.IsAdd(AMessageParams[0], ProcIndex, AMessageParams[2]));
        end;
      end;
    end;
  end;

  if BoolResult then
    Self.SaveUsers;

  Result := AMessageEvent + #58#32 + IntToStr(Ord(BoolResult));
end;

function TMainForm.RemDLL(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
var
  BoolResult : Boolean;
  Current    : TUserItem;
  CurrentB   : TModuleItemArray;
  CurrentC   : TModuleItem;
  Index      : LongInt;
begin
  BoolResult := false;

  if (Length(AMessageParams) >= 1) then
  begin
    Current := Self.FUserList.FindHandle(ASenderHandle);
    if (Current <> nil) then
    begin
      if Current.LoggedOn and
         not(Current.Locked) then
      begin
        SetLength(CurrentB, 0);
        CurrentB := Current.Methods.FindDll(AMessageParams[0]);
        if (Length(CurrentB) > 0) then
        begin
          for Index := Low(CurrentB) to High(CurrentB) do
          begin
            CurrentC := CurrentB[Index];
            if (CurrentC <> nil) then
            begin
              if Self.FPhoneEngine.IsKnownEventHandle(CurrentC.CallEvent, LongInt(Current)) then
//              if Self.FPhoneEngine.IsKnownEventHandle(CurrentC.ProcAddress, LongInt(Current)) then
                Self.FPhoneEngine.DeleteEventHandle(CurrentC.CallEvent, LongInt(Current));
//                Self.FPhoneEngine.DeleteEventHandle(CurrentC.ProcAddress, LongInt(Current));
            end;
          end;
          Current.Methods.DeleteDll(AMessageParams[0]);

          BoolResult := not(Current.Methods.IsAddDll(AMessageParams[0]));
        end;
      end;
    end;
  end;

  if BoolResult then
    Self.SaveUsers;

  Result := AMessageEvent + #58#32 + IntToStr(Ord(BoolResult));
end;

function TMainForm.RemDLLMeth(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
var
  BoolResult : Boolean;
  Current    : TUserItem;
  CurrentB   : TModuleItemArray;
  CurrentC   : TModuleItem;
  ErrorCode  : LongInt;
  Index      : LongInt;
  ProcIndex  : LongInt;
begin
  BoolResult := false;

  if (Length(AMessageParams) >= 2) then
  begin
    Val(AMessageParams[1], ProcIndex, ErrorCode);

    Current := Self.FUserList.FindHandle(ASenderHandle);
    if (Current <> nil) then
    begin
      if Current.LoggedOn and
         not(Current.Locked) then
      begin
        SetLength(CurrentB, 0);
        CurrentB := Current.Methods.FindDllID(AMessageParams[0], ProcIndex);
        if (Length(CurrentB) > 0) then
        begin
          for Index := Low(CurrentB) to High(CurrentB) do
          begin
            CurrentC := CurrentB[Index];
            if (CurrentC <> nil) then
            begin
              if Self.FPhoneEngine.IsKnownEventHandle(CurrentC.CallEvent, LongInt(Current)) then
//              if Self.FPhoneEngine.IsKnownEventHandle(CurrentC.ProcAddress, LongInt(Current)) then
                Self.FPhoneEngine.DeleteEventHandle(CurrentC.CallEvent, LongInt(Current));
//                Self.FPhoneEngine.DeleteEventHandle(CurrentC.ProcAddress, LongInt(Current));
            end;
          end;
          Current.Methods.DeleteDllID(AMessageParams[0], ProcIndex);

          BoolResult := not(Current.Methods.IsAddDllID(AMessageParams[0], ProcIndex));
        end;
      end;
    end;
  end;

  if BoolResult then
    Self.SaveUsers;

  Result := AMessageEvent + #58#32 + IntToStr(Ord(BoolResult));
end;

function TMainForm.RemMeth(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
var
  BoolResult : Boolean;
  Current    : TUserItem;
  CurrentB   : TModuleItemArray;
  CurrentC   : TModuleItem;
  ErrorCode  : LongInt;
  Index      : LongInt;
  ProcIndex  : LongInt;
begin
  BoolResult := false;

  if (Length(AMessageParams) >= 1) then
  begin
    Val(AMessageParams[0], ProcIndex, ErrorCode);

    Current := Self.FUserList.FindHandle(ASenderHandle);
    if (Current <> nil) then
    begin
      if Current.LoggedOn and
         not(Current.Locked) then
      begin
        SetLength(CurrentB, 0);
        CurrentB := Current.Methods.FindID(ProcIndex);
        if (Length(CurrentB) > 0) then
        begin
          for Index := Low(CurrentB) to High(CurrentB) do
          begin
            CurrentC := CurrentB[Index];
            if (CurrentC <> nil) then
            begin
              if Self.FPhoneEngine.IsKnownEventHandle(CurrentC.CallEvent, LongInt(Current)) then
//              if Self.FPhoneEngine.IsKnownEventHandle(CurrentC.ProcAddress, LongInt(Current)) then
                Self.FPhoneEngine.DeleteEventHandle(CurrentC.CallEvent, LongInt(Current));
//                Self.FPhoneEngine.DeleteEventHandle(CurrentC.ProcAddress, LongInt(Current));
            end;
          end;
          Current.Methods.DeleteID(ProcIndex);

          BoolResult := not(Current.Methods.IsAddID(ProcIndex));
        end;
      end;
    end;
  end;

  if BoolResult then
    Self.SaveUsers;

  Result := AMessageEvent + #58#32 + IntToStr(Ord(BoolResult));
end;

function TMainForm.RemText(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
var
  BoolResult : Boolean;
  Current    : TUserItem;
  CurrentB   : TModuleItemArray;
  CurrentC   : TModuleItem;
  Index      : LongInt;
begin
  BoolResult := false;

  if (Length(AMessageParams) >= 1) then
  begin
    Current := Self.FUserList.FindHandle(ASenderHandle);
    if (Current <> nil) then
    begin
      if Current.LoggedOn and
         not(Current.Locked) then
      begin
        SetLength(CurrentB, 0);
        CurrentB := Current.Methods.FindText(AMessageParams[0]);
        if (Length(CurrentB) > 0) then
        begin
          for Index := Low(CurrentB) to High(CurrentB) do
          begin
            CurrentC := CurrentB[Index];
            if (CurrentC <> nil) then
            begin
              if Self.FPhoneEngine.IsKnownEventHandleText(CurrentC.CallEvent, false, AMessageParams[0], LongInt(Current)) then
//              if Self.FPhoneEngine.IsKnownEventHandleText(CurrentC.ProcAddress, false, AMessageParams[0], LongInt(Current)) then
                Self.FPhoneEngine.DeleteEventHandleText(CurrentC.CallEvent, false, AMessageParams[0], LongInt(Current));
//                Self.FPhoneEngine.DeleteEventHandleText(CurrentC.ProcAddress, false, AMessageParams[0], LongInt(Current));
            end;
          end;
          Current.Methods.DeleteText(AMessageParams[0]);

          BoolResult := not(Current.Methods.IsAddText(AMessageParams[0]));
        end;
      end;
    end;
  end;

  if BoolResult then
    Self.SaveUsers;

  Result := AMessageEvent + #58#32 + IntToStr(Ord(BoolResult));
end;

function TMainForm.RemRing(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
var
  BoolResult : Boolean;
  Current    : TUserItem;
  CurrentB   : TModuleItemArray;
  CurrentC   : TModuleItem;
  ErrorCode  : LongInt;
  Index      : LongInt;
  ProcIndex  : LongInt;
begin
  BoolResult := false;

  if (Length(AMessageParams) >= 2) then
  begin
    Val(AMessageParams[1], ProcIndex, ErrorCode);

    Current := Self.FUserList.FindHandle(ASenderHandle);
    if (Current <> nil) then
    begin
      if Current.LoggedOn and
         not(Current.Locked) then
      begin
        SetLength(CurrentB, 0);
        CurrentB := Current.Methods.Find(AMessageParams[0], ProcIndex, #0);
        if (Length(CurrentB) > 0) then
        begin
          for Index := Low(CurrentB) to High(CurrentB) do
          begin
            CurrentC := CurrentB[Index];
            if (CurrentC <> nil) then
            begin
              if Self.FPhoneEngine.IsKnownEventHandleText(CurrentC.CallEvent, true, '', LongInt(Current)) then
//              if Self.FPhoneEngine.IsKnownEventHandleText(CurrentC.ProcAddress, true, '', LongInt(Current)) then
                Self.FPhoneEngine.DeleteEventHandleText(CurrentC.CallEvent, true, '', LongInt(Current));
//                Self.FPhoneEngine.DeleteEventHandleText(CurrentC.ProcAddress, true, '', LongInt(Current));
            end;
          end;
          Current.Methods.Delete(AMessageParams[0], ProcIndex, #0);

          BoolResult := not(Current.Methods.IsAdd(AMessageParams[0], ProcIndex, #0));
        end;
      end;
    end;
  end;

  if BoolResult then
    Self.SaveUsers;

  Result := AMessageEvent + #58#32 + IntToStr(Ord(BoolResult));
end;

function TMainForm.RemRingB(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
var
  BoolResult : Boolean;
  Current    : TUserItem;
  CurrentB   : TModuleItemArray;
  CurrentC   : TModuleItem;
  Index      : LongWord;
begin
  BoolResult := false;

  Current := FUserList.FindHandle(ASenderHandle);
  if (Current <> nil) then
  begin
    if Current.LoggedOn and
       not(Current.Locked) then
    begin
      SetLength(CurrentB, 0);
      CurrentB := Current.Methods.FindText(#0);
      if (Length(CurrentB) > 0) then
      begin
        for Index := Low(CurrentB) to High(CurrentB) do
        begin
          CurrentC := CurrentB[Index];
          if (CurrentC <> nil) then
          begin
            if Self.FPhoneEngine.IsKnownEventHandleText(CurrentC.CallEvent, true, '', LongInt(Current)) then
//            if Self.FPhoneEngine.IsKnownEventHandleText(CurrentC.ProcAddress, true, '', LongInt(Current)) then
              Self.FPhoneEngine.DeleteEventHandleText(CurrentC.CallEvent, true, '', LongInt(Current));
//              Self.FPhoneEngine.DeleteEventHandleText(CurrentC.ProcAddress, true, '', LongInt(Current));
          end;
        end;
        Current.Methods.DeleteText(#0);

        BoolResult := not(Current.Methods.IsAddText(#0));
      end;
    end;
  end;

  if BoolResult then
    Self.SaveUsers;

  Result := AMessageEvent + #58#32 + IntToStr(Ord(BoolResult));
end;

function TMainForm.Send(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
var
  BoolResult : Boolean;
  Current    : TUserItem;
begin
  BoolResult := false;

  if (Length(AMessageParams) >= 2) then
  begin
    Current := Self.FUserList.FindHandle(ASenderHandle);
    if (Current <> nil) then
    begin
      if Current.LoggedOn and
         ((Current.Privilege = upExtended) or
          (Current.Privilege = upAdmin)) then
        BoolResult := Self.FPhoneEngine.SendSMS(AMessageParams[0], AMessageParams[1])
    end;
  end;

  Result := AMessageEvent + #58#32 + IntToStr(Ord(BoolResult));
end;

function TMainForm.SetPort(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
var
  BoolResult : Boolean;
  Current    : TUserItem;
begin
  BoolResult := false;

  if (Length(AMessageParams) >= 1) then
  begin
    Current := Self.FUserList.FindHandle(ASenderHandle);
    if (Current <> nil) then
    begin
      if Current.LoggedOn and
         (Current.Privilege = upAdmin) then
      begin
        Self.FPhoneEngine.PortName := AMessageParams[0];

        BoolResult := (FPhoneEngine.PortName = AMessageParams[0]);
      end;
    end;
  end;

  if BoolResult then
    Self.SaveOptions;

  Result := AMessageEvent + #58#32 + IntToStr(Ord(BoolResult));
end;

function TMainForm.ShutDown(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
var
  BoolResult : Boolean;
  Current    : TUserItem;
begin
  BoolResult := false;

  Current := Self.FUserList.FindHandle(ASenderHandle);
  if (Current <> nil) then
  begin
    if Current.LoggedOn and
       (Current.Privilege = upAdmin) then
    begin
      Self.FStartedUp := Self.FStartedUp and not(Self.FPhoneEngine.ShutdownSiemensTC35I);

      BoolResult := not(Self.FStartedUp);
    end;
  end;

  Result := AMessageEvent + #58#32 + IntToStr(Ord(BoolResult));
end;

function TMainForm.Test(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
var
  BoolResult : Boolean;
  Current    : TUserItem;
begin
  BoolResult := false;

  Current := Self.FUserList.FindHandle(ASenderHandle);
  if (Current <> nil) then
  begin
    if Current.LoggedOn then
    begin
      if (Length(AMessageParams) >= 1) then
      begin
        if (Length(AMessageParams) >= 2) then
          Self.FPhoneEngine.InterpretMessage(AMessageParams[0], false, AMessageParams[1])
        else
          Self.FPhoneEngine.InterpretMessage(AMessageParams[0], true, '');

        BoolResult := true;
      end;
    end;
  end;

  Result := AMessageEvent + #58#32 + IntToStr(Ord(BoolResult));
end;

function TMainForm.Version(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
begin
  Result := AMessageEvent + #58#32 + CVersionInfoText;
end;

function TMainForm.UnLock(const ASenderHandle : THandleLongWord; const AMessageEvent : String; const AMessageParams : TStringArray) : String;
var
  BoolResult : Boolean;
  Current    : TUserItem;
begin
  BoolResult := false;

  Current := Self.FUserList.FindHandle(ASenderHandle);
  if (Current <> nil) then
  begin
    if Current.LoggedOn then
    begin
      Current.Unlock;

      BoolResult := not(Current.Locked);
    end;
  end;

  Result := AMessageEvent + #58#32 + IntToStr(Ord(BoolResult));
end;

end.

