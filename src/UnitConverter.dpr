program UnitConverter;

uses
  System.StartUpCopy,
  FMX.Forms,
  Main in 'Main.pas' {FrmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.Portrait];
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
