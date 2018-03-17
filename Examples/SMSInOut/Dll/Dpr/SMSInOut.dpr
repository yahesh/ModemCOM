library SMSInOut;

uses
  SendSU,
  IniFiles;

{+++}

var
  FSMSInOutExeHandle : LongInt;

{+++}

procedure LoadSMSInOutExeHandle; forward;

procedure ReceiveRing(const ANumber : PChar; const AEvent : PChar; const AParameter : PChar); stdcall; forward;
procedure ReceiveSMS(const ANumber : PChar; const AEvent : PChar; const AParameter : PChar); stdcall; forward;

{+++}

procedure LoadSMSInOutExeHandle;
var
  IniFile : TIniFile;
begin
  IniFile := TIniFile.Create('SMSInOutDLL.ini');
  try
    FSMSInOutExeHandle := IniFile.ReadInteger('SMSInOutDLL', 'SMSInOutExeHandle', 0);
  finally
    IniFile.Free;
    IniFile := nil;
  end;
end;

procedure ReceiveRing(const ANumber : PChar; const AEvent : PChar; const AParameter : PChar); stdcall;
begin
  if (FSMSInOutExeHandle = 0) then
    LoadSMSInOutExeHandle;

  SendStringMessage(FSMSInOutExeHandle, FSMSInOutExeHandle + 1, #82#58 + String(ANumber) + #58 + String(AParameter));
end;

procedure ReceiveSMS(const ANumber : PChar; const AEvent : PChar; const AParameter : PChar); stdcall;
begin
  if (FSMSInOutExeHandle = 0) then
    LoadSMSInOutExeHandle;

  SendStringMessage(FSMSInOutExeHandle, FSMSInOutExeHandle + 1, #83#58 + String(ANumber) + #58 + String(AParameter));
end;

exports
  ReceiveRing index 1,
  ReceiveSMS  index 2;

begin
  FSMSInOutExeHandle := 0;
end.
