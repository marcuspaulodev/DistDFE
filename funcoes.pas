unit Funcoes;

interface

uses Sysutils,DBTables,Dialogs,DB,RPDefine, RPBase, RPSystem,Winsock,Graphics,
     forms,Inifiles, ShellAPI, IdHashMessageDigest, idHash, controls, ZDataset,
     IdHTTP,wininet,zsqlprocessor,StrUtils;



procedure AjustaForm(f:TObject);
procedure MyFormResize(Sender:TObject);
procedure MudaReadOnly(DataSet:TDataSet;Flag:Boolean);
function Space(len:Integer):String;
Function StrZero(N:Longint;Len:Byte):String;
Function ZeroEsquerda(Numero:Real;Quant:integer;Caracter:string):String;
Function Subs(S:String;n1,n2:Byte):String;
Function Completa(s:String;Len:Byte):String;
function CalcDigito(cd:String):String;
Function CGC_OK(nrCGC : String) : Boolean;
Function CPF_OK(nrCPF : String) : Boolean;
Function GetCodigo(cd:String;t:ttable):String;
Function Encripta(s:String):String;
function Replicate(Str:Char;Len:Integer):String;
function TempFile(Extension:String) : String;
function CMONTH(nMes : Integer) : String;
procedure MyBeep;
procedure ValidaData(var Sender: TField);
function AjustaCodigo(codigo:String):String;
Function Extenso(Valor:Extended):String;
function Juros(ValorInicial:Extended;TaxaJuros:Extended;Vencimento:TDateTime):Extended;
function PADL(s:String; len:byte; c:char):String;
function PADR(s:String; len:byte; c:char):String;
Procedure Cab02(Report:TObject;nmEmpresa,Titulo:String);
Procedure Cab01(Report:TObject;nmEmpresa,Titulo:String;Usu:String;PathLogo:String);
procedure Cab01Bobina(Report:TObject;nmEmpresa,Titulo:String;Usu:String;PathLogo:String);
Procedure Cabx(Report:TObject;nmEmpresa,Titulo:String;Usu:String;PathLogo:String);
Procedure Cab03(Report:TObject; nmEmpresa,Titulo:String; data1,data2: TDateTime; Usu:String; PathLogo:String);
Procedure Foot01(Report:TBaseReport);
function  ConfirmaExclusao:boolean;
function FormataValor(v:extended):String;
function InverteDataTXT(dt:TDateTime):String;
function InverteData(dt:TDateTime):String;
function InverteDataStr(dt:String):variant;
function fmtPontoDecimal(v:extended):String;
function UltimoDia(mes:byte):TdateTime;
function UltimoDia2(ano:byte;mes:byte):TdateTime;
function FormataString(s:String):String;
function FormataTXT(s:String):String;
function CharToHex(c:char):byte;
function Arredonda(Valor: Real ; Decimais: Byte) : Extended;
function Trunca(Valor: Real ; Decimais: Byte) : Extended;
function GetIP:string;
Function Max(a, b: Extended): Extended;
Function ChecaIE(uf : string;ie : string) : boolean;
Function SubstitueCaracter(s:String):String;
Function SubstituePontoTracoBarra(s:String):String;
Function SubstitueBrancos(s:String):String;
Function IE_ok(sInscricao, sEstado: String): Boolean;
function ValidaCodigoNumerico(cd:string) : string;
function leinifileValor(InifileName,secao,item:String):String;
procedure gravainifile(Inifilename,secao,item,valor:string);
procedure ChamaPaginaInternet(www: String);
function MD5Texto(const Dados:String):String;
function VerificarAtualizacao(arq_sincro :string) :boolean;
function CaixaDialogo(sMens, sTipoMens :string) :boolean;
procedure CopiaExecutaInstalador(arq_sincro :string);
procedure qrLogAntes(qr1: TZQuery);
procedure tbLogAntes(tb1: TZTable);
procedure tbLogDepois(tb1: TZTable; usuario: String);
procedure qrLogDepois(qr1: TZQuery; usuario: String);
function NomeUF(UF: String):String;
function BuscaEndPorCep(CEP: String):String;
function CalculaTributos(vTotalItem : Double; NCM : String; servico : Boolean;
                          origem : Integer; ex : String; qr1: TZQuery) : Double;
function BuscaPorcentagem(vTotalItem : Double; NCM : String; servico : Boolean;
                         origem : Integer; ex : String; qr1: TZQuery) : Double;

function strDataVazia(s:String):boolean;

function truncarvalores(value:extended):extended;
procedure ValidaPISCOFINS(cstpis:string;cstcofins:string;basicapis:extended;basicacofins:extended;txpis:extended;txcofins:extended);
function ValidaPISCOFINS2(cstpis:string;cstcofins:string;basicapis:extended;basicacofins:extended;txpis:extended;txcofins:extended;cdprod:string='';crt:integer=2):boolean;
function VerificaConexaoWeb():boolean;
function IntToBoolean(numero:integer):boolean;
//procedure StartTransaction;
//procedure Commit;
//procedure Rollback;
//function DataServidor:Tdatetime;
//function horaServidor:TTime;
function Soletras(texto:string;tamanho:integer):boolean;
function PosicaoString(Busca, Text : string; qt : integer) : integer;
//procedure estoqueExists(cdprod, cdloja:string);
procedure gravarLog(nrdoc:string;modulo:string;acao:string;usuario:string;obs:string;dtlog:TDate;hrlog:TTime;dataset:TZSQLProcessor);
function retirarZeros( texto : string ): string;

implementation

Function ValidaCodigoNumerico(cd: string) : string;
var
i : integer;
s : string;
begin

   s := '';

   for i:=1 to length(cd) do begin

      if (cd[i] in ['0'..'9']) then
         s := s + cd[i];

   end;

   result := s;

end;

Function IE_ok(sInscricao, sEstado: String): Boolean;
Var iBaseFm, iBaseDV: ShortInt;
    iFormula, iFormulas: ShortInt;
    iDigito, iDigitoCalc, iDigitos, iDigitoVer, iDigitosVer, iDigitoPos: ShortInt;
    iPosicao, iPosicao2: ShortInt;
    iSoma: Integer;
    sProduto: string;
    iResto: ShortInt;
    iModulo: ShortInt;
    sModuloSubtrair: string;
    sInscr, sInscrBA: string;
    sPadrao, sPadrao9: string;
    sPeso, sPesos: string;
    lRetorno: Boolean;

