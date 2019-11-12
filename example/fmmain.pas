unit fmmain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, IHookAgent,IHooKing64,SiMath, GUIStatus,
  Capstone,CapstoneApi,AddShell,siMathEnc;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Edit1: TEdit;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    gs:TGUIStatus;
  public
    { Public declarations }
    ihook:TIHooKing;
    agent:TIHookAgent;
    procedure test(i,j,k,l:Integer);
    procedure jmptest;

  end;

var
  Form1: TForm1;

implementation
var
  disasm: TCapstone;
  addr: UInt64;
  insn: TCsInsn;

const
  CODE =#$55#$48#$8b#$05#$b8#$13#$00#$00;

function getEIP:Cardinal;
asm
{$IFDEF WIN64}
  mov eax,512
  db $e8,$0,$0,$0,$0
  mov rax,[rsp];
  add rax,-5
{$ENDIF}
end;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  handle:csh;
  insn:pcs_insn;
  j,l:integer;
  count:integer;
  s:string;
  p:pointer;
begin
  //self.test(1,2,3,4);
{$IFDEF WIN32}
  if (cs_open(Ord(CS_ARCH_X86), CS_MODE_32, @handle) <> CS_ERR_OK) then
{$ENDIF}
{$IFDEF WIN64}
  if (cs_open(Ord(CS_ARCH_X86), CS_MODE_64, @handle) <> CS_ERR_OK) then
{$ENDIF}
     exit;
  l:=length(CODE);
  p:=@CODE[1];
  l:=512;
{$IFDEF WIN32}
  asm
    mov l,512
    db $e8,$0,$0,$0,$0
    pop p
  end;
{$ENDIF}
{$IFDEF WIN64}
  p:=Pointer(getEIP);
{$ENDIF}
  Memo1.Lines.Add(floatToStr(compilerversion));
  Memo1.Lines.Add(IntToStr(l));
  //pinsn:=@insn[0];
  count:=cs_disasm(handle, p, l, Cardinal(p), 0, insn);
  for j := 0 to count-1 do
  begin
    s:=format('%x  %s %s', [insn.address, insn.mnemonic,
       insn.op_str]);
    //注意cs_disasm传出的指针结构c的方式为：下个指针要增加数据结构的长度
    insn:=pcs_insn(Integer(insn)+sizeof(cs_insn));
    Memo1.LineS.add(s);
  end;
  MessageBox(0,'wwwww','ttttt',MB_OK);
end;

function msgbox(h:thandle;txt:PWChar;tt:PChar;mb:Cardinal):Integer;stdcall;
var
  i:NativeUInt;
  c:pchar;
begin
  i:=getResult;
  //i:=nativeuint(Form1.ihook.getReturnAddr);
  //i:=Form1.ihook.getCallerSP;
  result:=i;
  MessageBoxW(0,txt,tt,MB_YESNOCANCEL);
  //ShowMessage(txt);
  c:='0000000000000000000';
  mmovs(txt,c,Length(c));
  mb:=MB_YESNO;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  i:Integer;
  j:Cardinal;
  p:Pointer;
begin
  ihook:=TIHooKing.Create();
  ihook.init;
  //ihook.hookAddress(@TForm1.Button1Click,'Button1Click');
  //ihook.hookAddress(@TForm1.jmptest,'jmptest');
  p:=GetProcAddress(LoadLibrary('user32.dll'),'MessageBoxA');
  ihook.hookAddress(p,'MessageBoxA');
  p:=GetProcAddress(LoadLibrary('user32.dll'),'MessageBoxW');
  ihook.hookAddress(p,'MessageBoxW',true,nativeint(@msgbox),nativeint(@msgbox),-1,-1,0,0);  //nativeint(@msgbox)
  p:=GetProcAddress(LoadLibrary('user32.dll'),'FindWindowExA');
  ihook.hookAddress(p,'FindWindowExA',true,nativeint(@msgbox),nativeint(@msgbox),-1,-1,0,0);  //nativeint(@msgbox)
  //ihook.addNoHookSectionByHandle(GetModuleHandle(nil));
  {gvm.pushadCopy;
  for i:=0 to 7 do
  begin
    j:=popadRegistersBuff[i];
    Memo1.Lines.Add(IntToHex(j,8));
  end;}
  //ihook.processorep;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  i:integer;
  txt:array[0..255] of byte;
  c:pchar;
