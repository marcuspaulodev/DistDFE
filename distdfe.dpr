program distdfe;

uses
  Forms,
  principal in 'principal.pas' {frPrincipal},
  c_config in 'c_config.pas' {frconfig};

{$R *.res}

begin
  Application.Initialize;
  Application.ShowMainForm := false;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrPrincipal, frPrincipal);
  Application.Run;
end.
