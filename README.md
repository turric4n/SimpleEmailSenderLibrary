# SimpleEmailSenderLibrary
Simple Email Sender Library for Win32 (Indy + OpenSSL Supported)

Libreria dinámica para enviar correo para Win32
-----------------------------------------------

Author : Enrique Fuentes (aka. Turrican)

Compatibility : Windows 2000,XP,Vista,7,8,8.1,10 (NT)

Developers : Native Win32 programming languajes with DLL support. 

Important : (for SSL usage : libeay32.dll and ssleay32.dll 32/64 bits.)

Functionality : Sends mails SMTP/SSMTP. 

Funcionalidades :

	- Plain SMTP.
	- SSMTP SSL/TLS (OpenSSL)
	- Attached files.
	- With Auth or without.
	- Exception control.	

Parámetros :
	- sendTo : string -> Destinatario 
	- sendFrom : string -> Remitente
	- subject : string -> Asunto
	- body : string -> Cuerpo del mensaje
	- attachFiles : string -> Ficheros adjuntos (separados por comas)
	- smtpHost : string -> Servidor de correo
	- smtpPort : string -> Puerto
	- smtpUser : string -> Usuario si lleva autenticación
	- smtpPass : string -> Password si lleva autenticación
	- tls : boolean -> Si es necesario el cifrado SSL
	- error: -> Salida de la excepción si la hay

Example with Object Pascal :

function SendEmail(const sendTo: string; const sendFrom: string; const subject: string; const body: string;
  const attachFiles: string; const smtpHost: string; const smtpPort: Integer;
  const smtpUser: string; const smtpPass: string; const tls: Boolean; var error: string): boolean; stdcall external 'hsmailsend.dll';

var
  error: string;
begin
    if SendEmail('foo@bar.com','foo@bar.com','John Doe Test','This is a test','.\AttachFile1.txt,.\AttachFile2.jpg','fooserver.bardomain.com',465,'','',True,error) then
    ShowMessage('ok')
    else ShowMessage(error);
end.
