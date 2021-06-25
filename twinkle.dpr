program twinkle;

uses
  Vcl.Forms,
  login in 'login.pas' {loging},
  main in 'main\main.pas' {app};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tloging, loging);
  Application.CreateForm(Tapp, app);
  Application.Run;
end.
