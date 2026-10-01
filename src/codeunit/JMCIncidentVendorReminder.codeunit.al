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
        CurrentLanguageId: Integer;
        Subject: Text;
        Body: Text;
    begin
        if not Vendor.Get(Incident."JMC Vendor No.") then
            exit;
        if Vendor."E-Mail" = '' then
            exit;

        CurrentLanguageId := GlobalLanguage();
        GlobalLanguage(Language.GetLanguageIdOrDefault(Vendor."Language Code"));
        Subject := StrSubstNo(SubjectLbl, Incident."JMC No.", CompanyInfo.Name);
        Body := BuildBody(Incident, Vendor);
        GlobalLanguage(CurrentLanguageId);

        EmailMessage.Create(Vendor."E-Mail", Subject, Body, true);
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

        Body.Append(SectionHeader(Section1Lbl));
        Body.Append('<table style="border-collapse:collapse;width:100%;">');
        Body.Append(InfoRow(IncidentCodeLbl, Incident."JMC No."));
        Body.Append(InfoRow(IssueDateLbl, Format(Incident."JMC Date", 0, '<Day,2>/<Month,2>/<Year4>')));
        Body.Append(InfoRow(VendorNameLbl, Vendor.Name));
        Body.Append(InfoRow(SourceDocLbl, StrSubstNo('%1 %2', Incident."JMC Source Type", Incident."JMC Source Document No.")));
        if Incident."JMC Lot No." <> '' then
            Body.Append(InfoRow(LotLbl, Incident."JMC Lot No."));
        Body.Append('</table>');
        AppendProducts(Body, Incident);

        Body.Append(SectionHeader(Section2Lbl));
        Body.Append('<table style="border-collapse:collapse;width:100%;">');
        Body.Append(InfoRow(DescriptionLbl, Incident."JMC Incident Description"));
        Body.Append(InfoRow(DetectedByLbl, Format(Incident."JMC Detected By")));
        Body.Append('</table>');

        Body.Append(SectionHeader(Section3Lbl));
        Body.Append(Paragraph(Section3IntroLbl));
        Body.Append('<ul>');
        Body.Append(ListItem(RootCauseLbl));
        Body.Append(ListItem(CorrectiveActionLbl));
        Body.Append(ListItem(PreventiveActionLbl));
        Body.Append(ListItem(ResponsibleLbl));
        Body.Append('</ul>');

        Body.Append(Paragraph(ReplyLbl));
        Body.Append(Paragraph(ApologyLbl));
        Body.Append(Paragraph(ThanksLbl));
        Body.Append(Paragraph(StrSubstNo(SignatureLbl, Encode(CompanyInfo.Name)), false));
        Body.Append('<p style="font-size:11px;color:#888;">' + Encode(AutoNoticeLbl) + '</p>');
        Body.Append('</div>');
        exit(Body.ToText());
    end;

    local procedure AppendProducts(var Body: TextBuilder; Incident: Record "JMC Supplier Incident")
    var
        IncidentProduct: Record "JMC Supplier Incident Product";
    begin
        IncidentProduct.SetRange("JMC Incident No.", Incident."JMC No.");
        if not IncidentProduct.FindSet() then
            exit;

        Body.Append('<table style="border-collapse:collapse;width:100%;margin-top:8px;">');
        Body.Append('<tr style="background:#e7e6e6;">');
        Body.Append(HeaderCell(ItemLbl));
        Body.Append(HeaderCell(ItemDescriptionLbl));
        Body.Append(HeaderCell(QuantityLbl));
        Body.Append(HeaderCell(LotLbl));
        Body.Append('</tr>');
        repeat
            Body.Append('<tr>');
            Body.Append(Cell(IncidentProduct."JMC Item No."));
            Body.Append(Cell(IncidentProduct."JMC Item Description"));
            Body.Append(Cell(Format(IncidentProduct."JMC Quantity")));
            Body.Append(Cell(IncidentProduct."JMC Lot No."));
            Body.Append('</tr>');
        until IncidentProduct.Next() = 0;
        Body.Append('</table>');
    end;

    local procedure SectionHeader(Title: Text): Text
    begin
        exit('<h3 style="background:#404040;color:#fff;padding:6px 8px;margin:20px 0 8px 0;font-size:15px;">' + Encode(Title) + '</h3>');
    end;

    local procedure InfoRow(Caption: Text; Value: Text): Text
    var
        CR: Char;
        LF: Char;
    begin
        CR := 13;
        LF := 10;
        exit('<tr><td style="border:1px solid #ccc;padding:4px 8px;background:#f2f2f2;font-weight:bold;width:30%;">' + Encode(Caption) +
             '</td><td style="border:1px solid #ccc;padding:4px 8px;">' + Encode(Value).Replace(Format(CR), '').Replace(Format(LF), '<br>') + '</td></tr>');
    end;

    local procedure HeaderCell(Value: Text): Text
    begin
        exit('<th style="border:1px solid #ccc;padding:4px 8px;text-align:left;">' + Encode(Value) + '</th>');
    end;

    local procedure Cell(Value: Text): Text
    begin
        exit('<td style="border:1px solid #ccc;padding:4px 8px;">' + Encode(Value) + '</td>');
    end;

    local procedure ListItem(Value: Text): Text
    begin
        exit('<li>' + Encode(Value) + '</li>');
    end;

    local procedure Paragraph(Value: Text): Text
    begin
        exit(Paragraph(Value, true));
    end;

    local procedure Paragraph(Value: Text; DoEncode: Boolean): Text
    begin
        if DoEncode then
            Value := Encode(Value);
        exit('<p>' + Value + '</p>');
    end;

    local procedure Encode(Value: Text): Text
    var
        TypeHelper: Codeunit "Type Helper";
    begin
        exit(TypeHelper.HtmlEncode(Value));
    end;

    var
        CompanyInfo: Record "Company Information";
        SubjectLbl: Label 'Follow-up on incident %1 - %2', Comment = 'ESP="Seguimiento de la incidencia %1 - %2"';
        GreetingLbl: Label 'Dear %1,', Comment = 'ESP="Estimado proveedor %1:"';
        IntroLbl: Label 'We are writing to follow up on incident %1, registered on %2. We have not yet received your reply, so we are sending you the details again in case they were overlooked.', Comment = 'ESP="Nos ponemos en contacto con ustedes para hacer seguimiento de la incidencia %1, registrada el %2. Todavía no hemos recibido su respuesta, por lo que les volvemos a enviar los datos por si hubieran pasado desapercibidos."';
        RequestLbl: Label 'We would be grateful if you could review it when possible and send us your analysis, so that we can close it together.', Comment = 'ESP="Les agradeceríamos que, cuando les sea posible, la revisaran y nos hicieran llegar su análisis, para poder cerrarla conjuntamente."';
        Section1Lbl: Label '1. General incident information', Comment = 'ESP="1. Datos generales de la incidencia"';
        Section2Lbl: Label '2. Description of the problem detected', Comment = 'ESP="2. Descripción del problema detectado"';
        Section3Lbl: Label '3. Root cause analysis and action plan', Comment = 'ESP="3. Análisis de causa raíz y plan de acción"';
        Section3IntroLbl: Label 'To close the incident, we need you to tell us:', Comment = 'ESP="Para poder cerrar la incidencia, necesitaríamos que nos indicaran:"';
        IncidentCodeLbl: Label 'Incident code', Comment = 'ESP="Código de incidencia"';
        IssueDateLbl: Label 'Issue date', Comment = 'ESP="Fecha de emisión"';
        VendorNameLbl: Label 'Vendor name', Comment = 'ESP="Nombre del proveedor"';
        SourceDocLbl: Label 'Order / Receipt No.', Comment = 'ESP="Nº pedido / albarán"';
        LotLbl: Label 'Lot', Comment = 'ESP="Lote"';
        ItemLbl: Label 'Item', Comment = 'ESP="Producto"';
        ItemDescriptionLbl: Label 'Description', Comment = 'ESP="Descripción"';
        QuantityLbl: Label 'Quantity', Comment = 'ESP="Cantidad"';
        DescriptionLbl: Label 'Detailed description of the failure', Comment = 'ESP="Descripción detallada del fallo"';
        DetectedByLbl: Label 'Detected by', Comment = 'ESP="Detectado por"';
        RootCauseLbl: Label 'Origin of the problem (root cause): technical, human or process reason that caused the incident.', Comment = 'ESP="Origen del problema (causa raíz): motivo técnico, humano o de proceso que originó la incidencia."';
        CorrectiveActionLbl: Label 'Corrective action (immediate solution): measures applied to correct the affected lot or service.', Comment = 'ESP="Acción correctiva (solución inmediata): medidas aplicadas para corregir el lote o servicio afectado."';
        PreventiveActionLbl: Label 'Preventive action (future): measures implemented to ensure it does not happen again.', Comment = 'ESP="Acción preventiva (a futuro): medidas implantadas para asegurar que no vuelva a ocurrir."';
        ResponsibleLbl: Label 'Person in charge and deadline for each action.', Comment = 'ESP="Responsable y fecha límite de cada acción."';
        ReplyLbl: Label 'You can simply reply to this email with this information. If you need any additional documentation (photos, delivery notes, etc.), please do not hesitate to ask us.', Comment = 'ESP="Pueden responder directamente a este correo con esta información. Si necesitan documentación adicional (fotografías, albaranes, etc.), no duden en solicitárnosla."';
        ApologyLbl: Label 'If you have already sent us your reply, please disregard this message and accept our apologies for the inconvenience.', Comment = 'ESP="Si ya nos han enviado su respuesta, les rogamos que ignoren este mensaje y disculpen las molestias."';
        ThanksLbl: Label 'Thank you very much for your collaboration.', Comment = 'ESP="Muchas gracias por su colaboración."';
        SignatureLbl: Label 'Kind regards,<br>Quality Department<br>%1', Comment = 'ESP="Un cordial saludo,<br>Departamento de Calidad<br>%1"';
        AutoNoticeLbl: Label 'This is an automatic reminder that is sent once a day while the incident is pending a reply.', Comment = 'ESP="Este es un recordatorio automático que se envía una vez al día mientras la incidencia esté pendiente de respuesta."';
}
