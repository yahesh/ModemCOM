unit SendSU;

interface

uses
  Windows, Messages;

type
  THandleLongWord = type LongWord;

function GetMessageData(const AMessage : TwmCopyData; var AMessageText : String; var AMessageSender : THandleLongWord) : Boolean;

procedure SendStringMessage(const AReceiveHandle : THandleLongWord; const ASendHandle : THandleLongWord; const AString : String);

implementation

function GetMessageData(const AMessage : TwmCopyData; var AMessageText : String; var AMessageSender : THandleLongWord) : Boolean;
begin
  Result := false;

  SetLength(AMessageText, 0);
  if (AMessage.Msg = wm_CopyData) then
  begin
    if (AMessage.CopyDataStruct.dwData = AMessage.From) then
    begin
      AMessageSender := AMessage.From;

      if ((AMessage.CopyDataStruct.cbData > 0) and
          (AMessage.CopyDataStruct.lpData <> nil)) then
        AMessageText := String(PChar(AMessage.CopyDataStruct.lpData));

      Result := true;
    end;
  end;
end;

procedure SendStringMessage(const AReceiveHandle : THandleLongWord; const ASendHandle : THandleLongWord; const AString : String);
var
  CopyDataStruct : TCopyDataStruct;
begin
  if (AReceiveHandle <> 0) then
  begin
    CopyDataStruct.cbData := Succ(Length(AString));
    CopyDataStruct.dwData := ASendHandle;
    CopyDataStruct.lpData := Pointer(AString);

    SendMessage(AReceiveHandle, wm_CopyData, ASendHandle, LongInt(@CopyDataStruct));
  end;
end;

end.
