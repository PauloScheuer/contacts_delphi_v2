unit contacts;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.MSAcc, FireDAC.Phys.MSAccDef, FireDAC.VCLUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage, Vcl.Buttons, Vcl.ExtDlgs;

type
  TContacts = class(TForm)
    LabelId: TLabel;
    LabelName: TLabel;
    LabelEmail: TLabel;
    LabelAbout: TLabel;
    LabelPhone: TLabel;
    EditName: TEdit;
    EditEmail: TEdit;
    EditPhone: TEdit;
    EditId: TEdit;
    MemoAbout: TMemo;
    FDConnection1: TFDConnection;
    FDContacts: TFDTable;
    DataSource1: TDataSource;
    ButtonNew: TButton;
    ButtonSave: TButton;
    LabelConnected: TLabel;
    ButtonBack: TButton;
    ButtonForth: TButton;
    ButtonEdit: TButton;
    ButtonDelete: TButton;
    ButtonCancel: TButton;
    EditSearch: TEdit;
    GroupSearch: TGroupBox;
    ButtonGo: TButton;
    DBGrid1: TDBGrid;
    ImagePhoto: TImage;
    LabelPhoto: TLabel;
    ButtonSearchImage: TSpeedButton;
    OpenPictureDialog1: TOpenPictureDialog;
    ButtonDeleteImage: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure ButtonBackClick(Sender: TObject);
    procedure ButtonForthClick(Sender: TObject);
    procedure ButtonNewClick(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
    procedure ButtonDeleteClick(Sender: TObject);
    procedure ButtonEditClick(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
    procedure ButtonGoClick(Sender: TObject);
    procedure DBGrid1DoubleClick(Sender: TObject);
    procedure ButtonSearchImageClick(Sender: TObject);
    procedure ButtonDeleteImageClick(Sender: TObject);
  private
    { Private declarations }
    m_bIsAddingNew : Boolean;

    procedure Load;
    procedure BlockDisblock;
    procedure ConfigButtons(strAction : String = '');
    procedure Clear;
  public
    { Public declarations }
  end;

var
  ContactsForm: TContacts;

implementation

{$R *.dfm}

procedure TContacts.ButtonBackClick(Sender: TObject);
begin
  FDContacts.Prior;
  Load;
end;

procedure TContacts.ButtonCancelClick(Sender: TObject);
begin
  Clear;
  if m_bIsAddingNew then
    FDContacts.Prior;
  Load;
  BlockDisblock;
  ConfigButtons;
end;

procedure TContacts.ButtonForthClick(Sender: TObject);
begin
  FDContacts.Next;
  Load;
end;

procedure TContacts.ButtonGoClick(Sender: TObject);
begin
  if not FDContacts.FindKey([EditSearch.Text])
    then ShowMessage('Not found')
    else Load;
end;

procedure TContacts.ButtonDeleteClick(Sender: TObject);
begin
  FDContacts.Delete;
  ConfigButtons;
  Load;
end;

procedure TContacts.ButtonEditClick(Sender: TObject);
begin
  BlockDisblock;
  FDContacts.Edit;
  ConfigButtons('edit');
end;

procedure TContacts.ButtonNewClick(Sender: TObject);
begin
  BlockDisblock;
  FDContacts.Insert;
  ConfigButtons('new');
  m_bIsAddingNew := True;
  Clear;
end;

procedure TContacts.ButtonSaveClick(Sender: TObject);
begin
  FDContacts.FieldByName('name_contact').Value  := EditName.Text;
  FDContacts.FieldByName('email_contact').Value := EditEmail.Text;
  FDContacts.FieldByName('phone_contact').Value := EditPhone.Text;
  FDContacts.FieldByName('about_contact').Value := MemoAbout.Text;
  FDContacts.FieldByName('photo_contact').Value := ImagePhoto.Hint;

  FDContacts.Post;
  BlockDisblock;
  ShowMessage('Data stored');
  Load;
  ConfigButtons;
end;

procedure TContacts.ButtonSearchImageClick(Sender: TObject);
begin
  OpenPictureDialog1.Execute;
  if OpenPictureDialog1.FileName <> '' then
    begin
      ImagePhoto.Picture.LoadFromFile(OpenPictureDialog1.FileName);
      ImagePhoto.Hint := OpenPictureDialog1.FileName;
    end;
end;

procedure TContacts.DBGrid1DoubleClick(Sender: TObject);
begin
  Load;
end;

procedure TContacts.ButtonDeleteImageClick(Sender: TObject);
begin
  ImagePhoto.Picture.LoadFromFile(GetCurrentDir+'\assets\blank.png');
  ImagePhoto.Hint := '';
end;

procedure TContacts.FormCreate(Sender: TObject);
begin
  FDConnection1.Params.Database := GetCurrentDir+'\assets\db.mdb';
  FDConnection1.Connected       := True;
  FDContacts.TableName          := 'contacts';
  FDContacts.Active             := True;

  if FDConnection1.Connected then
    begin
      LabelConnected.Caption := 'Connected';
      Load;
    end
  else
    LabelConnected.Caption := 'Disconnected';

  ConfigButtons;
end;

procedure TContacts.Load;
begin
  if FDConnection1.Connected then
    begin
      if FDContacts.FieldByName('id_contact').Value <> NULL
        then EditId.Text := FDContacts.FieldByName('id_contact').Value
        else EditId.Text := '';

      if FDContacts.FieldByName('name_contact').Value <> NULL
        then EditName.Text  := FDContacts.FieldByName('name_contact').Value
        else EditName.Text  := '';

      if FDContacts.FieldByName('email_contact').Value <> NULL
        then EditEmail.Text := FDContacts.FieldByName('email_contact').Value
        else EditEmail.Text := '';

      if FDContacts.FieldByName('phone_contact').Value <> NULL
        then EditPhone.Text := FDContacts.FieldByName('phone_contact').Value
        else EditPhone.Text := '';

      if FDContacts.FieldByName('about_contact').Value <> NULL
        then MemoAbout.Text := FDContacts.FieldByName('about_contact').Value
        else MemoAbout.Text := '';

      if (FDContacts.FieldByName('photo_contact').Value <> NULL)
      and (FileExists(FDContacts.FieldByName('photo_contact').Value)) then
        begin
          ImagePhoto.Picture.LoadFromFile(FDContacts.FieldByName('photo_contact').Value);
          ImagePhoto.Hint := FDContacts.FieldByName('photo_contact').Value;
        end
      else
        begin
          ImagePhoto.Picture.LoadFromFile(GetCurrentDir+'\assets\blank.png');
          ImagePhoto.Hint := '';
        end;
    end;
end;

procedure TContacts.BlockDisblock;
begin
  EditName.Enabled  := not EditName.Enabled;
  EditEmail.Enabled := not EditEmail.Enabled;
  EditPhone.Enabled := not EditPhone.Enabled;
  MemoAbout.Enabled := not MemoAbout.Enabled;
end;

procedure TContacts.ConfigButtons(strAction : String = '');
begin
  if FDConnection1.Connected then
    begin
      m_bIsAddingNew := False;

      if (strAction = 'new') or (strAction = 'edit') then
        begin
          ButtonDelete.Enabled := False;
          ButtonBack.Enabled   := False;
          ButtonForth.Enabled  := False;

          ButtonSearchImage.Enabled := True;
          ButtonDeleteImage.Enabled := True;

          ButtonSave.Enabled   := True;
          ButtonCancel.Enabled := True;
        end
      else
        begin
          if FDContacts.RecordCount > 0
            then ButtonDelete.Enabled := True
            else ButtonDelete.Enabled := False;

          ButtonBack.Enabled   := True;
          ButtonForth.Enabled  := True;

          ButtonSearchImage.Enabled := False;
          ButtonDeleteImage.Enabled := False;

          ButtonSave.Enabled   := False;
          ButtonCancel.Enabled := False;
        end;

      if strAction = 'new' then
        ButtonEdit.Enabled := False
      else if strAction = 'edit' then
        ButtonNew.Enabled := False
      else
        begin
          ButtonEdit.Enabled := True;
          ButtonNew.Enabled := True;
        end;
    end
  else
    begin
      ButtonBack.Enabled   := False;
      ButtonForth.Enabled  := False;
      ButtonNew.Enabled    := False;
      ButtonEdit.Enabled   := False;
      ButtonDelete.Enabled := False;
      ButtonSave.Enabled   := False;
      ButtonCancel.Enabled := False;
    end;
end;

procedure TContacts.Clear;
begin
  EditId.Text    := '';
  EditName.Text  := '';
  EditEmail.Text := '';
  EditPhone.Text := '';
  MemoAbout.Text := '';
  ImagePhoto.Picture.LoadFromFile(GetCurrentDir+'\assets\blank.png');
  ImagePhoto.Hint := '';
end;

end.
