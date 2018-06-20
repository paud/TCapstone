library hooktest;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  windows,System.SysUtils,
  System.Classes;

{$R *.res}
var
  th:THandle;
  tcp:pchar;
  ttt:PChar;
  tstyle:integer;


function msgbox(h:THandle;cp:PChar;tt:PChar;style:integer):Integer; stdcall;
begin
  th:=h;
  tcp:=cp;
  ttt:=tt;
  tstyle:=style;
  result:=MessageBox(h,PChar('caption:'+cp),PChar('title:'+tt),style);
end;

function msgbox1(h:THandle;cp:PChar;tt:PChar;style:integer):Integer; stdcall;
begin
  result:=MessageBox(th,PChar('after caption:'+tcp),PChar('after title:'+ttt),tstyle);
  //MessageBox(0,PChar('after caption:'),PChar('after title:'),MB_OK);
end;

exports
  msgbox,msgbox1;

begin
  //MessageBox(0,PChar('after caption:'),PChar('after title:'),MB_OK);
end.