Begin

  // PADRAO PARA ALGUNS ESTADOS
  sPadrao9 := '1-09-1/09-11-29-S';

  // VALOR PARA RETORNO
  lRetorno := True;

  try

    // TIRA EVENTUAIS CARACTERES NAO NUMERICOS
    sInscr := '';
    For iPosicao := 1 to Length(sInscricao) do
      if Pos(Copy(sInscricao,iPosicao,1),'0123456789') <> 0 then
        sInscr := sInscr + Copy(sInscricao,iPosicao,1);

    // SITUACOES ESPECIAIS -> 'BA'
    sInscrBA := sInscr;

                                   // ---------------------
                                   // PADRAO PARA O CALCULO
                                   // ---------------------
                                   // FOI ADOTADA A NOMENCLATURA HEXADECIMAL PARA OS PESOS
                                   // QUER DIZER QUE A=1O E B=11
                                   //
                                   //  +-> NUMERO DE FORMULAS DE CALCULO
                                   //  |  +-> NUMERO DE DIGITOS DA INSCRICAO ESTADUAL
                                   //  |  | +-> NUMERO DE DIGITOS VERIFICADORES
                                   //  |  | |  +-> POSICAO DO 1o DIGITO VERIFICADOR
                                   //  |  | |  |  +-> MODULO PARA O CALCULO DO 1o DIGITO VERIFICADOR
                                   //  |  | |  |  |  +-> PESOS PARA O 1o DIGITO, SE '00' DIFERENCIADO
                                   //  |  | |  |  |  | +-> SUBTRAIR RESTO DO MODULO S/N?
                                   //  |  | |  |  |  | |  +-> POSICAO DO 2 DIGITO VERIFICADOR
                                   //  |  | |  |  |  | |  |  +-> MODULO PARA CALCULO DO 2o DIGITO VERIFICADOR
                                   //  |  | |  |  |  | |  |  |  +-> PESOS PARA O 2o DIGITO, SE '00' DIFERENCIADO
                                   //  |  | |  |  |  | |  |  |  | +-> SUBTRAIR RESTO DO MODULO?
                                   //  |  | |  |  |  | |  |  |  | | +-> SEGUNDA FORMULA DE CALCULO
                                   //  |  | |  |  |  | |  |  |  | | |->
                                   // '1-12-1/12-12-12-A/12-12-12-A|1-12-1/12-12-12-1/12-12-12-1'
    if sEstado = 'AC' then sPadrao := '1-13-2/12-11-29-S/13-11-29-S';
    if sEstado = 'AL' then sPadrao := '1-09-1/09-11-29-N';
    if sEstado = 'AM' then sPadrao := sPadrao9;
    if sEstado = 'AP' then sPadrao := sPadrao9;
    if sEstado = 'BA' then sPadrao := '2-08-2/07-10-29-S/08-10-29-S|2-08-2/07-11-29-S/08-11-29-S';
    if sEstado = 'CE' then sPadrao := sPadrao9;
    if sEstado = 'DF' then sPadrao := '1-13-2/12-11-29-S/13-11-29-S';
    if sEstado = 'ES' then sPadrao := sPadrao9;
    if sEstado = 'GO' then sPadrao := sPadrao9;
    if sEstado = 'MA' then sPadrao := sPadrao9;
    if sEstado = 'MG' then sPadrao := '1-13-2/12-10-00-S/13-11-00-S';
    if sEstado = 'MS' then sPadrao := sPadrao9;
    if sEstado = 'MT' then sPadrao := '1-11-1/11-11-29-S';
    if sEstado = 'PA' then sPadrao := sPadrao9;
    if sEstado = 'PB' then sPadrao := sPadrao9;
    if sEstado = 'PE' then sPadrao := '1-14-1/14-11-00-S';
    if sEstado = 'PI' then sPadrao := sPadrao9;
    if sEstado = 'PR' then sPadrao := '1-10-2/09-11-27-S/10-11-27-S';
    if sEstado = 'RJ' then sPadrao := '1-08-1/08-11-27-S';
    if sEstado = 'RN' then sPadrao := '1-09-1/09-11-29-N';
    if sEstado = 'RO' then sPadrao := '2-09-1/09-11-00-S/  -  -  - |2-14-1/14-11-29-S';
    if sEstado = 'RR' then sPadrao := '1-09-1/09-09-81-N';
    if sEstado = 'RS' then sPadrao := '1-10-1/10-11-29-S';
    if sEstado = 'SC' then sPadrao := sPadrao9;
    if sEstado = 'SE' then sPadrao := sPadrao9;
    if sEstado = 'SP' then sPadrao := '1-12-2/09-11-00-N/12-11-00-N';
    if sEstado = 'TO' then sPadrao := '1-11-1/11-11-00-S';

    // NUMERO DE FORMULAS DE CALCULO
    iFormulas := StrToInt(Copy(sPadrao,1,1));

    // CONTROLE DAS FORMULAS DE CALCULO
    for iFormula := 1 to iFormulas do
    begin

      // VALOR PARA RETORNO
      lRetorno := True;

      // BASE PARA POSICIONAMENTO NA FORMULA
      iBaseFm := (iFormula-1)*29;

      // SITUACOES ESPECIAIS -> 'BA'
      if (sEstado = 'BA') then
      begin
        if Pos(Copy(sInscricao,1,1),'0123458') <> 0 then
          iBaseFm := 0
        else
          iBaseFm := 29;
      end;

      // SITUACOES ESPECIAIS -> 'RO'
      if (sEstado = 'RO') and (iFormula = 1) and (lRetorno = False) then
        lRetorno := True;

      // NUMERO DE DIGITOS NA INSCRICAO
      iDigitos := StrToInt(Copy(sPadrao,iBaseFm+3,2));

      // NUMERO DE DIGITOS VERIFICADORES
      iDigitosVer := StrToInt(Copy(sPadrao,iBaseFm+6,1));

      // DEIXA INSCRICAO COM NUMERO DE CARACTERES DEVIDOS
      sInscr := '00000000000000'+sInscr;
      sInscr := Copy(sInscr,(Length(sInscr)-iDigitos)+1,iDigitos);

      // CONTROLE DE DIGITOS VERIFICADORES
      for iDigitoVer := 1 to iDigitosVer do
      begin

        // BASE PARA POSICIONAMENTO NOS DADOS DO DIGITO VERIFICADOR
        if iDigitoVer = 1 then
          iBaseDV := 8
        else
          iBaseDV :=19;

        // POSICAO DO DIGITO VERIFICADOR
        iDigitoPos := StrToInt(Copy(sPadrao,iBaseFm+iBaseDV,2));
        // VALOR DO MODULO PARA CALCULO
        iModulo := StrToInt(Copy(sPadrao,iBaseFm+iBaseDV+3,2));
        // PESO PARA CALCULO
        sPeso := Copy(sPadrao,iBaseFm+iBaseDV+6,2);
        // FLAG DE SUBTRACAO DO RESTO PELO MODUTO
        sModuloSubtrair := Copy(sPadrao,iBaseFm+iBaseDV+9,1);

        // DEFINICAO DOS PESOS A SEREM UTILIZADOS
        if sPeso = '27' then
          sPesos := Copy('5432765432765432',18-iDigitoPos,iDigitoPos-1)
        else if sPeso = '29' then
          sPesos := Copy('9876543298765432',18-iDigitoPos,iDigitoPos-1)
        else if sPeso = '81' then
          sPesos := Copy('1234567812345678',18-iDigitoPos,iDigitoPos-1)
        else if (sPeso = '00') and (sEstado = 'MG') and (iDigitoVer = 1) then
          sPesos := '12112121212'
        else if (sPeso = '00') and (sEstado = 'MG') and (iDigitoVer = 2) then
          sPesos := '32BA98765432'
        else if (sPeso = '00') and (sEstado = 'PE') then
          sPesos := '5432198765432'
        else if (sPeso = '00') and (sEstado = 'RO') then
          sPesos := '00065432'
        else if (sPeso = '00') and (sEstado = 'SP') and (iDigitoVer = 1) then
          sPesos := '1345678A'
        else if (sPeso = '00') and (sEstado = 'SP') and (iDigitoVer = 2) then
          sPesos := '32A98765432'
        else if (sPeso = '00') and (sEstado = 'TO') then
          sPesos := '9800765432';

        // INICIANDO VARIAVEL DE SOMATORIO
        iSoma := 0;

        // SITUACOES ESPECIAIS -> 'AP'
        if sEstado = 'AP' then
        begin
          if (sInscr >= '03000001') and (sInscr <= '03017000') then
            iSoma := 5
          else if (sInscr >= '03017001') and (sInscr <= '03019022') then
            iSoma := 9;
        end;

        // SITUACOES ESPECIAIS -> 'BA'
        if (sEstado = 'BA') then
        begin
          // REALIZANDO CALCULO PARA O 1o ('2o') DIGITO VERIFICADOR
          if iDigitoVer = 1 then
            sInscr := Copy(sInscrBA,1,6) + Copy(sInscrBA,8,1)
          // REALIZANDO CALCULO PARA O 2o ('1o') DIGITO VERIFICADOR
          else
            sInscr := Copy(sInscrBA,1,6) + Copy(sInscrBA,8,1) + Copy(sInscrBA,7,1);
        end;

        // SOMATORIO DOS DIGITOS x OS PESOS
        for iPosicao := 1 to iDigitoPos - 1 do
        begin

          // SITUACOES ESPECIAIS - 'MG'
          if (sEstado = 'MG') and (iDigitoVer = 1) then
          begin
            sProduto := IntToStr(StrToInt(Copy(sInscr,iPosicao,1)) * StrToInt(Copy(sPesos,iPosicao,1)));
            for iPosicao2 := 1 to Length(sProduto) do
              iSoma := iSoma + StrToInt(Copy(sProduto,iPosicao2,1));
          end
          // DEMAIS ESTADOS...
          else
          begin
            // PESO NUMERICO?
            if Pos(Copy(sPesos,iPosicao,1),'0123456789') <> 0 then
              iSoma := iSoma + (StrToInt(Copy(sInscr,iPosicao,1)) * StrToInt(Copy(sPesos,iPosicao,1)))
            // PESO VALENDO A=1O?
            else if Copy(sPesos,iPosicao,1) = 'A' then
              iSoma := iSoma + (StrToInt(Copy(sInscr,iPosicao,1)) * 10)
            // PESO VALENDO B=11...
            else
              iSoma := iSoma + (StrToInt(Copy(sInscr,iPosicao,1)) * 11);
          end;

        end;

        // SITUACOES ESPECIAIS -> 'AL' e 'RN'
        if (sEstado = 'AL') or (sEstado = 'RN') then
          iSoma := iSoma * 10;

        // CALCULA O DIGITO VERIFICADOR
        iDigitoCalc := iSoma mod iModulo;

        // RETIRAR RESTO DO MODULO?
        if sModuloSubtrair = 'S' then
          iDigitoCalc := iModulo - iDigitoCalc;

        // SITUACOES ESPECIAIS -> 'AP'
        if (sEstado = 'AP') and (iDigitoCalc = 11) and (sInscr >= '03017001') and (sInscr <= '03019022') then
          iDigitoCalc := 1
        // SITUACOES ESPECIAIS -> 'GO'
        else if (sEstado = 'GO') and (iDigitoCalc = 10) and (sInscr >= '10103105') and (sInscr <= '10119997') then
          iDigitoCalc := 1
        // SITUACOES ESPECIAIS -> 'RO'
        else if (sEstado = 'RO') and (iDigitoCalc >= 10) then
          iDigitoCalc := iDigitoCalc - 10;

        // DIGITO CALCULADO >= 1O?
        if iDigitoCalc >= 10 then
          iDigitoCalc := 0;

        // DIGITO VERIFICADOR INCORRETO???
        if iDigitoCalc <> StrToInt(Copy(sInscr,iDigitoPos,1)) then
          lRetorno := False;

        // SITUACOES ESPECIAIS -> 'GO'
        if (sEstado = 'GO') and (sInscr = '11094402') and (Pos(Copy(sInscr,iDigitoPos,1),'01') <> 0) then
          lRetorno := True;

      end;

      // ATE AQUI DIGITO(S) CORRETO(S)?, VERIFICA ALGUMAS SITUACOES ESPECIAIS
      if lRetorno then
      begin

        // SITUACOES ESPECIAIS -> 'AL'
        if (sEstado = 'AL') and ((Copy(sInscr,1,2) <> '24') or (Pos(Copy(sInscr,3,1),'03578') = 0)) or
        // SITUACOES ESPECIAIS -> 'AP'
        (sEstado = 'AP') and (Copy(sInscr,1,2) <> '03') or
        // SITUACOES ESPECIAIS -> 'DF'
        (sEstado = 'DF') and (Copy(sInscr,1,2) <> '07') or
        // SITUACOES ESPECIAIS -> 'MA'
        (sEstado = 'MA') and (Copy(sInscr,1,2) <> '12') or
        // SITUACOES ESPECIAIS -> 'MS'
        (sEstado = 'MS') and (Copy(sInscr,1,2) <> '28') or
        // SITUACOES ESPECIAIS -> 'PA'
        (sEstado = 'PA') and (Copy(sInscr,1,2) <> '15') or
        // SITUACOES ESPECIAIS -> 'RR'
        (sEstado = 'RR') and (Copy(sInscr,1,2) <> '24') then
        // SITUACOES ESPECIAIS -> 'SP'
