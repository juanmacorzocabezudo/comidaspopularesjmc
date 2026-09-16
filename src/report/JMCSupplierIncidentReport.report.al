report 53316 "JMC Supplier Incident Report"
{
    Caption = 'Supplier Incident Report', Comment = 'ESP="Informe de Incidencia de Proveedor"';
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/layout/JMCSupplierIncidentReport.rdlc';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(Incident; "JMC Supplier Incident")
        {
            RequestFilterFields = "JMC No.", "JMC Date", "JMC Vendor No.", "JMC Item No.", "JMC Detected By", "JMC Recurring Incident", "JMC Credit Memo Registered", "JMC Source Type";
            column(No_; "JMC No.") { }
            column(Date_; "JMC Date") { }
            column(VendorNo; "JMC Vendor No.") { }
            column(VendorName; "JMC Vendor Name") { }
            column(SourceType; "JMC Source Type") { }
            column(SourceDocumentNo; "JMC Source Document No.") { }
            column(ItemNo; "JMC Item No.") { }
            column(ItemDescription; "JMC Item Description") { }
            column(LotNo; "JMC Lot No.") { }
            column(DetectedBy; "JMC Detected By") { }
            column(RecurringIncident; "JMC Recurring Incident") { }
            column(NCNo; "JMC NC No.") { }
            column(IncidentDescription; "JMC Incident Description") { }
            column(SupplierCommunication; "JMC Supplier Communication") { }
            column(CommunicationDate; "JMC Communication Date") { }
            column(SupplierResponse; "JMC Supplier Response") { }
            column(CorrectiveMeasures; "JMC Corrective Measures") { }
            column(CreditMemoRegistered; "JMC Credit Memo Registered") { }
            column(CreatedBy; "JMC Created By") { }
            column(CreationDateTime; "JMC Creation DateTime") { }
            column(CompanyName; CompanyInfo.Name) { }
            column(CompanyPicture; CompanyInfo.Picture) { }

            trigger OnAfterGetRecord()
            begin
                CalcFields("JMC Vendor Name");
            end;

            trigger OnPreDataItem()
            begin
                CompanyInfo.Get();
                CompanyInfo.CalcFields(Picture);
            end;
        }
    }

    var
        CompanyInfo: Record "Company Information";
}