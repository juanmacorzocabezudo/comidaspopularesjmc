codeunit 53111 "JMC Email Report Mgt"
{
    [EventSubscriber(ObjectType::Table, Database::"Report Selections", 'OnAfterSetEmailAttachmentUsageFilters', '', false, false)]
    local procedure OnAfterSetEmailAttachmentUsageFilters(var ReportSelections: Record "Report Selections"; ReportUsage: Enum "Report Selection Usage")
    begin
        if ReportUsage = ReportUsage::"S.Invoice" then
            ReportSelections.SetRange("JMC Use Industry Report", false);
    end;

    procedure SendIndustryInvoice(var SalesInvoiceHeader: Record "Sales Invoice Header"; InvoiceNo: Code[20]; RecipientEmail: Text[80])
    var
        ReportSelections: Record "Report Selections";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        TempBlob: Codeunit "Temp Blob";
        ReportOutStream: OutStream;
        ReportInStream: InStream;
        RecordRef: RecordRef;
        AttachmentName: Text[250];
        EmailSubject: Text[250];
        EmailBodyLbl: Label 'Please find attached sales invoice %1.', Comment = 'ESP="Se adjunta la factura de venta %1."';
        EmailSubjectLbl: Label 'Sales Invoice %1', Comment = 'ESP="Factura de venta %1"';
        IndustryReportNotConfiguredErr: Label 'No Industry report is configured for sales invoices.', Comment = 'ESP="No hay ningún informe de Industria configurado para las facturas de venta."';
    begin
        ReportSelections.SetRange(Usage, ReportSelections.Usage::"S.Invoice");
        ReportSelections.SetRange("JMC Use Industry Report", true);
        if not ReportSelections.FindFirst() then
            Error(IndustryReportNotConfiguredErr);

        RecordRef.GetTable(SalesInvoiceHeader);
        TempBlob.CreateOutStream(ReportOutStream);
        Report.SaveAs(ReportSelections."Report ID", '', ReportFormat::Pdf, ReportOutStream, RecordRef);

        AttachmentName := InvoiceNo + '.pdf';
        EmailSubject := StrSubstNo(EmailSubjectLbl, InvoiceNo);
        EmailMessage.Create(RecipientEmail, EmailSubject, StrSubstNo(EmailBodyLbl, InvoiceNo), false);

        TempBlob.CreateInStream(ReportInStream);
        EmailMessage.AddAttachment(AttachmentName, 'application/pdf', ReportInStream);
        Email.OpenInEditor(EmailMessage);
    end;

}