codeunit 53102 "JMC Incident Vendor Reminder"
{
    trigger OnRun()
    var
        Incident: Record "JMC Supplier Incident";
    begin
        CompanyInfo.Get();
        Incident.SetRange("JMC Notify Vendor", true);
        Incident.SetRange("JMC Vendor Responded", false);
        if Incident.FindSet() then
            repeat
                SendReminder(Incident);
            until Incident.Next() = 0;
    end;

    local procedure SendReminder(Incident: Record "JMC Supplier Incident")
    var
        Vendor: Record Vendor;
        Language: Codeunit Language;
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        TempBlob: Codeunit "Temp Blob";
        IncidentReference: RecordRef;
        ReportOutStream: OutStream;
        ReportInStream: InStream;
        CurrentLanguageId: Integer;
        Subject: Text;
        Body: Text;
        AttachmentName: Text[250];
    begin
        if not Vendor.Get(Incident."JMC Vendor No.") then
            exit;
        if Vendor."E-Mail" = '' then
            exit;

        CurrentLanguageId := GlobalLanguage();
        GlobalLanguage(Language.GetLanguageIdOrDefault(Vendor."Language Code"));
        Subject := StrSubstNo(SubjectLbl, Incident."JMC No.", CompanyInfo.Name);
        Body := BuildBody(Incident, Vendor);
        IncidentReference.GetTable(Incident);
        IncidentReference.SetRecFilter();
        TempBlob.CreateOutStream(ReportOutStream);
        Report.SaveAs(Report::"JMC Incident Vendor PDF", '', ReportFormat::Pdf, ReportOutStream, IncidentReference);
        GlobalLanguage(CurrentLanguageId);

        EmailMessage.Create(Vendor."E-Mail", Subject, Body, true);
        AttachmentName := StrSubstNo('Incident-%1.pdf', Incident."JMC No.");
        TempBlob.CreateInStream(ReportInStream);
        EmailMessage.AddAttachment(AttachmentName, 'application/pdf', ReportInStream);
        Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
    end;

    local procedure BuildBody(Incident: Record "JMC Supplier Incident"; Vendor: Record Vendor): Text
    var
        Body: TextBuilder;
    begin
        Body.Append('<div style="font-family:Segoe UI,Arial,sans-serif;font-size:14px;color:#333;max-width:800px;">');
        Body.Append(Paragraph(StrSubstNo(GreetingLbl, Vendor.Name)));
        Body.Append(Paragraph(StrSubstNo(IntroLbl, Incident."JMC No.", Format(Incident."JMC Date", 0, '<Day,2>/<Month,2>/<Year4>'))));
        Body.Append(Paragraph(RequestLbl));
        Body.Append(Paragraph(ReplyLbl));
        Body.Append(Paragraph(ApologyLbl));
        Body.Append(Paragraph(ThanksLbl));
        Body.Append(Paragraph(StrSubstNo(SignatureLbl, EncodeHtmlText(CompanyInfo.Name)), false));
        Body.Append('<p style="font-size:11px;color:#888;">' + EncodeHtmlText(AutoNoticeLbl) + '</p>');
        Body.Append('</div>');
        exit(Body.ToText());
    end;

    local procedure Paragraph(Value: Text): Text
    begin
        exit(Paragraph(Value, true));
    end;

    local procedure Paragraph(Value: Text; DoEncode: Boolean): Text
    begin
        if DoEncode then
            Value := EncodeHtmlText(Value);
        exit('<p>' + Value + '</p>');
    end;

    local procedure EncodeHtmlText(Value: Text): Text
    var
        TypeHelper: Codeunit "Type Helper";
    begin
        exit(TypeHelper.HtmlEncode(Value));
    end;

    var
        CompanyInfo: Record "Company Information";
        SubjectLbl: Label 'Follow-up on incident %1 - %2', Comment = 'ESP="Seguimiento de la incidencia %1 - %2"';
        GreetingLbl: Label 'Dear %1,', Comment = 'ESP="Estimado proveedor %1:"';
        IntroLbl: Label 'We are writing to follow up on incident %1, registered on %2. We kindly ask you to send us a reply as soon as possible.', Comment = 'ESP="Nos ponemos en contacto con ustedes para hacer seguimiento de la incidencia %1, registrada el %2. Les solicitamos el favor de enviar una respuesta a la mayor brevedad posible."';
        RequestLbl: Label 'We would be grateful if you could review it when possible and send us your analysis, so that we can close it together.', Comment = 'ESP="Les agradeceríamos que, cuando les sea posible, la revisaran y nos hicieran llegar su análisis, para poder cerrarla conjuntamente."';
        ReplyLbl: Label 'You can simply reply to this email with this information. If you need any additional documentation (photos, delivery notes, etc.), please do not hesitate to ask us.', Comment = 'ESP="Pueden responder directamente a este correo con esta información. Si necesitan documentación adicional (fotografías, albaranes, etc.), no duden en solicitárnosla."';
        ApologyLbl: Label 'If you have already sent us your reply, please disregard this message and accept our apologies for the inconvenience.', Comment = 'ESP="Si ya nos han enviado su respuesta, les rogamos que ignoren este mensaje y disculpen las molestias."';
        ThanksLbl: Label 'Thank you very much for your collaboration.', Comment = 'ESP="Muchas gracias por su colaboración."';
        SignatureLbl: Label 'Kind regards,<br>Quality Department<br>%1', Comment = 'ESP="Un cordial saludo,<br>Departamento de Calidad<br>%1"';
        AutoNoticeLbl: Label 'This is an automatic reminder that is sent once a day while the incident is pending a reply.', Comment = 'ESP="Este es un recordatorio automático que se envía una vez al día mientras la incidencia esté pendiente de respuesta."';
}
