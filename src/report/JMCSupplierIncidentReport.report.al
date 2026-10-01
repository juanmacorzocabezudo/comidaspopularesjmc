report 53316 "JMC Supplier Incident Report"
{
    Caption = 'Supplier Incident Report', Comment = 'ESP="Informe de Incidencia de Proveedor"';
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/layout/JMCSupplierIncidentListReport.rdlc';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(Incident; "JMC Supplier Incident")
        {
            RequestFilterFields = "JMC No.", "JMC Date", "JMC Vendor No.", "JMC Detected By", "JMC Recurring Incident", "JMC Credit Memo Registered", "JMC Source Type", "JMC Vendor Responded";
            column(No_; "JMC No.") { }
            column(Date_; "JMC Date") { }
            column(VendorNo; "JMC Vendor No.") { }
            column(VendorName; "JMC Vendor Name") { }
            column(SourceType; "JMC Source Type") { }
            column(SourceDocumentNo; "JMC Source Document No.") { }
            column(DetectedBy; "JMC Detected By") { }
            column(RecurringIncident; "JMC Recurring Incident") { }
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

            dataitem(IncidentProduct; "JMC Supplier Incident Product")
            {
                DataItemLinkReference = Incident;
                DataItemLink = "JMC Incident No." = field("JMC No.");
                DataItemTableView = sorting("JMC Incident No.", "JMC Line No.");
                RequestFilterFields = "JMC Item No.";

                column(ProductNo; "JMC Item No.") { }
                column(ProductDescription; "JMC Item Description") { }
            }

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