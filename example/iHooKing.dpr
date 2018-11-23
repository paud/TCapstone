library iHooKing;

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
  System.SysUtils, IHookAgent, SiMath,
  System.Classes;

{$R *.res}

var
  agent:TIHookAgent;
  exePath:string;

begin
  agent:=tihookagent.Create('hooklog.txt');
  agent.FIHooKing.addNoHookSectionByHandle(HInstance);
  exePath:=GetExePath;
  exepath:=ExtractFileName(exePath);
  exepath:=GetLocal(exepath+'.cfg');
  if FileExists(exePath) then
  begin
    agent.loadConfig(exepath);
  end else
  begin
    agent.loadConfig('config.txt');
  end;
end.