//        (sEstado = 'SP') and (Copy(sInscricao,1,1) <> 'P') then
          lRetorno := False;
      end;

      // SITUACOES ESPECIAIS -> 'RO'
      if (sEstado = 'RO') and (iFormula = 1) and lRetorno then
        Break;

    end;

  Except on EConvertError do
    lRetorno := False;

  end;

  // NAO SEI PORQUE NAO ESTA DANDO CERTO, ENTAO, VAI TODOS TRU

  lRetorno := True;
  
  // RESULTADO DO CALCULO
  Result := lRetorno;

end;


function SubstitueCaracter(s:String):String;
var i : integer;
c:String;
begin
  c := '';
  for i := 1 to length(s) do begin
    case s[i] of
      '(' : c := c + ' ';
      ')' : c := c + ' ';
      'á' : c := c + 'a';
      'é' : c := c + 'e';
      'i' : c := c + 'i';
      'ó' : c := c + 'o';
      'ú' : c := c + 'u';
      'Á' : c := c + 'A';
      'É' : c := c + 'E';
      'Í' : c := c + 'I';
      'Ó' : c := c + 'O';
      'Ú' : c := c + 'U';
      'ç' : c := c + 'c';
      'Ç' : c := c + 'C';
      'ã' : c := c + 'a';
      'õ' : c := c + 'o';
      'Ã' : c := c + 'A';
      'Õ' : c := c + 'O';
      '"' : c := c + '';
      '\' : c := c + '';
    else
        c := c + s[i];
    end;
  end;
  result := c;
end;

function SubstituePontoTracoBarra(s:String):String;
var i : integer;
c:String;
begin
  c := '';
  for i := 1 to length(s) do begin
    case s[i] of
      '(' : c := c + ' ';
      ')' : c := c + ' ';
      'á' : c := c + 'a';
      'é' : c := c + 'e';
      'i' : c := c + 'i';
      'ó' : c := c + 'o';
      'ú' : c := c + 'u';
      'Á' : c := c + 'A';
      'É' : c := c + 'E';
      'Í' : c := c + 'I';
      'Ó' : c := c + 'O';
      'Ú' : c := c + 'U';
      'ç' : c := c + 'c';
      'Ç' : c := c + 'C';
      '€' : C := C + 'C';
      'ã' : c := c + 'a';
      'õ' : c := c + 'o';
      'Ã' : c := c + 'A';
      'Õ' : c := c + 'O';
      '.' : c := c + '';
      ',' : c := c + '';
      '-' : c := c + '';
      '"' : c := c + 'p';
      '&' : c := c + 'e';
//      '/' : c := c + '';
//      '\' : c := c + '';
    else
        c := c + s[i];
    end;
  end;
  result := c;
end;

function SubstitueBrancos(s:String):String;
var i : integer;
c:String;
begin
  c := '';
  for i := 1 to length(s) do begin
    case s[i] of
      ' ' : c := c + '';
    else
        c := c + s[i];
    end;
  end;
  result := c;
end;

function checaie(uf, ie: string): boolean;
Const
  //Define Peso1 e peso2 com os pesos para o calculo do
  //1o. digito e 2o. Digito
  Peso1 : array[1..8] of Integer = (1,3,4,5,6,7,8,10);
  Peso2 : array[1..11] of Integer = (3,2,10,9,8,7,6,5,4,3,2);
Var
  tmp,soma,dig1,dig2 : Integer;
  FimIE : String;
begin
  Soma := 0;
  tmp  := 0;  //Zera todas as variaveis
  dig1 := 0;
  dig2 := 0;
  FimIE := '';

  If upperCase(uf) = 'SP' Then
  Begin

    //Vamos achar o valor do 1o. digito
    for tmp := 1 to 8 do
      Soma := Soma + ( StrToInt(ie[tmp]) * Peso1[tmp]);

    Dig1 := Soma mod 11;  //Grava o resto da divisão de soma por 11
    if (Dig1 >= 10) Then
      Dig1 := 0;

    //faz a junção dos 8 primeiros numeros com o digito encontrado,
    //apartir desse ponto acharemos o segundo digito.

    FimIE := Copy(Ie,1,8) + IntToStr(Dig1) +  Copy(Ie,10,2);

    Soma := 0;

    For tmp := 1 To 11 Do
      Soma := Soma + ( StrToInt( FimIE[tmp] ) * Peso2[tmp] );

    Dig2 := Soma mod 11;

    If Dig2 >= 10 Then
      Dig2 := 0;

    //Faz a junção do 2o. digito
    FimIE := FimIE + Inttostr(Dig2);

    If FimIE = IE Then
      Result := True
    else
      Result := False;

  End;
end;

function Max(A, B: Extended): Extended;
{Compara dois valores Retornando o maior deles}
begin
  if A > B then
    Result := A
  else
    Result := B;
end;

Function StrZero(N:Longint;Len:Byte):String;
Var S : String;
  L : Integer;
  I : Byte;
begin
  S := IntToStr(N);
  L := Length(S);
  if (L < Len) Then L := Len - L  Else L := 0;
  For I := 1 to L do
    S := '0' + S;
  Result := S;
end;

Function Subs(S:String;n1,n2:Byte):String;
var n : Byte;
begin
  n := Length(s);

  if n1 > n Then n1 := n
  Else if n1 <= 0 Then n1 := 1;

  n := n - n1 + 1;

  if ( (n2 > n) or (n2 <= 0) )   Then n2 := n;

  Result := Copy(s,n1,n2);

end;


Function Completa(S:String;Len:Byte):String;
Var
  L : Integer;
  I : Byte;
  s1:String;
begin
  s1:=s;
  L := Length(s1);
  if (L < Len) Then L := Len - L  Else L := 0;
  For I := 1 to L do
    S1 := '0' + S1;
  Result := S1;
end;

function ConfirmaExclusao:boolean;
begin
  if (MessageDlg('Confirma Exclusao?',mtConfirmation, [mbYes, mbNo], 0)=6) then
  result := true else result := false;
end;

function CalcDigito(cd:String):String;
var
  i,len : byte;
  flag : boolean;
  soma,digito : integer;
begin
  soma := 0;
  flag := true;
  len := length(cd);


  for i := 1 to len do begin
    digito := strtoint(Copy(cd,i,1));
    if flag then
      soma := soma + digito * 1
    else
      soma := soma + digito * 3;
    flag := not flag;
  end;

  if (soma mod 10) = 0 then
    result := '0'
  else begin
    digito := 1 + (soma div 10);
    digito := 10 * digito - soma;
    result := inttostr(digito);
  end;

end;

function GetCodigo(cd:String;t:ttable):String;
var x :String;
begin

  x := Completa(cd,13); //DUN14
  //x := cd;
  if (not t.findkey([x])) then begin
    x := Completa(cd,12);// DUN14
    //x := cd;
    x := x + CalcDigito(x);
  end;

  result := x;

end;

Function Encripta(s:String):String;
var i:integer;
x:string;
begin

  x := s;
  for i := 1 to length(s) do begin
    x[i] := chr(ord(x[i]) xor 255);
  end;
  result := x;
end;

procedure MudaReadOnly(DataSet:TDataSet;Flag:Boolean);
var i:Integer;
begin
  For i := 0 to DataSet.FieldCount -1 do
    if not Dataset.Fields[i].Calculated Then
      DataSet.Fields[i].ReadOnly := Flag;
end;

{Funcao Repl(Char,Len)
  Exemplo : MyString := Repl('-',30)
}
function Replicate(Str:Char;Len:Integer):String;
Var MyString : AnsiString;
begin
  FillChar(MyString,SizeOf(MyString),Str);
  MyString := chr(Len);
  Result := Copy(MyString,1,Len);
end;

function CMONTH(nMes : Integer) : String;
begin
  Case nMes of
    1 : Result := 'Janeiro';
    2 : Result := 'Fevereiro';
    3 : Result := 'Marco';
    4 : Result := 'Abril';
    5 : Result := 'Maio';
    6 : Result := 'Junho';
    7 : Result := 'Julho';
    8 : Result := 'Agosto';
    9 : Result := 'Setembro';
    10: Result := 'Outubro';
    11: Result := 'Novembro';
    12: Result := 'Dezembro';
  end;
end;

function TempFile(Extension:String) : String;
Var MyString : String;
begin
  Randomize;
  MyString := '';
  While Length(MyString) < 15 do
    MyString := MyString + IntToStr(Random(MAXINT));
  Result := Copy(MyString,1,8);
end;

procedure MyBeep;
begin
{  doBleep(2000,50);
  doBleep(1000,50);
  doBleep(500,50);
}
end;

procedure ValidaData(var Sender: TField);
VAR
  Ano,Mes,Dia : Word;
//  novaData : TDateTime;
begin

  DecodeDate((Sender as TField).asDateTime,Ano,Mes,Dia);
  if (Ano > 2050) Then begin
    Ano := Ano - 100;
    (Sender as Tfield).asDateTime := EncodeDate(Ano,mes,dia);
  end;

{
// ESTE TRECHO FUNCIONA MELHOR COM DELPHI1
  if (Ano < 1950) Then begin
    Ano := Ano + 100;
    (Sender as Tfield).asDateTime := EncodeDate(Ano,mes,dia);
  end;
 }

end;


FUNCTION CGC_OK(Nrcgc : String) : Boolean;
Var d1,d2,resto,i,cnt,Tam,Dig1 : Integer;
    digito : String;
    CGCDIG:String;
