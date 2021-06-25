unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ExtDlgs,
  Vcl.Imaging.jpeg;

type
  TBoards = record
    img: TImage;
    customName: string[16];
    bgName: string[255];
  end;
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
    createBoardDlg: TPanel;
    Label2: TLabel;
    boardNameEdit: TEdit;
    moreBGbtn: TButton;
    Label3: TLabel;
    createOkBtn: TButton;
    createCancelBtn: TButton;
    previewImg: TImage;
    Label4: TLabel;
    OpenPictureDialog1: TOpenPictureDialog;
    procedure boardSel(Sender:Tobject); //��������� �������� �����, �� ������� ������� ������������
    procedure loadBoards;               //��������� ����� �� users/user_id_<id_������������>/boardsInfo.txt
//    procedure createBoard;              //
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure createOkBtnClick(Sender: TObject);
    procedure createCancelBtnClick(Sender: TObject);
    procedure moreBGbtnClick(Sender: TObject);
    procedure boardNameEditChange(Sender: TObject);
    procedure boardNameEditKeyPress(Sender: TObject; var Key: Char);
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
  im: array[1..20] of TBoards;
  lb: array[1..20] of TLabel;
  board_count: byte;
  lft, tp: integer;
  imgPath: string;

implementation

{$R *.dfm}

uses login;

procedure Tapp.loadBoards;
var
  bInfo: file of TBoards;
  i: Integer;
begin
  for i := 1 to board_count do
  begin
    FreeAndNil(im[i]);
    FreeAndNil(lb[i]);
  end;

  tp := 10;
  lft := 55;
  board_count := 0;
  AssignFile(bInfo, 'users/user_id_'+IntToStr(userInf.id)+'/boardsInfo.txt');
  reset(bInfo);
  while not eof(bInfo) do
  begin
    inc(board_count);
    read(bInfo, im[board_count]);
    im[board_count].img := TImage.Create(app);
    im[board_count].img.Parent := boards_menu;
    im[board_count].img.Height := 100;
    im[board_count].img.Width := 200;
    im[board_count].img.Top := tp;
    im[board_count].img.Left := lft;
    im[board_count].img.Cursor := crHandPoint;
    im[board_count].img.OnClick := boardSel;
    im[board_count].img.Name := 'img' + IntToStr(board_count);
    im[board_count].img.Picture.LoadFromFile('resources/img/' + im[board_count].bgName);

    lb[board_count] := TLabel.Create(app);
    lb[board_count].Parent := boards_menu;
    lb[board_count].Cursor := crHandPoint;
    lb[board_count].Left := lft+10;
    lb[board_count].Top := tp+10;
//    lb[board_count].Name := 'lb' + IntToStr(board_count);
    lb[board_count].Font.Name := '1';
    lb[board_count].Font.Size := 14;
    lb[board_count].Font.Color := clWhite;
    lb[board_count].Caption := im[board_count].customName;

    lft := lft + 230;
    if board_count mod 5 = 0 then
    begin
      tp := tp + 120;
      lft := 55;
    end;
  end;
  closeFile(bInfo);
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

  if board_count < 20 then
  begin
    createBoardDlg.Visible := true;
    boardNameEdit.SetFocus;
  end;
end;

procedure Tapp.createCancelBtnClick(Sender: TObject);
begin
  createBoardDlg.Visible := false;
  boardNameEdit.Text := '';
end;

procedure Tapp.createOkBtnClick(Sender: TObject);
var
  f:textFile;
  bInfo: file of TBoards;
begin
  inc(board_count);
  im[board_count].img := TImage.Create(app);
  im[board_count].bgName := ExtractFileName(OpenPictureDialog1.FileName);

  if boardNameEdit.Text<>'' then
    im[board_count].img.Canvas.TextOut(20, 5, boardNameEdit.Text)
  else
    boardNameEdit.Text := '����� ' + IntToStr(board_count);

  im[board_count].customName := boardNameEdit.Text;
  boardNameEdit.Text := '';

//  �������� ����� ����� �����
  AssignFile(f, 'users/user_id_'+IntToStr(userInf.id)+'/board_'+IntToStr(board_count)+'.txt');
  rewrite(f);
  closeFile(f);

//  ������ ���������� � �����
  AssignFile(bInfo, 'users/user_id_'+IntToStr(userInf.id)+'/boardsInfo.txt');
    reset(bInfo);
    seek(bInfo, fileSize(bInfo));
    write(bInfo, im[board_count]);
  closeFile(bInfo);

  createBoardDlg.Visible := false;
  loadBoards;
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
  Label1.Caption := userInf.log;
  Label4.Font.Name := '1';
  OpenPictureDialog1.FileName := 'blue.bmp';

  loadBoards;
end;

procedure Tapp.moreBGbtnClick(Sender: TObject);
begin
//OpenPictureDialog1.FileName := ExtractFilePath(Application.ExeName) + 'resources/img/default.bmp';
//  OpenPictureDialog1.InitialDir := ExtractFilePath(Application.ExeName) + '/resources/img/';
  if OpenPictureDialog1.Execute then
  begin
//    imgPath := ExtractFilePath(Application.ExeName) + '/resources/img' + OpenPictureDialog1.FileName;
    previewImg.Picture.LoadFromFile(OpenPictureDialog1.FileName);
//    im[board_count].bgName := OpenPictureDialog1.FileName;
  end;
end;

procedure Tapp.boardNameEditChange(Sender: TObject);
begin
  Label4.Caption := BoardNameEdit.Text;
end;

procedure Tapp.boardNameEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    createOkBtn.Click;
    Key := #0;
  end;
end;

procedure Tapp.boardSel(Sender:Tobject);
var
  i: byte;
begin
  for i := 1 to 20 do
    if ((Sender as TImage).Name = 'img' + IntToStr(i))then
      showMessage(IntToStr(i));
end;

end.
