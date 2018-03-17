unit ShtDwnU;

interface

uses
  Windows;

procedure DoRestart;
procedure DoShutdown;

implementation

type
  TRestartMode = (rmRestart, rmShutdown);

procedure RestartProcedure(const ARestartMode : TRestartMode); forward;

procedure RestartProcedure(const ARestartMode : TRestartMode);
  function ExWindows(AFlag : LongInt) : Boolean;
  var
    Number          : LongWord;
    TokenPrivileges : TTokenPrivileges;
    VersionInfo     : TOSVersionInfo;
    WindowsHandle   : THandle;
  begin
    Result := false;

    VersionInfo.dwOSVersionInfoSize := SizeOf(VersionInfo);
    GetVersionEx(VersionInfo);
    if (VersionInfo.dwPlatformId = VER_PLATFORM_WIN32_NT) then
    begin
      // Windows NT
      OpenProcessToken(GetCurrentProcess, TOKEN_ADJUST_PRIVILEGES, WindowsHandle);
      LookupPrivilegeValue(nil, 'SeShutdownPrivilege', TokenPrivileges.Privileges[0].Luid);
      TokenPrivileges.PrivilegeCount := 1;
      TokenPrivileges.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
      Number := 0;
      AdjustTokenPrivileges(WindowsHandle, false, TokenPrivileges, 0, PTokenPrivileges(nil)^, Number);
      CloseHandle(WindowsHandle);

      Result := ExitWindowsEx(AFlag, 0);
    end
    else
    begin // Windows 95
      Result := ExitWindowsEx(AFlag, 0);
    end;
  end;

begin
  if (ARestartMode = rmRestart) then
    ExWindows(EWX_REBOOT + EWX_FORCEIFHUNG)
  else
  begin
    if (ARestartMode = rmShutdown) then
      ExWindows(EWX_SHUTDOWN + EWX_FORCEIFHUNG + EWX_POWEROFF);
  end;
end;

procedure DoRestart;
begin
  RestartProcedure(rmRestart);
end;

procedure DoShutdown;
begin
  RestartProcedure(rmShutdown);
end;

end.