begin
  nrcgc := trim(nrcgc);
  
  d1 := 0; d2 := 0; cnt := 1;
  Tam := Length(nrCGC) - 2;
  CGCDig := Copy(NrCGC,Tam+1,2);

  for i := 1 to Tam do begin
    if (Copy(Nrcgc,i,1)>='0') and (Copy(NrCGC,i,1) <= '9') Then begin

       if (cnt < 5) Then
         d1 := d1 + StrToInt(Copy(Nrcgc,i,1)) * (6 - cnt)
       else
         d1 := d1 + StrToInt(Copy(Nrcgc,i,1)) * (14 - cnt);

       if (cnt < 6) Then
          d2 := d2 + StrToInt(Copy(Nrcgc,i,1)) * (7 - cnt)
       Else
          d2 := d2 + StrToInt(Copy(Nrcgc,i,1)) * (15 - cnt);

       cnt := cnt + 1;
    end;
  end;

  resto  := d1 mod 11;

  if (Resto < 2) Then
    Dig1 := 0
  Else
    Dig1 := 11 - Resto;

  d2  := d2 + 2*dig1;

  Resto := d2 Mod 11;

  digito := IntToStr(dig1);

  if (Resto < 2) Then
    Digito := Digito + '0'
  Else
    Digito := Digito + IntToStr(11 - Resto);

  If (Digito = CGCDig) Then
    CGC_OK := True
  Else
    CGC_OK := False;
end;


FUNCTION CPF_OK(Nrcpf : String) : Boolean;
Var
  Tam,d1,d2,resto,i,cnt,Dig1 : Integer;
  digito,CPFDig : String;
Begin
  nrcpf := trim(nrcpf);
  d1:=0; d2:=0; cnt := 1;
  Tam := Length(NrCPF) - 2;
  CPFDig := Copy(nrCPF,Tam+1,2);

  for i := 1 to Tam do begin
    if (Copy(Nrcpf,i,1)>='0') and (Copy(NrCPF,i,1) <= '9') Then begin
       d1 := d1 + StrToInt(Copy(Nrcpf,i,1)) * (11 - cnt);
       d2 := d2 + StrToInt(Copy(Nrcpf,i,1)) * (12 - cnt);
       cnt := cnt + 1;
    end;
  end;
  resto  := d1 Mod  11;

  if (Resto < 2) Then
    Dig1 := 0
  Else
    Dig1 := 11 - Resto;

  d2 := d2 + 2*dig1;

  resto  := d2 Mod  11;

  digito := IntToStr(dig1);

  if (Resto < 2) Then
    Digito := Digito + '0'
  Else
    Digito := Digito + IntToStr(11 - Resto);

  If (Digito = CPFDig) Then
    CPF_OK := True
  Else
    CPF_OK := False;

end;


function Ajustacodigo(codigo:String):String;

{var cd : String;
flag:Boolean;
DIG1,DIG2:STRING;
c1,c2 : string;
}

begin

//  if (not ean) then begin
    if (length(codigo)>13) then
      result := copy(codigo,1,13)// DUN14
      //result := codigo
    else result := completa(codigo,13);// DUN14
    //else result := codigo;
{  end
  else begin
    cd := codigo;
    if (cd <> '') then begin
      c1 := completa(cd,13);
      c2 := cd;
      Delete(c2,length(c2),1);
      if (length(c2) = 0) then
        c2 := cd;

      c2 := completa(c2,12);

      c2 := c2+Calcdigito(c2);

      if (c1 <> c2) then begin
        c2 := Completa(cd,12);
        c2 := c2 + calcdigito(c2);
        cd := c2;
      end
      else
        cd := c1;

      codigo := cd;
    end;
    result := codigo;
  end;
}
end;


Function Extenso(Valor:Extended):String;
type
  Palavra = String[12];
  Numero = array[1..9] of Palavra;
  Milhares = array[1..3] of Palavra;
  Centenas = array[1..2] of Palavra;
Const
  Unidade : Numero = ('Um','Dois','Tres','Quatro','Cinco',
                      'Seis','Sete','Oito','Nove');
  Dezena0 : Numero = ('Dez','Vinte','Trinta','Quarenta','Cinquenta',
                      'Sessenta','Setenta','Oitenta','Noventa');
  Dezena1 : Numero = ('Onze','Doze','Treze','Catorze','Quinze',
                      'Desesseis','Desessete','Dezoito','Dezenove');
  Centena : Numero = ('Cento','Duzentos','Trezentos','Quatrocentos',
                      'Quinhentos','Seiscentos','Setecentos','Oitocentos',
                      'Novecentos');
  Milhar : Milhares = ('Mil','Milhão','Milhões');
  Cents : Centenas = ('Centavo','Centavos');
type
  Digitos = 1..9;
var
  cExtenso : String;
  cNum : String[12];
  cVar : String[3];
  v,vMilhao,vMilhar,vCentena,vCentavo : Longint;
  i,nMax,Code : Integer;
//  cDigito:String[1];
  vDig1,vDig2,vDig3:Digitos;

begin
  Str(Valor:12:2,cNum);
  Val(Copy(cNum,1,3),vMilhao,Code);
  Val(Copy(cNum,4,3),vMilhar,Code);
  Val(Copy(cNum,7,3),vCentena,Code);
  Val(Copy(cNum,11,2),vCentavo,Code);
  nMax := 4;
  cExtenso := '';
  For i := 1 to nMax do
  begin
    cVar := Copy(cNum,3*i-2,3);
    if pos('.',cVar) > 0 then
      cVar := '0'+ Copy(cVar,2,2);
    Val(cVar,v,Code);

    if v > 0 then
    begin
      Val(Copy(cVar,1,1),vDig1,Code);
      Val(Copy(cVar,2,1),vDig2,Code);
      Val(Copy(cVar,3,1),vDig3,Code);
      if vDig1 > 0 then
        if (vDig1 = 1) and (vDig2 = 0) and (vDig3 = 0) then
          cExtenso := cExtenso + 'Cem'
        else
          begin
            cExtenso := cExtenso + ' '+Centena[vDig1];
            if (vDig2>0) or (vDig3 > 0) then
              cExtenso := cExtenso + ' e ';
          end;
      if vDig2 > 0 then
        if vDig2 = 1 then
          if vDig3 > 0 then
            cExtenso := cExtenso + ' '+Dezena1[vDig3]
          else
          begin
              cExtenso := cExtenso + ' '+Dezena0[vDig2];
              if vDig3 > 0 then
                cExtenso := cExtenso + ' e';
          end
        else
        begin
           cExtenso := cExtenso + ' '+Dezena0[vDig2];
           if vDig3 > 0 then
             cExtenso := cExtenso + ' e';
        end;
        if (vDig3 > 0) and (vDig2 <> 1) then
        begin
           cExtenso := cExtenso + ' '+ Unidade[vDig3];
        end;
    end;
    if i <= 2 then
    begin
      Case i of
        1:  begin
              if v > 0 then
              begin
                if v = 1 then
                  cExtenso := cExtenso + ' Milhão'
                else
                  cExtenso := cExtenso + ' Milhões';
                if (vMilhar <> 0) or (vCentena <> 0) then
                  cExtenso := cExtenso + ' e';
              end;
            end;
        2:  begin
              if v > 0 then
              begin
                cExtenso := cExtenso + ' Mil';
                if (vCentena<>0) then
                  cExtenso := cExtenso + ' e';
              end;
            end;
      end;
    end;
    if i = 3 then
    begin
      if vMilhao > 0 then
      begin
        if (vMilhar = 0) and (vCentena = 0) then
          cExtenso := cExtenso + ' de Reais'
        else
          cExtenso := cExtenso + ' Reais';
      end
      else
        if vMilhar > 0 then
          cExtenso := cExtenso + ' Reais'
        else
          if vCentena > 0 then
            if vCentena = 1 then
              cExtenso := cExtenso + ' Real'
            else
              cExtenso := cExtenso + ' Reais';
      if (vMilhao > 0) or (vMilhar > 0) or (vCentena > 0) then
         if vCentavo <> 0 then
           cExtenso := cExtenso + ' e';
    end;
    if i = 4 then
    begin
      if v > 0 then
        if v = 1 then
        begin
          if (vMilhao <> 0) or (vMilhar <> 0) or (vCentena <> 0) then
            cExtenso := cExtenso + ' ' + Cents[1]
          else
            cExtenso := cExtenso + ' ' + Cents[1];
        end
        Else
          cExtenso := cExtenso + ' ' + Cents[2];
    end;
  end;
  result := cExtenso;
end;

function Juros(ValorInicial:Extended;TaxaJuros:Extended;Vencimento:TDateTime):Extended;
var qtDias  : Integer;
    vlJuros : Extended;
begin

  qtDias  := trunc(date - Vencimento);
  vlJuros := 0;
  if (qtDias > 0) then begin
    vlJuros := (qtDias * TaxaJuros / 30.0);
    vlJuros := vlJuros / 100.0;
    vlJuros := vlJuros * ValorInicial;
    vlJuros := strtofloat(FloatToStrF(vlJuros,ffFixed,15,2));
  end;
  result := vlJuros;

end;

{**********************************************************************
Function PADL - Preenche a string com caracteres a esquerda.
***********************************************************************}
function PADL(s:String;len:byte;c:char):String;
var dif,i : byte;
begin
  dif := len - length(s);
  for i := 1 to dif do
    s := c + s;
  result := s;
end;

{**********************************************************************
Function PADR - Preenche a string com caracteres a direita.
***********************************************************************}
function PADR(s:String;len:byte;c:char):String;
var i   :byte;
    dif : integer;
    x : String;
begin
  x := s;
  if (length(x)>len) then
    x := copy(s,1,len);

  dif := len - length(x);

//  if (dif < 0) then
//    x := copy(s,1,len);

  for i := 1 to dif do
    x := x + c;
  result := x;

end;








Procedure Cab02(Report:TObject;nmEmpresa,Titulo:String);
Begin
  With Report as TBaseReport do begin
     SaveFont(1);
     SetFont('courier new',9);
//     SetFont('arial',8);
     AdjustLine;
