program inlineHookKingTest;

uses
{$IFDEF WIN32}
  CheckMem,
{$ENDIF}
  Vcl.Forms,windows,IHookAgent,
  fmmain in 'fmmain.pas' {Form1};

{$R *.res}

var
 agent:TIHookAgent;

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  //LoadLibrary('inlineHookKingDll.dll');
  agent := TIHookAgent.Create();
  agent.loadConfig('config.txt');
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
