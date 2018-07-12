object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'DASM'
  ClientHeight = 404
  ClientWidth = 579
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 563
    Height = 305
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object Button1: TButton
    Left = 8
    Top = 336
    Width = 73
    Height = 33
    Caption = 'Button1'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 80
    Top = 336
    Width = 81
    Height = 33
    Caption = 'Button2'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 372
    Top = 336
    Width = 97
    Height = 33
    Caption = 'Button3'
    TabOrder = 3
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 464
    Top = 336
    Width = 107
    Height = 33
    Caption = 'Button4'
    TabOrder = 4
    OnClick = Button4Click
  end
  object Edit1: TEdit
    Left = 167
    Top = 342
    Width = 199
    Height = 21
    TabOrder = 5
    Text = 'inlineHookKingDll.dll'
  end
  object Button5: TButton
    Left = 336
    Top = 371
    Width = 75
    Height = 25
    Caption = 'Button5'
    TabOrder = 6
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 417
    Top = 371
    Width = 73
    Height = 25
    Caption = 'Button6'
    TabOrder = 7
    OnClick = Button6Click
  end
  object Button7: TButton
    Left = 8
    Top = 370
    Width = 113
    Height = 31
    Caption = 'load_ihook_dll'
    TabOrder = 8
    OnClick = Button7Click
  end
end
