program TestLibrary;

uses
  Vcl.Forms,
  umainform in 'umainform.pas' {mainform};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tmainform, mainform);
  Application.Run;
end.
