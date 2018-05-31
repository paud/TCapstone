unit fmmain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  IHooKing64,
  Capstone,CapstoneApi;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Edit1: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ihook:TIHooKing;
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
  //mov eax,512
  //db $e8,$0,$0,$0,$0
  //mov rax,[rsp];
  //add rax,-5
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
  if (cs_open(Ord(CS_ARCH_X86), CS_MODE_64, @handle) <> CS_ERR_OK) then
     exit;
  l:=length(CODE);
  p:=@CODE[1];
  l:=512;
  p:=Pointer(getEIP);
  {asm
    mov l,512
    db $e8,$0,$0,$0,$0
    pop p
  end; }
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
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  p:Pointer;
begin
  p:=GetProcAddress(LoadLibrary('user32.dll'),'MessageBoxA');
  ihook.hookAddress(p)
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  ihook:=TIHooKing.Create;
end;

procedure TForm1.test(i,j,k,l:Integer);
begin
  ShowMessage('a');
end;

end.
