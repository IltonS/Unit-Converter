unit Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Styles.Objects, FMX.Edit, FMX.ListBox;

type
  TFrmMain = class(TForm)
    Header: TToolBar;
    HeaderLabel: TLabel;
    CmbMedidas: TComboBox;
    EdtUnidadeOrigem: TEdit;
    CmbUnidadeOrigem: TComboBox;
    EdtUnidadeDestino: TEdit;
    CmbUnidadeDestino: TComboBox;
    LblBadgeFormula: TLabel;
    LblFormula: TLabel;
    LblUnidadeOrigem: TLabel;
    LblUnidadeDestino: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure CmbMedidasChange(Sender: TObject);
    procedure CmbUnidadeOrigemChange(Sender: TObject);
    procedure CmbUnidadeDestinoChange(Sender: TObject);
    procedure EdtUnidadeOrigemChange(Sender: TObject);
    procedure EdtUnidadeDestinoChange(Sender: TObject);
  private
    { Private declarations }
    ValorBase: double;

    procedure CarregarListaMedidas;
    procedure CarregarListaUnidades;
    procedure CalcularUnidadeDestino;
    procedure CalcularUnidadeOrigem;
    procedure AtualizarFormula;
    procedure AtualizarRelacao;
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.fmx}

{ TFrmMain }

procedure TFrmMain.AtualizarFormula;
begin
  //
end;

procedure TFrmMain.AtualizarRelacao;
begin
  //
end;

procedure TFrmMain.CalcularUnidadeDestino;
begin
  //
end;

procedure TFrmMain.CalcularUnidadeOrigem;
begin
  //
end;

procedure TFrmMain.CarregarListaMedidas;
begin
  //
end;

procedure TFrmMain.CarregarListaUnidades;
begin
  //
end;

procedure TFrmMain.CmbMedidasChange(Sender: TObject);
begin
  if CmbMedidas.Tag=0 then
  begin
    CmbUnidadeOrigem.Tag := 1;
    CmbUnidadeDestino.Tag := 1;

    CarregarListaUnidades;

    CmbUnidadeOrigem.ItemIndex := 0;
    CmbUnidadeDestino.ItemIndex := 1;

    CmbUnidadeOrigem.Tag := 0;
    CmbUnidadeDestino.Tag := 0;

    CalcularUnidadeDestino;
    AtualizarRelacao;
  end;
end;

procedure TFrmMain.CmbUnidadeDestinoChange(Sender: TObject);
begin
  if CmbUnidadeDestino.Tag=0 then
  begin
    CalcularUnidadeDestino;
    AtualizarFormula;
    AtualizarRelacao;
  end;
end;

procedure TFrmMain.CmbUnidadeOrigemChange(Sender: TObject);
begin
  if CmbUnidadeOrigem.Tag=0 then
  begin
    CalcularUnidadeDestino;
    AtualizarFormula;
    AtualizarRelacao;
  end;
end;

procedure TFrmMain.EdtUnidadeDestinoChange(Sender: TObject);
begin
  if EdtUnidadeDestino.Tag=0 then
  begin
    CalcularUnidadeOrigem;
    AtualizarRelacao;
  end;
end;

procedure TFrmMain.EdtUnidadeOrigemChange(Sender: TObject);
begin
  if EdtUnidadeOrigem.Tag=0 then
  begin
    CalcularUnidadeDestino;
    AtualizarRelacao;
  end;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  CmbMedidas.Tag := 1;
  CarregarListaMedidas;
  CmbMedidas.ItemIndex := 0;
  CmbMedidas.Tag := 0;

  CmbUnidadeOrigem.Tag := 1;
  CmbUnidadeDestino.Tag := 1;

  CarregarListaUnidades;

  CmbUnidadeOrigem.ItemIndex := 0;
  CmbUnidadeDestino.ItemIndex := 1;

  CmbUnidadeOrigem.Tag := 0;
  CmbUnidadeDestino.Tag := 0;

  EdtUnidadeOrigem.Tag := 1;
  EdtUnidadeOrigem.Text := '1';
  EdtUnidadeOrigem.Tag := 0;

  CalcularUnidadeDestino;
  AtualizarFormula;
  AtualizarRelacao;
end;

end.
