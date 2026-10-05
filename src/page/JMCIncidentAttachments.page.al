page 53300 "JMC Incident Attachments"
{
    PageType = ListPart;
    SourceTable = "Document Attachment";
    Caption = 'Attachments', Comment = 'ESP="Documentos adjuntos"';
    ApplicationArea = All;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Attachments)
            {
                field("File Name"; Rec."File Name") { ApplicationArea = All; }
                field("File Extension"; Rec."File Extension") { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("JMC Add Attachment")
            {
                ApplicationArea = All;
                Caption = 'Add Attachment', Comment = 'ESP="Añadir documento"';
                Image = Add;

                trigger OnAction()
                var
                    Attachment: Record "Document Attachment";
                    AttachmentInStream: InStream;
                    FileName: Text;
                begin
                    if not UploadIntoStream(SelectFileLbl, '', '', FileName, AttachmentInStream) then
                        exit;

                    Attachment.Init();
                    Attachment."Table ID" := Database::"JMC Supplier Incident";
                    Attachment."No." := Incident."JMC No.";
                    Attachment.ImportFromStream(AttachmentInStream, FileName);
                    Attachment."File Name" := CopyStr(FileName, 1, MaxStrLen(Attachment."File Name"));
                    Attachment."File Extension" := CopyStr(GetFileExtension(FileName), 1, MaxStrLen(Attachment."File Extension"));
                    Attachment.Insert(true);
                    CurrPage.Update(false);
                end;
            }
            action("JMC View Attachment")
            {
                ApplicationArea = All;
                Caption = 'View Attachment', Comment = 'ESP="Ver documento"';
                Image = View;

                trigger OnAction()
                begin
                    Rec.ViewFile();
                end;
            }
            action("JMC Download Attachment")
            {
                ApplicationArea = All;
                Caption = 'Download Attachment', Comment = 'ESP="Descargar documento"';
                Image = Export;

                trigger OnAction()
                begin
                    Rec.Export(true);
                end;
            }
            action("JMC Delete Attachment")
            {
                ApplicationArea = All;
                Caption = 'Delete Attachment', Comment = 'ESP="Eliminar documento"';
                Image = Delete;

                trigger OnAction()
                begin
                    if Confirm(DeleteAttachmentQst) then begin
                        Rec.Delete(true);
                        CurrPage.Update(false);
                    end;
                end;
            }
        }
    }

    procedure SetIncident(NewIncident: Record "JMC Supplier Incident")
    begin
        Incident := NewIncident;
        Rec.SetRange("Table ID", Database::"JMC Supplier Incident");
        Rec.SetRange("No.", Incident."JMC No.");
        CurrPage.Update(false);
    end;

    local procedure GetFileExtension(FileName: Text): Text
    var
        CharacterPosition: Integer;
        LastDotPosition: Integer;
    begin
        for CharacterPosition := 1 to StrLen(FileName) do
            if CopyStr(FileName, CharacterPosition, 1) = '.' then
                LastDotPosition := CharacterPosition;

        if LastDotPosition = 0 then
            exit('');
        exit(CopyStr(FileName, LastDotPosition + 1));
    end;

    var
        Incident: Record "JMC Supplier Incident";
        SelectFileLbl: Label 'Select a file to attach.', Comment = 'ESP="Seleccione el archivo que desea adjuntar."';
        DeleteAttachmentQst: Label 'Do you want to delete the selected attachment?', Comment = 'ESP="¿Desea eliminar el documento adjunto seleccionado?"';
}