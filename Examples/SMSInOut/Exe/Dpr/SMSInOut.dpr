program SMSInOut;

uses
  Forms,
  MainF in '..\Pas_KN\MainF.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'SMSInOut';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