begin
  FillMemory(@txt,256,0);
  c:=PChar('txtWWWWWWWWWWWWWWWWWWWtxt');
  mmovs(@Txt,c,Length(c)*2);
  i:=MessageBoxW(0,@txt,'wwwwwwwwwwwwwwwwwwwwwwwwwwww',MB_OK);
  ShowMessage(IntToStr(i)+PChar(@txt));
end;

procedure TForm1.Button4Click(Sender: TObject);
type
  tp=procedure(a,b,c,d,e:Integer);stdcall;
var
  h:THandle;
  p:tp;
begin
  //h:=LoadLibrary('Win32Project3.dll');
  //p:=getprocaddress(h,PChar(1));
  //p:=getprocaddress(h,'_test4@20');
  //if Cardinal(@p)>0 then
  //  p(1,2,3,4,5);
  MessageBoxA(0,'AAAAAAAAAAAA','fklsjfj4234',MB_OK);
  //ghook.getcontextFromAddr(0);
  //gvm.stack[0]:=$12;
end;

procedure TForm1.Button5Click(Sender: TObject);
var
  sl:TStringList;
  h:thandle;
begin
  //ihook:=TIHooKing.Create;
  //ihook.init;
  //h:=LoadLibrary('user32.dll');
  //ihook.addNoHookSectionByHandle(h);
  agent:=TIHookAgent.Create();
  agent.loadConfig('config.txt');
  //loadlibrary('hooktest.dll');
end;

procedure TForm1.Button6Click(Sender: TObject);
var
  h:THandle;
  i:integer;
  ars:arString;
  pc,pc1:PAnsiChar;
  s:AnsiString;
begin
  pc:=#$42#$00#$00#$00#$48#$89#$4c#$24#$08#$48#$83#$ec#$38#$c6#$44#$24#$20#$4f#$c6#$44#$24#$21#$4b#$c6
    +#$44#$24#$22#$00#$b8#$08#$00#$00#$00#$48#$6b#$c0#$00#$45#$33#$c9#$4c#$8d#$44#$24#$20#$48#$8d#$54#$24#$20#$33
    +#$c9#$4c#$8b#$54#$24#$40#$41#$ff#$14#$02#$48#$83#$c4#$38#$c3;
  //s:=pc;
  SetLength(s,$42);
  mmovs(@s[1],pc,$42);
  Memo1.Lines.Add(strtoasc(s));
  pc1:=PAnsiChar(roundEncLoop(Pbyte(pc),$42,91024));
  mmovs(@s[1],pc1,$42);
  //s:=pc1;
  Memo1.Lines.Add(StrtoAscEx(s,',0x',0));
  pc1:=PAnsiChar(roundDecLoop(Pbyte(pc1),$42,91024));
  mmovs(@s[1],pc1,$42);
  Memo1.Lines.Add(strtoasc(s));
  //if ($Ea in [$E8,$E9,$EB,$74,$77,$72,$7F,$7C]) then //看是否有相对跳转
  //  ShowMessage('a');
  //FindWindowExA(0,0,0,0);
  //h:=LoadLibrary('monitor-x64.dll');
  //ars:=Split(',aaa',',');
  //i:=Length(ars);
  //h:=GetModuleHandle(nil);
  //ShowMessage(IntToStr(h));
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
  LoadLibrary(PChar(Edit1.Text));
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  gs.SaveToFile();
  gs.Free;
  //ihook.Free;
  //agent.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  h:thandle;
  i:Integer;
  s:string;
  cxt:THookContext;
begin
  gs:=TGUIStatus.Create(nil);
  gs.Add(Edit1);
  {}
  //ihook.addNoHookSectionByHandle(HInstance);
  //agent:=TIHookAgent.Create;
  //agent.loadConfig('config.txt');
  //s:='aa';
  //i:=Integer(@(THookContext(0).logFile));//SizeOf();
  //ShowMessage(IntToStr(i));
  //test(1,2,3,4);
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  gs.LoadFromFile();
end;

procedure TForm1.jmptest;
asm
  jmp TForm1.test
end;

procedure TForm1.test(i,j,k,l:Integer);
var
  s:string;
  s1,s2:string;
  ii:array of Integer;
  sl:TStringList;
begin
  s:='aaa';
  SetLength(ii,1);
  ii[0]:=$123;
  SetLength(ii,2);
  ii[1]:=$567;
  s1:='bbb';
  try
  s:=s+s1;
  except

  end;
  ShowMessage(s);
  chlocal;
end;

end.
