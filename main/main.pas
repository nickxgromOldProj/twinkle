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
    boards_menu: TPanel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure gio(Sender:Tobject);
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
  im: array[1..20] of TImage;
//  im1, im2, im3, im4, im5: TImage;
  board_count: byte;
  lft, tp: integer;

implementation

{$R *.dfm}

uses login;

procedure Tapp.gio(Sender:Tobject);
begin
  ShowMessage(IntToStr(board_count));
end;

procedure Tapp.Button1Click(Sender: TObject);
var
  i, j: byte;
  f: textFile;
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

  inc(board_count);
  im[board_count] := TImage.Create(app);
  im[board_count].Parent := boards_menu;
  im[board_count].Height := 100;
  im[board_count].Width := 200;
  im[board_count].Top := tp;
  im[board_count].Left := lft;
  im[board_count].OnClick := gio;
  im[board_count].Canvas.Brush.Color := rgb(random(255), random(255), random(255));
  im[board_count].Canvas.Rectangle(0, 0, 200, 100);
  AssignFile(f, 'users/user_id_'+IntToStr(userInf.id)+'/board_'+IntToStr(board_count)+'.txt');
  rewrite(f);
  closeFile(f);
  lft := lft + 230;

  if board_count mod 5 = 0 then
  begin
    tp := tp + 120;
    lft := 55;
  end;
  if board_count = 20 then
    Button1.Enabled := false;
end;

procedure Tapp.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;
end;

procedure Tapp.FormShow(Sender: TObject);
begin
  tp := 10;
  lft := 55;
  board_count := 0;
  userInf.log := loging.user.log;
  userInf.pass := loging.user.pass;
  userInf.id := loging.user.id;
  Label1.Caption := IntToStr(userInf.id);
end;

end.