//     MoveTo(MarginLeft,YPos);
//     LineTo(PageWidth - MarginRight - MarginLeft,YPos);
//     NewLine;
     PrintLeft(nmEmpresa,MarginLeft);
     PrintRight('HORA: '+TimeToStr(Time)+' - DATA: '+DateToStr(date),PageWidth - MarginRight - MarginLeft);
     NewLine;
     PrintLeft(Titulo,MarginLeft);
     PrintRight('Pag. '+IntToStr(CurrentPage),PageWidth - MarginRight - MarginLeft);
     MoveTo(MarginLeft,YPos+0.2);
     LineTo(PageWidth - MarginRight - MarginLeft,YPos+0.2);
     NewLine;
     NewLine;
     RestoreFont(1);
     AdjustLine;
  end;
end;



Procedure Cab01(Report:TObject;nmEmpresa,Titulo:String;Usu:String;pathlogo:string);
var
Cl : integer;
Logo: TBitmap;
Begin

  With Report as TBaseReport do begin

     cl := 0;
     if (pathlogo<>'') then begin
        logo := TBitmap.Create;
        try
           logo.LoadFromFile(pathlogo);
           PrintBitmapRect(0.3,0.3,2.0,0.8,logo);
           cl := 2;
        except
           cl := 0;
           logo.Free;
        end;
     end;

     AdjustLine;
     SetFont('Arial',7);
     Bold := True;
     PrintRight('Lemarq Software 84-3316-3070',PageWidth - MarginRight - MarginLeft);
     Bold := False;
     SetFont('Arial',8);
     NewLine;

     SetFont('courier new',9);
     PrintLeft(nmEmpresa,MarginLeft+cl+0.3);

     SetFont('courier new',8);
     PrintRight('Data/Hora '+DateToStr(date)+' '+TimeToStr(Time),PageWidth - MarginRight - MarginLeft);
     NewLine;

     SetFont('courier new',9);
     PrintLeft(Titulo,MarginLeft+cl+0.3);

     SetFont('courier new',8);
     PrintRight('Usuario '+usu+' Pag. '+IntToStr(CurrentPage),PageWidth - MarginRight - MarginLeft);

     MoveTo(MarginLeft,YPos+0.2);
     LineTo(PageWidth - MarginRight - MarginLeft,YPos+0.2);

     NewLine;
     NewLine;
     NewLine;

  end;

end;


Procedure Cabx(Report:TObject;nmEmpresa,Titulo:String;Usu:String;pathlogo:string);
var
Cl : extended;
Logo: TBitmap;
Begin

  With Report as TBaseReport do begin

     cl := 0;
     if (pathlogo<>'') then begin
        logo := TBitmap.Create;
        try
           logo.LoadFromFile(pathlogo);
//           PrintBitmapRect(0.6,0.3,4.0,2.0,logo);
           PrintBitmapRect(0.6,0.3,2.0,1.0,logo);
           logo.Free;
           cl := 2.5;
        except
           cl := 0;
           logo.Free;
        end;
     end;

     SaveFont(1);
     AdjustLine;
     NewLine;

     SetFont('courier new',9);
     PrintLeft(nmEmpresa,MarginLeft+cl);

     SetFont('courier new',8);
     PrintRight('Data/Hora: '+DateToStr(date)+' '+TimeToStr(Time),PageWidth - MarginRight - MarginLeft+0.2);
     NewLine;

     SetFont('courier new',9);
     PrintLeft(Subs(Titulo,1,50),MarginLeft+4.0);
     newline;
     PrintLeft(Subs(Titulo,51,50),MarginLeft+cl);
     //newline;

     SetFont('courier new',8);
     PrintRight('Usuario '+usu+' - Pag. '+IntToStr(CurrentPage),PageWidth - MarginRight - MarginLeft+0.2);

     MoveTo(MarginLeft,YPos+0.2);
     LineTo(PageWidth - MarginRight - MarginLeft,YPos+0.2);

     NewLine;
     NewLine;
//     NewLine;

     RestoreFont(1);
     AdjustLine;

  end;

end;


Procedure Foot01(Report:TBaseReport);
Begin
  With Report do begin
     GotoXY(MarginLeft,PageHeight - MarginBottom - 2.0);
     PrintRight('_______________',PageWidth - MarginRight - 1.0);
     NewLine;
{     GotoXY(MarginLeft,PageHeight - MarginBottom - 0.5);}
     PrintRight('PAGINA : ' +
     IntToStr(CurrentPage),PageWidth - MarginRight - 1.0);
  end;
end;

function FormataValor(v:extended):String;
begin
  if (v = 0) then result := ''
  else result := formatFloat('#,##0.00',v);
end;



function InverteDataTXT(dt:TDateTime):String;
var ano,mes,dia:word;
s:String;
begin

  decodedate(dt,ano,mes,dia);
  s := StrZero(ano,4)+StrZero(mes,2)+StrZero(dia,2);
  result := s;

end;

function InverteData(dt:TDateTime):String;
var ano,mes,dia:word;
s:String;
begin

  decodedate(dt,ano,mes,dia);
  {s := inttostr(ano)+'-'+inttostr(mes)+'-'+inttostr(dia);}
  s:= formatdatetime('yyyy-mm-dd',dt);
  result := s;

end;

function InverteDataStr(dt:String):variant;
var d:TDateTime;
s:variant;
begin

  if (dt<>'') then begin
    try
      d := strtodate(dt);
      s := InverteData(d);
    except
      s := 0;
    end;
  end
  else s := 0;

  result := s;

end;

function fmtPontoDecimal(v:extended):string;
var
s : String;
begin

  s := format('%18.6f',[v]);
  s[12] := '.';
  result := trimleft(s);

end;

function Space(len:Integer):String;
var s:String;
i:integer;
begin
  s := '';
  for i := 1 to len do s:=s+' ';
  result := s;
end;

function UltimoDia(mes:byte):Tdatetime;
var a,m,d:word;
dt : Tdatetime;
begin
  decodedate(now,a,m,d);
  dt := encodedate(a,mes,1);
  dt := dt + 31;
  decodedate(dt,a,m,d);
  dt := dt - d;
  result := dt;
end;

function UltimoDia2(ano:byte;mes:byte):Tdatetime;
var a,m,d:word;
dt : Tdatetime;
begin
  decodedate(ano,a,m,d);
  dt := encodedate(a,mes,1);
  dt := dt + 31;
  decodedate(dt,a,m,d);
  dt := dt - d;
  result := dt;
end;

function FormataString(s:String):String;
var i : integer;
c:String;
begin
  c := '';
  for i := 1 to length(s) do begin
    case s[i] of
      #13,
      #10,
      #9: begin
          end;
      else
        c := c + s[i];
    end;
  end;
  result := c;
end;

function CharToHex(c:char):byte;
begin
  case c of
    '0'..'9' : result := ord(c) - ord('0');
    'A'..'F' : result := (ord(c) - ord('A'))+10;
    'a'..'f' : result := (ord(c) - ord('a'))+10;
  end;
end;

function Arredonda(Valor : Real ; Decimais : Byte) : Extended;
var
i : Byte;
ML : string;
RR : string;
begin
  ML := '0.';
  for i := 1 To Decimais do begin
     ML := ML + '0';
  end;
  RR := FormatFloat(ML,Valor);
  Result := StrToFloat (RR);
end;

function Trunca(Valor : Real ; Decimais : Byte) : Extended;
var
X : Extended;
begin
   // ValorReal := 135.54658;

   { Somente a parte inteira - nenhuma casa decimal }
   if Decimais=0 then
      X := Trunc(Valor); // X será 135

   { Uma casa decimal }
   if Decimais=1 then
      X := Trunc(Valor * 10); // X será 135.5

   { Duas casas }
   if Decimais=2 then
      X := Trunc(Valor * 100) / 100; // X será 135.54

   { Três casas }
   if Decimais=3 then
      X := Trunc(Valor * 1000) / 1000; // X será 135.5465

   Result := X;
end;


function GetIP:string;     // Declare a Winsock na clausula uses da unit
var
WSAData: TWSAData;
HostEnt: PHostEnt;
Name:AnsiString;
begin
  WSAStartup(2, WSAData);
  SetLength(Name, 255);
  Gethostname(PAnsiChar(Name), 255);
  SetLength(Name, StrLen(PAnsiChar(Name)));
  HostEnt := gethostbyname(PAnsiChar(Name));
  with HostEnt^ do
  begin
  Result := Format('%d.%d.%d.%d',[Byte(h_addr^[0]),Byte(h_addr^[1]),Byte(h_addr^[2]),Byte(h_addr^[3])]);
  end;
  WSACleanup;
end;




function ZeroEsquerda(Numero:Real;Quant:integer;Caracter:string):String;
var I, Tamanho: Integer;
aux, Texto: String;
begin
  Texto    := Trim(FormatFloat('#,##0.00',Numero));     //2.40
  aux      := Texto;
  Tamanho  := length(Texto);                //4
  Texto    :='';

  for I:=1 to (quant-tamanho) do
      Texto:=Texto + Caracter;

  aux    := Texto + aux;
  Result := aux;
end;



function FormataTXT(s:String):String;
var i : integer;
c:String;
begin
  c := '';
  for i := 1 to length(s) do begin
    case s[i] of
      '(' : c := c + ' ';
      ')' : c := c + ' ';
    else
        c := c + s[i];
    end;
  end;
  result := c;
end;

procedure AjustaForm(f:TObject);
begin


  if (Screen.Height<=600) and (Screen.Width<=800) then begin
       (f as TForm).WindowState := wsMaximized;
   //    (f as TForm).OnResize := funcoes.MyFormResize;
   end;


   if (Screen.Height>600) and (Screen.Width>800) then begin
      (f as Tform).borderstyle := bsdialog;
      (f as TForm).WindowState := wsNormal;
      (f as TForm).Position := poScreenCenter;
      (f as TForm).OnResize := nil;
   end;


end;


