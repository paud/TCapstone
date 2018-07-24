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
  LoadLibrary('inlinehookkingdll.dll');
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  //agent := TIHookAgent.Create();
  //agent.loadConfig('config.txt');
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
