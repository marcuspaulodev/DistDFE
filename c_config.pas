unit c_config;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, RxToolEdit, Buttons;

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
    GroupBox1: TGroupBox;
    Edit5: TEdit;
    Label4: TLabel;
    SpeedButton1: TSpeedButton;
    Edit6: TEdit;
    Label5: TLabel;
    DateEdit1: TDateEdit;
    Label6: TLabel;
    GroupBox2: TGroupBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frconfig: Tfrconfig;

implementation

{$R *.dfm}

end.
