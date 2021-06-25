unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TUser = record
    log: string[16];
    pass: string[16];
    id: word;
  end;
  Tapp = class(TForm)
    Label1: TLabel;
    Button1: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    l:string;
    userInf: TUser;
  end;

var
  app: Tapp;

implementation

{$R *.dfm}

procedure Tapp.Button1Click(Sender: TObject);
begin
  Label1.Caption := IntToStr(userInf.id);
end;

procedure Tapp.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;
end;

end.