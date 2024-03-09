unit Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Styles.Objects, FMX.Edit, FMX.ListBox,
  FMX.Memo.Types, FMX.ScrollBox, FMX.Memo, System.JSON, FMX.Platform.Android,
  System.StrUtils;

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
    function StrToDouble(const AValue: string): double;
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
var
  Caption, Unidade: string;
  FormulaSelecionadaOrigem, FormulaSelecionadaDestino: string;
  I: Integer;
  Formula: TJSONObject;
begin
  Caption := EmptyStr;

  if Abs(StrToDouble(EdtUnidadeOrigem.Text)) < 0.00000001 then
    Caption := FormatFloat('0.0000E+00', StrToDouble(EdtUnidadeOrigem.Text)) + ' '
  else
    Caption := FormatFloat('0.########', StrToDouble(EdtUnidadeOrigem.Text)) + ' ';

  FormulaSelecionadaOrigem := CmbUnidadeOrigem.Items[CmbUnidadeOrigem.ItemIndex];
  for I:=0 to Formulas.Count-1 do
  begin
    Formula := Formulas.Items[I] as TJSONObject;

    if Formula.GetValue('Nome').Value = FormulaSelecionadaOrigem then
    begin
      if StrToDouble(EdtUnidadeOrigem.Text) = 1 then
        Caption := Caption + Formula.GetValue('Nome').Value + ' ='
      else
        Caption := Caption + Formula.GetValue('Plural').Value + ' =';

      Break;
    end;
  end;

  LblUnidadeOrigem.Text := Caption;

  Caption := EmptyStr;

  if Abs(StrToDouble(EdtUnidadeDestino.Text)) < 0.00000001 then
    Caption := FormatFloat('0.0000E+00', StrToDouble(EdtUnidadeDestino.Text)) + ' '
  else
    Caption := FormatFloat('0.########', StrToDouble(EdtUnidadeDestino.Text)) + ' ';

  FormulaSelecionadaDestino := CmbUnidadeDestino.Items[CmbUnidadeDestino.ItemIndex];
  for I:=0 to Formulas.Count-1 do
  begin
    Formula := Formulas.Items[I] as TJSONObject;

    if Formula.GetValue('Nome').Value = FormulaSelecionadaDestino then
    begin
      if StrToDouble(EdtUnidadeDestino.Text) = 1 then
        Caption := Caption + Formula.GetValue('Nome').Value
      else
        Caption := Caption + Formula.GetValue('Plural').Value;

      Break;
    end;
  end;

  LblUnidadeDestino.Text := Caption;
end;

procedure TFrmMain.CalcularUnidadeDestino;
var
  ValorOrigem, ValorDestino, ValorFormula, ValorBase: double;
  FormulaSelecionadaOrigem, FormulaSelecionadaDestino: string;
  I: Integer;
  Formula: TJSONObject;
begin
  ValorOrigem := StrToDouble(EdtUnidadeOrigem.Text);

  // Converter o valor origem para unidade base
  FormulaSelecionadaOrigem := CmbUnidadeOrigem.Items[CmbUnidadeOrigem.ItemIndex];
  for I:=0 to Formulas.Count-1 do
  begin
    Formula := Formulas.Items[I] as TJSONObject;

    if Formula.GetValue('Nome').Value = FormulaSelecionadaOrigem then
    begin
      ValorFormula := StrToDouble(Formula.GetValue('Formula').Value);
      ValorBase := ValorOrigem * ValorFormula;
      Break;
    end;
  end;

  // Converter o valor base para o destino
  FormulaSelecionadaDestino := CmbUnidadeDestino.Items[CmbUnidadeDestino.ItemIndex];
  for I:=0 to Formulas.Count-1 do
  begin
    Formula := Formulas.Items[I] as TJSONObject;

    if Formula.GetValue('Nome').Value = FormulaSelecionadaDestino then
    begin
      ValorFormula := StrToDouble(Formula.GetValue('Formula').Value);
      ValorDestino := ValorBase / ValorFormula;
      Break;
    end;
  end;

  // Atualizar Unidade de destino
  EdtUnidadeDestino.Tag := 1;

  if Abs(ValorDestino) < 0.00000001 then
    EdtUnidadeDestino.Text := FormatFloat('0.0000E+00', ValorDestino)
  else
    EdtUnidadeDestino.Text := FormatFloat('0.########', ValorDestino);

  EdtUnidadeDestino.Tag := 0;
end;

procedure TFrmMain.CalcularUnidadeOrigem;
var
  ValorOrigem, ValorDestino, ValorFormula, ValorBase: double;
  FormulaSelecionadaOrigem, FormulaSelecionadaDestino: string;
  I: Integer;
  Formula: TJSONObject;
begin
  ValorDestino := StrToDouble(EdtUnidadeDestino.Text);

  // Converter o valor destino para unidade base
  FormulaSelecionadaDestino := CmbUnidadeDestino.Items[CmbUnidadeDestino.ItemIndex];
  for I:=0 to Formulas.Count-1 do
  begin
    Formula := Formulas.Items[I] as TJSONObject;

    if Formula.GetValue('Nome').Value = FormulaSelecionadaDestino then
    begin
      ValorFormula := StrToDouble(Formula.GetValue('Formula').Value);
      ValorBase := ValorDestino * ValorFormula;
      Break;
    end;
  end;

  // Converter o valor base para a origem
  FormulaSelecionadaOrigem := CmbUnidadeOrigem.Items[CmbUnidadeOrigem.ItemIndex];
  for I:=0 to Formulas.Count-1 do
  begin
    Formula := Formulas.Items[I] as TJSONObject;

    if Formula.GetValue('Nome').Value = FormulaSelecionadaOrigem then
    begin
      ValorFormula := StrToDouble(Formula.GetValue('Formula').Value);
      ValorOrigem := ValorBase / ValorFormula;
      Break;
    end;
  end;

  // Atualizar Unidade de origem
  EdtUnidadeOrigem.Tag := 1;

  if Abs(ValorOrigem) < 0.00000001 then
    EdtUnidadeOrigem.Text := FormatFloat('0.0000E+00', ValorOrigem)
  else
    EdtUnidadeOrigem.Text := FormatFloat('0.########', ValorOrigem);

  EdtUnidadeOrigem.Tag := 0;
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

      Break;
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
begin
  TAndroidHelper.Activity.getWindow.setStatusBarColor(Integer(Header.TintColor));

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

function TFrmMain.StrToDouble(const AValue: string): double;
var
  FmtSettings: TFormatSettings;
  TempValue: string;
begin
  // Pega as configurações de formato
  FmtSettings := TFormatSettings.Create;

  // Substitui ponto e virgulas com o separador decimal apropriado
  TempValue := ReplaceStr(AValue, '.', FmtSettings.DecimalSeparator);
  TempValue := ReplaceStr(TempValue, ',', FmtSettings.DecimalSeparator);

  // converte para double e retorna
  if not TryStrToFloat(TempValue, Result, FmtSettings) then
    raise Exception.CreateFmt('Erro ao converter "%s" para um número.', [AValue]);
end;

end.
