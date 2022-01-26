unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Imaging.jpeg,
  Vcl.Menus;

type
  TMain = class(TForm)
    Image1: TImage;
    MainMenu1: TMainMenu;
    MainMenu2: TMenuItem;
    Initial1: TMenuItem;
    procedure Initial1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMain;

implementation

{$R *.dfm}

uses Contacts;

procedure TMain.Initial1Click(Sender: TObject);
begin
  ContactsForm.Show;
end;

end.
