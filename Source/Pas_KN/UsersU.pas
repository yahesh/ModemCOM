unit UsersU;

// DON'T DELETE THIS COMMENT !!!

{--------------------------------------------}
{ Unit:      UsersU.pas                      }
{ Version:   1.01                            }
{                                            }
{ Coder:     Yahe <hello@yahe.sh>            }
{                                            }
{ I'm NOT Liable For Damages Of ANY Kind !!! }
{--------------------------------------------}

// DON'T DELETE THIS COMMENT !!!

interface

uses
  Windows,
  SysUtils,
  PhoneU,
  Classes;

type
  TModuleItem       = class;
  TModuleItemThread = class;
  TModuleList       = class;

  TUserItem = class;
  TUserList = class;

//+ taken from PhoneU
  TDLLPhoneEvent = procedure (const ANumber : PChar; const AEvent : PChar; const AParameter : PChar); stdcall;
//- taken from PhoneU

  TModuleItem = class(TObject)
  private
  protected
    FDllName        : String;
    FLibraryAddress : THandle;
    FMethodID       : LongInt;
    FMethodText     : String;
    FProcAddress    : TDLLPhoneEvent;

    procedure LoadMethod;
    procedure UnloadMethod;

    procedure SetDllName(const AValue : String);
    procedure SetMethodID(const AValue : LongInt);
    procedure SetMethodText(const AValue : String);
  public
    constructor Create; overload;
    constructor Create(const ADllName : String; const AMethodID : LongInt; const AMethodText : String); overload;

    destructor Destroy; override;

    property DllName        : String         read FDllName         write SetDllName;
    property LibraryAddress : THandle        read FLibraryAddress;
    property MethodID       : LongInt        read FMethodID        write SetMethodID;
    property MethodText     : String         read FMethodText      write SetMethodText;
    property ProcAddress    : TDLLPhoneEvent read FProcAddress;

    procedure CallEvent(const ANumber : String; const AEvent : String; const AParameter : String);
  published
  end;
  TModuleItemArray = array of TModuleItem;

  TModuleItemThread = class(TThread)
  private
  protected
    FEvent       : String;
    FNumber      : String;
    FParameter   : String;
    FProcAddress : TDLLPhoneEvent;

    procedure Execute; override;
  public
    constructor Create(const ACreateSuspended : Boolean; const ANumber : String; const AEvent : String; const AParameter : String; const AProcAddress : TDLLPhoneEvent); overload;

    destructor Destroy; override;

    property Event       : String         read FEvent       write FEvent;
    property Number      : String         read FNumber      write FNumber;
    property Parameter   : String         read FParameter   write FParameter;
    property ProcAddress : TDLLPhoneEvent read FProcAddress write FProcAddress;
  published
  end;

  TModuleList = class(TList)
  private
  protected
  public
    destructor Destroy; override;

    function Add(const ADllName : String; const AMethodID : LongInt; const AMethodText : String) : LongInt; overload;
    function Find(const ADllName : String; const AMethodID : LongInt; const AMethodText : String) : TModuleItemArray;
    function FindDll(const ADllName : String) : TModuleItemArray;
    function FindDllID(const ADllName : String; const AMethodID : LongInt) : TModuleItemArray;
    function FindID(const AMethodID : LongInt) : TModuleItemArray;
    function FindText(const AMethodText : String) : TModuleItemArray;
    function IsAdd(const ADllName : String; const AMethodID : LongInt; const AMethodText : String) : Boolean;
    function IsAddDll(const ADllName : String) : Boolean;
    function IsAddDllID(const ADllName : String; const AMethodID : LongInt) : Boolean;
    function IsAddID(const AMethodID : LongInt) : Boolean;
    function IsAddText(const AMethodText : String) : Boolean;

    procedure ClearAll;
    procedure Delete(const ADllName : String; const AMethodID : LongInt; const AMethodText : String); overload;
    procedure DeleteDll(const ADllName : String);
    procedure DeleteDllID(const ADllName : String; const AMethodID : LongInt);
    procedure DeleteID(const AMethodID : LongInt);
    procedure DeleteText(const AMethodText : String);
  published
  end;

  TUserPrivilege = (upNone, upUser, upExtended, upAdmin);
  TUserItem = class(TObject)
  private
  protected
    FLocked     : Boolean;
    FMethods    : TModuleList;
    FPrivilege  : TUserPrivilege;
    FUserHandle : LongWord;
    FUserName   : String;
    FUserText   : String;

    function GetLoggedOn : Boolean;
  public
    constructor Create; overload;
    constructor Create(const AUserName : String; const AUserText : String; const APrivilege : TUserPrivilege); overload;

    destructor Destroy; override;

    property Locked     : Boolean        read FLocked;
    property LoggedOn   : Boolean        read GetLoggedOn;
    property Methods    : TModuleList    read FMethods;
    property Privilege  : TUserPrivilege read FPrivilege;
    property UserHandle : LongWord       read FUserHandle;
    property UserName   : String         read FUserName;
    property UserText   : String         read FUserText;

    function LogOn(const AUserText : String; const AUserHandle : LongWord) : Boolean;

    procedure Lock;
    procedure LogOff;
    procedure Unlock;
  published
  end;

  TUserList = class(TList)
  private
  protected
  public
    destructor Destroy; override;

    function Add(const AUserName : String; const AUserText : String; const APrivilege : TUserPrivilege) : LongInt; overload;
    function FindName(const AUserName : String) : TUserItem;
    function FindHandle(const AUserHandle : LongWord) : TUserItem;
    function IsAdd(const AUserName : String) : Boolean;

    procedure ClearAll;
  published
  end;

implementation

{ TModuleItem }

procedure TModuleItem.LoadMethod;
begin
  UnloadMethod;

  if FileExists(FDllName) then
  begin
    FLibraryAddress := LoadLibrary(PChar(FDllName));
    try
      FProcAddress := GetProcAddress(FLibraryAddress, PChar(FMethodID));
    except
      UnloadMethod;
    end;
  end;
end;

procedure TModuleItem.UnloadMethod;
begin
  if (FLibraryAddress <> 0) or (@FProcAddress <> nil) then
  begin
    if (FLibraryAddress <> 0) then
    begin
      FreeLibrary(FLibraryAddress);

      FLibraryAddress := 0;
    end;

    FProcAddress := nil;
  end;
end;

procedure TModuleItem.SetDllName(const AValue : String);
begin
  UnloadMethod;

  FDllName := AValue;

  LoadMethod;
end;

procedure TModuleItem.SetMethodID(const AValue : LongInt);
begin
  UnloadMethod;

  FMethodID := AValue;

  LoadMethod;
end;

procedure TModuleItem.SetMethodText(const AValue : String);
begin
  UnloadMethod;

  FMethodText := AValue;

  LoadMethod;
end;

constructor TModuleItem.Create;
begin
  inherited Create;

  FDllName        := '';
  FLibraryAddress := 0;
  FMethodID       := 0;
  FMethodText     := '';
  FProcAddress    := nil;
end;

constructor TModuleItem.Create(const ADllName : String; const AMethodID : LongInt; const AMethodText : String);
begin
  Create;

  FDllName    := ADllName;
  FMethodID   := AMethodID;
  FMethodText := AMethodText;

  LoadMethod;
end;

destructor TModuleItem.Destroy;
begin
  UnloadMethod;

  inherited Destroy;
end;

procedure TModuleItem.CallEvent(const ANumber : String; const AEvent : String; const AParameter : String);
var
  CallThread : TModuleItemThread;
begin
  CallThread := TModuleItemThread.Create(false, ANumber, AEvent, AParameter, FProcAddress);
  try
  except
    CallThread.Free;
    CallThread := nil;
  end;
end;

{ TModuleItemThread }

procedure TModuleItemThread.Execute;
begin
  inherited;

  try
    if Assigned(FProcAddress) then
      FProcAddress(PChar(FNumber), PChar(FEvent), PChar(FParameter));
  finally
    Free;
  end;
end;

constructor TModuleItemThread.Create(const ACreateSuspended : Boolean; const ANumber : String; const AEvent : String; const AParameter : String; const AProcAddress : TDLLPhoneEvent);
begin
  inherited Create(ACreateSuspended);

  FEvent       := AEvent;
  FNumber      := ANumber;
  FParameter   := AParameter;
  FProcAddress := AProcAddress;
end;

destructor TModuleItemThread.Destroy;
begin
  SetLength(FNumber, 0);
  SetLength(FParameter, 0);
  FProcAddress := nil;

  inherited Destroy;
end;

{ TModuleList }

destructor TModuleList.Destroy;
begin
  ClearAll;

  inherited Destroy;
end;

function TModuleList.Add(const ADllName : String; const AMethodID : LongInt; const AMethodText : String) : LongInt;
begin
  Result := Add(TModuleItem.Create(ADllName, AMethodID, AMethodText));
end;

function TModuleList.Find(const ADllName : String; const AMethodID : LongInt; const AMethodText : String) : TModuleItemArray;
var
  Counter : LongInt;
  Current : TModuleItem;
  Index   : LongInt;
begin
  SetLength(Result, Count);

  Counter := 0;
  for Index := Pred(Count) downto 0 do
  begin
    if (Items[Index] <> nil) then
    begin
      Current := TModuleItem(Items[Index]);

      if (AnsiLowerCase(Trim(Current.DllName)) = AnsiLowerCase(Trim(ADllName))) and
         (AnsiLowerCase(Trim(Current.MethodText)) = AnsiLowerCase(Trim(AMethodText))) and
         (Current.MethodID = AMethodID) then
      begin
        Result[Counter] := Current;

        Inc(Counter);
      end;
    end;
  end;

  SetLength(Result, Counter);
end;

function TModuleList.FindDll(const ADllName: String): TModuleItemArray;
var
  Counter : LongInt;
  Current : TModuleItem;
  Index   : LongInt;
begin
  SetLength(Result, Count);

  Counter := 0;
  for Index := Pred(Count) downto 0 do
  begin
    if (Items[Index] <> nil) then
    begin
      Current := TModuleItem(Items[Index]);

      if (AnsiLowerCase(Trim(Current.DllName)) = AnsiLowerCase(Trim(ADllName))) then
      begin
        Result[Counter] := Current;

        Inc(Counter);
      end;
    end;
  end;

  SetLength(Result, Counter);
end;

function TModuleList.FindDllID(const ADllName: String; const AMethodID: Integer): TModuleItemArray;
var
  Counter : LongInt;
  Current : TModuleItem;
  Index   : LongInt;
begin
  SetLength(Result, Count);

  Counter := 0;
  for Index := Pred(Count) downto 0 do
  begin
    if (Items[Index] <> nil) then
    begin
      Current := TModuleItem(Items[Index]);

      if (AnsiLowerCase(Trim(Current.DllName)) = AnsiLowerCase(Trim(ADllName))) and
         (Current.MethodID = AMethodID) then
      begin
        Result[Counter] := Current;

        Inc(Counter);
      end;
    end;
  end;

  SetLength(Result, Counter);
end;

function TModuleList.FindID(const AMethodID: Integer): TModuleItemArray;
var
  Counter : LongInt;
  Current : TModuleItem;
  Index   : LongInt;
begin
  SetLength(Result, Count);

  Counter := 0;
  for Index := Pred(Count) downto 0 do
  begin
    if (Items[Index] <> nil) then
    begin
      Current := TModuleItem(Items[Index]);

      if (Current.MethodID = AMethodID) then
      begin
        Result[Counter] := Current;

        Inc(Counter);
      end;
    end;
  end;

  SetLength(Result, Counter);
end;

function TModuleList.FindText(const AMethodText: String): TModuleItemArray;
var
  Counter : LongInt;
  Current : TModuleItem;
  Index   : LongInt;
begin
  SetLength(Result, Count);

  Counter := 0;
  for Index := Pred(Count) downto 0 do
  begin
    if (Items[Index] <> nil) then
    begin
      Current := TModuleItem(Items[Index]);

      if (AnsiLowerCase(Trim(Current.MethodText)) = AnsiLowerCase(Trim(AMethodText)))then
      begin
        Result[Counter] := Current;

        Inc(Counter);
      end;
    end;
  end;

  SetLength(Result, Counter);
end;

function TModuleList.IsAdd(const ADllName : String; const AMethodID : LongInt; const AMethodText : String) : Boolean;
var
  Current : TModuleItem;
  Index   : LongInt;
begin
  Result := false;

  for Index := Pred(Count) downto 0 do
  begin
    if (Items[Index] <> nil) then
    begin
      Current := TModuleItem(Items[Index]);

      if (AnsiLowerCase(Trim(Current.DllName)) = AnsiLowerCase(Trim(ADllName))) and
         (Current.MethodID = AMethodID) and
         (AnsiLowerCase(Trim(Current.MethodText)) = AnsiLowerCase(Trim(AMethodText))) then
      begin
        Result := true;

        Break;
      end;
    end;
  end;
end;

function TModuleList.IsAddDll(const ADllName : String) : Boolean;
var
  Current : TModuleItem;
  Index   : LongInt;
begin
  Result := false;

  for Index := Pred(Count) downto 0 do
  begin
    if (Items[Index] <> nil) then
    begin
      Current := TModuleItem(Items[Index]);

      if (AnsiLowerCase(Trim(Current.DllName)) = AnsiLowerCase(Trim(ADllName))) then
      begin
        Result := true;

        Break;
      end;
    end;
  end;
end;

function TModuleList.IsAddDllID(const ADllName : String; const AMethodID : LongInt) : Boolean;
var
  Current : TModuleItem;
  Index   : LongInt;
begin
  Result := false;

  for Index := Pred(Count) downto 0 do
  begin
    if (Items[Index] <> nil) then
    begin
      Current := TModuleItem(Items[Index]);

      if (AnsiLowerCase(Trim(Current.DllName)) = AnsiLowerCase(Trim(ADllName))) and
         (Current.MethodID = AMethodID) then
      begin
        Result := true;

        Break;
      end;
    end;
  end;
end;

function TModuleList.IsAddID(const AMethodID : LongInt) : Boolean;
var
  Current : TModuleItem;
  Index   : LongInt;
begin
  Result := false;

  for Index := Pred(Count) downto 0 do
  begin
    if (Items[Index] <> nil) then
    begin
      Current := TModuleItem(Items[Index]);

      if (Current.MethodID = AMethodID) then
      begin
        Result := true;

        Break;
      end;
    end;
  end;
end;

function TModuleList.IsAddText(const AMethodText : String) : Boolean;
var
  Current : TModuleItem;
  Index   : LongInt;
begin
  Result := false;

  for Index := Pred(Count) downto 0 do
  begin
    if (Items[Index] <> nil) then
    begin
      Current := TModuleItem(Items[Index]);

      if (AnsiLowerCase(Trim(Current.MethodText)) = AnsiLowerCase(Trim(AMethodText)))then
      begin
        Result := true;

        Break;
      end;
    end;
  end;
end;

procedure TModuleList.ClearAll;
var
  Index : LongInt;
begin
  for Index := Pred(Count) downto 0 do
  begin
    if (Items[Index] <> nil) then
      TModuleItem(Items[Index]).Free;
  end;

  Clear;
end;

procedure TModuleList.Delete(const ADllName : String; const AMethodID : LongInt; const AMethodText : String);
var
  Current : TModuleItem;
  Index   : LongInt;
begin
  for Index := Pred(Count) downto 0 do
  begin
    if (Items[Index] <> nil) then
    begin
      Current := TModuleItem(Items[Index]);

      if (AnsiLowerCase(Trim(Current.DllName)) = AnsiLowerCase(Trim(ADllName))) and
         (Current.MethodID = AMethodID) and
         (AnsiLowerCase(Trim(Current.MethodText)) = AnsiLowerCase(Trim(AMethodText))) then
      begin
        Current.Free;

        Delete(Index);
      end;
    end;
  end;
end;

procedure TModuleList.DeleteDll(const ADllName : String);
var
  Current : TModuleItem;
  Index   : LongInt;
begin
  for Index := Pred(Count) downto 0 do
  begin
    if (Items[Index] <> nil) then
    begin
      Current := TModuleItem(Items[Index]);

      if (AnsiLowerCase(Trim(Current.DllName)) = AnsiLowerCase(Trim(ADllName))) then
      begin
        Current.Free;

        Delete(Index);
      end;
    end;
  end;
end;

procedure TModuleList.DeleteDllID(const ADllName : String; const AMethodID : LongInt);
var
  Current : TModuleItem;
  Index   : LongInt;
begin
  for Index := Pred(Count) downto 0 do
  begin
    if (Items[Index] <> nil) then
    begin
      Current := TModuleItem(Items[Index]);

      if (AnsiLowerCase(Trim(Current.DllName)) = AnsiLowerCase(Trim(ADllName))) and
         (Current.MethodID = AMethodID) then
      begin
        Current.Free;

        Delete(Index);
      end;
    end;
  end;
end;

procedure TModuleList.DeleteID(const AMethodID : LongInt);
var
  Current : TModuleItem;
  Index   : LongInt;
begin
  for Index := Pred(Count) downto 0 do
  begin
    if (Items[Index] <> nil) then
    begin
      Current := TModuleItem(Items[Index]);

      if (Current.MethodID = AMethodID) then
      begin
        Current.Free;

        Delete(Index);
      end;
    end;
  end;
end;

procedure TModuleList.DeleteText(const AMethodText : String);
var
  Current : TModuleItem;
  Index   : LongInt;
begin
  for Index := Pred(Count) downto 0 do
  begin
    if (Items[Index] <> nil) then
    begin
      Current := TModuleItem(Items[Index]);

      if (AnsiLowerCase(Trim(Current.MethodText)) = AnsiLowerCase(Trim(AMethodText))) then
      begin
        Current.Free;

        Delete(Index);
      end;
    end;
  end;
end;

{ TUserItem }

function TUserItem.GetLoggedOn: Boolean;
begin
  Result := (FUserHandle <> 0);
end;

constructor TUserItem.Create;
begin
  inherited Create;

  FLocked     := false;
  FMethods    := TModuleList.Create;
  FUserHandle := 0;
end;

constructor TUserItem.Create(const AUserName : String; const AUserText : String; const APrivilege : TUserPrivilege);
begin
  Create;

  FPrivilege := APrivilege;
  FUserName  := AnsiLowerCase(Trim(AUserName));
  FUserText  := AnsiLowerCase(Trim(AUserText));
end;

destructor TUserItem.Destroy;
begin
  FMethods.Free;
  FMethods := nil;

  inherited Destroy;
end;

function TUserItem.LogOn(const AUserText: String; const AUserHandle : LongWord) : Boolean;
begin
  Result := (AnsiLowerCase(Trim(FUserText)) = AnsiLowerCase(Trim(AUserText)));
  if Result then
    FUserHandle := AUserHandle;
end;

procedure TUserItem.Lock;
begin
  if LoggedOn then
    FLocked := true;
end;

procedure TUserItem.LogOff;
begin
  FUserHandle := 0;
end;

procedure TUserItem.Unlock;
begin
  if LoggedOn then
    FLocked := false;
end;

{ TUserList }

destructor TUserList.Destroy;
begin
  ClearAll;

  inherited Destroy;
end;

function TUserList.Add(const AUserName : String; const AUserText : String; const APrivilege : TUserPrivilege) : LongInt;
begin
  Result := - 1;

  if not(IsAdd(AUserName)) then
    Result := Add(TUserItem.Create(AUserName, AUserText, APrivilege));
end;

function TUserList.FindHandle(const AUserHandle: LongWord): TUserItem;
var
  Current : TUserItem;
  Index   : LongInt;
begin
  Result := nil;

  for Index := Pred(Count) downto 0 do
  begin
    if (Items[Index] <> nil) then
    begin
      Current := TUserItem(Items[Index]);

      if (Current.UserHandle = AUserHandle) then
      begin
        Result := Current;

        Break;
      end;
    end;
  end;
end;

function TUserList.FindName(const AUserName: String) : TUserItem;
var
  Current : TUserItem;
  Index   : LongInt;
begin
  Result := nil;

  for Index := Pred(Count) downto 0 do
  begin
    if (Items[Index] <> nil) then
    begin
      Current := TUserItem(Items[Index]);

      if (AnsiLowerCase(Trim(Current.UserName)) = AnsiLowerCase(Trim(AUserName))) then
      begin
        Result := Current;

        Break;
      end;
    end;
  end;
end;

function TUserList.IsAdd(const AUserName: String) : Boolean;
var
  Current : TUserItem;
  Index   : LongInt;
begin
  Result := false;

  for Index := Pred(Count) downto 0 do
  begin
    if (Items[Index] <> nil) then
    begin
      Current := TUserItem(Items[Index]);

      if (AnsiLowerCase(Trim(Current.UserName)) = AnsiLowerCase(Trim(AUserName))) then
      begin
        Result := true;

        Break;
      end;
    end;
  end;
end;

procedure TUserList.ClearAll;
var
  Index : LongInt;
begin
  for Index := Pred(Count) downto 0 do
  begin
    if (Items[Index] <> nil) then
      TUserItem(Items[Index]).Free;
  end;

  Clear;
end;

end.
