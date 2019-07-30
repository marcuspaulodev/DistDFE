unit principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Menus, c_config, inifiles, ZAbstractConnection, ZConnection,
  Grids, DBGrids, StdCtrls, DB, ZAbstractRODataset, ZDataset, ZSqlProcessor,
  ACBrBase, ACBrDFe, ACBrNFe, pcnconversaonfe, pcnconversao, funcoes;

type
  TfrPrincipal = class(TForm)
    TrayIcon1: TTrayIcon;
    PopupMenu1: TPopupMenu;
    Configuraes1: TMenuItem;
    Abrir1: TMenuItem;
    N1: TMenuItem;
    Sair1: TMenuItem;
    db0: TZConnection;
    DBGrid1: TDBGrid;
    Button1: TButton;
    qr1: TZReadOnlyQuery;
    z1: TZSQLProcessor;
    DataSource1: TDataSource;
    ACBrNFe1: TACBrNFe;
    qruf: TZReadOnlyQuery;
    qrnf: TZReadOnlyQuery;
    Timer1: TTimer;
    procedure TrayIcon1Click(Sender: TObject);
    procedure Sair1Click(Sender: TObject);
    procedure Abrir1Click(Sender: TObject);
    procedure Configuraes1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
    procedure Timer1Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    host, database, user, password : string;
    nrseriecertificado, senhacertificado,dtvenc : string;

    ufautor, cnpjautor, path_salvar : string;

    arqininame : string;
    arqini : TIniFile;
    estados : TStrings;
    flag : integer;

    function validaConfiguracoes(inifilename:string; inifile:TIniFile):boolean;
    procedure executarBusca;
    procedure confirmarOperacoes;
  end;

var
  frPrincipal: TfrPrincipal;

implementation

{$R *.dfm}

procedure TfrPrincipal.Abrir1Click(Sender: TObject);
begin
  frPrincipal.ShowModal;
end;

procedure TfrPrincipal.Button1Click(Sender: TObject);
begin
  confirmarOperacoes;
end;

procedure TfrPrincipal.Configuraes1Click(Sender: TObject);
begin

  arqininame := ChangeFileExt(paramstr(0), '.INI');

  frconfig := Tfrconfig.Create(Self);
  frconfig.carregarConfiguracoes(arqininame,arqini);
  frconfig.ShowModal;
  frconfig.Free;
end;

procedure TfrPrincipal.confirmarOperacoes;
begin
  ACBrNFe1.EventoNFe.Evento.Clear;
  with ACBrNFe1.EventoNFe.Evento.New do begin
    InfEvento.cOrgao := 91;
    InfEvento.chNFe := qrnf.FieldByName('nr_chave').AsString;
    InfEvento.CNPJ := qr1.FieldByName('nr_cgc').AsString;
    InfEvento.dhEvento := Now;
    InfEvento.tpEvento := teManifDestConfirmacao;
  end;

  ACBrNFe1.EnviarEvento(0);

  if ACBrNFe1.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0].RetInfEvento.cStat = 135 then begin
    showmessage('operacao confirmada');
  end;


end;

procedure TfrPrincipal.DataSource1DataChange(Sender: TObject; Field: TField);
begin
//  if qrnf.FieldByName('baixado').Asinteger = 0 then
//    Button1.Enabled := false
//  else
//    Button1.Enabled := true;

end;

procedure TfrPrincipal.executarBusca;
var
  i, qtdoc:integer;
  snbaixado : integer;
