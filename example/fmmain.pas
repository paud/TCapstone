unit fmmain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, IHookAgent,IHooKing64,SiMath,
  Capstone,CapstoneApi;

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
  private
    { Private declarations }
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

procedure TForm1.Button2Click(Sender: TObject);
var
  i:Integer;
  j:Cardinal;
  p:Pointer;
begin
  ihook:=TIHooKing.Create();
  ihook.init;
  //ihook.hookAddress(@TForm1.Button1Click,'Button1Click');
  ihook.hookAddress(@TForm1.jmptest,'jmptest');
  p:=GetProcAddress(LoadLibrary('user32.dll'),'MessageBoxA');
  ihook.hookAddress(p,'MessageBoxA');
  p:=GetProcAddress(LoadLibrary('user32.dll'),'MessageBoxW');
  ihook.hookAddress(p,'MessageBoxW',true);
  {gvm.pushadCopy;
  for i:=0 to 7 do
  begin
    j:=popadRegistersBuff[i];
    Memo1.Lines.Add(IntToHex(j,8));
  end;}
  //ihook.processorep;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  MessageBoxW(0,'WWWWWWWWWWWWWWWWWWW','wwwwwwwwwwwwwwwwwwwwwwwwwwww',MB_OK);

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
begin
  //h:=LoadLibrary('iHooking.dll');
  ars:=Split(',aaa',',');
  i:=Length(ars);
  ShowMessage(IntToStr(i));
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
  LoadLibrary(PChar(Edit1.Text));
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //ihook.Free;
  //agent.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  h:thandle;
  i:Integer;
  s:string;
begin
  {}
  //ihook.addNoHookSectionByHandle(HInstance);
  //agent:=TIHookAgent.Create;
  //agent.loadConfig('config.txt');
  //s:='aa';
  //i:=SizeOf(s);
  //ShowMessage(IntToStr(i));
  //test(1,2,3,4);
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
