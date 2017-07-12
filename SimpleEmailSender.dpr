library SimpleEmailSender;

{
 *  Copyright (c) 2017 Enrique Fuentes aka. Turrican
 *
 *  This software is provided 'as-is', without any express or
 *  implied warranty. In no event will the authors be held
 *  liable for any damages arising from the use of this software.
 *
 *  Permission is granted to anyone to use this software for any purpose,
 *  including commercial applications, and to alter it and redistribute
 *  it freely, subject to the following restrictions:
 *
 *  1. The origin of this software must not be misrepresented;
 *     you must not claim that you wrote the original software.
 *     If you use this software in a product, an acknowledgment
 *     in the product documentation would be appreciated but
 *     is not required.
 *
 *  2. Altered source versions must be plainly marked as such,
 *     and must not be misrepresented as being the original software.
 *
 *  3. This notice may not be removed or altered from any
 *     source distribution.
}  

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }
  

uses
  System.SysUtils,
  System.Classes,
  IdSMTP,
  IdSSL,
  IdMessage,
  IdSSLOpenSSL,
  IdSSLOpenSSLHeaders,
  IdExplicitTLSClientServerBase,
  IdAttachment,
  IdAttachmentFile;

{$R *.res}

procedure Split(Delimiter: Char; Str: string; ListOfStrings: TStrings) ;
begin
   ListOfStrings.Clear;
   ListOfStrings.Delimiter       := Delimiter;
   ListOfStrings.StrictDelimiter := True; // Requires D2006 or newer.
   ListOfStrings.DelimitedText   := Str;
end;


function SendEmail(const sendTo: string; const sendFrom: string; const subject: string; const body: string;
  const attachFiles: string; const smtpHost: string; const smtpPort: Integer;
  const smtpUser: string; const smtpPass: string; const tls: Boolean; var error: string): boolean; stdcall;

var
  smtp : TIdSmtp;
  ssl : TIdSSLIOHandlerSocketOpenSSL;
  msg : TIdMessage;
  i : Integer;
  attached : TStringList;
begin
  attached := nil;
  smtp := TIdSmtp.Create(nil);
  ssl := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  msg := TIdMessage.Create(nil);
  try
    try
      if not attachFiles.IsEmpty then
      begin
        attached:= TStringList.Create;
        if attachFiles.Contains(',') then Split(',', attachFiles, attached)
        else attached.Add(attachFiles);
      end;
      smtp.Host := smtpHost;
      smtp.Port := smtpPort;
      smtp.Username := smtpUser;
      smtp.Password := smtpPass;
      if tls then
      begin
        ssl.Destination := smtpHost + ':' + IntToStr(smtpPort);
        ssl.Host := smtpHost;
        ssl.Port := smtpPort;
        smtp.IOHandler := ssl;
        smtp.UseTLS := utUseImplicitTLS;
      end;
      msg.From.Address:=sendFrom;
      msg.Recipients.EMailAddresses := sendTo;
      msg.subject := subject;
      msg.body.Text := body;
      if (Assigned(attached)) then
      begin
        for i := 0 to attached.Count - 1 do
        begin
          if FileExists(attached[i]) then
            TIdAttachmentFile.Create(msg.MessageParts, attached[i]);
        end;
      end;
      smtp.Connect;
      smtp.Send(msg);
      smtp.Disconnect;
      result := true;
    finally
      attached.Free;
      msg.Free;
      ssl.Free;
      smtp.Free;
    end;
  except
    on e: Exception do
    begin
      error:=e.ToString;
      Result:=False;
    end;
  end;
end;

exports SendEmail;

begin
end.
