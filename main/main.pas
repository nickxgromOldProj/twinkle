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
    addBoardBtn: TButton;
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
    bgPickSB: TScrollBox;
    Panel1: TPanel;
    procedure boardSel(Sender:Tobject); //????????? ???????? ?????, ?? ??????? ??????? ????????????
    procedure loadBoards;               //????????? ????? ?? users/user_id_<id_????????????>/boardsInfo.txt
    procedure pickImg(Sender:Tobject);  //
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure addBoardBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure createOkBtnClick(Sender: TObject);
    procedure createCancelBtnClick(Sender: TObject);
    procedure boardNameEditChange(Sender: TObject);
    procedure boardNameEditKeyPress(Sender: TObject; var Key: Char);
    procedure moreBGbtnClick(Sender: TObject);
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
  im: array[1..25] of TBoards;
  lb: array[1..25] of TLabel;
  board_count: byte;
  lft, tp: integer;
  imgPath: string;
  preImg: array[1..20] of TImage;
  bgName: string;

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
    im[board_count].img.Picture.LoadFromFile('resources/img/previewBG/' + im[board_count].bgName);
    im[board_count].img.Stretch := true;
    im[board_count].img.Proportional := true;

    lb[board_count] := TLabel.Create(app);
    lb[board_count].Parent := boards_menu;
    lb[board_count].Cursor := crHandPoint;
    lb[board_count].OnClick := boardSel;
    lb[board_count].Left := lft+10;
    lb[board_count].Top := tp+10;
    lb[board_count].Name := 'lb' + IntToStr(board_count);
    lb[board_count].Font.Name := 'oswald';
    lb[board_count].Font.Size := 16;
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
  if board_count mod 5 = 0 then
  begin
    addBoardBtn.Left := 55;
    addBoardBtn.Top := im[board_count].img.Top + 120;
  end
  else
  begin
    addBoardBtn.Top := im[board_count].img.Top;
    addBoardBtn.Left := im[board_count].img.Left + 230;
  end;
end;

procedure Tapp.moreBGbtnClick(Sender: TObject);
var
  i: byte;
  lft, tp: word;
begin
  for i := 1 to 20 do
    FreeAndNil(preImg[i]);
  bgPickSB.Visible := true;
  lft := 20;
  tp := 20;
  for i := 1 to 19 do
  begin
    preImg[i] := TImage.Create(app);
    preImg[i].Parent := bgPickSB;
    preImg[i].Width := 200;
    preImg[i].Height := 100;
    preImg[i].Left := lft;
    preImg[i].Top := tp;
    preImg[i].OnClick := pickImg;
    preImg[i].Name := 'preImg' + IntToStr(i);
    preImg[i].Picture.LoadFromFile('resources/img/previewBG/'+IntToStr(i)+'.jpg');
    lft := lft + 230;
    if i mod 2 = 0 then
    begin
        tp := tp + 120;
        lft := 20;
    end;
  end;
end;

procedure Tapp.addBoardBtnClick(Sender: TObject);
var
  i, j: byte;
  f: textFile;
begin
  if board_count < 25 then
  begin
    createBoardDlg.Visible := true;
    boardNameEdit.SetFocus;
  end
  else
    addBoardBtn.Visible := false;
end;

procedure Tapp.createCancelBtnClick(Sender: TObject);
begin
  createBoardDlg.Visible := false;
  boardNameEdit.Text := '';
  bgPickSB.Visible := false;

end;

procedure Tapp.createOkBtnClick(Sender: TObject);
var
  f:textFile;
  bInfo: file of TBoards;
begin
  inc(board_count);
  im[board_count].img := TImage.Create(app);
  im[board_count].bgName := bgName;

  if boardNameEdit.Text='' then
    boardNameEdit.Text := '????? ' + IntToStr(board_count);

  im[board_count].customName := boardNameEdit.Text;
  boardNameEdit.Text := '';

//  ???????? ????? ????? ?????
  AssignFile(f, 'users/user_id_'+IntToStr(userInf.id)+'/board_'+IntToStr(board_count)+'.txt');
  rewrite(f);
  closeFile(f);

//  ?????? ?????????? ? ?????
  AssignFile(bInfo, 'users/user_id_'+IntToStr(userInf.id)+'/boardsInfo.txt');
    reset(bInfo);
    seek(bInfo, fileSize(bInfo));
    write(bInfo, im[board_count]);
  closeFile(bInfo);

  createBoardDlg.Visible := false;
  loadBoards;
  bgPickSB.Visible := false;
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
  Label4.Font.Name := 'oswald';
  bgName := '1.jpg';

  loadBoards;
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
  if Sender is TImage then
    for i := 1 to 25 do
      if ((Sender as TImage).Name = 'img' + IntToStr(i)) then
        showMessage(IntToStr(i));
  if Sender is TLabel then
    for i := 1 to 25 do
      if ((Sender as TLabel).Name = 'lb' + IntToStr(i)) then
        showMessage(IntToStr(i));
end;

procedure Tapp.pickImg(Sender: TObject);
var
  i, j: byte;
begin
  if Sender is TImage then
  begin
    for i := 1 to 20 do
      if (Sender as TImage).Name = 'preImg' + IntToStr(i)  then
      begin
        previewImg.Picture.LoadFromFile('resources/img/previewBG/' + IntToStr(i) + '.jpg');
        bgName := IntToStr(i) + '.jpg';
      end;
      for j := 1 to 20 do
        FreeAndNil(preImg[j]);
    bgPickSB.Visible := false;
  end;
end;

end.
