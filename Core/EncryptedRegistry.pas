unit EncryptedRegistry;

{
  Copyright (c) 1999 Dave Shapiro, Professional Software, Inc. (daves@cfxc.com)
  Use and modify freely. Keep this header, please.


                      How NOT to design a reusable class

                     A commentary by Dave Shapiro (age 26)


  I'd like to begin this comment section by saying that the person at Inprise
  who wrote TRegistry should be spanked several times. Here's the problem:
  TRegistry reads and writes many different types of values from and to the
  Windows registry. Thankfully, the various methods for doing this all
  eventually call common get and put methods -- namely GetData and PutData --
  which nicely centralizes the nasty code. These methods are protected as well,
  shielding the client from such internal messiness, but allowing the zealous
  developer to override their behavior to make more specialized registry
  classes. Sounds great, right? WRONG. GetData and PutData are not virtual
  methods. Thus, if TEncryptedRegistry inherited from TRegistry, calling
  TRegistry.ReadString would ALWAYS call TRegistry.GetData, and not
  TEncryptedRegistry.GetData, UNLESS you ALSO re-implement ReadString in
  TEncryptedRegistry. But then you'd have to re-implement WriteString, and
  Read- and WriteInteger, and Read- and WriteFloat, etc. That's a lot of work.
  And even if you did that, someone could easily circumvent your efforts,
  as the public Read/Write methods are static as well:

  var
    Reg: TRegistry; // Use sub-type substitutability.
  begin
    Reg := TEncryptedRegistry.Create;
    Reg.WriteString('Blah', 'Blah'); // ALWAYS calls TRegistry.WriteString!
  end;

  In short, you CANNOT inherit from TRegistry and have it do anything useful.
  TRegistry's protected features are worthless, since you're not guaranteed
  correct dispatching at runtime. It's a done class; stick a fork in it.
  (Don't even get me STARTED on why static methods are the default. Any 'OO'
  language that does not implement polymorphism by default is not 'OO', and
  this includes C++. So says me.)

  My solution, then, was to use what's called 'aggregation' or 'object
  composition'. In essence, you establish a 'has-a' relationship, as opposed
  to an 'is-a' (inheritance) relationship. In this case, TEncryptedRegistry
  inherits from TObject, and has an instance field FRegistry which is of type
  TRegistry. All of TRegistry's public features are copied and to
  TEncryptedRegistry, literally by copying and pasting from the Registry unit.
  Most features are left alone, and as such are simply 'forwarded' to
  FRegistry. For instance, here is the implementation of HasSubKeys:

    function TEncryptedRegistry.HasSubKeys: Boolean;
    begin
      Result := FRegistry.HasSubKeys;
    end;

  Any feature that needs to be redefined (which, if it were virtual, you could
  just inherit and override) is 'hijacked' and implemented as appropriate. In
  the case of TEncryptedRegistry, all of the Read/Write methods are redefined
  to call TEncryptedRegistry.Get- or PutData, which have also been redefined
  to decrypt or encrypt the data before reading or writing.

  The good news, then, is that with a little work we have a class that acts
  exactly like a TRegistry, but transparently encrypts or decrypts the data.

  The bad news is that this new class doesn't inherit from TRegistry, and thus
  can't take advantage of sub-type substitution (like with TStrings and
  TStringList, or TStream and TMemoryStream), which is one of the main
  strengths of OO. Duh. The other major disadvantage is that the behavior of
  TRegistry isn't automatically inherited. TEncryptedRegistry has to forward
  all calls, and the owner of TEncryptedRegistry (that's me) has to vigilantly
  keep track of differences in versions of TRegistry, adding new features in
  manually, instead of just inheriting them automatically. For instance,
  Delphi 4's TRegistry introduced the OpenKeyReadOnly method. Now I have to
  conditionally compile its forwarding call in TEncryptedRegistry manually,
  instead of inheriting it automatically. Very messy. Very non-OO.


  How this class works: From the client's standpoint, TEncryptedRegistry
  behaves *exactly* like TRegistry. The only difference is the constructor:
  TEncryptedRegistry needs a TBlockCipher (the TBlockCipher hierarchy can be
  found in my BlockCipher unit. Don't have it? Download it from
  http://www.csd.net/~daves/delphi). You can take advantage of TBlockCipher's
  virtual constructor, and send a class reference to TEncryptedRegistry
  (e.g. MyReg := TEncryptedRegistry.Create(TDESCipher ...). In this case,
  TEncryptedRegistry will create and free a block cipher for you. If you
  have an existing block cipher, you can use
  TEncryptedRegistry.CreateWithExistingCipher. In this case, TEncryptedRegistry
  will use your pre-existing block cipher, and will not free it on destruction.
}

(*$IFDEF Ver80*)
  (*$DEFINE PreDelphi4*)
  (*$DEFINE PreDelphi3*)
(*$ENDIF*)
(*$IFDEF Ver90*)
  (*$DEFINE PreDelphi4*)
  (*$DEFINE PreDelphi3*)
(*$ENDIF*)
(*$IFDEF Ver100*)
  (*$DEFINE PreDelphi4*)
(*$ENDIF*)

interface

uses Windows, SysUtils, Classes, Registry, BlockCiphers;

type
  TEncryptedRegistry = class(TObject)
  private
    FRegistry: TRegistry;
    FBlockCipher: TBlockCipher;
  protected
    FFreeCipher: Boolean;
    // Aggregate property accessors; just forwarded calls to FRegistry.
    function GetCurrentKey: HKEY; virtual;
    function GetCurrentPath: string; virtual;
    function GetLazyWrite: Boolean; virtual;
    procedure SetLazyWrite(const NewLazyWrite: Boolean); virtual;
    function GetRootKey: HKEY; virtual;
    procedure SetRootKey(const NewRootKey: HKEY); virtual;
  protected
    function RawDataInfo(const Name: string): TRegDataInfo; virtual;
    function RawData(const Name: string): Pointer; virtual;
    function DataInfoFromRawData(RawData: Pointer): TRegDataInfo; virtual;
    procedure DecryptRawData(Data, Buffer: Pointer; BufSize: Integer;
                             const DataInfo: TRegDataInfo); virtual;
    function GetData(const Name: string; Buffer: Pointer; BufSize: Integer;
                     var RegData: TRegDataType): Integer; virtual;
    procedure PutData(const Name: string; Buffer: Pointer; BufSize: Integer;
                      RegData: TRegDataType); virtual;
    property Registry: TRegistry read FRegistry;
    property BlockCipher: TBlockCipher read FBlockCipher;
  public
    // Construction/destruction.
    constructor Create(const BlockCipherClass: TBlockCipherClass;
                       const Key; const Length: Integer);
    constructor CreateWithExistingCipher(Cipher: TBlockCipher);
    destructor Destroy; override;
    // 'Hijacked' features.
    function GetDataInfo(const ValueName: string;
                         var Value: TRegDataInfo): Boolean;
    function GetDataSize(const ValueName: string): Integer;
    function GetDataType(const ValueName: string): TRegDataType;
    function ReadCurrency(const Name: string): Currency;
    function ReadBinaryData(const Name: string; var Buffer;
                            BufSize: Integer): Integer;
    function ReadBool(const Name: string): Boolean;
    function ReadDate(const Name: string): TDateTime;
    function ReadDateTime(const Name: string): TDateTime;
    function ReadFloat(const Name: string): Double;
    function ReadInteger(const Name: string): Integer;
    function ReadString(const Name: string): string;
    function ReadTime(const Name: string): TDateTime;
    procedure WriteCurrency(const Name: string; Value: Currency);
    procedure WriteBinaryData(const Name: string; var Buffer; BufSize: Integer);
    procedure WriteBool(const Name: string; Value: Boolean);
    procedure WriteDate(const Name: string; Value: TDateTime);
    procedure WriteDateTime(const Name: string; Value: TDateTime);
    procedure WriteFloat(const Name: string; Value: Double);
    procedure WriteInteger(const Name: string; Value: Integer);
    procedure WriteString(const Name, Value: string);
    procedure WriteExpandString(const Name, Value: string);
    procedure WriteTime(const Name: string; Value: TDateTime);
    // Forwarded calls.
    procedure CloseKey;
    function CreateKey(const Key: string): Boolean;
    function DeleteKey(const Key: string): Boolean;
    function DeleteValue(const Name: string): Boolean;
    function GetKeyInfo(var Value: TRegKeyInfo): Boolean;
    procedure GetKeyNames(Strings: TStrings);
    procedure GetValueNames(Strings: TStrings);
    function HasSubKeys: Boolean;
    function KeyExists(const Key: string): Boolean;
    function LoadKey(const Key, FileName: string): Boolean;
    procedure MoveKey(const OldName, NewName: string; Delete: Boolean);
    function OpenKey(const Key: string; CanCreate: Boolean): Boolean;
    (*$IFNDEF PreDelphi4*)
      function OpenKeyReadOnly(const Key: String): Boolean;
    (*$ENDIF*)
    function RegistryConnect(const UNCName: string): Boolean;
    procedure RenameValue(const OldName, NewName: string);
    function ReplaceKey(const Key, FileName, BackUpFileName: string): Boolean;
    function RestoreKey(const Key, FileName: string): Boolean;
    function SaveKey(const Key, FileName: string): Boolean;
    function UnLoadKey(const Key: string): Boolean;
    function ValueExists(const Name: string): Boolean;
    // Forwarded properties.
    property CurrentKey: HKEY read GetCurrentKey;
    property CurrentPath: string read GetCurrentPath;
    property LazyWrite: Boolean read GetLazyWrite write SetLazyWrite;
    property RootKey: HKEY read GetRootKey write SetRootKey;
  end;

implementation

uses Consts;

const
  SRawDataFailure = 'Failed to get raw data for ''%s''';

procedure ReadError(const Name: string);
begin
  raise ERegistryException.CreateFmt(SInvalidRegType, [Name]);
end;


// -------------------------- TEncryptedRegistry -------------------------------


constructor TEncryptedRegistry.Create(const BlockCipherClass: TBlockCipherClass;
                                      const Key; const Length: Integer);
begin
  inherited Create;
  FRegistry := TRegistry.Create;
  FBlockCipher := BlockCipherClass.Create(Key, Length);
  FFreeCipher := True;
end;

constructor TEncryptedRegistry.CreateWithExistingCipher(Cipher: TBlockCipher);
begin
  inherited Create;
  if not Assigned(Cipher) then begin
    raise Exception.Create('Cipher is not Assigned.');
  end;
  FRegistry := TRegistry.Create;
  FBlockCipher := Cipher;
  FFreeCipher := False;
end;

destructor TEncryptedRegistry.Destroy;
begin
  if FFreeCipher then FBlockCipher.Free;
  FRegistry.Free;
  inherited;
end;

// Hijacked features.

procedure TEncryptedRegistry.PutData(const Name: string; Buffer: Pointer;
                                     BufSize: Integer; RegData: TRegDataType);
var
  DataInfo: TRegDataInfo;
  Ciphertext, Plaintext: TMemoryStream;
begin
  DataInfo.DataSize := BufSize;
  DataInfo.RegData := RegData;
  Plaintext := TMemoryStream.Create;
  try
    Plaintext.Write(Buffer^, BufSize);
    Plaintext.Position := 0;
    Ciphertext := TMemoryStream.Create;
    try
      Ciphertext.Write(DataInfo, SizeOf(DataInfo));
      FBlockCipher.EncryptStream(Plaintext, Ciphertext);
      FRegistry.WriteBinaryData(Name, Ciphertext.Memory^, Ciphertext.Size);
    finally
      Ciphertext.Free;
    end;
  finally
    Plaintext.Free;
  end;
end;

procedure TEncryptedRegistry.DecryptRawData(Data, Buffer: Pointer;
                                            BufSize: Integer;
                                            const DataInfo: TRegDataInfo);
var
  Ciphertext, Plaintext: TMemoryStream;
  DataSize: Integer;
begin
  DataSize := DataInfo.DataSize + SizeOf(DataInfo) + FBlockCipher.BlockSize -
              DataInfo.DataSize mod FBlockCipher.BlockSize;
  Ciphertext := TMemoryStream.Create;
  try
    Ciphertext.SetSize(DataSize);
    Ciphertext.Write(Data^, Ciphertext.Size);
    Ciphertext.Position := SizeOf(DataInfo);
    Plaintext := TMemoryStream.Create;
    try
      FBlockCipher.DecryptStream(Ciphertext, Plaintext);
      Plaintext.Position := 0;
      Plaintext.Read(Buffer^, BufSize);
    finally
      Plaintext.Free;
    end;
  finally
    Ciphertext.Free;
  end;
end;

function TEncryptedRegistry.GetData(const Name: string; Buffer: Pointer;
                                    BufSize: Integer;
                                    var RegData: TRegDataType): Integer;
var
  DataInfo: TRegDataInfo;
  Data: Pointer;
begin
  Data := RawData(Name);
  try
    DataInfo := DataInfoFromRawData(Data);
    Result := DataInfo.DataSize;
    RegData := DataInfo.RegData;
    DecryptRawData(Data, Buffer, BufSize, DataInfo);
  finally
    FreeMem(Data);
  end;
end;

function TEncryptedRegistry.RawDataInfo(const Name: string): TRegDataInfo;
begin
  if not FRegistry.GetDataInfo(Name, Result) then begin
    raise ERegistryException.CreateFmt(SRawDataFailure, [Name]);
  end;
end;

function TEncryptedRegistry.RawData(const Name: string): Pointer;
var
  Info: TRegDataInfo;
begin
  Info := RawDataInfo(Name);
  GetMem(Result, Info.DataSize);
  try
    FRegistry.ReadBinaryData(Name, Result^, Info.DataSize);
  except
    FreeMem(Result);
    raise;
  end;
end;

function TEncryptedRegistry.DataInfoFromRawData(RawData: Pointer): TRegDataInfo;
begin
  Move(RawData^, Result, SizeOf(Result));
end;

function TEncryptedRegistry.GetDataInfo(const ValueName: string;
                                        var Value: TRegDataInfo): Boolean;
var
  Data: Pointer;
begin
  Result := True;
  FillChar(Value, SizeOf(Value), 0);
  Data := RawData(ValueName);
  try
    Value := DataInfoFromRawData(Data);
  finally
    FreeMem(Data);
  end;
end;

function TEncryptedRegistry.GetDataSize(const ValueName: string): Integer;
var
  Info: TRegDataInfo;
begin
  if GetDataInfo(ValueName, Info) then
    Result := Info.DataSize
  else begin
    Result := -1;
  end;
end;

function TEncryptedRegistry.GetDataType(const ValueName: string): TRegDataType;
var
  Info: TRegDataInfo;
begin
  if GetDataInfo(ValueName, Info) then
    Result := Info.RegData
  else begin
    Result := rdUnknown;
  end;
end;

function TEncryptedRegistry.ReadCurrency(const Name: string): Currency;
var
  Len: Integer;
  RegData: TRegDataType;
begin
  Len := GetData(Name, @Result, SizeOf(Currency), RegData);
  if (RegData <> rdBinary) or (Len <> SizeOf(Currency)) then ReadError(Name);
end;

function TEncryptedRegistry.ReadBinaryData(const Name: string; var Buffer;
                                           BufSize: Integer): Integer;
var
  DataInfo: TRegDataInfo;
  Data: Pointer;
begin
  Data := RawData(Name);
  try
    DataInfo := DataInfoFromRawData(Data);
    Result := DataInfo.DataSize;
    if (DataInfo.RegData in [rdBinary, rdUnknown]) and (Result <= BufSize) then
      DecryptRawData(Data, Addr(Buffer), DataInfo.DataSize, DataInfo)
    else begin
      ReadError(Name);
    end;
  finally
    FreeMem(Data);
  end;
end;

function TEncryptedRegistry.ReadBool(const Name: string): Boolean;
begin
  Result := ReadInteger(Name) <> 0;
end;

function TEncryptedRegistry.ReadDate(const Name: string): TDateTime;
begin
  Result := ReadDateTime(Name);
end;

function TEncryptedRegistry.ReadDateTime(const Name: string): TDateTime;
var
  Len: Integer;
  RegData: TRegDataType;
begin
  Len := GetData(Name, @Result, SizeOf(TDateTime), RegData);
  if (RegData <> rdBinary) or (Len <> SizeOf(TDateTime)) then ReadError(Name);
end;

function TEncryptedRegistry.ReadFloat(const Name: string): Double;
var
  Len: Integer;
  RegData: TRegDataType;
begin
  Len := GetData(Name, @Result, SizeOf(Double), RegData);
  if (RegData <> rdBinary) or (Len <> SizeOf(Double)) then ReadError(Name);
end;

function TEncryptedRegistry.ReadInteger(const Name: string): Integer;
var
  RegData: TRegDataType;
begin
  GetData(Name, @Result, SizeOf(Integer), RegData);
  if RegData <> rdInteger then ReadError(Name);
end;

function TEncryptedRegistry.ReadString(const Name: string): string;
var
  DataInfo: TRegDataInfo;
  Data: Pointer;
begin
  Data := RawData(Name);
  try
    DataInfo := DataInfoFromRawData(Data);
    if DataInfo.RegData in [rdString, rdExpandString] then begin
      SetLength(Result, DataInfo.DataSize);
      DecryptRawData(Data, Pointer(Result), DataInfo.DataSize, DataInfo);
    end
    else begin
      ReadError(Name);
    end;
  finally
    FreeMem(Data);
  end;
end;

function TEncryptedRegistry.ReadTime(const Name: string): TDateTime;
begin
  Result := ReadDateTime(Name);
end;

procedure TEncryptedRegistry.WriteCurrency(const Name: string; Value: Currency);
begin
  PutData(Name, @Value, SizeOf(Currency), rdBinary);
end;

procedure TEncryptedRegistry.WriteBinaryData(const Name: string;
                                             var Buffer; BufSize: Integer);
begin
  PutData(Name, @Buffer, BufSize, rdBinary);
end;

procedure TEncryptedRegistry.WriteBool(const Name: string; Value: Boolean);
begin
  WriteInteger(Name, Ord(Value));
end;

procedure TEncryptedRegistry.WriteDate(const Name: string; Value: TDateTime);
begin
  WriteDateTime(Name, Value);
end;

procedure TEncryptedRegistry.WriteDateTime(const Name: string; Value: TDateTime);
begin
  PutData(Name, @Value, SizeOf(TDateTime), rdBinary);
end;

procedure TEncryptedRegistry.WriteFloat(const Name: string; Value: Double);
begin
  PutData(Name, @Value, SizeOf(Double), rdBinary);
end;

procedure TEncryptedRegistry.WriteInteger(const Name: string; Value: Integer);
begin
  PutData(Name, @Value, SizeOf(Integer), rdInteger);
end;

procedure TEncryptedRegistry.WriteString(const Name, Value: string);
begin
  PutData(Name, Pointer(Value), Length(Value), rdString);
end;

procedure TEncryptedRegistry.WriteExpandString(const Name, Value: string);
begin
  PutData(Name, Pointer(Value), Length(Value), rdExpandString);
end;

procedure TEncryptedRegistry.WriteTime(const Name: string; Value: TDateTime);
begin
  WriteDateTime(Name, Value);
end;

// Forwarded calls for aggregate FRegistry usage.

function TEncryptedRegistry.GetCurrentKey: HKEY;
begin
  Result := FRegistry.CurrentKey;
end;

function TEncryptedRegistry.GetCurrentPath: string;
begin
  Result := FRegistry.CurrentPath;
end;

function TEncryptedRegistry.GetLazyWrite: Boolean;
begin
  Result := FRegistry.LazyWrite;
end;

procedure TEncryptedRegistry.SetLazyWrite(const NewLazyWrite: Boolean);
begin
  FRegistry.LazyWrite := NewLazyWrite;
end;

function TEncryptedRegistry.GetRootKey: HKEY;
begin
  Result := FRegistry.RootKey;
end;

procedure TEncryptedRegistry.SetRootKey(const NewRootKey: HKEY);
begin
  FRegistry.RootKey := NewRootKey;
end;

procedure TEncryptedRegistry.CloseKey;
begin
  FRegistry.CloseKey;
end;

function TEncryptedRegistry.CreateKey(const Key: string): Boolean;
begin
  Result := FRegistry.CreateKey(Key);
end;

function TEncryptedRegistry.DeleteKey(const Key: string): Boolean;
begin
  Result := FRegistry.DeleteKey(Key);
end;

function TEncryptedRegistry.DeleteValue(const Name: string): Boolean;
begin
  Result := FRegistry.DeleteValue(Name);
end;

function TEncryptedRegistry.GetKeyInfo(var Value: TRegKeyInfo): Boolean;
begin
  Result := FRegistry.GetKeyInfo(Value);
end;

procedure TEncryptedRegistry.GetKeyNames(Strings: TStrings);
begin
  FRegistry.GetKeyNames(Strings);
end;

procedure TEncryptedRegistry.GetValueNames(Strings: TStrings);
begin
  FRegistry.GetValueNames(Strings);
end;

function TEncryptedRegistry.HasSubKeys: Boolean;
begin
  Result := FRegistry.HasSubKeys;
end;

function TEncryptedRegistry.KeyExists(const Key: string): Boolean;
begin
  Result := FRegistry.KeyExists(Key);
end;

function TEncryptedRegistry.LoadKey(const Key, FileName: string): Boolean;
begin
  Result := FRegistry.LoadKey(Key, FileName);
end;

procedure TEncryptedRegistry.MoveKey(const OldName, NewName: string;
                                     Delete: Boolean);
begin
  FRegistry.MoveKey(OldName, NewName, Delete);
end;

function TEncryptedRegistry.OpenKey(const Key: string; CanCreate: Boolean): Boolean;
begin
  Result := FRegistry.OpenKey(Key, CanCreate);
end;

(*$IFNDEF PreDelphi4*)
  function TEncryptedRegistry.OpenKeyReadOnly(const Key: String): Boolean;
  begin
    Result := FRegistry.OpenKeyReadOnly(Key);
  end;
(*$ENDIF*)

function TEncryptedRegistry.RegistryConnect(const UNCName: string): Boolean;
begin
  Result := FRegistry.RegistryConnect(UNCName);
end;

procedure TEncryptedRegistry.RenameValue(const OldName, NewName: string);
begin
  FRegistry.RenameValue(OldName, NewName);
end;

function TEncryptedRegistry.ReplaceKey(const Key, FileName,
                                             BackUpFileName: string): Boolean;
begin
  Result := FRegistry.ReplaceKey(Key, FileName, BackUpFileName);
end;

function TEncryptedRegistry.RestoreKey(const Key, FileName: string): Boolean;
begin
  Result := FRegistry.RestoreKey(Key, FileName);
end;

function TEncryptedRegistry.SaveKey(const Key, FileName: string): Boolean;
begin
  Result := FRegistry.SaveKey(Key, FileName);
end;

function TEncryptedRegistry.UnLoadKey(const Key: string): Boolean;
begin
  Result := FRegistry.UnLoadKey(Key);
end;

function TEncryptedRegistry.ValueExists(const Name: string): Boolean;
begin
  Result := FRegistry.ValueExists(Name);
end;

end.
