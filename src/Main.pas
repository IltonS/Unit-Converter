unit Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Styles.Objects, FMX.Edit, FMX.ListBox,
  FMX.Memo.Types, FMX.ScrollBox, FMX.Memo, System.JSON, FMX.Platform.Android;

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
    MmConversor: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure CmbMedidasChange(Sender: TObject);
    procedure CmbUnidadeOrigemChange(Sender: TObject);
    procedure CmbUnidadeDestinoChange(Sender: TObject);
    procedure EdtUnidadeOrigemChange(Sender: TObject);
    procedure EdtUnidadeDestinoChange(Sender: TObject);
  private
    { Private declarations }
    ValorBase: double;
    Conversor: TJSONObject;
    Medidas: TJSONArray;
    Formulas: TJSONArray;

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

uses
  Androidapi.Helpers;

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
var
  I: Integer;
  Medida: TJSONObject;
begin
  for I:=0 to Medidas.Count-1 do
  begin
    Medida := Medidas.Items[I] as TJSONObject;
    CmbMedidas.Items.Add(Medida.GetValue('Medida').Value);
  end;
end;

procedure TFrmMain.CarregarListaUnidades;
var
  I,J: Integer;
  MedidaSelecionada: string;
  Medida, Formula: TJSONObject;
begin
  MedidaSelecionada := CmbMedidas.Items[CmbMedidas.ItemIndex];

  CmbUnidadeOrigem.Clear;
  CmbUnidadeDestino.Clear;

  for I:=0 to Medidas.Count-1 do
  begin
    Medida := Medidas.Items[I] as TJSONObject;

    if Medida.GetValue('Medida').Value = MedidaSelecionada then
    begin
      Formulas := Medida.GetValue('Formulas') as TJSONArray;

      for J:=0 to Formulas.Count-1 do
      begin
        Formula := Formulas.Items[J] as TJSONObject;

        CmbUnidadeOrigem.Items.Add(Formula.GetValue('Nome').Value);
        CmbUnidadeDestino.Items.Add(Formula.GetValue('Nome').Value);
      end;
    end;
  end;
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
const
  WordBlue = TAlphaColor($FF2B579A);
begin
  TAndroidHelper.Activity.getWindow.setStatusBarColor(TAlphaColorRec.ColorToRGB(WordBlue));

  Conversor := TJSONObject.ParseJSONValue(MmConversor.Lines.Text) as TJSONObject;
  Medidas := Conversor.GetValue('Medidas') as TJSONArray;

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
