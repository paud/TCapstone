unit fmmain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, IHookAgent,
  IHooKing64,  SimVBS,
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
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    ihook:TIHooKing;
    agent:TIHookAgent;
    procedure test(i,j,k,l:Integer);
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
  ihook.hookAddress(@TForm1.Button1Click,'Button1Click');
  p:=GetProcAddress(LoadLibrary('user32.dll'),'MessageBoxA');
  ihook.hookAddress(p,'MessageBoxA');
  p:=GetProcAddress(LoadLibrary('user32.dll'),'MessageBoxW');
  ihook.hookAddress(p,'MessageBoxW');
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
  MessageBoxW(0,'WWWWWWWWWWWWWWWWWWW','1',MB_OK);

end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  MessageBoxA(0,'AAAAAAAAAAAA','fklsjfj4234',MB_OK);
  //ghook.getcontextFromAddr(0);
  //gvm.stack[0]:=$12;
end;

procedure TForm1.Button5Click(Sender: TObject);
var
  sl:TStringList;
  vbs:TSimVBS;
begin
  agent.loadConfig('config.txt');
  {vbs:=TSimVBS.Create;
  vbs.loadScript('');
  vbs.pretreat;
  vbs.FScript.SaveToFile('e:\const.txt'); }
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ihook.Free;
  agent.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  h:thandle;
begin
  {}ihook:=TIHooKing.Create;
  ihook.init;
  h:=LoadLibrary('user32.dll');
  ihook.addNoHookSectionByHandle(h);
  //ihook.addNoHookSectionByHandle(HInstance);
  //agent:=TIHookAgent.Create;
  //agent.loadConfig('config.txt');
end;

procedure TForm1.test(i,j,k,l:Integer);
begin
  ShowMessage('a');
end;

end.
