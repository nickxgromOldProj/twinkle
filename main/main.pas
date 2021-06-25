unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TColor = (red, green, blue, white);
  TData = record
    day: 1..31;
    month: 1..12;
    year: word;
  end;
  TCard = record
    name: string[16];
    discription: string[127];
    marker: set of TColor;
    data: TData;
  end;
  TList = record
    name: string[16];
    lst: array[1..20] of TCard;
  end;
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
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    l:string;
    userInf: TUser;
  end;

var
  app: Tapp;
  board: array[1..5] of TList;
  list: TList;
  card: TCard;
  im1, im2, im3, im4, im5: TImage;

implementation

{$R *.dfm}

uses login;

procedure Tapp.Button1Click(Sender: TObject);
var
  i, j: byte;
  f: file of TList;
begin
//  assignFile(f, 'users/user_id_1/q.txt');
//  reset(f);
//  for i := 1 to 5 do
//  begin
//    list.name := 'name';
//    for j := 1 to 20 do
//    begin
//      card.name := IntToStr(j);
//      card.discription := 'sd';
//      card.marker := [red];
//      card.data.day := 4;
//      card.data.month := 1;
//      card.data.year := 1234;
//      list.lst[j] := card;
//    end;
//    board[i] := list;
//    write(f, board[i]);
//  end;
//  closefile(f);
    im1 := TImage.Create(app);
    im1.Parent := app;
    im1.Width := 100;
    im1.Height := 100;
    im1.Top := 50;
    im1.Left := 20;
    im1.Canvas.Pen.Color := rgb(255, 12, 12);
    im1.Canvas.Rectangle(0, 0, 100,100);
end;

procedure Tapp.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;
end;

procedure Tapp.FormShow(Sender: TObject);
begin
  userInf.log := loging.user.log;
  userInf.pass := loging.user.pass;
  userInf.id := loging.user.id;
  Label1.Caption := intToStr(userInf.id);
end;

end.