begin

    TrayIcon1.BalloonTitle := 'MONITOR DFE';
    TrayIcon1.BalloonFlags := bfInfo;
    TrayIcon1.BalloonHint  := 'Localizando Notas Fiscais';
    TrayIcon1.ShowBalloonHint;

    with qr1 do begin
      close;
        with sql do begin
          clear;
          add('select nr_serial, nr_senha, dt_certvenc, nm_uf, nr_cgc, path_consultas, nr_ultnsu, path_schemas from empresa where cd_loja = "001"');
        end;
      open;
    end;

    with qruf do begin
      close;
        with sql do begin
          clear;
          add('select cd_uf from cidades where nm_ufibge = "'+qr1.FieldByName('nm_uf').AsString+'"');
        end;
      open;
    end;

    ACBrNFe1.Configuracoes.Geral.ModeloDF := moNFe;
    ACBrNFe1.Configuracoes.Geral.VersaoDF := ve400;

    ACBrNFe1.Configuracoes.Arquivos.PathSalvar := qr1.FieldByName('path_consultas').asstring;
    acbrnfe1.Configuracoes.Arquivos.PathSchemas := qr1.FieldByName('path_schemas').AsString;
    ACBrNFe1.Configuracoes.Geral.Salvar := true;
    ACBrNFe1.Configuracoes.Arquivos.Salvar := true;
    ACBrNFe1.Configuracoes.Arquivos.SepararPorMes := true;
    acbrnfe1.Configuracoes.WebServices.Ambiente := taProducao;
    ACBrNFe1.Configuracoes.WebServices.UF := UpperCase(qr1.FieldByName('nm_uf').AsString);
    ACBrNFe1.Configuracoes.Certificados.NumeroSerie := qr1.FieldByName('nr_serial').AsString;
    ACBrNFe1.Configuracoes.Certificados.Senha := qr1.FieldByName('nr_senha').AsString;
    acbrnfe1.Configuracoes.Geral.Salvar := false;

    with z1 do begin
      with script do begin
        clear;
        add('drop temporary table if exists tmpdist;');
        add('create temporary table if not exists tmpdist(');
        add('id integer(11) auto_increment,');
        add('nr_doc varchar(9),');
        add('nr_modelo char(2),');
        add('sn_baixado tinyint(1),');
        add('nr_cpfcnpj varchar(14),');
        add('nm_forn varchar(255),');
        add('dt_emis datetime,');
        add('nr_chave varchar(44),');
        add('vl_nf decimal(10,2) default 0.00,');
        add('nr_protocolo varchar(50),');
        add('nr_nsu integer(11),');
        add('primary key(id)');
        add(');')
      end;
//      inputbox('','',script.Text);
      execute;
    end;

    ACBrNFe1.DistribuicaoDFePorUltNSU(qruf.fieldbyname('cd_uf').asinteger,qr1.FieldByName('nr_cgc').AsString,qr1.FieldByName('nr_ultnsu').AsString);


    z1.Script.Clear;

    for I := 0 to ACBrNFe1.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Count - 1 do begin

      snbaixado := -1;

      if(ACBrNFe1.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[i].schema = schresNFe)then
        snbaixado := 0;

      if (ACBrNFe1.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[i].schema = schprocNFe) then
        snbaixado := 1;


      if ((snbaixado = 0) or (snbaixado = 1))then begin

        z1.Script.Add('insert into tmpdist set');
        z1.Script.Add('sn_baixado = "'+inttostr(snbaixado)+'",');
        z1.Script.Add('nr_doc = "'+copy(ACBrNFe1.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[i].resDFe.chDFe,26,9)+'",');
        z1.Script.Add('nr_modelo = "'+copy(ACBrNFe1.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[i].resDFe.chDFe,21,2)+'",');
        z1.Script.Add('nr_cpfcnpj = "'+ACBrNFe1.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[i].resDFe.CNPJCPF+'",');
        z1.Script.Add('nm_forn = "'+ACBrNFe1.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[i].resDFe.xNome+'",');
        z1.Script.Add('dt_emis = "'+invertedata(ACBrNFe1.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[i].resDFe.dhEmi)+'",');
        z1.Script.Add('nr_chave = "'+ACBrNFe1.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[i].resDFe.chDFe+'",');
        z1.Script.Add('vl_nf  = "'+fmtPontoDecimal(Arredonda(ACBrNFe1.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[i].resDFe.vNF,2))+'",');
        z1.Script.Add('nr_protocolo = "'+ACBrNFe1.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[i].resDFe.nProt+'",');
        z1.Script.Add('nr_nsu = "'+ACBrNFe1.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[i].NSU+'";');
      end;
    end;