procedure Myformresize(Sender:TObject);
begin
 if (Screen.Height<=600) and (Screen.Width<=800) then begin
       (Sender as TForm).WindowState := wsMaximized;
 end;
end;


function leinifileValor(InifileName,secao,item:String):String;
var s:String;
  FInifile : Tinifile;
begin
  Finifile := Tinifile.create( inifilename );
  s := Finifile.readstring(secao,item,'');
  Finifile.free;
  result := s;
end;

Procedure Cab03(Report:TObject; nmEmpresa,Titulo:String; data1,data2: TDateTime; Usu:String; PathLogo:String);
var
Cl : integer;
Logo: TBitmap;
Begin

  With Report as TBaseReport do begin

     cl := 0;
     if (pathlogo<>'') then begin
        logo := TBitmap.Create;
        try
           logo.LoadFromFile(pathlogo);
           PrintBitmapRect(0.3,0.3,2.0,0.8,logo);
           cl := 2;
        except
           cl := 0;
           logo.Free;
        end;
     end;

     AdjustLine;
     SetFont('Arial',7);
     Bold := True;
     PrintRight('Lemarq Software 84.3316-3070',PageWidth - MarginRight - MarginLeft);
     Bold := False;
     SetFont('Arial',8);
     NewLine;

     SetFont('courier new',9);
     PrintLeft(nmEmpresa,MarginLeft+cl);

     SetFont('courier new',8);
     PrintRight('Data/Hora '+DateToStr(date)+' '+TimeToStr(Time),PageWidth - MarginRight - MarginLeft);
     NewLine;

     SetFont('courier new',9);
     PrintLeft(Titulo,MarginLeft+cl);
     NewLine;

     SetFont('courier new',9);
     PrintLeft('PERIODO '+DateToStr(data1)+' a '+DateToStr(data2),MarginLeft+cl);

     SetFont('courier new',8);
     PrintRight('Usuario '+usu+' Pag. '+IntToStr(CurrentPage),PageWidth - MarginRight - MarginLeft);

     MoveTo(MarginLeft,YPos+0.2);
     LineTo(PageWidth - MarginRight - MarginLeft,YPos+0.2);

     NewLine;
     NewLine;
     NewLine;

  end;

end;
procedure gravainifile(Inifilename,secao,item,valor:string);
var
Inifile:TInifile;
begin
    Inifile:=Tinifile.Create(Inifilename);
    Inifile.WriteString(secao,item,valor);
    Inifile.Free;
end;

procedure ChamaPaginaInternet(www: String);
var
buffer: String;
begin
    buffer:= 'http://'+www;
    ShellExecute(Application.Handle, nil, PChar(buffer), nil, nil, 1);
                                                                 //1 = SW_ShowNormal
end;

function MD5Texto(const Dados:String):String;
var
idmd5 : TIdHashMessageDigest5;
begin
 idmd5 := TIdHashMessageDigest5.Create;
 try
   //result := idmd5.AsHex(idmd5.HashValue(dados)); //HashStreamAsHex(fs);
   Result:=idmd5.HashStringAsHex(Dados);
 finally
   idmd5.Free;
 end;
end;


function VerificarAtualizacao(arq_sincro :string) :boolean;
var
  SR: TSearchRec;
  I: integer;
  ArqOrigem, ArqDestino: string;
  dtorigem, dtdestino :TDateTime;
  cont :integer;
  ArqSincro : Tinifile;
  sPathOrigem, sPathDestino :string;
  ExisteDiferenca :boolean;
