program contacts_v2;

uses
  Vcl.Forms,
  contacts in 'contacts.pas' {Contacts},
  main in 'main.pas' {Main};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMain, MainForm);
  Application.CreateForm(TContacts, ContactsForm);
  Application.Run;
end.
