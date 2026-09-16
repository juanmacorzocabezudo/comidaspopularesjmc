codeunit 53303 "JMC Supplier Incident Mgt"
{
    procedure CreateFromPurchaseOrder(var PurchaseHeader: Record "Purchase Header")
    var
        PurchaseLine: Record "Purchase Line";
        SelectionPage: Page "JMC Supplier Incident Lines";
    begin
        PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
        PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
        PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
        if not PurchaseLine.FindFirst() then
            Error(NoItemLinesErr);

        SelectionPage.SetTableView(PurchaseLine);
        if SelectionPage.RunModal() = Action::LookupOK then begin
            SelectionPage.GetRecord(PurchaseLine);
            CreateFromPurchaseLine(PurchaseHeader, PurchaseLine);
        end;
    end;

    procedure CreateFromAssemblyOrder(var AssemblyHeader: Record "Assembly Header")
    var
        AssemblyLine: Record "Assembly Line";
        SelectionPage: Page "JMC Assembly Incident Lines";
    begin
        AssemblyLine.SetRange("Document Type", AssemblyHeader."Document Type");
        AssemblyLine.SetRange("Document No.", AssemblyHeader."No.");
        AssemblyLine.SetRange(Type, AssemblyLine.Type::Item);
        if not AssemblyLine.FindFirst() then
            Error(NoItemLinesErr);

        SelectionPage.SetTableView(AssemblyLine);
        if SelectionPage.RunModal() = Action::LookupOK then begin
            SelectionPage.GetRecord(AssemblyLine);
            CreateFromAssemblyLine(AssemblyHeader, AssemblyLine);
        end;
    end;

    local procedure CreateFromPurchaseLine(PurchaseHeader: Record "Purchase Header"; PurchaseLine: Record "Purchase Line")
    var
        Incident: Record "JMC Supplier Incident";
    begin
        Incident.Init();
        Incident."JMC No. Series" := DefaultNoSeriesCode;
        Incident."JMC Vendor No." := PurchaseHeader."Buy-from Vendor No.";
        Incident."JMC Source Type" := Incident."JMC Source Type"::"Purchase Order";
        Incident."JMC Source Document No." := PurchaseHeader."No.";
        Incident."JMC Source Line No." := PurchaseLine."Line No.";
        Incident."JMC Item No." := PurchaseLine."No.";
        Incident."JMC Item Description" := PurchaseLine.Description;
        Incident.Insert(true);
        Page.Run(Page::"JMC Supplier Incident Card", Incident);
    end;

    local procedure CreateFromAssemblyLine(AssemblyHeader: Record "Assembly Header"; AssemblyLine: Record "Assembly Line")
    var
        Incident: Record "JMC Supplier Incident";
        Item: Record Item;
    begin
        Incident.Init();
        Incident."JMC No. Series" := DefaultNoSeriesCode;
        Incident."JMC Source Type" := Incident."JMC Source Type"::"Assembly Order";
        Incident."JMC Source Document No." := AssemblyHeader."No.";
        Incident."JMC Source Line No." := AssemblyLine."Line No.";
        Incident."JMC Item No." := AssemblyLine."No.";
        Incident."JMC Item Description" := AssemblyLine.Description;
        if Item.Get(AssemblyLine."No.") then
            Incident."JMC Vendor No." := Item."Vendor No.";
        Incident.Insert(true);
        Page.Run(Page::"JMC Supplier Incident Card", Incident);
    end;

    procedure PrintAndSend(var Incident: Record "JMC Supplier Incident")
    var
        Vendor: Record Vendor;
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        TempBlob: Codeunit "Temp Blob";
        ReportOutStream: OutStream;
        ReportInStream: InStream;
        RecordRef: RecordRef;
        RecipientEmail: Text[250];
    begin
        if Vendor.Get(Incident."JMC Vendor No.") then
            RecipientEmail := Vendor."E-Mail";
        EmailMessage.Create(RecipientEmail, StrSubstNo(IncidentSubjectLbl, Incident."JMC No."), '', false);
        RecordRef.GetTable(Incident);
        TempBlob.CreateOutStream(ReportOutStream);
        Report.SaveAs(Report::"JMC Supplier Incident Report", '', ReportFormat::Pdf, ReportOutStream, RecordRef);
        TempBlob.CreateInStream(ReportInStream);
        EmailMessage.AddAttachment(Incident."JMC No." + '.pdf', 'application/pdf', ReportInStream);
        Email.OpenInEditor(EmailMessage);
    end;

    var
        NoItemLinesErr: Label 'The document does not contain item lines.', Comment = 'ESP="El documento no contiene líneas de producto."';
        DefaultNoSeriesCode: Label 'JMCINC', Comment = 'ESP="JMCINC"';
        IncidentSubjectLbl: Label 'Supplier incident No. %1', Comment = 'ESP="Incidencia proveedor Nº %1"';
}