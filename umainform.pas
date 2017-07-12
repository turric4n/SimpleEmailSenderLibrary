unit umainform;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TMainform = class(TForm)
    btn1: TButton;
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  mainform: Tmainform;

function SendEmail(const sendTo: string; const sendFrom: string; const subject: string; const body: string;
  const attachFiles: string; const smtpHost: string; const smtpPort: Integer;
  const smtpUser: string; const smtpPass: string; const tls: Boolean; var error: string): boolean; stdcall external 'SimpleEmailSender.dll';

implementation

{$R *.dfm}

procedure TMainform.btn1Click(Sender: TObject);
var
  error: string;
begin
 if SendEmail('foo@bar.com','foo@bar.com','John Doe Test','This is a test','.\AttachFile1.txt,.\AttachFile2.jpg','fooserver.bardomain.com',465,'','',True,error) then
  ShowMessage('ok')
 else
  ShowMessage(error)
end;

end.
