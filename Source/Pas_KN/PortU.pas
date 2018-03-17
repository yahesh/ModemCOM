unit PortU;

// DON'T DELETE THIS COMMENT !!!

{--------------------------------------------}
{ Unit:      PortU.pas                       }
{ Version:   1.29                            }
{                                            }
{ Coder:     Yahe <hello@yahe.sh>            }
{                                            }
{ I'm NOT Liable For Damages Of ANY Kind !!! }
{--------------------------------------------}

// DON'T DELETE THIS COMMENT !!!


// INFORMATION FOR USING THIS UNIT
//
// For Using the Functionality Of This Unit You
// Have To Call The Methods As Followed:
//
//
// SetParallelPortName(APortName,
//                     ACheckAvailabilityThroughConnecting); [EITHER]
//   - Set The Name Of The Parallel Port You Want
//     To Work With, E.G.: 'LPT1', 'LPT2', ETC.
//   - Can Use ConnectPort() To Check the
//     Availability Of The Chosen Port
//   - If Sucessful, PFCommConfig, PFPortName And
//     PFPortType Are <> NIL And
//     FPortType = ptParallel
//
// SetSerialPortName(APortName,
//                   ACheckAvailabilityThroughConnecting); [OR]
//   - Set The Name Of The Serial Port You Want
//     To Work With, E.G.: 'COM1', 'COM2', ETC.
//   - Can Use ConnectPort() To Check the
//     Availability Of The Chosen Port
//   - If Sucessful, PFCommConfig, PFPortName And
//     PFPortType Are <> NIL And
//     FPortType = ptSerial
//
// SetCommConfig(ADialogOwnerHandle); {Optional}
//   - Set The Configurations Of The Earlier
//     Chosen Serial Port, E.G.: BaudRate, ETC.
//
// ConnectPort(AReadIntervalTimeout,
//             AReadTotalTimeoutMultiplier,
//             AReadTotalTimeoutConstant,
//             AWriteTotalTimeoutMultiplier,
//             AWriteTotalTimeoutConstant,
//             AOnDataReceived, AOnNoDataReceived,
//             AOnReadPortError, AReadPause,
//             AReadPortActivated,
//             ASynchronizeOnDataReceived,
//             ASynchronizeOnNoDataReceived,
//             ASynchronizeOnReadPortError);
//   - Build Up The Connection To The Earlier
//     Chosen And {Optional} Configured Port
//   - If Sucessful, PFConnected, PFPortHandle
//     And PFReadPortThread Are <> NIL
//
// IsConnected(); {Optional}
//   - Check Whether The Connection Was Built
//     Up Correctly Or Not
//   - If Sucessful, TRUE Is Returned
//
// WriteStringToPort(AString); {Optional}
//   - Write A String To The Port To Which A
//     Connection Was Built Up
//   - If Sucessful, TRUE Is Returned
//
// DisConnectPort();
//   - Close The Connection To The Port You
//     Earlier Connected To
//   - If Sucessful, PFConnected, PFPortHandle
//     And PFReadPortThread Are = NIL
//
// INFORMATION FOR USING THIS UNIT

interface

uses
  Windows, Forms, Classes;

type
  TNoReadPortEvent = procedure of Object;
  TPortType        = (ptNone, ptParallel, ptSerial);
  TReadPortEvent   = procedure (const AChar : Char) of Object;

  TReadPortThread = class(TThread)
  protected
    FActivated                   : Boolean;
    FBufferedChar                : Char;
    FOnDataReceived              : TReadPortEvent;
    FOnNoDataReceived            : TNoReadPortEvent;
    FOnReadPortError             : TNoReadPortEvent;
    FPortHandle                  : THandle;
    FReadPause                   : LongInt;
    FSynchronizeOnDataReceived   : Boolean;
    FSynchronizeOnNoDataReceived : Boolean;
    FSynchronizeOnReadPortError  : Boolean;

    procedure Execute; override;
    procedure FDataReceived;
    procedure FNoDataReceived;
    procedure FReadPortError;
  public
    property Activated                   : Boolean          read FActivated                   write FActivated;
    property OnDataReceived              : TReadPortEvent   read FOnDataReceived              write FOnDataReceived;
    property OnNoDataReceived            : TNoReadPortEvent read FOnNoDataReceived            write FOnNoDataReceived;
    property OnReadPortError             : TNoReadPortEvent read FOnReadPortError             write FOnReadPortError;
    property PortHandle                  : THandle          read FPortHandle                  write FPortHandle;
    property ReadPause                   : LongInt          read FReadPause                   write FReadPause;
    property SynchronizeOnDataReceived   : Boolean          read FSynchronizeOnDataReceived   write FSynchronizeOnDataReceived;
    property SynchronizeOnNoDataReceived : Boolean          read FSynchronizeOnNoDataReceived write FSynchronizeOnNoDataReceived;
    property SynchronizeOnReadPortError  : Boolean          read FSynchronizeOnReadPortError  write FSynchronizeOnReadPortError;

    procedure Activate;
    procedure DataReceived(const AChar : Char);
    procedure DeActivate;
    procedure NoDataReceived;
    procedure ReadPortError;
  end;

function IsConnected : Boolean;
function WriteStringToPort(const AString : String) : Boolean;

procedure ConnectPort(const AReadIntervalTimeout : LongInt; const AReadTotalTimeoutMultiplier : LongInt;
                      const AReadTotalTimeoutConstant : LongInt; const AWriteTotalTimeoutMultiplier : LongInt;
                      const AWriteTotalTimeoutConstant : LongInt; const AOnDataReceived : TReadPortEvent;
                      const AOnNoDataReceived : TNoReadPortEvent; const AOnReadPortError : TNoReadPortEvent;
                      const AReadPause : LongInt;
                      const AReadPortActivated : Boolean;
                      const ASynchronizeOnDataReceived : Boolean; const ASynchronizeOnNoDataReceived : Boolean;
                      const ASynchronizeOnReadPortError : Boolean);
procedure DisConnectPort;
procedure SetCommConfig(const ADialogOwnerHandle : THandle);
procedure SetParallelPortName(const APortName : String; const ACheckAvailabilityThroughConnecting : Boolean);
procedure SetSerialPortName(const APortName : String; const ACheckAvailabilityThroughConnecting : Boolean);

procedure Wait(const AMilliSeconds : LongInt);

var
  PFCommConfig     : ^TCommConfig     = nil;
  PFConnected      : ^Boolean         = nil;
  PFPortHandle     : ^THandle         = nil;
  PFPortName       : ^String          = nil;
  PFPortType       : ^TPortType       = nil;
  PFReadPortThread : ^TReadPortThread = nil;

implementation

var
  FCommConfig     : TCommConfig;
  FConnected      : Boolean         = false;
  FPortHandle     : THandle         = 0;
  FPortName       : String          = '';
  FPortType       : TPortType       = ptNone;
  FReadPortThread : TReadPortThread = nil;

function IsConnected : Boolean;
begin
  Result := (FConnected and (FPortType <> ptNone) and (PFCommConfig <> nil) and
            (PFConnected <> nil) and (PFPortHandle <> nil) and (PFPortName <> nil) and
            (PFPortType <> nil) and (PFReadPortThread <> nil));
end;

function WriteStringToPort(const AString : String) : Boolean;
var
  WrittenByteCount : Cardinal;
begin
  Result := false;

  if FConnected then
  begin
    if (Length(AString) > 0) then
    begin
      if WriteFile(FPortHandle, AString[1], Length(AString), WrittenByteCount, nil) then
        Result := (WrittenByteCount = Length(AString));
    end
    else
      Result := true;
  end;
end;

procedure ConnectPort(const AReadIntervalTimeout : LongInt; const AReadTotalTimeoutMultiplier : LongInt;
                      const AReadTotalTimeoutConstant : LongInt; const AWriteTotalTimeoutMultiplier : LongInt;
                      const AWriteTotalTimeoutConstant : LongInt; const AOnDataReceived : TReadPortEvent;
                      const AOnNoDataReceived : TNoReadPortEvent; const AOnReadPortError : TNoReadPortEvent;
                      const AReadPause : LongInt;
                      const AReadPortActivated : Boolean;
                      const ASynchronizeOnDataReceived : Boolean; const ASynchronizeOnNoDataReceived : Boolean;
                      const ASynchronizeOnReadPortError : Boolean);
var
  CommTimeouts : TCommTimeouts;
begin
  if not(FConnected) then
  begin
    FPortHandle := CreateFile(PAnsiChar(FPortName), Generic_Read or Generic_Write, 0 , nil, Open_Existing, {File_Flag_Overlapped or }File_Attribute_Normal, 0);

    if (FPortHandle <> Invalid_Handle_Value) then
    begin
      FConnected := true;

      PFConnected  := @FConnected;
      PFPortHandle := @FPortHandle;

      if (FPortType = ptSerial) then
      begin
        SetCommState(FPortHandle, FCommConfig.dcb);

        GetCommTimeouts(FPortHandle, CommTimeouts);

        if (AReadIntervalTimeout >= 0) then
          CommTimeouts.ReadIntervalTimeout := AReadIntervalTimeout;
        if (AReadTotalTimeoutMultiplier >= 0) then
          CommTimeouts.ReadTotalTimeoutMultiplier := AReadTotalTimeoutMultiplier;
        if (AReadTotalTimeoutConstant >= 0) then
          CommTimeouts.ReadTotalTimeoutConstant := AReadTotalTimeoutConstant;
        if (AWriteTotalTimeoutMultiplier >= 0) then
          CommTimeouts.WriteTotalTimeoutMultiplier := AWriteTotalTimeoutMultiplier;
        if (AWriteTotalTimeoutConstant >= 0) then
          CommTimeouts.WriteTotalTimeoutConstant := AWriteTotalTimeoutConstant;

        SetCommTimeouts(FPortHandle, CommTimeouts);
      end;
    end
    else
    begin
      PFPortHandle := nil;

      FConnected := false;
    end;

    if FConnected and (PFPortHandle <> nil) then
    begin
      if (FReadPortThread = nil) and (PFReadPortThread = nil) then
        FReadPortThread := TReadPortThread.Create(true)
      else
      begin
        if (FReadPortThread <> nil) then
          FReadPortThread.Suspend;

        if (PFReadPortThread <> nil) then
          PFReadPortThread := nil;
      end;

      try
        FReadPortThread.OnDataReceived              := AOnDataReceived;
        FReadPortThread.OnNoDataReceived            := AOnNoDataReceived;
        FReadPortThread.FOnReadPortError            := AOnReadPortError;
        FReadPortThread.PortHandle                  := FPortHandle;
        FReadPortThread.ReadPause                   := AReadPause;
        FReadPortThread.SynchronizeOnDataReceived   := ASynchronizeOnDataReceived;
        FReadPortThread.SynchronizeOnNoDataReceived := ASynchronizeOnNoDataReceived;
        FReadPortThread.SynchronizeOnReadPortError  := ASynchronizeOnReadPortError;

        if AReadPortActivated then
          FReadPortThread.Activate
        else
          FReadPortThread.DeActivate;

        FReadPortThread.Resume;

        PFReadPortThread := @FReadPortThread;
      except
        FReadPortThread.Free;
        FReadPortThread := nil;

        PFReadPortThread := nil;

        DisConnectPort;
      end;
    end;
  end;
end;

procedure DisConnectPort;
begin
  if FConnected then
  begin
    if CloseHandle(FPortHandle) then
    begin
      FConnected := false;

      PFConnected  := nil;
      PFPortHandle := nil;
    end;

    FReadPortThread.Free;
    FReadPortThread := nil;

    PFReadPortThread := nil;
  end;
end;

procedure SetCommConfig(const ADialogOwnerHandle : THandle);
begin
  if not(FConnected) then
    CommConfigDialog(PAnsiChar(FPortName), ADialogOwnerHandle, FCommConfig);
end;

procedure SetParallelPortName(const APortName : String; const ACheckAvailabilityThroughConnecting : Boolean);
begin
  FPortName := APortName;

  if ACheckAvailabilityThroughConnecting then
    ConnectPort(0, 0, 0, 0, 0, nil, nil, nil, 0, false, false, false, false);

  if (FConnected or not(ACheckAvailabilityThroughConnecting)) then
  begin
    FPortType := ptParallel;

    PFCommConfig := @FCommConfig;
    PFPortName   := @FPortName;
    PFPortType   := @FPortType;
  end
  else
  begin
    FPortType := ptNone;

    PFCommConfig := nil;
    PFPortName   := nil;
    PFPortType   := nil;
  end;

  if ACheckAvailabilityThroughConnecting then
    DisconnectPort;
end;

procedure SetSerialPortName(const APortName : String; const ACheckAvailabilityThroughConnecting : Boolean);
begin
  FPortName := APortName;

  FCommConfig.dwSize := SizeOf(FCommConfig);
  if GetDefaultCommConfig(PAnsiChar(FPortName), FCommConfig, FCommConfig.dwSize) then
  begin
    if ACheckAvailabilityThroughConnecting then
      ConnectPort(0, 0, 0, 0, 0, nil, nil, nil, 0, false, false, false, false);

    if FConnected or not(ACheckAvailabilityThroughConnecting) then
    begin
      FPortType := ptSerial;

      PFCommConfig := @FCommConfig;
      PFPortName   := @FPortName;
      PFPortType   := @FPortType;
    end
    else
    begin
      FPortType := ptNone;

      PFCommConfig := nil;
      PFPortName   := nil;
      PFPortType   := nil;
    end;

    if ACheckAvailabilityThroughConnecting then
      DisConnectPort;
  end
  else
  begin
    FPortType := ptNone;

    PFCommConfig := nil;
    PFPortName   := nil;
    PFPortType   := nil;
  end;
end;

procedure Wait(const AMilliSeconds : LongInt);
var
  StartTime : LongInt;
begin
  StartTime := GetTickCount;

  while ((GetTickCount - StartTime) < AMilliSeconds) do
  begin
    Application.ProcessMessages;
    Sleep(0);
  end;
end;

{ TReadPortThread }

procedure TReadPortThread.Activate;
begin
  FActivated := true;
end;

procedure TReadPortThread.DeActivate;
begin
  FActivated := false;
end;

procedure TReadPortThread.Execute;
var
  BufferChar    : Char;
  ReadByteCount : Cardinal;
begin
  while not(Terminated) do
  begin
    if FActivated then
    begin
      if FConnected then
      begin
        if (ReadFile(FPortHandle, BufferChar, 1, ReadByteCount, nil)) then
        begin
          if FActivated then
          begin
            if (ReadByteCount > 0) then
            begin
              if FActivated then
              begin
                FBufferedChar := BufferChar;

                if FSynchronizeOnDataReceived then
                  Synchronize(FDataReceived)
                else
                  FDataReceived;
              end;
            end
            else
            begin
              if FActivated then
              begin
                if FSynchronizeOnNoDataReceived then
                  Synchronize(FNoDataReceived)
                else
                  FNoDataReceived;
              end;
            end;
          end;
        end
        else
        begin
          if FActivated then
          begin
            if FSynchronizeOnReadPortError then
              Synchronize(FReadPortError)
            else
              FReadPortError;
          end;
        end;
      end;
    end;

    if (FReadPause > 0) then
      Wait(FReadPause)
    else
      Wait(1);
  end;
end;

procedure TReadPortThread.FDataReceived;
begin
  DataReceived(FBufferedChar);
end;

procedure TReadPortThread.FNoDataReceived;
begin
  NoDataReceived;
end;

procedure TReadPortThread.FReadPortError;
begin
  ReadPortError;
end;

procedure TReadPortThread.DataReceived(const AChar: Char);
begin
  if Assigned(FOnDataReceived) then
    FOnDataReceived(AChar);
end;

procedure TReadPortThread.NoDataReceived;
begin
  if Assigned(FOnNoDataReceived) then
    FOnNoDataReceived;
end;

procedure TReadPortThread.ReadPortError;
begin
  if Assigned(FOnReadPortError) then
    FOnReadPortError;
end;

end.
