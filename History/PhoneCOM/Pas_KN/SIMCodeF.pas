unit SIMCodeF;

// DON'T DELETE THIS COMMENT !!!

{--------------------------------------------}
{ Unit:      SIMCodeF.pas                    }
{ Version:   1.01                            }
{                                            }
{ Coder:     Yahe <hello@yahe.sh>            }
{                                            }
{ I'm NOT Liable For Damages Of ANY Kind !!! }
{--------------------------------------------}

// DON'T DELETE THIS COMMENT !!!

interface

uses
  StdCtrls, Forms, ExtCtrls, Controls, Classes;

type
  TSIMCodeResult = record
    Done    : Boolean;
    SIMCode : String;
  end;

  TSIMCodeType = (sctPIN, sctPUK);

  TSIMCodeForm = class(TForm)
    BottomButtonsBevel : TBevel;
    CancelButton       : TButton;
    OKButton           : TButton;
    SIMCodeEdit        : TEdit;
    SIMCodeLabel       : TLabel;

    procedure CancelButtonClick(Sender : TObject);
    procedure FormShow(Sender : TObject);
    procedure OKButtonClick(Sender : TObject);
  private
    { Private-Deklarationen }
    FDone : Boolean;
  public
    { Public-Deklarationen }
    function GetSIMCode(ASIMCodeType : TSIMCodeType) : TSIMCodeResult;
  end;

var
  SIMCodeForm : TSIMCodeForm;

implementation

{$R *.dfm}

procedure TSIMCodeForm.CancelButtonClick(Sender : TObject);
begin
  FDone := false;

  Close;
end;

procedure TSIMCodeForm.FormShow(Sender : TObject);
begin
  SimCodeEdit.Text := '';
  SimCodeEdit.SetFocus;
end;

procedure TSIMCodeForm.OKButtonClick(Sender : TObject);
begin
  FDone := true;

  Close;
end;

function TSIMCodeForm.GetSIMCode(ASIMCodeType : TSIMCodeType) : TSIMCodeResult;
begin
  case ASIMCodeType of
    sctPIN :
    begin
      Caption := 'Enter "SIM PIN"';

      SIMCodeLabel.Caption := 'Please Enter The "SIM PIN" Of Your SIM Card.';
    end;

    sctPUK :
    begin
      Caption := 'Enter "SIM PUK"';

      SIMCodeLabel.Caption := 'Please Enter The "SIM PUK" Of Your SIM Card.';
    end;
  else
    Caption := 'Error: Unknown Request';

    SIMCodeLabel.Caption := 'Error: Unknown Code Requested';
  end;

  Result.Done    := false;
  Result.SIMCode := '';

  ShowModal;

  Result.Done    := FDone;
  Result.SIMCode := SIMCodeEdit.Text;
end;

end.