begin
  ExisteDiferenca :=false;
  ArqSincro := TInifile.create(arq_sincro);
  sPathOrigem := ArqSincro.readstring('lemarqsincro', 'origem', '');
  sPathDestino:= ArqSincro.readstring('lemarqsincro', 'destino', '');
  ArqSincro.free;

  if DirectoryExists(sPathOrigem)=False then
  begin
    caixadialogo('Não foi possível acessar o caminho de sincronização.'+#13+'Favor verificar o arquivo c:\sas\sas.ini'+#13+#13+'Impossível continuar!','E');
    Application.Terminate;
  end
  else
  begin

    //-- verificando a quantidade de arquivos na ORIGEM
    I := FindFirst(sPathOrigem + '\sas_install.exe', faAnyFile, SR);
    cont := 0;
    while I = 0 do
    begin
      cont := cont+1;
      I := FindNext(SR);
    end;
    //--

    //-- aponto para o primeiro registro (ORIGEM)
    I := FindFirst( sPathOrigem +'\sas_install.exe', faAnyFile, SR);

    //-- efetua um laço em todos os arquivos da ORIGEM e compara se são diferente no DESTINO
    for i :=1 to cont do
    begin
      if (SR.Attr and faDirectory) <> faDirectory then
      begin
        ArqOrigem  := sPathOrigem  + '\' + SR.Name;
        ArqDestino := sPathDestino + '\' + SR.Name;

        if FileExists(ArqOrigem) then
          DtOrigem  := FileDateToDateTime(FileAge(ArqOrigem));

        if FileExists(ArqDestino) then
          DtDestino := FileDateToDateTime(FileAge(ArqDestino))
        else
          DtDestino := now;

        if (DtOrigem <> DtDestino) then
          ExisteDiferenca := true;
      end;

      FindNext(SR);
    end;

    Result := ExisteDiferenca;

  end;

end;

function CaixaDialogo(sMens, sTipoMens :string) :boolean;
//--  CODIGO	TIPO		    BOTOES
//--  16	    ERRO 		    OK
//--  36	    PERGUNTA 	  SIM OU NAO
//--  48	    CUIDADO		  OK
//--  64	    INFORMACAO  OK - CERTO
var
  sTitulo :String;
begin
  Result :=False;
  sTipoMens :=UpperCase(sTipoMens);
  //-- se tipo mensagem = Pergunta
  if sTipoMens ='E' then
  begin
    sTipoMens :='16';
    sTitulo :='Atenção(ERRO)';
  end
  else if sTipoMens ='P' then
  begin
    sTipoMens :='36';
    sTitulo :='Atenção(PERGUNTA)';
  end
  else if sTipoMens ='C' then
  begin
    sTipoMens :='48';
    sTitulo :='Atenção(CUIDADO)';
  end
  else if sTipoMens ='I' then
  begin
    sTipoMens :='64';
    sTitulo :='Atenção(INFORMAÇÃO)';
  end;

  if application.messagebox(PChar(sMens),PChar(sTitulo), StrToInt(sTipoMens))=mrYes then
    Result :=True
  else
    Result :=False;
end;


procedure CopiaExecutaInstalador(arq_sincro :string);
var
  Dados: TSHFileOpStruct;
  ArqSincro : Tinifile;
  sPathOrigem, sPathDestino :string;
begin

  ArqSincro := TInifile.create(arq_sincro);
  sPathOrigem := ArqSincro.readstring('lemarqsincro', 'origem', '');
  sPathDestino:= ArqSincro.readstring('lemarqsincro', 'destino', '');
  ArqSincro.free;


  DeleteFile(sPathDestino+'\sas_install.exe');

  FillChar(Dados,SizeOf(Dados), 0);
  with Dados do
  begin
    wFunc := FO_COPY;
    pFrom := PChar(sPathOrigem+'\sas_install.exe');
    pTo   := PChar(sPathDestino);
    fFlags:= FOF_ALLOWUNDO;
  end;
  SHFileOperation(Dados);

end;

//procedure AdicionaLog(Linha: String);
//var
//  Handle: TextFile;
//begin
//  try
//    AssignFile(Handle, ChangeFileExt(ParamStr(0),'.log') );
//    if not FileExists( ChangeFileExt(ParamStr(0),'.log') ) then
//      Rewrite(Handle);
//    Append(Handle);
//    WriteLn(Handle, Linha);
//  finally
//    CloseFile(Handle);
//  end;
//end;



procedure qrLogAntes(qr1: TZQuery);
Var
  i : Integer;
  Antes : TextFile;
begin
  AssignFile(Antes, 'C:\Windows\SysLMS-Antes.log');
  ReWrite(Antes);
  For i := 0 to qr1.Fields.Count-1 do begin
    WriteLN(Antes, TRIM(qr1.Fields[i].AsString));
  end;
  CloseFile(Antes);
end;

procedure tbLogAntes(tb1: TZTable);
Var
  i : Integer;
  Antes : TextFile;
begin
  AssignFile(Antes, 'C:\Windows\SysLMS-Antes.log');
  ReWrite(Antes);
  For i := 0 to tb1.Fields.Count-1 do begin
    WriteLN(Antes, TRIM(tb1.Fields[i].AsString));
  end;
  CloseFile(Antes);
end;


procedure tbLogDepois(tb1: TZTable; usuario: String);
Var i : Integer;
  Antes, Log : TextFile;
  S : String;
  Primeiro : Boolean;
  cAntes, cLog: String; //-- Caminho dos Logs
begin
  cAntes:= 'C:\Windows\SysLMS-Antes.log';
  cLog  := 'C:\Windows\SysLMS.log';

  Primeiro := True;

  AssignFile(Log, cLog);
  If FileExists(cLog) then
    Append(Log)
  else
    ReWrite(Log);

  AssignFile(Antes, cAntes);
  If FileExists(cAntes) then
    Reset(Antes);


  For i := 0 to tb1.Fields.Count-1 do begin
    S:= '';
    try
      Readln(Antes, S);
    except
      S:= '';
    end;


    If (S <> TRIM(tb1.Fields[i].AsString)) and (trim(S) <> '') then
    begin
      If Primeiro then
      begin
        If tb1.State = dsEdit then
        begin
          WriteLN(Log, '');
          WriteLN(Log, FormatDateTime('dd/mm/yyyy hh:nn:ss', Now) + ' | Usuário..: ' + Usuario + ' | Tabela..: ' + tb1.name + ' | Alteração de registro');
        end
        else
        begin
          WriteLN(Log, '');
          WriteLN(Log, FormatDateTime('dd/mm/yyyy hh:nn:ss', Now) + ' | Usuário..: ' + Usuario + ' | Tabela..: ' + tb1.name + ' | Inclusão de registro');
        end;
        Primeiro := False;
      end;

      WriteLN(Log, ' Campo..: ' + tb1.Fields[i].FieldName + ' | De..: ' + S + ' | Para..: ' + tb1.Fields[i].AsString);
    end;
  end;

  If FileExists(cAntes) then
    CloseFile(Antes);

  FileSetAttr(cLog,2);
  CloseFile(Log);
  DeleteFile(cAntes);
end;

procedure qrLogDepois(qr1: TZQuery; usuario: String);
Var i : Integer;
  Antes, Log : TextFile;
  S : String;
  Primeiro : Boolean;
  cAntes, cLog: String; //-- Caminho dos Logs
begin
  cAntes:= 'C:\Windows\SysLMS-Antes.log';
  cLog  := 'C:\Windows\SysLMS.log';

  Primeiro := True;

  AssignFile(Log, cLog);
  If FileExists(cLog) then
    Append(Log)
  else
    ReWrite(Log);

  AssignFile(Antes, cAntes);
  If FileExists(cAntes) then
    Reset(Antes);


  For i := 0 to qr1.Fields.Count-1 do begin
    S:= '';
    try
      Readln(Antes, S);
    except
      S:= '';
    end;


    If (S <> TRIM(qr1.Fields[i].AsString)) and (trim(S) <> '') then
    begin
      If Primeiro then
      begin
        If qr1.State = DsEdit then
        begin
          WriteLN(Log, '');
          WriteLN(Log, FormatDateTime('dd/mm/yyyy hh:nn:ss', Now) + ' | Usuário..: ' + Usuario + ' | Tabela..: ' + qr1.name + ' | Alteração de registro');
        end
        else
        begin
          WriteLN(Log, '');
          WriteLN(Log, FormatDateTime('dd/mm/yyyy hh:nn:ss', Now) + ' | Usuário..: ' + Usuario + ' | Tabela..: ' + qr1.name + ' | Inclusão de registro');
        end;
        Primeiro := False;
      end;

      WriteLN(Log, ' Campo..: ' + qr1.Fields[i].FieldName + ' | De..: ' + S + ' | Para..: ' + qr1.Fields[i].AsString);
    end;
  end;

  If FileExists(cAntes) then
    CloseFile(Antes);


  FileSetAttr(cLog,2);
  CloseFile(Log);
  DeleteFile(cAntes);
end;


function NomeUF(UF: String):String;
begin
  if UF = 'AC' then Result := 'Acre';
  if UF = 'AL' then Result := 'Alagoas';
  if UF = 'AM' then Result := 'Amazonas';
  if UF = 'AP' then Result := 'Amapá';
  if UF = 'BA' then Result := 'Bahia';
  if UF = 'CE' then Result := 'Ceará';
  if UF = 'DF' then Result := 'Distrito Federal';
  if UF = 'ES' then Result := 'Espírito Santo';
  if UF = 'GO' then Result := 'Goiás';
  if UF = 'MA' then Result := 'Maranhão';
  if UF = 'MG' then Result := 'Minas Gerais';
  if UF = 'MS' then Result := 'Mato Grosso do Sul';
  if UF = 'MT' then Result := 'Mato Grosso';
  if UF = 'PA' then Result := 'Pará';
  if UF = 'PB' then Result := 'Paraíba';
  if UF = 'PE' then Result := 'Pernambuco';
  if UF = 'PI' then Result := 'Piauí';
  if UF = 'PR' then Result := 'Paraná';
  if UF = 'RJ' then Result := 'Rio de Janeiro';
  if UF = 'RN' then Result := 'Rio Grande do Norte';
  if UF = 'RO' then Result := 'Rondônia';
  if UF = 'RR' then Result := 'Roraima';
  if UF = 'RS' then Result := 'Rio Grande do Sul';
  if UF = 'SC' then Result := 'Santa Catarina';
  if UF = 'SE' then Result := 'Sergipe';
  if UF = 'SP' then Result := 'São Paulo';
  if UF = 'TO' then Result := 'Tocantins';
end;

function BuscaEndPorCep(CEP: String):String;
var
  url: String;
  http: TIdHTTP;
  r: String;
begin
  http:= TIdHTTP.Create(nil);
  url:= leinifileValor(ChangeFileExt(ParamStr(0),'.INI'),'GERAL','url');
  url:= StringReplace(url,'NUMCEP',CEP,[rfIgnoreCase]);
  r:= stringreplace(http.URL.URLDecode(http.Get(url)),'&',#13#10,[rfreplaceAll]);
  result:= r;
end;

function CalculaTributos(vTotalItem : Double; NCM : String; servico : Boolean;
                         origem : Integer; ex : String; qr1: TZQuery) : Double;
var
  vTributos : Double;
begin

  try
    with qr1 do
      begin
        SQL.Clear;
        SQL.Add('select coalesce(aliq_nac,0) AS aliq_nac,');
        SQL.Add('coalesce(aliq_imp,0) AS aliq_imp');
        SQL.Add('from ibpt where ncm = '+quotedstr(NCM));
        SQL.Add('AND excecao = '+quotedstr(ex));
        if servico then
          SQL.Add('and tabela = '+quotedstr('1')+';')
        else
          SQL.Add('and tabela = '+quotedstr('0')+';');
        Open;
        First;
      end;

      if qr1.RecordCount > 0 then
      begin
        case origem of
          0 :
            vTributos := Trunca((vTotalItem * qr1['aliq_nac']) / 100, 2);
          else
            vTributos := Trunca((vTotalItem * qr1['aliq_imp']) / 100, 2);
        end;
      end;

    Result := vTributos;
  except
    Result := 0;
  end;


end;

function BuscaPorcentagem(vTotalItem : Double; NCM : String; servico : Boolean;
                         origem : Integer; ex : String; qr1: TZQuery) : Double;
var
  vTributos : Double;
begin

  try
    with qr1 do
      begin
        SQL.Clear;
        SQL.Add('select coalesce(aliq_nac,0) AS aliq_nac,');
        SQL.Add('coalesce(aliq_imp,0) AS aliq_imp');
        SQL.Add('from ibpt where ncm = '+quotedstr(NCM));
        SQL.Add('AND excecao = '+quotedstr(ex));
        if servico then
          SQL.Add('and tabela = '+quotedstr('1')+';')
        else
          SQL.Add('and tabela = '+quotedstr('0')+';');
        Open;
        First;
      end;

      if qr1.RecordCount > 0 then
      begin
        case origem of
          0 :
            vTributos := qr1['aliq_nac'];
          else
            vTributos := qr1['aliq_imp'];
        end;
      end;

    Result := vTributos;
  except
    Result := 0;
  end;


end;

function strDataVazia(s:String):boolean;
begin
  result := (pos(' ',s)>0);
end;

function truncarvalores(value: extended): extended;
var
  p : integer;
  s, inteiro, decimal : string;
begin

  p := 0;
  s := FloatToStr(value);

  while(p < Length(s)) and (s[p] <> ',') and (s[p] <> '.') do
    Inc(p);

   if not(p = Length(s))then begin
     inteiro := Copy(s, 0, p);
     decimal := Copy(s, p+1, 2);
     Result := StrToFloat(inteiro + decimal);
   end else begin
      Result := value;
   end;

end;

Procedure Cab01Bobina(Report:TObject;nmEmpresa,Titulo:String;Usu:String;pathlogo:string);
var
Cl : integer;
Logo: TBitmap;
Begin

  With Report as TBaseReport do begin

     cl := 0;
     if (pathlogo<>'') then begin
        logo := TBitmap.Create;
        try
           logo.LoadFromFile(pathlogo);
           PrintBitmapRect(0,0,1.0,0.4,logo);
           cl := 1;
        except
           cl := 0;
           logo.Free;
        end;
     end;

     AdjustLine;
     SetFont('Arial',6);
     Bold := True;
     PrintRight(nmEmpresa,PageWidth - MarginRight - MarginLeft);
     Bold := False;
     SetFont('Arial',7);
     NewLine;

    { SetFont('courier new',7);
     PrintLeft(nmEmpresa,MarginLeft+cl);}

     SetFont('courier new',7);
     PrintRight('Data/Hora '+DateToStr(date)+' '+TimeToStr(Time),PageWidth - MarginRight - MarginLeft);
     NewLine;

     SetFont('courier new',8);
     PrintLeft(Titulo,MarginLeft+cl);

     SetFont('courier new',8);
     PrintRight('Usuario '+usu,PageWidth - MarginRight - MarginLeft);

     MoveTo(0,YPos+0.2);
     LineTo(PageWidth - MarginRight - MarginLeft,YPos+0.2);

     NewLine;
     NewLine;

  end;

end;
procedure ValidaPISCOFINS(cstpis:string;cstcofins:string;basicapis:extended;basicacofins:extended;txpis:extended;txcofins:extended);
begin
  if(cstpis = '')then
    raise Exception.Create('Codigo do PIS em Branco');

  if(cstcofins = '')then
    raise Exception.Create('Codigo do COFINS em Branco');

  if cstpis <> cstcofins then
    raise Exception.Create('CSTs de PIS e COFINS Devem Ser Iguais');

  if ((cstpis = '01') and (arredonda(txpis,2) <> arredonda(basicapis,2))) then
    raise Exception.Create('CST PIS: '+cstpis + ' Deve Ter aliquota Basica.: '+formatfloat('#,##0.00',basicapis));//exibir aliq basica

  if ((cstcofins = '01') and (arredonda(txcofins,2) <> arredonda(basicacofins,2))) then
    raise Exception.Create('CST COFINS: '+cstcofins + ' Deve Ter Aliquota Basica: '+formatfloat('#,##0.00',basicacofins));

  if (((cstpis = '06')or(cstpis = '07')or(cstpis = '08')or(cstpis = '09'))and (txpis <> 0)) then//adicionar cst 07,08,09
    raise Exception.Create('CST PIS: '+ cstpis+' Deve Ter Taxa Igual a Zero');

  if (((cstcofins = '06')or(cstcofins = '07')or(cstcofins = '08')or(cstcofins = '09'))and (txcofins <> 0)) then
    raise Exception.Create('CST COFINS: '+ cstcofins+' Deve Ter Taxa Igual a Zero');

  if((cstpis = '50') and (arredonda(txpis,2) <> arredonda(basicapis,2)))then  //and(txpis <> basicapis)
    raise Exception.Create('CST PIS: '+cstpis+' Deve Ter Aliquota Basica: '+formatfloat('#,##0.00',basicapis));

  if((cstcofins = '50')and(arredonda(txcofins,2) <> arredonda(basicacofins,2)))then
    raise Exception.Create('CST COFINS: '+cstcofins+' Deve Ter Aliquota Basica: '+formatfloat('#,##0.00',basicacofins));

  if ((copy(cstpis,1,1) = '7') and (txpis <> 0)) then //70 até 75
    raise Exception.Create('CST PIS: '+cstpis+'Deve Ter Aliquota Igual a Zero');

  if ((copy(cstcofins,1,1) = '7') and (txcofins <> 0)) then//70 até 75
    raise Exception.Create('CST COFINS: '+cstcofins+'Deve Ter Aliquota Igual a Zero');

end;
function ValidaPISCOFINS2(cstpis:string;cstcofins:string;basicapis:extended;basicacofins:extended;txpis:extended;txcofins:extended;cdprod:string='';crt:integer=2):boolean;
var
ok:boolean;
begin

 ok := true;

 try
  if(cstpis = '')then
    raise Exception.Create('Codigo do PIS em Branco');

  if(cstcofins = '')then
    raise Exception.Create('Codigo do COFINS em Branco');

  if cstpis <> cstcofins then
    raise Exception.Create('CSTs de PIS e COFINS Devem Ser Iguais');

  if ((cstpis = '01') and (arredonda(txpis,2) <> arredonda(basicapis,2))) then
    raise Exception.Create('CST PIS: '+cstpis + ' Deve Ter aliquota Basica.: '+formatfloat('#,##0.00',basicapis));//exibir aliq basica

  if ((cstcofins = '01') and (arredonda(txcofins,2) <> arredonda(basicacofins,2))) then
    raise Exception.Create('CST COFINS: '+cstcofins + ' Deve Ter Aliquota Basica: '+formatfloat('#,##0.00',basicacofins));

  if (((cstpis = '06')or(cstpis = '07')or(cstpis = '08')or(cstpis = '09'))and (txpis <> 0)) then
    raise Exception.Create('CST PIS: '+ cstpis+' Deve Ter Taxa Igual a Zero');

  if (((cstcofins = '06')or(cstcofins = '07')or(cstcofins = '08')or(cstcofins = '09'))and (txcofins <> 0)) then
    raise Exception.Create('CST COFINS: '+ cstcofins+' Deve Ter Taxa Igual a Zero');

  if((cstpis = '50') and (arredonda(txpis,2) <> arredonda(basicapis,2)))then  //and(txpis <> basicapis)
    raise Exception.Create('CST PIS: '+cstpis+' Deve Ter Aliquota Basica: '+formatfloat('#,##0.00',basicapis));

  if((cstcofins = '50')and(arredonda(txcofins,2) <> arredonda(basicacofins,2)))then
    raise Exception.Create('CST COFINS: '+cstcofins+' Deve Ter Aliquota Basica: '+formatfloat('#,##0.00',basicacofins));

  if ((copy(cstpis,1,1) = '7') and (txpis <> 0)) then //70 até 75
    raise Exception.Create('CST PIS: '+cstpis+'Deve Ter Aliquota Igual a Zero');

  if ((copy(cstcofins,1,1) = '7') and (txcofins <> 0)) then//70 até 75
    raise Exception.Create('CST COFINS: '+cstcofins+'Deve Ter Aliquota Igual a Zero');
 except
   on E: Exception do begin
     if cdprod <> '' then begin
      if crt <> 2 then
        ok := true
      else begin
        ok:=false;
        Showmessage(' Cod. Produto:'+cdprod+' '+e.Message);
      end;
     end
     else begin
      if crt <> 2 then
        ok := true
      else begin
        ok:=false;
       raise exception.Create(e.Message);
      end;
     end;

   end;

 end;

  result := ok

end;

function VerificaConexaoWeb():boolean;
var
i:word;
begin
   if InternetGetConnectedState(@i,0) then
    result:=true
   else
    result:=false;

end;
function IntToBoolean(numero:integer):boolean;
begin
  if numero > 0 then
    result := true
  else
    result := false;
end;

//procedure StartTransaction;
//var
//  ztransaction:TZSQLProcessor;
//begin
//   ztransaction := TZSQLProcessor.Create(Application);
//   ztransaction.Connection := frprincipal.db0;
//
//   with ztransaction do begin
//     with script do begin
//       clear;
//       add('start transaction;');
//     end;
//     execute;
//   end;
//
//   ztransaction.Free;
//end;

//procedure Commit;
//var
//  ztransaction:TZSQLProcessor;
//begin
//   ztransaction := TZSQLProcessor.Create(Application);
//   ztransaction.Connection := frprincipal.db0;
//
//   with ztransaction do begin
//     with script do begin
//       clear;
//       add('commit;');
//     end;
//     execute;
//   end;
//
//   ztransaction.Free;
//end;

//procedure Rollback;
//var
//  ztransaction:TZSQLProcessor;
//begin
//
//   ztransaction := TZSQLProcessor.Create(Application);
//   ztransaction.Connection := frprincipal.db0;
//
//   with ztransaction do begin
//     with script do begin
//       clear;
//       add('rollback;');
//     end;
//     execute;
//   end;
//
//   ztransaction.Free;
//end;

//function DataServidor:Tdatetime;
//var
//  qrdataservidor:TZQuery;
//begin
//
//  qrdataservidor := Tzquery.Create(Application);
//  qrdataservidor.connection := frprincipal.db0;
//
//  with qrdataservidor do begin
//    close;
//      with sql do begin
//        clear;
//        add('select current_date() as data');
//      end;
//    open;
//  end;
//
//  result := qrdataservidor.fieldbyname('data').asdatetime;
//
//end;

//function horaServidor:TTime;
//var
//  qrdataservidor:TZQuery;
//begin
//
//  qrdataservidor := Tzquery.Create(Application);
//  qrdataservidor.connection := frprincipal.db0;
//
//  with qrdataservidor do begin
//    close;
//      with sql do begin
//        clear;
//        add('select current_time() as hora');
//      end;
//    open;
//  end;
//
//  result := qrdataservidor.fieldbyname('hora').asdatetime;
//
//end;

function Soletras(texto:string;tamanho:integer):boolean;
var
 I : integer;
begin

    for I := 1 to tamanho do begin
       if texto[I] in ['A'..'Z'] then
         result := true
       else begin
        if tamanho <= 2 then
           result := false;
       end;
    end;

end;

function PosicaoString(Busca, Text : string; qt : integer) : integer;
var
n,retorno : integer;
begin

   retorno := 0;

   for n := 1 to length(Text) do begin
      if (Copy(Text,n,1) = Busca) and (qt>0) then begin
         qt := qt - 1;
         retorno := n;
      end;
   end;

   Result := retorno;

end;

//procedure estoqueExists(cdprod, cdloja:string);
//var
//  qrestoque : Tzquery;
//  ztransaction:TZSQLProcessor;
//begin
//
//  qrestoque := Tzquery.Create(Application);
//  qrestoque.connection := frprincipal.db0;
//
//  ztransaction := TZSQLProcessor.Create(Application);
//  ztransaction.Connection := frprincipal.db0;
//
//  with qrestoque do begin
//    close;
//      with sql do begin
//        clear;
//        add('select * from estoque where nr_loja = :loja and cd_prod = :prod');
//      end;
//    parambyname('loja').asstring := cdloja;
//    parambyname('prod').asstring := cdprod;
//    open;
//  end;
//
//  if (qrestoque.recordcount = 0) then begin
//
//     with ztransaction do begin
//       with script do begin
//         clear;
//         add('insert into estoque set ');
//         add('qt_est = 0,');
//         add('nr_loja = :loja,');
//         add('cd_prod = :prod');
//         add(';');
//       end;
//       parambyname('loja').asstring := cdloja;
//       parambyname('prod').asstring := cdprod;
//       execute;
//     end;
//
//  end;
//
//
//
//
//end;
procedure gravarLog(nrdoc:string;modulo:string;acao:string;usuario:string;obs:string;dtlog:TDate;hrlog:TTime;dataset:TZSQLProcessor);
begin
  with dataset do begin
    with script do begin
      clear;
      add('insert into log set');
      add('nr_doc = :nrdoc,');
      add('nm_modulo = :modulo,');
      add('nm_acao = :acao,');
      add('nm_usuario = :usuario,');
      add('nm_obs = :obs,');
      add('dt_log = :dtlog,');
      add('hr_log = :hrlog');
    end;
    parambyname('nrdoc').asstring:= nrdoc;
    parambyname('modulo').asstring:= modulo;
    parambyname('acao').asstring:= acao;
    parambyname('usuario').asstring:= usuario;
    parambyname('obs').asstring:= obs;
    parambyname('dtlog').AsDate:= dtlog;
    parambyname('hrlog').AsTime:= hrlog;
    execute;
  end;

end;

function retirarZeros( texto : string ): string;
begin
   result := texto;
   while ( pos( '0', result ) = 1 ) do begin
      result := copy( result, 2, length( result ) );
   end;
end;

end.
