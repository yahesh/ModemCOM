program ModemCOM;

uses
  Windows,
  SysUtils,
  Forms,
  Dialogs,
  MainF in '..\Pas_KN\MainF.pas' {MainForm};

{$R *.res}

{$R Icons.res}

var
  VHandle : THandle;

const
  CMutexName = '|Shorei| ModemCOM - Engine';

begin
  VHandle := CreateMutex(nil, true, CMutexName);
  try
    if (GetLastError = Error_Already_Exists) then
    begin
      VHandle := OpenMutex(Mutex_All_Access, true, CMutexName);
      ShowMessage('Mutex already running at address: $' + IntToHex(VHandle, 0) + 'h');
    end
    else
    begin
      Application.Initialize;
      Application.Title := 'Shorei ModemCOM-Engine';
      Application.CreateForm(TMainForm, MainForm);
      Application.Run;
    end;
  finally
    if (VHandle <> 0) then
    begin
      CloseHandle(VHandle);
      VHandle := 0;
    end;
  end;
end.
