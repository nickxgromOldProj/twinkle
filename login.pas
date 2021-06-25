unit login;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TUser = record
    log: string[16];
    pass: string[16];
    id: byte;
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
  private
    { Private declarations }
  public
    t: file of TUser;
    user: TUser;
    { Public declarations }
  end;

var
  loging: Tloging;

implementation

{$R *.dfm}

procedure Tloging.Button1Click(Sender: TObject);
var
  r: boolean;
  login: string[16];
  pass: string[16];
begin
  if (Edit1.Text<>'') and (Edit2.Text<>'') then
  begin
    AssignFile(t, ExtractFilePath(Application.ExeName)+'users/users.txt');
    reset(t);
    login := Edit1.Text;
    pass := Edit2.Text;
    while not eof(t) and not(r) do
    begin
      read(t, user);
      r := (user.log = login);
    end;
    if r and (pass = user.pass) then
      ShowMessage('найден')
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
  login: string[16];
  r: boolean;
begin
  if (Edit1.Text<>'') and (Edit2.Text<>'') and (Edit3.Text<>'') then
    if (Edit2.Text = Edit3.Text) then
    begin
      r := true;
      randomize;
      AssignFile(t, ExtractFilePath(Application.ExeName)+'users/users.txt');
      reset(t);
      login := Edit1.Text;
      while not eof(t) and r do
      begin
        read(t, user);
          r := not(user.log = login);
      end;
      if r then
      begin
        MessageBox(0, 'Аккаунт успешно зарегистрирован', 'Успешно', mb_iconInformation);
        user.log := Edit1.Text;
        user.pass := Edit2.Text;
        user.id := random(256);
        write(t, user);
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
  if not(Key in ['A'..'z']) and not(Key in ['0'..'9']) then
    Key := #0;
end;

end.
