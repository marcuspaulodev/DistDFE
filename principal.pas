unit principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Menus, c_config;

type
  TfrPrincipal = class(TForm)
    TrayIcon1: TTrayIcon;
    PopupMenu1: TPopupMenu;
    Configuraes1: TMenuItem;
    Abrir1: TMenuItem;
    N1: TMenuItem;
    Sair1: TMenuItem;
    procedure TrayIcon1Click(Sender: TObject);
    procedure Sair1Click(Sender: TObject);
    procedure Abrir1Click(Sender: TObject);
    procedure Configuraes1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frPrincipal: TfrPrincipal;

implementation

{$R *.dfm}

procedure TfrPrincipal.Abrir1Click(Sender: TObject);
begin
  frPrincipal.ShowModal;
end;

procedure TfrPrincipal.Configuraes1Click(Sender: TObject);
begin
  frconfig := Tfrconfig.Create(Self);
  frconfig.ShowModal;
  frconfig.Free;
end;

procedure TfrPrincipal.Sair1Click(Sender: TObject);
begin

  Application.Terminate;

end;

procedure TfrPrincipal.TrayIcon1Click(Sender: TObject);
begin
  showmessage('teste de click');
end;

end.