//    inputbox('','',z1.Script.Text);
    z1.Execute;

    with qrnf do begin
      close;
        with sql do begin
          clear;
          add('select');
          add('tmpdist.nr_doc,');
          add('tmpdist.nr_modelo,');
          add('tmpdist.dt_emis,');
          add('sum(tmpdist.sn_baixado) as baixado,');
          add('forn.cd_forn,');
          add('tmpdist.nr_cpfcnpj,');
          add('ifnull(forn.nm_forn,tmpdist.nr_cpfcnpj) as nm_forn,');
          add('tmpdist.nr_chave,');
          add('tmpdist.vl_nf,');
          add('tmpdist.nr_protocolo,');
          add('tmpdist.nr_nsu');
          add('from tmpdist');
          add('left join forn on forn.nr_cgc = tmpdist.nr_cpfcnpj');
          add('group by tmpdist.nr_doc, tmpdist.nr_cpfcnpj');
          add('having baixado = 0');
          add('order by tmpdist.dt_emis');
        end;
//        inputbox('','',qrnf.SQL.Text);
      open;
    end;

    TrayIcon1.BalloonTitle := 'MONITOR DFE';
    TrayIcon1.BalloonFlags := bfInfo;
    TrayIcon1.BalloonHint  := inttostr(qrnf.RecordCount)+' DOCUMENTOS DISPONIVEIS PARA DOWNLOAD';
    TrayIcon1.ShowBalloonHint;

end;

procedure TfrPrincipal.FormCreate(Sender: TObject);
begin

  estados := TStringList.Create;

  estados.add('AC');
  estados.add('AL');
  estados.add('AM');
  estados.add('AP');
  estados.add('BA');
  estados.add('CE');
  estados.add('DF');
  estados.add('ES');
  estados.add('GO');
  estados.add('MA');
  estados.add('MG');
  estados.add('MS');
  estados.add('MT');
  estados.add('PA');
  estados.add('PB');
  estados.add('PE');
  estados.add('PI');
  estados.add('PR');
  estados.add('RJ');
  estados.add('RN');
  estados.add('RO');
  estados.add('RR');
  estados.add('RS');
  estados.add('SC');
  estados.add('SE');
  estados.add('SP');
  estados.add('TO');
  estados.add('EX');

  arqininame := ChangeFileExt(paramstr(0), '.INI');

 if not validaConfiguracoes(arqininame,arqini) then begin

    if MessageDlg('ERRO DE CONEXÃO COM SERVIDOR',mtError,[mbOK],0) = mrOk then begin
      frconfig := Tfrconfig.Create(self);
      frconfig.carregarConfiguracoes(arqininame,arqini);
      frconfig.ShowModal;
      frconfig.Free;
    end;

 end
 else begin
    arqini := TIniFile.Create(arqininame);
    Timer1.Interval := arqini.ReadInteger('consultas','intervalo',60000);
    executarBusca;
 end;


end;

procedure TfrPrincipal.Sair1Click(Sender: TObject);
begin

  Application.Terminate;

end;

procedure TfrPrincipal.Timer1Timer(Sender: TObject);
begin
  executarBusca;
end;

procedure TfrPrincipal.TrayIcon1Click(Sender: TObject);
begin
  frPrincipal.ShowModal;
end;

function TfrPrincipal.validaConfiguracoes(inifilename: string;
  inifile: TIniFile): boolean;
begin

  inifile:= TIniFile.Create(inifilename);

  if not FileExists(inifilename) then
    result := false
  else begin
    if ((inifile.SectionExists('mysql'))) then begin

      host     := inifile.ReadString('mysql','host','localhost');
      database := inifile.ReadString('mysql','database','SAS');
      user     := inifile.ReadString('mysql','user','root');
      password := inifile.ReadString('mysql','password','');

      try
        db0.HostName  := host;
        db0.Password  := password;
        db0.User      := user;
        db0.Database  := database;
        db0.Connected := true;
        result := true;
      except
        result := false;
      end;

    end
    else
      result := false
  end;

  inifile.Free;

end;

end.
