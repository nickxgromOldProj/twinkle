object app: Tapp
  Left = 0
  Top = 0
  Caption = 'app'
  ClientHeight = 682
  ClientWidth = 1264
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 865
    Top = 16
    Width = 3
    Height = 13
  end
  object Button1: TButton
    Left = 33
    Top = 8
    Width = 169
    Height = 37
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1076#1086#1089#1082#1091
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = Button1Click
  end
  object boards_menu: TPanel
    Left = 26
    Top = 59
    Width = 1230
    Height = 529
    TabOrder = 1
  end
end
