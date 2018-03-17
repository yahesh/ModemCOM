unit PhoneU;

// DON'T DELETE THIS COMMENT !!!

{--------------------------------------------}
{ Unit:      PhoneU.pas                      }
{ Version:   1.18                            }
{                                            }
{ Coder:     Yahe <hello@yahe.sh>            }
{                                            }
{ I'm NOT Liable For Damages Of ANY Kind !!! }
{--------------------------------------------}

// DON'T DELETE THIS COMMENT !!!

interface

{$I PhoneI.inc}

uses
{$IfDef EnableSimCodeForm}
  SimCodeF,
{$EndIf EnableSimCodeForm}
  PortU,
  Classes;

type
  TPhoneEngine        = class;
  TPhoneEventData     = class;
  TPhoneEventDataList = class;
  TSMSSendItem        = class;
  TSMSSendList        = class; 

{$IfDef DLLMethods}
  TPhoneEvent = procedure (const ANumber : PChar; const AEvent : PChar; const AParameter : PChar); stdcall;
{$Else}
{$IfDef ObjectMethods}
  TPhoneEvent = procedure (const ANumber : String; const AEvent : String; const AParameter : String) of Object;
{$Else}
  TPhoneEvent = procedure (const ANumber : String; const AEvent : String; const AParameter : String);
{$EndIf ObjectMethods}
{$EndIf DLLMethods}

  TPhoneEventDataArray = array of TPhoneEventData;
  TStringArray         = array of String;

{$IfDef EnableLogCapability}
  TLogType = (ltIn, ltOut, ltSys);
{$EndIf EnableLogCapability}

  TPhoneEngine = class(TObject)
  private
  protected
    FCaseSensitive      : Boolean;
    FDataReceived       : Boolean;
    FEventList          : TPhoneEventDataList;
    FIgnoreCommandChars : Boolean;
    FLineDelimiter      : String;
{$IfDef EnableLogCapability}
    FLogFile            : LongWord;
    FLogFileActive      : Boolean;
    FLogFileName        : String;
    FLogFileOpen        : Boolean;
    FLogSimCode         : Boolean;
{$EndIf EnableLogCapability}
    FPortData           : String;
    FPortDataReceived   : Boolean;
    FPortName           : String;
    FPortReactTimeOut   : LongWord;
    FPortReadPause      : LongWord;
    FPortReadWaitDelay  : LongWord;
    FOnUnknownEvent     : TPhoneEvent;
    FSMSSendList        : TSMSSendList;
    FSyncPortEvents     : Boolean;
    FTranslateSMSText   : Boolean;

{$IfDef EnableLogCapability}
    function CloseLogFile : Boolean;
{$EndIf EnableLogCapability}
    function GetIgnoreUser : Boolean;
    function GetInput(const AOutput : String; const ALogOutput : Boolean; const ALogInput : Boolean) : String;
    function GetNextLine(var AText : String) : String;
    function IsNextLine(const AText : String) : Boolean;
{$IfDef EnableLogCapability}
    function OpenLogFile : Boolean;
{$EndIf EnableLogCapability}

    procedure DataReceived(const AChar : Char);
    procedure NoDataReceived;
    procedure ReadPortError;
    procedure SetIgnoreUser(const AValue : Boolean);
    procedure SetLineDelimiter(const AValue : String);
{$IfDef EnableLogCapability}
    procedure SetLogFileActive(const AValue : Boolean);
    procedure SetLogFileName(const AValue : String);
{$EndIf EnableLogCapability}
    procedure SetPortName(const AValue : String);
    procedure SetSyncPortEvents(const AValue : Boolean);
    procedure WaitNoDataReceived;
{$IfDef EnableLogCapability}
    procedure WriteLog(const ALogType : TLogType; const AText : String; const AUser : LongInt; const AWriteUser : Boolean);
{$EndIf EnableLogCapability}
  public
    constructor Create;

    destructor Destroy; override;

    property CaseSensitive      : Boolean     read FCaseSensitive      write FCaseSensitive;
    property IgnoreCommandChars : Boolean     read FIgnoreCommandChars write FIgnoreCommandChars;
    property IgnoreUser         : Boolean     read GetIgnoreUser       write SetIgnoreUser;
    property LineDelimiter      : String      read FLineDelimiter      write SetLineDelimiter;
{$IfDef EnableLogCapability}
    property LogFileActive      : Boolean     read FLogFileActive      write SetLogFileActive;
    property LogFileName        : String      read FLogFileName        write SetLogFileName;
    property LogSimCode         : Boolean     read FLogSimCode         write FLogSimCode;
{$EndIf EnableLogCapability}
    property OnUnknownEvent     : TPhoneEvent read FOnUnknownEvent     write FOnUnknownEvent;
    property PortName           : String      read FPortName           write SetPortName;
    property PortReactTimeOut   : LongWord    read FPortReactTimeOut   write FPortReactTimeOut;
    property PortReadPause      : LongWord    read FPortReadPause      write FPortReadPause;
    property PortReadWaitDelay  : LongWord    read FPortReadWaitDelay  write FPortReadWaitDelay;
    property SyncPortEvents     : Boolean     read FSyncPortEvents     write SetSyncPortEvents;
    property TranslateSMSText   : Boolean     read FTranslateSMSText   write FTranslateSMSText;

    function AddEvent(const AEvent : TPhoneEvent; const AIsRing : Boolean; const AText : String; const AUser : LongInt) : Boolean;
    function CreatePortConnection : Boolean;
    function DeleteEventHandle(const AEvent : TPhoneEvent; const AUser : LongInt) : LongWord;
    function DeleteEventHandleText(const AEvent : TPhoneEvent; const AIsRing : Boolean; const AText : String; const AUser : LongInt) : LongWord;
    function DeleteEventText(const AIsRing : Boolean; const AText : String; const AUser : LongInt) : LongWord;
    function DestroyPortConnection : Boolean;
{$IfDef EnableSimCodeForm}
    function InitializeSiemensTC35I(const ASimCode : String; const AShowSimForm : Boolean) : Boolean;
{$Else}
    function InitializeSiemensTC35I(const ASimCode : String) : Boolean;
{$EndIf EnableSimCodeForm}
    function IsKnownEventHandle(const AEvent : TPhoneEvent; const AUser : LongInt) : Boolean;
    function IsKnownEventHandleText(const AEvent : TPhoneEvent; const AIsRing : Boolean; const AText : String; const AUser : LongInt) : Boolean;
    function IsKnownEventText(const AIsRing : Boolean; const AText : String; const AUser : LongInt) : Boolean;
    function PortConnectionEstablished : Boolean;
    function SendSMS(const AReceiver : String; const AMessage : String) : Boolean;
    function ShutdownSiemensTC35I : Boolean;
    function WaitForInput(const AOutput : String) : String;

    procedure ClearEventList;
    procedure InterpretMessage(const ANumber : String; const AIsRing : Boolean; AText : String);
  published
  end;

  TPhoneEventData = class(TObject)
  private
  protected
    FEventEvent  : TPhoneEvent;
    FEventIsRing : Boolean;
    FEventText   : String;
    FEventUser   : LongInt;
  public
    constructor Create; overload;
    constructor Create(const AEvent : TPhoneEvent; const AIsRing : Boolean; const AText : String; const AUser : LongInt); overload;

    property Event  : TPhoneEvent read FEventEvent  write FEventEvent;
    property IsRing : Boolean     read FEventIsRing write FEventIsRing;
    property Text   : String      read FEventText   write FEventText;
    property User   : LongInt     read FEventUser   write FEventUser;
  published
  end;

  TPhoneEventDataList = class(TList)
  private
  protected
    FIgnoreUser : Boolean;

    function CaseSensitive(const AText : String; const ACaseSensitive : Boolean) : String;
  public
    constructor Create;

    destructor Destroy; override;

    property IgnoreUser : Boolean read FIgnoreUser write FIgnoreUser;

    function AddEvent(const AEvent : TPhoneEvent; const AIsRing : Boolean; const AText : String; const AUser : LongInt) : LongInt;
    function DeleteEventHandle(const AEvent : TPhoneEvent; const AUser : LongInt) : LongWord;
    function DeleteEventHandleText(const AEvent : TPhoneEvent; const AIsRing : Boolean; const AText : String; const ACaseSensitive : Boolean; const AUser : LongInt) : LongWord;
    function DeleteEventIndex(const AIndex : LongInt) : Boolean;
    function DeleteEventText(const AIsRing : Boolean; const AText : String; const ACaseSensitive : Boolean; const AUser : LongInt) : LongWord;
    function GetEventHandle(const AEvent : TPhoneEvent; const AUser : LongInt) : TPhoneEventDataArray;
    function GetEventHandleText(const AEvent : TPhoneEvent; const AIsRing : Boolean; const AText : String; const ACaseSensitive : Boolean; const AUser : LongInt) : TPhoneEventDataArray;
    function GetEventText(const AIsRing : Boolean; const AText : String; const ACaseSensitive : Boolean; const AUser : LongInt) : TPhoneEventDataArray;
    function GetEventTextAll(const AIsRing : Boolean; const AText : String; const ACaseSensitive : Boolean) : TPhoneEventDataArray;

    procedure ClearAll;
  published
  end;

  TSMSSendItem = class(TObject)
  private
  protected
    FMessageTranslated : Boolean;

    FRequestReturned  : Boolean;
    FRequestSubmitted : Boolean;
    FTextReturned     : Boolean;

    FMessage  : String;
    FReceiver : String;
  public
    constructor Create; overload;
    constructor Create(const AMessage : String; const AReceiver : String); overload;

    property IsMessageTranslated : Boolean read FMessageTranslated;

    property IsRequestReturned  : Boolean read FRequestReturned;
    property IsRequestSubmitted : Boolean read FRequestSubmitted;
    property IsTextReturned     : Boolean read FTextReturned;

    property Message  : String read FMessage  write FMessage;
    property Receiver : String read FReceiver write FReceiver;

    procedure RequestReturned(const AMessageTranslated : Boolean);
    procedure RequestSubmitted;
    procedure TextReturned;
  published
  end;

  TSMSSendList = class(TList)
  private
  protected
  public
    destructor Destroy; override;

    function Add(const AMessage : String; const AReceiver : String) : LongInt; overload;
    function GetFirst : TSMSSendItem;

    procedure ClearAll;
    procedure DeleteFirst;
  published
  end;

const
  CDefaultIgnoreUser        : Boolean  = true;
  CDefaultLineDelimiter     : String   = #13#10;
  CDefaultPortName          : String   = 'COM1';
  CDefaultPortReactTimeOut  : LongWord = 10000;
  CDefaultPortReadPause     : LongWord = 0;
  CDefaultPortReadWaitDelay : LongWord = 100;
  CDefaultSyncPortEvents    : Boolean  = true;

  CAllEventsText     : String = '';
  CCarrier           : Char   = #62;
  CCtrlZ             : Char   = #26;
  CNumberNotSentText : String = '(NUMBER NOT SENT)';
  CSuccess           : String = 'ok';

function ASCIIToSMS(const AString : String) : String;
{$IfDef EnableLogCapability}
function FileClose(const AFileHandle : LongWord) : Boolean;
function FileCreate(const AFileName : String; const AMode : LongWord) : LongWord;
function FileExists(const AFileName : String) : Boolean;
function FileOpen(const AFileName : String; const AMode : LongWord) : LongWord;
function FileSeek(const AFileHandle : LongWord; const AOffset : Int64; const ASeekOrigin : TSeekOrigin) : Int64;
function FileSize(const AFileHandle : LongWord) : Int64;
function FileWrite(const AFileHandle : LongWord; const ABuffer; const ANumberOfBytesToWrite : LongWord; var ANumberOfBytesWritten : LongWord) : Boolean;
function GetDateTimeString : String;
function IntegerToString(const AInteger : LongInt) : String;
{$EndIf EnableLogCapability}
function LowerCaseString(const AString : String) : String;
function SMSToASCII(const AString : String) : String;
function TrimString(const AString : String) : String;

implementation

{$IfDef EnableLogCapability}
type
  TOverlapped = record
    Internal     : LongWord;
    InternalHigh : LongWord;
    Offset       : LongWord;
    OffsetHigh   : LongWord;
    hEvent       : LongWord;
  end;
  POverlapped = ^TOverlapped;

  TSecurityAttributes = record
    nLength              : LongWord;
    lpSecurityDescriptor : Pointer;
    bInheritHandle       : Boolean;
  end;
  PSecurityAttributes = ^TSecurityAttributes;

  TSystemTime = record
    wYear         : Word;
    wMonth        : Word;
    wDayOfWeek    : Word;
    wDay          : Word;
    wHour         : Word;
    wMinute       : Word;
    wSecond       : Word;
    wMilliseconds : Word;
  end;
{$EndIf EnableLogCapability}

const
{$IfDef EnableLogCapability}
  CCreateAlways     = 2;
  CCreateNew        = 1;
  COpenAlways       = 4;
  COpenExisting     = 3;
  CTruncateExisting = 5;

  CFileAttributeArchive    = LongWord($00000020);
  CFileAttributeCompressed = LongWord($00000800);
  CFileAttributeDirectory  = LongWord($00000010);
  CFileAttributeHidden     = LongWord($00000002);
  CFileAttributeNormal     = LongWord($00000080);
  CFileAttributeOffline    = LongWord($00001000);
  CFileAttributeReadOnly   = LongWord($00000001);
  CFileAttributeSystem     = LongWord($00000004);
  CFileAttributeTemporary  = LongWord($00000100);

  CFileFlagWriteThrough = LongWord($80000000);

  CFileShareRead      = LongWord($00000001);
  CFileShareUnknown   = LongWord($00000000);
  CFileShareWrite     = LongWord($00000002);
  CFileShareReadWrite = CFileShareRead or CFileShareWrite;

  CGenericRead      = LongWord($80000000);
  CGenericWrite     = LongWord($40000000);
  CGenericReadWrite = CGenericRead or CGenericWrite;

  CInvalidFileHandle = LongWord(- 1);

  COpenRead      = $0000;
  COpenWrite     = $0001;
  COpenReadWrite = $0002;

  CShareCompat    = $0000 platform;
  CShareDenyNone  = $0040;
  CShareDenyRead  = $0030 platform;
  CShareDenyWrite = $0020;
  CShareExclusive = $0010;

  CKernel32 = 'kernel32.dll';
{$EndIf EnableLogCapability}
  CUser32   = 'user32.dll';

{$IfDef EnableLogCapability}
function CloseHandle(AObject : LongWord) : LongBool; stdcall; external CKernel32 name 'CloseHandle';
{$EndIf EnableLogCapability}
function CharLowerBuff(ACharBuff : PChar; ALength : LongWord) : LongWord; stdcall; external CUser32 name 'CharLowerBuffA';
{$IfDef EnableLogCapability}
function CreateFile(AFileName : PChar;
                    ADesiredAccess : LongWord;
                    AShareMode : LongInt;
                    ASecurityAttributes : PSecurityAttributes;
                    AdwCreationDisposition : LongWord;
                    AdwFlagsAndAttributes : LongWord;
                    AhTemplateFile : LongWord) : LongWord; stdcall; external CKernel32 name 'CreateFileA';
function FlushFileBuffers(AFileHandle : LongWord) : LongBool; stdcall; external CKernel32 name 'FlushFileBuffers';
function GetFileAttributes(AFileName : PChar): LongWord; stdcall; external CKernel32 name 'GetFileAttributesA';
function SetFilePointer(AFile : LongWord; ADistanceToMove : LongWord; ADistanceToMoveHigh : Pointer; AMoveMethod : LongInt) : LongWord; stdcall; external CKernel32 name 'SetFilePointer';
function WriteFile(AFile : LongWord; const ABuffer; ANumberOfBytesToWrite : LongWord; var ANumberOfBytesWritten : LongWord; AOverlapped : POverlapped) : LongBool; stdcall; external CKernel32 name 'WriteFile';

procedure GetLocalTime(var ASystemTime : TSystemTime); stdcall; external CKernel32 name 'GetLocalTime';
{$EndIf EnableLogCapability}

function ASCIIToSMS(const AString : String) : String;
var
  Counter : LongInt;
  Index   : LongInt;
begin
  SetLength(Result, Length(AString) * 2);

  Counter := 0;
  Index   := 0;
  while (Index < Length(AString)) do
  begin
    Inc(Counter);
    Inc(Index);

    case AString[Index] of
      #036 : Result[Counter] := #002;
      #064 : Result[Counter] := #000;
      #095 : Result[Counter] := #017;
      #167 : Result[Counter] := #095;
      #196 : Result[Counter] := #091;
      #214 : Result[Counter] := #092;
      #220 : Result[Counter] := #094;
      #223 : Result[Counter] := #030;
      #228 : Result[Counter] := #123;
      #246 : Result[Counter] := #124;
      #252 : Result[Counter] := #126;

      #091, #092, #093, #094, #123, #124, #125, #126 :
      begin
        Result[Counter] := #027;
        Inc(Counter);

        case AString[Index] of
          #091 : Result[Counter] := #060;
          #092 : Result[Counter] := #047;
          #093 : Result[Counter] := #062;
          #094 : Result[Counter] := #020;
          #123 : Result[Counter] := #040;
          #124 : Result[Counter] := #064;
          #125 : Result[Counter] := #041;
          #126 : Result[Counter] := #061;
        else
          Dec(Counter);
          Result[Counter] := AString[Index];
        end;
      end;
    else
      Result[Counter] := AString[Index];
    end;
  end;

  SetLength(Result, Counter);
end;

{$IfDef EnableLogCapability}
function FileClose(const AFileHandle : LongWord) : Boolean;
begin
  Result := CloseHandle(AFileHandle);
end;

function FileCreate(const AFileName : String; const AMode : LongWord) : LongWord;
const
  AccessMode : array[0..2] of LongWord = (CGenericRead,
                                          CGenericWrite,
                                          CGenericReadWrite);
  ShareMode  : array[0..4] of LongWord = (CFileShareUnknown,
                                          CFileShareUnknown,
                                          CFileShareRead,
                                          CFileShareWrite,
                                          CFileShareReadWrite);
begin
  Result := CInvalidFileHandle;

  if (((AMode and 3) <= COpenReadWrite) and
      ((AMode and $F0) <= CShareDenyNone)) then
    Result := CreateFile(PChar(AFileName),
                         AccessMode[AMode and 3],
                         ShareMode[(AMode and $F0) shr 4],
                         nil,
                         CCreateAlways,
                         CFileAttributeNormal or CFileFlagWriteThrough,
                         0);
end;

function FileExists(const AFileName : String) : Boolean;
begin
  Result := (GetFileAttributes(PChar(AFileName)) <> LongWord(- 1));
end;

function FileOpen(const AFileName : String; const AMode : LongWord) : LongWord;
const
  AccessMode : array[0..2] of LongWord = (CGenericRead, CGenericWrite, CGenericReadWrite);
  ShareMode  : array[0..4] of LongWord = (CFileShareUnknown, CFileShareUnknown, CFileShareRead, CFileShareWrite, CFileShareReadWrite);
begin
  Result := CInvalidFileHandle;

  if (((AMode and 3) <= COpenReadWrite) and
      ((AMode and $F0) <= CShareDenyNone)) then
    Result := CreateFile(PChar(AFileName), AccessMode[AMode and 3], ShareMode[(AMode and $F0) shr 4],
                         nil, COpenExisting, CFileAttributeNormal or CFileFlagWriteThrough, 0);
end;

function FileSeek(const AFileHandle : LongWord; const AOffset : Int64; const ASeekOrigin : TSeekOrigin) : Int64;
begin
  Result := SetFilePointer(AFileHandle, AOffset, nil, Ord(ASeekOrigin));
end;

function FileSize(const AFileHandle : LongWord) : Int64;
var
  LastPosition : Int64;
begin
  LastPosition := FileSeek(AFileHandle, 0, soCurrent);
  Result := FileSeek(AFileHandle, 0, soEnd);
  FileSeek(AFileHandle, LastPosition, soBeginning);
end;

function FileWrite(const AFileHandle : LongWord; const ABuffer; const ANumberOfBytesToWrite : LongWord; var ANumberOfBytesWritten : LongWord) : Boolean;
begin
  Result := WriteFile(AFileHandle, ABuffer, ANumberOfBytesToWrite, ANumberOfBytesWritten, nil);
end;

function GetDateTimeString : String;
var
  SystemTime : TSystemTime;
begin
  GetLocalTime(SystemTime);

  Result := IntegerToString(SystemTime.wDay) + #46 + IntegerToString(SystemTime.wMonth) + #46 + IntegerToString(SystemTime.wYear) + #32 +
            IntegerToString(SystemTime.wHour) + #58 + IntegerToString(SystemTime.wMinute) + #58 + IntegerToString(SystemTime.wSecond) + #46 +
            IntegerToString(SystemTime.wMilliseconds);
end;

function IntegerToString(const AInteger : LongInt) : String;
const
  CDecimalChars : array [0..9] of Char = (#48, #49, #50, #51, #52, #53, #54, #55, #56, #57);
  CMinusChar    = #45;
var
  BuffLongInt : LongInt;
begin
  if (AInteger = 000) then
    Result := CDecimalChars[Low(CDecimalChars)]
  else
  begin
    Result := '';

    BuffLongInt := Abs(AInteger);
    while (BuffLongInt <> 000) do
    begin
      Result := CDecimalChars[BuffLongInt - ((BuffLongInt div Length(CDecimalChars)) * Length(CDecimalChars))] + Result;

      BuffLongInt := BuffLongInt div Length(CDecimalChars);
    end;

    if (AInteger < 000) then
      Result := CMinusChar + Result;
  end;
end;
{$EndIf EnableLogCapability}

function LowerCaseString(const AString : String) : String;
begin
  Result := AString;
  if (Length(Result) > 0) then
    CharLowerBuff(PChar(Result), Length(Result));
end;

function SMSToASCII(const AString : String) : String;
var
  Counter : LongInt;
  Index   : LongInt;
begin
  SetLength(Result, Length(AString));

  Counter := 0;
  Index   := 0;
  while (Index < Length(AString)) do
  begin
    Inc(Counter);
    Inc(Index);

    case AString[Index] of
      #000 : Result[Counter] := #064;
      #002 : Result[Counter] := #036;
      #017 : Result[Counter] := #095;

      #027 :
      begin
        if (Index < Length(AString)) then
        begin
          Inc(Index);

          case AString[Index] of
            #020 : Result[Counter] := #094;
            #040 : Result[Counter] := #123;
            #041 : Result[Counter] := #125;
            #047 : Result[Counter] := #092;
            #060 : Result[Counter] := #091;
            #061 : Result[Counter] := #126;
            #062 : Result[Counter] := #093;
            #064 : Result[Counter] := #124;
          else
            Result[Counter] := AString[Index];
          end;
        end;
      end;

      #030 : Result[Counter] := #223;
      #091 : Result[Counter] := #196;
      #092 : Result[Counter] := #214;
      #094 : Result[Counter] := #220;
      #095 : Result[Counter] := #167;
      #123 : Result[Counter] := #228;
      #124 : Result[Counter] := #246;
      #126 : Result[Counter] := #252;
    else
      Result[Counter] := AString[Index];
    end;
  end;

  SetLength(Result, Counter);
end;

function TrimString(const AString : String) : String;
var
  CounterL : LongInt;
  CounterR : LongInt;
begin
  Result := '';

  CounterL := 1;
  CounterR := Length(AString);
  while (CounterL <= CounterR) and (AString[CounterL] <= #32) do
    Inc(CounterL);
  if (CounterL <= CounterR) then
  begin
    while (CounterR >= CounterL) and (AString[CounterR] <= #32) do
      Dec(CounterR);

    if (CounterL <= CounterR) then
      Result := Copy(AString, CounterL, Succ(CounterR - CounterL));
  end;
end;

{ TPhoneEngine }

{$IfDef EnableLogCapability}
function TPhoneEngine.CloseLogFile : Boolean;
begin
  WriteLog(ltSys, 'Closing LogFile' + #32#34 + FLogFileName + #34, 0, false);

  Result := not(FLogFileOpen);

  if not(Result) then
  begin
    try
      FlushFileBuffers(FLogFile);
    finally
      CloseHandle(FLogFile);
      FLogFile := 0;

      FLogFileOpen := false;
    end;
  end;

  Result := not(FLogFileOpen);

  if Result then
    WriteLog(ltSys, 'Closing Successful', 0, false)
  else
    WriteLog(ltSys, 'Closing Not Successful', 0, false);
end;
{$EndIf EnableLogCapability}

function TPhoneEngine.GetIgnoreUser : Boolean;
begin
  Result := FEventList.IgnoreUser;
end;

function TPhoneEngine.GetInput(const AOutput : String; const ALogOutput : Boolean; const ALogInput : Boolean) : String;
var
  Counter : LongInt;
  Index   : LongInt;
  NoAdd   : Boolean;
begin
{$IfDef EnableLogCapability}
  if (ALogOutput) then
    WriteLog(ltOut, TrimString(AOutput), 0, false);
{$EndIf EnableLogCapability}

  Result := '';

  FDataReceived := false;
  WriteStringToPort(AOutput + #13);

  Counter := 0;
  while not(FDataReceived) and not((Counter * FPortReadWaitDelay) > FPortReactTimeOut) do
  begin
    Wait(FPortReadWaitDelay);

    Inc(Counter);
  end;

  if not((Counter * FPortReadWaitDelay) > FPortReactTimeOut) then
  begin
    if FIgnoreCommandChars then
    begin
      SetLength(Result, Length(FPortData));
      Counter := 1;
      NoAdd   := false;
      for Index := 1 to Length(FPortData) do
      begin
        if (FPortData[Index] >= #32) then
        begin
          Result[Counter] := FPortData[Index];

          Inc(Counter);
          NoAdd := false;
        end
        else
        begin
          if not(NoAdd) then
          begin
            Result[Counter] := #32;

            Inc(Counter);
            NoAdd := true;
          end;
        end;
      end;
      SetLength(Result, Pred(Counter));
    end
    else
      Result := FPortData;

    FPortData := '';

{$IfDef EnableLogCapability}
    if (ALogInput) then
      WriteLog(ltIn, TrimString(Result), 0, false);
{$EndIf EnableLogCapability}
  end
{$IfDef EnableLogCapability}
  else
    WriteLog(ltSys, 'Port Timed Out', 0, false);
{$EndIf EnableLogCapability}
end;

function TPhoneEngine.GetNextLine(var AText : String) : String;
begin
  if (Pos(FLineDelimiter, AText) > 0) then
  begin
    Result := Copy(AText, 1, Pred(Pos(FLineDelimiter, AText)));

    AText := Copy(AText, (Pos(FLineDelimiter, AText) + Length(FLineDelimiter)), Succ(Length(AText) - (Pos(FLineDelimiter, AText) + Length(FLineDelimiter))));
  end
  else
  begin
    Result := AText;

    AText := '';
  end;
end;

function TPhoneEngine.IsNextLine(const AText : String) : Boolean;
begin
  Result := (Pos(FLineDelimiter, AText) > 0);
end;

{$IfDef EnableLogCapability}
function TPhoneEngine.OpenLogFile : Boolean;
begin
  WriteLog(ltSys, 'Opening LogFile' + #32#34 + FLogFileName + #34, 0, false);

  Result := FLogFileOpen;

  if not(Result) then
  begin
    if FileExists(FLogFileName) then
      FLogFile := FileOpen(FLogFileName, COpenWrite or CShareDenyWrite)
    else
      FLogFile := FileCreate(FLogFileName, COpenWrite or CShareDenyWrite);

    FLogFileOpen := (FLogFile <> CInvalidFileHandle);

    try
      if FLogFileOpen then
        FileSeek(FLogFile, 0, soEnd);
    except
      FileClose(FLogFile);
      FLogFile := 0;
    end;
  end;

  Result := FLogFileOpen;

  if Result then
    WriteLog(ltSys, 'Opening Successful', 0, false)
  else
    WriteLog(ltSys, 'Opening Not Successful', 0, false);
end;
{$EndIf EnableLogCapability}

procedure TPhoneEngine.DataReceived(const AChar : Char);
begin
  FPortData := FPortData + AChar;

  FPortDataReceived := true;
end;

procedure TPhoneEngine.NoDataReceived;
var
  HandyNumber : String;
  HandyText   : String;
  NextItem    : TSMSSendItem;
  SMSIndex    : String;
  WorkText    : String;
begin
  if FPortDataReceived then
  begin
    FPortDataReceived := false;

    while IsNextLine(FPortData) do
    begin
      WorkText := GetNextLine(FPortData);
{$IfDef EnableLogCapability}
      WriteLog(ltIn, WorkText, 0, false);
{$EndIf EnableLogCapability}

      if (Pos('+clcc:', LowerCaseString(TrimString(WorkText))) > 0) then
      begin
        WorkText := LowerCaseString(TrimString(WorkText));

        if (Pos(#34, LowerCaseString(TrimString(WorkText))) > 0) then
        begin
          Delete(WorkText, 1, Pos(#34, WorkText));
          HandyNumber := Copy(WorkText, 1, Pred(Pos(#34, WorkText)));

          InterpretMessage(HandyNumber, true, '');
        end
        else
          InterpretMessage(CNumberNotSentText, true, '');

        WorkText := '';
      end;

      if (Pos('+cmgr:', LowerCaseString(TrimString(WorkText))) > 0) then
      begin
        WorkText := LowerCaseString(TrimString(WorkText));

        if (Pos('"rec unread"', LowerCaseString(TrimString(WorkText))) > 0) then
        begin
          Delete(WorkText, 1, Succ(Pos(#44, WorkText)));
          HandyNumber := Copy(WorkText, 1, Pred(Pos(#34, WorkText)));
          HandyText   := GetNextLine(FPortData) + GetNextLine(FPortData);

          if FTranslateSMSText then
          begin
{$IfDef EnableLogCapability}
            WriteLog(ltSys, SMSToASCII(HandyText), 0, false);
{$EndIf EnableLogCapability}
            InterpretMessage(HandyNumber, false, SMSToASCII(HandyText));
          end
          else
          begin
{$IfDef EnableLogCapability}
            WriteLog(ltSys, HandyText, 0, false);
{$EndIf EnableLogCapability}
            InterpretMessage(HandyNumber, false, HandyText);
          end;

          WorkText := '';
        end;
      end;

      if (Pos('+cmti:', LowerCaseString(TrimString(WorkText))) > 0) then
      begin
        WorkText := LowerCaseString(TrimString(WorkText));
        SMSIndex := Copy(WorkText, Succ(Pos(#44, WorkText)), Succ(Length(WorkText) - Pos(#44, WorkText)));

{$IfDef EnableLogCapability}
        WriteLog(ltOut, 'AT+CMGR=' + SMSIndex, 0, false);
{$EndIf EnableLogCapability}
        WriteStringToPort('AT+CMGR=' + SMSIndex + #13);

        WorkText := '';
      end;

      if (Pos('at+cmgr=', LowerCaseString(TrimString(WorkText))) > 0) then
      begin
        WorkText := LowerCaseString(TrimString(WorkText));
        SMSIndex := Copy(WorkText, Succ(Pos(#61, WorkText)), Succ(Length(WorkText) - Pos(#61, WorkText)));

{$IfDef EnableLogCapability}
        WriteLog(ltOut, 'AT+CMGD=' + SMSIndex, 0, false);
{$EndIf EnableLogCapability}
        WriteStringToPort('AT+CMGD=' + SMSIndex + #13);

        WorkText := '';
      end;

      if (Pos('ring', LowerCaseString(TrimString(WorkText))) > 0) then
      begin
{$IfDef EnableLogCapability}
        WriteLog(ltOut, 'AT+CLCC;+CHUP', 0, false);
{$EndIf EnableLogCapability}
        WriteStringToPort('AT+CLCC;+CHUP' + #13);

        WorkText := '';
      end;

      NextItem := FSMSSendList.GetFirst;
      if (NextItem <> nil) then
      begin
        if not(NextItem.IsRequestSubmitted) then
        begin
{$IfDef EnableLogCapability}
          WriteLog(ltOut, 'AT+CMGS=' + NextItem.Receiver, 0, false);
{$EndIf EnableLogCapability}
          WriteStringToPort('AT+CMGS=' + NextItem.Receiver + #13);

          NextItem.RequestSubmitted;
        end
        else
        begin
          if not(NextItem.IsRequestReturned) then
          begin
            if (Pos('at+cmgs=' + NextItem.Receiver, LowerCaseString(TrimString(WorkText))) > 0) then
            begin
              if FTranslateSMSText then
              begin
{$IfDef EnableLogCapability}
                WriteLog(ltOut, ASCIIToSMS(NextItem.Message), 0, false);
{$EndIf EnableLogCapability}
                WriteStringToPort(ASCIIToSMS(NextItem.Message) + CCtrlZ + #13);
              end
              else
              begin
{$IfDef EnableLogCapability}
                WriteLog(ltOut, NextItem.Message, 0, false);
{$EndIf EnableLogCapability}
                WriteStringToPort(NextItem.Message + CCtrlZ + #13);
              end;
              WorkText := '';

              NextItem.RequestReturned(FTranslateSMSText);
            end;
          end
          else
          begin
            if not(NextItem.IsTextReturned) then
            begin
              if NextItem.IsMessageTranslated then
              begin
                if (Pos(LowerCaseString(TrimString(ASCIIToSMS(NextItem.Message))), LowerCaseString(TrimString(WorkText))) > 0) then
                begin
                  NextItem.TextReturned;

                  WorkText := '';
                end;
              end
              else
              begin
                if (Pos(LowerCaseString(TrimString(NextItem.Message)), LowerCaseString(TrimString(WorkText))) > 0) then
                begin
                  NextItem.TextReturned;

                  WorkText := '';
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  end
  else
  begin
    NextItem := FSMSSendList.GetFirst;
    if (NextItem <> nil) then
    begin
      if not(NextItem.IsRequestSubmitted) then
      begin
{$IfDef EnableLogCapability}
        WriteLog(ltOut, 'AT+CMGS=' + NextItem.Receiver, 0, false);
{$EndIf EnableLogCapability}
        WriteStringToPort('AT+CMGS=' + NextItem.Receiver + #13);

        NextItem.RequestSubmitted;
      end;
    end;
  end;
end;

procedure TPhoneEngine.ReadPortError;
begin
{$IfDef EnableLogCapability}
  WriteLog(ltSys, 'ReadPort-Error', 0, false);
{$EndIf EnableLogCapability}
end;

procedure TPhoneEngine.SetIgnoreUser(const AValue : Boolean);
begin
  FEventList.IgnoreUser := AValue;
end;

procedure TPhoneEngine.SetLineDelimiter(const AValue : String);
begin
  if (Length(AValue) > 0) then
    FLineDelimiter := AValue
  else
    FLineDelimiter := CDefaultLineDelimiter;
end;

{$IfDef EnableLogCapability}
procedure TPhoneEngine.SetLogFileActive(const AValue : Boolean);
begin
  FLogFileActive := AValue;

  if FLogFileActive then
    OpenLogFile
  else
    CloseLogFile;
end;

procedure TPhoneEngine.SetLogFileName(const AValue : String);
begin
  if FLogFileActive then
    CloseLogFile;

  FLogFileName := AValue;

  if FLogFileActive then
    OpenLogFile;
end;
{$EndIf EnableLogCapability}

procedure TPhoneEngine.SetPortName(const AValue : String);
var
  ConnectedToPort : Boolean;
begin
  ConnectedToPort := PortConnectionEstablished;

  if ConnectedToPort then
    DestroyPortConnection;

  FPortName := AValue;

  if ConnectedToPort then
    CreatePortConnection;
end;

procedure TPhoneEngine.SetSyncPortEvents(const AValue : Boolean);
var
  ConnectedToPort : Boolean;
begin
  ConnectedToPort := PortConnectionEstablished;

  if ConnectedToPort then
    DestroyPortConnection;

  FSyncPortEvents := AValue;

  if ConnectedToPort then
    CreatePortConnection;
end;

procedure TPhoneEngine.WaitNoDataReceived;
begin
  FDataReceived := FPortDataReceived;

  FPortDataReceived := false;
end;

{$IfDef EnableLogCapability}
procedure TPhoneEngine.WriteLog(const ALogType : TLogType; const AText : String; const AUser : LongInt; const AWriteUser : Boolean);
var
  WriteCounter : LongWord;
  WriteText    : String;
begin
  if FLogFileActive and FLogFileOpen then
  begin
    WriteText := #91 + GetDateTimeString + #93;
    case ALogType of
      ltIn  : WriteText := WriteText + #32 + 'In :';
      ltOut : WriteText := WriteText + #32 + 'Out:';
      ltSys : WriteText := WriteText + #32 + 'Sys:';
    else
      WriteText := WriteText + #32 + 'Err:';
    end;

    if IgnoreUser or not(AWriteUser) then
      WriteText := WriteText + #32 + AText + #13#10
    else
      WriteText := WriteText + #32 + AText + #32#40#85#115#101#114#58#32#36 + IntegerToString(AUser) + #100#41#13#10;

    FileWrite(FLogFile, WriteText[1], Length(WriteText), WriteCounter);
    FlushFileBuffers(FLogFile);
  end;
end;
{$EndIf EnableLogCapability}

constructor TPhoneEngine.Create;
begin
  inherited Create;

  FEventList          := TPhoneEventDataList.Create;
  FIgnoreCommandChars := true;
  FLineDelimiter      := CDefaultLineDelimiter;
{$IfDef EnableLogCapability}
  FLogFile            := 0;
  FLogFileActive      := false;
  FLogFileName        := '';
  FLogFileOpen        := false;
  FLogSimCode         := false;
{$EndIf EnableLogCapability}
  FPortName           := CDefaultPortName;
  FPortReactTimeOut   := CDefaultPortReactTimeOut;
  FPortReadPause      := CDefaultPortReadPause;
  FPortReadWaitDelay  := CDefaultPortReadWaitDelay;
  FSMSSendList        := TSMSSendList.Create;
  FSyncPortEvents     := CDefaultSyncPortEvents;
  FTranslateSMSText   := true;
end;

destructor TPhoneEngine.Destroy;
begin
  ClearEventList;
{$IfDef EnableLogCapability}
  CloseLogFile;
{$EndIf EnableLogCapability}
  DestroyPortConnection;

  FEventList.Free;
  FEventList := nil;

  FSMSSendList.Free;
  FSMSSendList := nil;

  inherited Destroy;
end;

function TPhoneEngine.AddEvent(const AEvent : TPhoneEvent; const AIsRing : Boolean; const AText : String; const AUser : LongInt) : Boolean;
begin
{$IfDef EnableLogCapability}
  if AIsRing then
    WriteLog(ltSys, 'Adding Event $' + IntegerToString(Integer(@AEvent)) + 'd For Ringing', AUser, true)
  else
    WriteLog(ltSys, 'Adding Event $' + IntegerToString(Integer(@AEvent)) + 'd For Message' + #32#34 + AText + #34, AUser, true);
{$EndIf EnableLogCapability}

  Result := (FEventList.AddEvent(AEvent, AIsRing, AText, AUser) >= 0);

{$IfDef EnableLogCapability}
  if Result then
    WriteLog(ltSys, 'Adding Successful', 0, false)
  else
    WriteLog(ltSys, 'Adding Not Successful', 0, false);
{$EndIf EnableLogCapability}
end;

function TPhoneEngine.CreatePortConnection : Boolean;
begin
{$IfDef EnableLogCapability}
  WriteLog(ltSys, 'Connecting To Port' + #32#34 + FPortName + #34, 0, false);
{$EndIf EnableLogCapability}

  Result := false;

  SetSerialPortName(FPortName, false);
  if ((PFCommConfig <> nil) and (PFPortName <> nil) and (PFPortType <> nil)) then
  begin
    ConnectPort(100, 100, 100, 100, 100, DataReceived, NoDataReceived,
                ReadPortError, FPortReadPause,
                true, FSyncPortEvents, FSyncPortEvents, FSyncPortEvents);

    Result := IsConnected;
  end;

{$IfDef EnableLogCapability}
  if Result then
    WriteLog(ltSys, 'Connecting Successful', 0, false)
  else
    WriteLog(ltSys, 'Connecting Not Successful', 0, false);
{$EndIf EnableLogCapability}
end;

function TPhoneEngine.DeleteEventHandle(const AEvent : TPhoneEvent; const AUser : LongInt) : LongWord;
begin
{$IfDef EnableLogCapability}
  WriteLog(ltSys, 'Deleting Events $' + IntegerToString(Integer(@AEvent)) + 'd', AUser, true);
{$EndIf EnableLogCapability}

  Result := FEventList.DeleteEventHandle(AEvent, AUser);

{$IfDef EnableLogCapability}
  if (Result > 0) then
    WriteLog(ltSys, 'Deleting Successful', 0, false)
  else
    WriteLog(ltSys, 'Deleting Not Successful', 0, false);
{$EndIf EnableLogCapability}
end;

function TPhoneEngine.DeleteEventHandleText(const AEvent : TPhoneEvent; const AIsRing : Boolean; const AText : String; const AUser : LongInt) : LongWord;
begin
{$IfDef EnableLogCapability}
  if AIsRing then
    WriteLog(ltSys, 'Deleting Events $' + IntegerToString(Integer(@AEvent)) + 'd For Ringing', AUser, true)
  else
    WriteLog(ltSys, 'Deleting Events $' + IntegerToString(Integer(@AEvent)) + 'd For Message' + #32#34 + AText + #34, AUser, true);
{$EndIf EnableLogCapability}

  Result := FEventList.DeleteEventHandleText(AEvent, AIsRing, AText, FCaseSensitive, AUser);

{$IfDef EnableLogCapability}
  if (Result > 0) then
    WriteLog(ltSys, 'Deleting Successful', 0, false)
  else
    WriteLog(ltSys, 'Deleting Not Successful', 0, false);
{$EndIf EnableLogCapability}
end;

function TPhoneEngine.DeleteEventText(const AIsRing : Boolean; const AText : String; const AUser : LongInt) : LongWord;
begin
{$IfDef EnableLogCapability}
  if AIsRing then
    WriteLog(ltSys, 'Deleting Events For Ringing', AUser, true)
  else
    WriteLog(ltSys, 'Deleting Events For Message' + #32#34 + AText + #34, AUser, true);
{$EndIf EnableLogCapability}

  Result := FEventList.DeleteEventText(AIsRing, AText, FCaseSensitive, AUser);

{$IfDef EnableLogCapability}
  if (Result > 0) then
    WriteLog(ltSys, 'Deleting Successful', 0, false)
  else
    WriteLog(ltSys, 'Deleting Not Successful', 0, false);
{$EndIf EnableLogCapability}
end;

function TPhoneEngine.DestroyPortConnection : Boolean;
begin
{$IfDef EnableLogCapability}
  WriteLog(ltSys, 'DisConnecting From Port', 0, false);
{$EndIf EnableLogCapability}

  DisConnectPort;

  Result := not(IsConnected);

{$IfDef EnableLogCapability}
  if Result then
    WriteLog(ltSys, 'DisConnecting Successful', 0, false)
  else
    WriteLog(ltSys, 'DisConnecting Not Successful', 0, false);
{$EndIf EnableLogCapability}
end;

{$IfDef EnableSimCodeForm}
function TPhoneEngine.InitializeSiemensTC35I(const ASimCode : String; const AShowSimForm : Boolean) : Boolean;
{$Else}
function TPhoneEngine.InitializeSiemensTC35I(const ASimCode : String) : Boolean;
{$EndIf EnableSimCodeForm}
var
  NextInput : String;
{$IfDef EnableSimCodeForm}
  SIMCode   : TSIMCodeResult;
{$EndIf EnableSimCodeForm}
  SIMReady  : Boolean;
  WorkText  : String;
begin
{$IfDef EnableLogCapability}
  WriteLog(ltSys, 'Initializing Modem', 0, false);
{$EndIf EnableLogCapability}

  Result := false;

  if PortConnectionEstablished then
  begin
    PFReadPortThread^.OnNoDataReceived := WaitNoDataReceived;

    NextInput := LowerCaseString(TrimString(GetInput('ATEZ', true, true)));
    if (Pos(CSuccess, NextInput) > 0) then
    begin
      NextInput := LowerCaseString(TrimString(GetInput('ATE0', true, true)));
      if (Pos(CSuccess, NextInput) > 0) then
      begin
        NextInput := LowerCaseString(TrimString(GetInput('AT+CPIN?', true, true)));
        if (Pos(CSuccess, NextInput) > 0) then
        begin
          WorkText := TrimString(Copy(NextInput, Pos('+cpin:', NextInput), (Pos(CSuccess, NextInput) - Pos('+cpin:', NextInput))));

          if (Pos('+cpin:', WorkText) > 0) then
          begin
            WorkText := TrimString(Copy(WorkText, Pos('+cpin:', WorkText) + Length('+cpin:'), Succ(Length(WorkText) - Pos('+cpin:', WorkText) - Length('+cpin:'))));

            SIMReady := (WorkText = 'ready');
            if not(SIMReady) then
            begin
{$IfDef EnableSimCodeForm}
              if AShowSimForm then
              begin
                SIMCode.Done := false;

                SIMCodeForm := TSIMCodeForm.Create(nil);
                try
                  if (WorkText = 'sim pin') then
                    SIMCode := SIMCodeForm.GetSIMCode(sctPIN)
                  else
                  begin
                    if (WorkText = 'sim puk') then
                      SIMCode := SIMCodeForm.GetSIMCode(sctPUK)
{$IfDef EnableLogCapability}
                    else
                      WriteLog(ltSys, 'Unknown Code Requested', 0, false);
{$EndIf EnableLogCapability}
                  end;
                finally
                  SIMCodeForm.Free;
                  SIMCodeForm := nil;
                end;
              end;

              if (SIMCode.Done or
                  not(AShowSimForm)) then
              begin
{$EndIf EnableSimCodeForm}
{$IfDef EnableLogCapability}
                if not(FLogSimCode) then
                begin
                  if (WorkText = 'sim pin') then
                    WriteLog(ltOut, 'AT+CPIN=[PIN]', 0, false)
                  else
                  begin
                    if (WorkText = 'sim puk') then
                    begin
                      WriteLog(ltOut, 'AT+CPIN=[PUK]', 0, false);
                    end;
                  end;
                end;
{$EndIf EnableLogCapability}

{$IfDef EnableSimCodeForm}
                if AShowSimForm then
{$IfDef EnableLogCapability}
                  NextInput := LowerCaseString(TrimString(GetInput('AT+CPIN=' + SIMCode.SIMCode, FLogSimCode, true)))
{$Else}
                  NextInput := LowerCaseString(TrimString(GetInput('AT+CPIN=' + SIMCode.SIMCode, false, true)))
{$EndIf EnableLogCapability}
                else
{$EndIf EnableSimCodeForm}
{$IfDef EnableLogCapability}
                  NextInput := LowerCaseString(TrimString(GetInput('AT+CPIN=' + ASimCode, FLogSimCode, true)));
{$Else}
                  NextInput := LowerCaseString(TrimString(GetInput('AT+CPIN=' + ASimCode, false, true)));
{$EndIf EnableLogCapability}
                if (Pos(CSuccess, NextInput) > 0) then
                begin
                  NextInput := LowerCaseString(TrimString(GetInput('AT+CPIN?', true, true)));
                  if (Pos(CSuccess, NextInput) > 0) then
                  begin
                    WorkText := TrimString(Copy(NextInput, Pos('+cpin:', NextInput), (Pos(CSuccess, NextInput) - Pos('+cpin:', NextInput))));

                    if (Pos('+cpin:', WorkText) > 0) then
                    begin
                      WorkText := TrimString(Copy(WorkText, Pos('+cpin:', WorkText) + Length('+cpin:'), Succ(Length(WorkText) - Pos('+cpin:', WorkText) - Length('+cpin:'))));

                      SIMReady := (WorkText = 'ready');
                    end;
                  end;
                end;
{$IfDef EnableSimCodeForm}
              end
{$IfDef EnableLogCapability}
              else
                WriteLog(ltSys, 'Initializing Aborted', 0, false);
{$EndIf EnableLogCapability}
{$EndIf EnableSimCodeForm}
            end;

            if SIMReady then
            begin
              NextInput := LowerCaseString(TrimString(GetInput('AT+CMEE=2', true, true)));
              if (Pos(CSuccess, NextInput) > 0) then
              begin
                NextInput := LowerCaseString(TrimString(GetInput('AT+CMGF=1', true, true)));
                if (Pos(CSuccess, NextInput) > 0) then
                begin
                  NextInput := LowerCaseString(TrimString(GetInput('AT+CNMI=3,1,0,0,1', true, true)));
                  if (Pos(CSuccess, NextInput) > 0) then
                  begin
                    NextInput := LowerCaseString(TrimString(GetInput('AT+CSDH=1', true, true)));
                    if (Pos(CSuccess, NextInput) > 0) then
                    begin
                      NextInput := LowerCaseString(TrimString(GetInput('ATE1', true, true)));
                      if (Pos(CSuccess, NextInput) > 0) then
                        Result := true;
                    end;
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    end;

    PFReadPortThread^.OnNoDataReceived := NoDataReceived;
  end;

{$IfDef EnableLogCapability}
  if Result then
    WriteLog(ltSys, 'Initializing Successful', 0, false)
  else
    WriteLog(ltSys, 'Initializing Not Successful', 0, false);
{$EndIf EnableLogCapability}
end;

function TPhoneEngine.IsKnownEventHandle(const AEvent : TPhoneEvent; const AUser : LongInt) : Boolean;
begin
  Result := (Length(FEventList.GetEventHandle(AEvent, AUser)) > 0);
end;

function TPhoneEngine.IsKnownEventHandleText(const AEvent : TPhoneEvent; const AIsRing : Boolean; const AText : String; const AUser : LongInt) : Boolean;
begin
  Result := (Length(FEventList.GetEventHandleText(AEvent, AIsRing, AText, FCaseSensitive, AUser)) > 0);
end;

function TPhoneEngine.IsKnownEventText(const AIsRing : Boolean; const AText : String; const AUser : LongInt) : Boolean;
begin
  Result := (Length(FEventList.GetEventText(AIsRing, AText, FCaseSensitive, AUser)) > 0);
end;

function TPhoneEngine.PortConnectionEstablished : Boolean;
begin
  Result := IsConnected;
end;

function TPhoneEngine.SendSMS(const AReceiver : String; const AMessage : String) : Boolean;
begin
  Result := (FSMSSendList.Add(AMessage, AReceiver) >= 0);
end;

function TPhoneEngine.ShutdownSiemensTC35I : Boolean;
var
  NextInput : String;
begin
{$IfDef EnableLogCapability}
  WriteLog(ltSys, 'Shutting Down Modem', 0, false);
{$EndIf EnableLogCapability}

  Result := false;

  if PortConnectionEstablished then
  begin
    PFReadPortThread^.OnNoDataReceived := WaitNoDataReceived;

    NextInput := LowerCaseString(TrimString(GetInput('AT^SMSO', true, true)));
    if (Pos(CSuccess, NextInput) > 0) then
      Result := true;

    PFReadPortThread^.OnNoDataReceived := NoDataReceived;
  end;

{$IfDef EnableLogCapability}
  if Result then
    WriteLog(ltSys, 'Shutting Down Successful', 0, false)
  else
    WriteLog(ltSys, 'Shutting Down Not Successful', 0, false);
{$EndIf EnableLogCapability}
end;

function TPhoneEngine.WaitForInput(const AOutput : String) : String;
begin
  Result := '';

  if PortConnectionEstablished then
  begin
    PFReadPortThread^.OnNoDataReceived := WaitNoDataReceived;

    Result := GetInput(AOutput, true, true);

    PFReadPortThread^.OnNoDataReceived := NoDataReceived;
  end;
end;

procedure TPhoneEngine.ClearEventList;
begin
{$IfDef EnableLogCapability}
  WriteLog(ltSys, '[Clearing Event-Handler - List]', 0, false);
{$EndIf EnableLogCapability}

  FEventList.ClearAll;
end;

procedure TPhoneEngine.InterpretMessage(const ANumber : String; const AIsRing : Boolean; AText : String);
  procedure GetValues(var AValueArray : TStringArray; AValueCounter : LongInt; var AValueText : String);
  var
    Index : LongInt;
  begin
    SetLength(AValueArray, AValueCounter);

    for Index := 0 to Pred(AValueCounter) do
    begin
      AValueArray[Index] := '';

      AValueText := TrimString(AValueText);
      if (AValueText <> '') and (AValueText[1] = #34) then
      begin
        Delete(AValueText, 1, 1);

        if (Pos(#34, AValueText) <= 0) then
          AValueText := AValueText + #34;

        AValueArray[Index] := TrimString(Copy(AValueText, 1, Pred(Pos(#34, AValueText))));
        Delete(AValueText, 1, Pos(#34, AValueText));
      end
      else
      begin
        if (Pos(#32, AValueText) <= 0) then
          AValueText := AValueText + #32;

        AValueArray[Index] := TrimString(Copy(AValueText, 1, Pred(Pos(#32, AValueText))));
        Delete(AValueText, 1, Pos(#32, AValueText));
      end;
    end;
  end;

var
  EventDataArray : TPhoneEventDataArray;
  Index          : LongInt;
  ValueArray     : TStringArray;
begin
  if not(AIsRing) then
  begin
    EventDataArray := FEventList.GetEventTextAll(AIsRing, CAllEventsText, FCaseSensitive);
    if (Length(EventDataArray) > 0) then
    begin
      for Index := Low(EventDataArray) to High(EventDataArray) do
      begin
        if (EventDataArray[Index] <> nil) and Assigned(EventDataArray[Index].Event) then
        begin
{$IfDef EnableLogCapability}
          WriteLog(ltSys, 'Calling Event $' + IntegerToString(Integer(@EventDataArray[Index].Event)) + 'd (Known Event) with Number' + #32#34 + ANumber + #34#32 + 'with Parameter' + #32#34 + AText + #34, EventDataArray[Index].User, true);
{$EndIf EnableLogCapability}

{$IfDef DLLMethods}
          EventDataArray[Index].Event(PChar(ANumber), PChar(CAllEventsText), PChar(AText));
{$Else}
          EventDataArray[Index].Event(ANumber, CAllEventsText, AText);
{$EndIf DLLMethods}
        end;
      end;
    end;

    GetValues(ValueArray, 1, AText);
  end;

  if AIsRing then
    EventDataArray := FEventList.GetEventTextAll(AIsRing, '', FCaseSensitive)
  else
    EventDataArray := FEventList.GetEventTextAll(AIsRing, ValueArray[0], FCaseSensitive);
  if (Length(EventDataArray) > 0) then
  begin
    for Index := Low(EventDataArray) to High(EventDataArray) do
    begin
      if (EventDataArray[Index] <> nil) and Assigned(EventDataArray[Index].Event) then
      begin
{$IfDef EnableLogCapability}
        if AIsRing then
          WriteLog(ltSys, 'Calling Event $' + IntegerToString(Integer(@EventDataArray[Index].Event)) + 'd (Known Event) with Number' + #32#34 + ANumber + #34#32 + 'for Ringing', EventDataArray[Index].User, true)
        else
          WriteLog(ltSys, 'Calling Event $' + IntegerToString(Integer(@EventDataArray[Index].Event)) + 'd (Known Event) with Number' + #32#34 + ANumber + #34#32 + 'for Message' + #32#34 + ValueArray[0] + #34#32 + 'with Parameter' + #32#34 + AText + #34, EventDataArray[Index].User, true);
{$EndIf EnableLogCapability}

{$IfDef DLLMethods}
        if AIsRing then
          EventDataArray[Index].Event(PChar(ANumber), PChar(''), PChar(AText))
        else
          EventDataArray[Index].Event(PChar(ANumber), PChar(ValueArray[0]), PChar(AText));
{$Else}
        if AIsRing then
          EventDataArray[Index].Event(ANumber, '', AText)
        else
          EventDataArray[Index].Event(ANumber, ValueArray[0], AText);
{$EndIf DLLMethods}
      end
      else
      begin
        if Assigned(FOnUnknownEvent) then
        begin
{$IfDef EnableLogCapability}
          if AIsRing then
            WriteLog(ltSys, 'Calling Event $' + IntegerToString(Integer(@FOnUnknownEvent)) + 'd (Unknown Event) with Number' + #32#34 + ANumber + #34#32 + 'for Ringing', 0, false)
          else
            WriteLog(ltSys, 'Calling Event $' + IntegerToString(Integer(@FOnUnknownEvent)) + 'd (Unknown Event) with Number' + #32#34 + ANumber + #34#32 + 'for Message' + #32#34 + ValueArray[0] + #34#32 + 'with Parameter' + #32#34 + AText + #34, 0, false);
{$EndIf EnableLogCapability}

{$IfDef DLLMethods}
          if AIsRing then
            FOnUnknownEvent(PChar(ANumber), PChar(''), PChar(AText))
          else
            FOnUnknownEvent(PChar(ANumber), PChar(ValueArray[0]), PChar(AText));
{$Else}
          FOnUnknownEvent(ANumber, ValueArray[0], AText);
{$EndIf DLLMethods}
        end;
      end;
    end;
  end
  else
  begin
    if Assigned(FOnUnknownEvent) then
    begin
{$IfDef EnableLogCapability}
      if AIsRing then
        WriteLog(ltSys, 'Calling Event $' + IntegerToString(Integer(@FOnUnknownEvent)) + 'd (Unknown Event) with Number' + #32#34 + ANumber + #34#32 + 'for Ringing', 0, false)
      else
        WriteLog(ltSys, 'Calling Event $' + IntegerToString(Integer(@FOnUnknownEvent)) + 'd (Unknown Event) with Number' + #32#34 + ANumber + #34#32 + 'for Message' + #32#34 + ValueArray[0] + #34#32 + 'with Parameter' + #32#34 + AText + #34, 0, false);
{$EndIf EnableLogCapability}

{$IfDef DLLMethods}
      if AIsRing then
        FOnUnknownEvent(PChar(ANumber), PChar(''), PChar(AText))
      else
        FOnUnknownEvent(PChar(ANumber), PChar(ValueArray[0]), PChar(AText));
{$Else}
      if AIsRing then
        FOnUnknownEvent(ANumber, '', AText)
      else
        FOnUnknownEvent(ANumber, ValueArray[0], AText);
{$EndIf DLLMethods}
    end;
  end;
end;

{ TPhoneEventData }

constructor TPhoneEventData.Create;
begin
  inherited Create;

  FEventEvent  := nil;
  FEventIsRing := false;
  FEventText   := '';
  FEventUser   := - 1;
end;

constructor TPhoneEventData.Create(const AEvent : TPhoneEvent; const AIsRing : Boolean; const AText : String; const AUser : LongInt);
begin
  Create;

  FEventEvent  := AEvent;
  FEventIsRing := AIsRing;
  FEventText   := AText;
  FEventUser   := AUser;
end;

{ TPhoneEventDataList }

function TPhoneEventDataList.CaseSensitive(const AText : String; const ACaseSensitive : Boolean) : String;
begin
  if ACaseSensitive then
    Result := AText
  else
    Result := LowerCaseString(AText);
end;

constructor TPhoneEventDataList.Create;
begin
  inherited Create;

  FIgnoreUser := CDefaultIgnoreUser;
end;

destructor TPhoneEventDataList.Destroy;
begin
  ClearAll;

  inherited Destroy;
end;

function TPhoneEventDataList.AddEvent(const AEvent : TPhoneEvent; const AIsRing : Boolean; const AText : String; const AUser : LongInt) : LongInt;
begin
  Result := Add(TPhoneEventData.Create(AEvent, AIsRing, AText, AUser));
end;

function TPhoneEventDataList.DeleteEventHandle(const AEvent : TPhoneEvent; const AUser : LongInt) : LongWord;
var
  Index : LongInt;
begin
  Result := 0;

  for Index := Pred(Count) downto 0 do
  begin
    if (Items[Index] <> nil) then
    begin
      if (((TPhoneEventData(Items[Index]).User = AUser) or (FIgnoreUser)) and
          (@TPhoneEventData(Items[Index]).Event = @AEvent)) then
      begin
        TPhoneEventData(Items[Index]).Free;

        Delete(Index);

        Inc(Result);
      end;
    end;
  end;
end;

function TPhoneEventDataList.DeleteEventHandleText(const AEvent : TPhoneEvent; const AIsRing : Boolean; const AText : String; const ACaseSensitive : Boolean; const AUser : LongInt) : LongWord;
var
  Index : LongInt;
begin
  Result := 0;

  for Index := Pred(Count) downto 0 do
  begin
    if (Items[Index] <> nil) then
    begin
      if (((TPhoneEventData(Items[Index]).User = AUser) or (FIgnoreUser)) and
          (@TPhoneEventData(Items[Index]).Event = @AEvent) and
          ((not(AIsRing) and not(TPhoneEventData(Items[Index]).IsRing) and (CaseSensitive(TPhoneEventData(Items[Index]).Text, ACaseSensitive) = CaseSensitive(AText, ACaseSensitive))) or
           (AIsRing and TPhoneEventData(Items[Index]).IsRing))) then
      begin
        TPhoneEventData(Items[Index]).Free;

        Delete(Index);

        Inc(Result);
      end;
    end;
  end;
end;

function TPhoneEventDataList.DeleteEventIndex(const AIndex : LongInt) : Boolean;
begin
  Result := false;

  if (Count > AIndex) then
  begin
    if (Items[AIndex] <> nil) then
      TPhoneEventData(Items[AIndex]).Free;

    Delete(AIndex);

    Result := true;
  end;
end;

function TPhoneEventDataList.DeleteEventText(const AIsRing : Boolean; const AText : String; const ACaseSensitive : Boolean; const AUser : LongInt) : LongWord;
var
  Index : LongInt;
begin
  Result := 0;

  for Index := Pred(Count) downto 0 do
  begin
    if (Items[Index] <> nil) then
    begin
      if (((TPhoneEventData(Items[Index]).User = AUser) or (FIgnoreUser)) and
          ((not(AIsRing) and not(TPhoneEventData(Items[Index]).IsRing) and (CaseSensitive(TPhoneEventData(Items[Index]).Text, ACaseSensitive) = CaseSensitive(AText, ACaseSensitive))) or
           (AIsRing and TPhoneEventData(Items[Index]).IsRing))) then
      begin
        TPhoneEventData(Items[Index]).Free;

        Delete(Index);

        Inc(Result);
      end;
    end;
  end;
end;

function TPhoneEventDataList.GetEventHandle(const AEvent : TPhoneEvent; const AUser : LongInt) : TPhoneEventDataArray;
var
  Counter : LongInt;
  Index   : LongInt;
begin
  SetLength(Result, Count);

  Counter := 0;
  for Index := 0 to Pred(Count) do
  begin
    if (Items[Index] <> nil) then
    begin
      if (((TPhoneEventData(Items[Index]).User = AUser) or (FIgnoreUser)) and
          (@TPhoneEventData(Items[Index]).Event = @AEvent)) then
      begin
        Result[Counter] := TPhoneEventData(Items[Index]);

        Inc(Counter);
      end;
    end;
  end;

  SetLength(Result, Counter);
end;

function TPhoneEventDataList.GetEventHandleText(const AEvent : TPhoneEvent; const AIsRing : Boolean; const AText : String; const ACaseSensitive : Boolean; const AUser : LongInt) : TPhoneEventDataArray;
var
  Counter : LongInt;
  Index   : LongInt;
begin
  SetLength(Result, Count);

  Counter := 0;
  for Index := 0 to Pred(Count) do
  begin
    if (Items[Index] <> nil) then
    begin
      if (((TPhoneEventData(Items[Index]).User = AUser) or (FIgnoreUser)) and
           (@TPhoneEventData(Items[Index]).Event = @AEvent) and
          ((not(AIsRing) and not(TPhoneEventData(Items[Index]).IsRing) and (CaseSensitive(TPhoneEventData(Items[Index]).Text, ACaseSensitive) = CaseSensitive(AText, ACaseSensitive))) or
           (AIsRing and TPhoneEventData(Items[Index]).IsRing))) then
      begin
        Result[Counter] := TPhoneEventData(Items[Index]);

        Inc(Counter);
      end;
    end;
  end;

  SetLength(Result, Counter);
end;

function TPhoneEventDataList.GetEventText(const AIsRing : Boolean; const AText : String; const ACaseSensitive : Boolean; const AUser : LongInt) : TPhoneEventDataArray;
var
  Counter : LongInt;
  Index   : LongInt;
begin
  SetLength(Result, Count);

  Counter := 0;
  for Index := 0 to Pred(Count) do
  begin
    if (Items[Index] <> nil) then
    begin
      if (((TPhoneEventData(Items[Index]).User = AUser) or (FIgnoreUser)) and
          ((not(AIsRing) and not(TPhoneEventData(Items[Index]).IsRing) and (CaseSensitive(TPhoneEventData(Items[Index]).Text, ACaseSensitive) = CaseSensitive(AText, ACaseSensitive))) or
           (AIsRing and TPhoneEventData(Items[Index]).IsRing))) then
      begin
        Result[Counter] := TPhoneEventData(Items[Index]);

        Inc(Counter);
      end;
    end;
  end;

  SetLength(Result, Counter);
end;

function TPhoneEventDataList.GetEventTextAll(const AIsRing : Boolean; const AText : String; const ACaseSensitive : Boolean) : TPhoneEventDataArray;
var
  Counter : LongInt;
  Index   : LongInt;
begin
  SetLength(Result, Count);

  Counter := 0;
  for Index := 0 to Pred(Count) do
  begin
    if (Items[Index] <> nil) then
    begin
      if ((not(AIsRing) and not(TPhoneEventData(Items[Index]).IsRing) and (CaseSensitive(TPhoneEventData(Items[Index]).Text, ACaseSensitive) = CaseSensitive(AText, ACaseSensitive))) or
          (AIsRing and TPhoneEventData(Items[Index]).IsRing)) then
      begin
        Result[Counter] := TPhoneEventData(Items[Index]);

        Inc(Counter);
      end;
    end;
  end;

  SetLength(Result, Counter);
end;

procedure TPhoneEventDataList.ClearAll;
var
  Index : LongInt;
begin
  for Index := 0 to Pred(Count) do
  begin
    if (Items[Index] <> nil) then
      TPhoneEventData(Items[Index]).Free;
  end;

  Clear;
end;

{ TSMSSendItem }

constructor TSMSSendItem.Create;
begin
  inherited Create;

  FMessageTranslated := false;

  FRequestReturned  := false;
  FRequestSubmitted := false;
  FTextReturned     := false;
end;

constructor TSMSSendItem.Create(const AMessage : String; const AReceiver : String);
begin
  Create;

  FMessage  := AMessage;
  FReceiver := AReceiver;
end;

procedure TSMSSendItem.RequestReturned(const AMessageTranslated : Boolean);
begin
  if IsRequestSubmitted then
  begin
    FRequestReturned := true;

    FMessageTranslated := AMessageTranslated;
  end;
end;

procedure TSMSSendItem.RequestSubmitted;
begin
  FRequestSubmitted := true;
end;

procedure TSMSSendItem.TextReturned;
begin
  if IsRequestReturned then
    FTextReturned := true;
end;

{ TSMSSendList }

destructor TSMSSendList.Destroy;
begin
  ClearAll;

  inherited Destroy;
end;

function TSMSSendList.Add(const AMessage : String; const AReceiver : String) : LongInt;
var
  NextItem : TSMSSendItem;
begin
  NextItem := TSMSSendItem.Create(AMessage, AReceiver);
  Result := Add(NextItem);

  if not(Result >= 0) then
  begin
    NextItem.Free;
    NextItem := nil;
  end;
end;

function TSMSSendList.GetFirst : TSMSSendItem;
var
  NextItem : TSMSSendItem;
begin
  Result := nil;

  while ((Result = nil) and (Count > 0)) do
  begin
    NextItem := Items[0];
    if (NextItem <> nil) then
    begin
      if not(NextItem.IsTextReturned) then
        Result := NextItem;
    end;

    if (Result = nil) then
      DeleteFirst;
  end;
end;

procedure TSMSSendList.ClearAll;
var
  Index    : LongInt;
  NextItem : TSMSSendItem;
begin
  for Index := Pred(Count) downto 0 do
  begin
    NextItem := Items[Index];
    if (NextItem <> nil) then
    begin
      NextItem.Free;
      NextItem := nil;
    end;
  end;

  Clear;
end;

procedure TSMSSendList.DeleteFirst;
var
  NextItem : TSMSSendItem;
begin
  if (Count > 0) then
  begin
    NextItem := Items[0];
    if (NextItem <> nil) then
    begin
      NextItem.Free;
      NextItem := nil;
    end;

    Delete(0);
  end;
end;

end.
