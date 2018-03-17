unit UserF;

interface

uses
  StdCtrls,
  Forms,
  ExtCtrls,
  Controls,
  Classes,
  Buttons;

type
  TUserForm = class(TForm)
    CancelBitBtn  : TBitBtn;
    DividerBevel  : TBevel;
    OKBitBtn      : TBitBtn;
    UserNameEdit  : TEdit;
    UserNameLabel : TLabel;
    UserTextEdit  : TEdit;
    UserTextLabel : TLabel;

    procedure CancelBitBtnClick(Sender : TObject);
    procedure OKBitBtnClick(Sender : TObject);
  private
    { Private-Deklarationen }
    FResult : Boolean;
  public
    { Public-Deklarationen }
    function GetUserData(var AUserName : String; var AUserText : String) : Boolean;
  end;

function GetUserData(var AUserName : String; var AUserText : String) : Boolean;

implementation

{$R *.dfm}

function GetUserData(var AUserName : String; var AUserText : String) : Boolean;
var
  UserForm : TUserForm;
begin
  Application.CreateForm(TUserForm, UserForm);
  try
    Result := UserForm.GetUserData(AUserName, AUserText);
  finally
    UserForm.Release;
    UserForm := nil;
  end;
end;

{ TUserForm }

procedure TUserForm.CancelBitBtnClick(Sender : TObject);
begin
  FResult := false;
end;

procedure TUserForm.OKBitBtnClick(Sender : TObject);
begin
  FResult := true;
end;

function TUserForm.GetUserData(var AUserName : String; var AUserText : String) : Boolean;
begin
  FResult := false;

  UserNameEdit.Text := '';
  UserTextEdit.Text := '';

  ShowModal;

  if FResult then
  begin
    AUserName := UserNameEdit.Text;
    AUserText := UserTextEdit.Text;
  end
  else
  begin
    AUserName := '';
    AUserText := '';
  end;

  Result := FResult;
end;

end.
