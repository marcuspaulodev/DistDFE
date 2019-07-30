unit c_config;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, RxToolEdit, Buttons, framebr, ACBrBase, ACBrDFe,
  ACBrNFe,acbrdfessl, IniFiles, funcoes, DB, ZAbstractRODataset, ZDataset,
  ZSqlProcessor;

type
  Tfrconfig = class(TForm)
    Conex�o: TGroupBox;
    Edit1: TEdit;
    HOST: TLabel;
    Edit2: TEdit;
    Label1: TLabel;
    Edit3: TEdit;
    Label2: TLabel;
    Edit4: TEdit;
    Label3: TLabel;
    Button1: TButton;
    frameOKCancel1: TframeOKCancel;
    ACBrNFe1: TACBrNFe;
    qr1: TZReadOnlyQuery;
    z1: TZSQLProcessor;
    GroupBox1: TGroupBox;
    Label4: TLabel;
    Edit5: TEdit;
//    procedure SpeedButton1Click(Sender: TObject);
    procedure frameOKCancel1BitBtn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    arquivoini : Tinifile;
    ininame : string;

    procedure carregarConfiguracoes(inifilename:string; inifile:TIniFile);
    procedure limpaCampos;
//    procedure habilitaCampos;
  end;

var
  frconfig: Tfrconfig;

implementation

{$R *.dfm}

 uses principal;

procedure Tfrconfig.Button1Click(Sender: TObject);
begin
  frPrincipal.db0.HostName := edit1.Text;
  frprincipal.db0.User     := edit2.Text;
  frprincipal.db0.Password := edit3.Text;
  frprincipal.db0.Database := edit4.Text;

  try
    frprincipal.db0.Connected := true;
 //   habilitaCampos;

//    with qr1 do begin
//      close;
//        with sql do begin
//          clear;
//          add('select nr_serial, nr_senha, dt_certvenc, nm_uf, nr_cgc, path_consultas, nr_ultnsu from empresa where cd_loja = "001"');
//        end;
//      open;
//    end;

//    edit5.Text := qr1.FieldByName('nr_serial').AsString;
//    edit6.Text := qr1.FieldByName('nr_senha').AsString;
//    DateEdit1.Date := qr1.FieldByName('dt_certvenc').AsDateTime;
//    ComboBox1.Text := qr1.FieldByName('nm_uf').AsString;
//    edit7.Text := qr1.FieldByName('nr_cgc').AsString;
//    DirectoryEdit1.Text := qr1.FieldByName('path_consultas').AsString;
//    edit8.Text := qr1.FieldByName('nr_ultnsu').AsString;

  except
    on e:exception do begin
      raise Exception.Create(e.Message);
    end;
  end;
end;

procedure Tfrconfig.carregarConfiguracoes(inifilename: string;
  inifile: TIniFile);
begin
  inifile := TIniFile.Create(inifilename);

  if not FileExists(inifilename) then begin
    FileCreate(inifilename);
    limpaCampos;
  end
  else begin

     if (inifile.SectionExists('mysql')) then begin

        edit1.Text := inifile.ReadString('mysql','host','localhost');
        edit2.Text := inifile.ReadString('mysql','user','root');
        edit3.Text := inifile.ReadString('mysql','password','');
        edit4.Text := inifile.ReadString('mysql','database','SAS');

     end;

     if (inifile.SectionExists('consultas')) then begin
       edit5.Text := inifile.ReadString('consultas','intervalo','10000');
     end;


  end;

  inifile.Free;

end;

procedure Tfrconfig.FormShow(Sender: TObject);
begin
//  if ComboBox1.Text = '' then
//    combobox1.Items.AddStrings(frprincipal.estados);
end;

procedure Tfrconfig.frameOKCancel1BitBtn1Click(Sender: TObject);
begin
  ininame := ChangeFileExt(paramstr(0), '.INI');

  arquivoini := TIniFile.Create(ininame);

  arquivoini.WriteString('mysql','host',edit1.Text);
  arquivoini.WriteString('mysql','user',edit2.Text);
  arquivoini.WriteString('mysql','password',edit3.Text);
  arquivoini.WriteString('mysql','database',edit4.Text);
  arquivoini.WriteString('consultas','intervalo',edit5.Text);

  arquivoini.Free;

end;

//procedure Tfrconfig.habilitaCampos;
//begin
//  SpeedButton1.Enabled   := true;
//  Edit6.Enabled          := true;
//  ComboBox1.Enabled      := true;
//  DirectoryEdit1.Enabled := true;
//  edit8.Enabled          := true;
//end;

procedure Tfrconfig.limpaCampos;
begin
  edit1.Clear;
  edit2.Clear;
  edit3.Clear;
  edit4.Clear;
//  edit5.Clear;
//  edit6.Clear;
//  DateEdit1.Date := 0;
//  ComboBox1.Text := '';
//  edit7.Clear;
//  DirectoryEdit1.Clear;
end;

//procedure Tfrconfig.SpeedButton1Click(Sender: TObject);
//begin
//  ACBrNFe1.Configuracoes.Geral.SSLLib := Tssllib(4);
//  edit5.Text := ACBrNFe1.SSL.SelecionarCertificado;
//  DateEdit1.Date := ACBrNFe1.SSL.DadosCertificado.DataVenc;
//  edit7.Text := ACBrNFe1.SSL.DadosCertificado.CNPJ;
//end;

end.
