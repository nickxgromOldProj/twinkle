unit login;

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
  Tloging = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    t: file of TUser;
    user: TUser;
    { Public declarations }
  end;

var
  loging: Tloging;
  log: string[16];
  pass: string[16];

implementation

{$R *.dfm}

uses main;

procedure Tloging.Button1Click(Sender: TObject);
var
  r: boolean;
begin
// Автовход
  Edit1.Text := 'nxg';
  Edit2.Text := '0899';
  AddFontResource('C:\Users\NickGrom\Desktop\Проект_Мылтыкбаев_Громыко\TwinkleboardsMenu\login\resources\fonts\oswald.ttf');
  SendMessage(HWND_BROADCAST, WM_FONTCHANGE, 0, 0) ;
AddFontResourceEx('C:\Users\NickGrom\Desktop\Проект_Мылтыкбаев_Громыко\TwinkleboardsMenu\login\resources\fonts\oswald.ttf',FR_PRIVATE,0);
  if (Edit1.Text<>'') and (Edit2.Text<>'') then
  begin
    AssignFile(t, ExtractFilePath(Application.ExeName)+'users/users.txt');
    reset(t);
    r := false;
    log := Edit1.Text;
    pass := Edit2.Text;
    while not eof(t) and not(r) do
    begin
      read(t, user);
      r := (user.log = log);
    end;
    if r and (pass = user.pass) then
    begin
      app.Show;
      loging.Hide;
    end
    else
      MessageBox(0, 'Пользователя с таким логином не найдено или неверно введен пароль', 'Ошибка', mb_iconError);
  end
  else
    MessageBox(0, 'Необходимо заполнить все поля', 'Внимание', mb_iconInformation);
end;

procedure Tloging.Button2Click(Sender: TObject);
begin
  Edit3.Visible := true;
  Label3.Visible := true;
  loging.Caption := 'Регистрация';
  Button1.Visible := false;
  Button2.Visible := false;
  Button3.Visible := true;
  Button4.Visible := true;
end;

procedure Tloging.Button3Click(Sender: TObject);
var
  r: boolean;
  f: textFile;
begin
  if (Edit1.Text<>'') and (Edit2.Text<>'') and (Edit3.Text<>'') then
    if (Edit2.Text = Edit3.Text) then
    begin
      r := true;
      AssignFile(t, ExtractFilePath(Application.ExeName)+'users/users.txt');
      reset(t);
      log := Edit1.Text;
      while not eof(t) and r do
      begin
        read(t, user);
          r := not(user.log = log);
      end;
      if r then
      begin
        MessageBox(0, 'Аккаунт успешно зарегистрирован', 'Успешно', mb_iconInformation);
        if fileSize(t) = 0 then
          user.id := 1
        else
        begin
          seek(t, fileSize(t)-1);
          read(t, user);
          user.id := user.id +1;
        end;
        user.log := Edit1.Text;
        user.pass := Edit2.Text;
        write(t, user);
        createdir('users\'+'user_id_'+IntToStr(user.id));
        AssignFile(f, 'users/user_id_'+IntToStr(user.id)+'/boardsInfo.txt');
        rewrite(f);
        closeFile(f);
        Button4.Click;
      end
      else
        MessageBox(0, 'Аккаунт с таким логином уже существует', 'Ошибка', mb_iconError);
      closeFile(t);
    end
    else
      MessageBox(0, 'Пароли не совпадают', 'Ошибка', mb_iconError)
  else
    MessageBox(0, 'Все поля должны быть заполнены', 'Ошибка', mb_iconError)
end;

procedure Tloging.Button4Click(Sender: TObject);
begin
  Button1.Visible := true;
  Button2.Visible := true;
  Button3.Visible := false;
  Button4.Visible := false;
  Edit3.Visible := false;
  Label3.Visible := false;
  loging.Caption := 'Вход';
end;

procedure Tloging.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if not(Key in ['A'..'z']) and not(Key in ['0'..'9']) and (ord(Key)<>8) then
    Key := #0;
end;

procedure Tloging.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  RemoveFontResource('1.ttf');
end;

end.
