report 53107 "JMC Sales Invoice Report"
{
    Caption = 'Sales Invoice Report', Comment = 'ESP="Informe de factura de venta"';
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/layout/JMCSalesInvoiceReport.rdlc';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(SalesInvoiceHeader; "Sales Invoice Header")
        {
            RequestFilterFields = "No.";

            column(No_SalesInvoiceHeader; "No.")
            {
            }
            column(PostingDate_SalesInvoiceHeader; Format("Posting Date", 0, '<Day,2>/<Month,2>/<Year4>'))
            {
            }
            column(DueDate_SalesInvoiceHeader; Format("Due Date", 0, '<Day,2>/<Month,2>/<Year4>'))
            {
            }
            column(PaymentTermsCode_SalesInvoiceHeader; "Payment Terms Code")
            {
            }
            column(SelltoCustomerNo_SalesInvoiceHeader; "Sell-to Customer No.")
            {
            }
            column(SelltoCustomerName_SalesInvoiceHeader; "Sell-to Customer Name")
            {
            }
            column(CustomerVATRegistrationNo; Customer."VAT Registration No.")
            {
            }
            column(VATRegistrationNo_SalesInvoiceHeader; "VAT Registration No.")
            {
            }
            column(SelltoAddress_SalesInvoiceHeader; "Sell-to Address")
            {
            }
            column(SelltoAddress2_SalesInvoiceHeader; "Sell-to Address 2")
            {
            }
            column(SelltoCity_SalesInvoiceHeader; "Sell-to City")
            {
            }
            column(SelltoPostCode_SalesInvoiceHeader; "Sell-to Post Code")
            {
            }
            column(SelltoCounty_SalesInvoiceHeader; "Sell-to County")
            {
            }
            column(ShiptoName_SalesInvoiceHeader; "Ship-to Name")
            {
            }
            column(ShiptoAddress_SalesInvoiceHeader; "Ship-to Address")
            {
            }
            column(ShiptoAddress2_SalesInvoiceHeader; "Ship-to Address 2")
            {
            }
            column(ShiptoCity_SalesInvoiceHeader; "Ship-to City")
            {
            }
            column(ShiptoPostCode_SalesInvoiceHeader; "Ship-to Post Code")
            {
            }
            column(ShiptoCounty_SalesInvoiceHeader; "Ship-to County")
            {
            }
            column(SelltoContactNo_SalesInvoiceHeader; "Sell-to Contact No.")
            {
            }
            column(SelltoPhoneNo_SalesInvoiceHeader; "Sell-to Phone No.")
            {
            }
            column(SelltoEMail_SalesInvoiceHeader; "Sell-to E-Mail")
            {
            }
            column(ExternalDocumentNo_SalesInvoiceHeader; "External Document No.")
            {
            }
            column(PaymentTermsDescription; PaymentTermsDescription)
            {
            }
            column(CompanyInfoName; SalesSetup."JMC Company Name")
            {
            }
            column(CompanyInfoAddress; SalesSetup."JMC Company Address")
            {
            }
            column(CompanyInfoAddress2; SalesSetup."JMC Company Address 2")
            {
            }
            column(CompanyInfoCity; SalesSetup."JMC Company City")
            {
            }
            column(CompanyInfoPostCode; SalesSetup."JMC Company Post Code")
            {
            }
            column(CompanyInfoCounty; SalesSetup."JMC Company County")
            {
            }
            column(CompanyInfoPhoneNo; SalesSetup."JMC Company Phone No.")
            {
            }
            column(CompanyInfoEMail; SalesSetup."JMC Company E-Mail")
            {
            }
            column(CompanyInfoHomePage; SalesSetup."JMC Company Home Page")
            {
            }
            column(CompanyInfoVATRegNo; SalesSetup."JMC Company VAT Reg. No.")
            {
            }
            column(CompanyInfoPicture; CompanyInfo.Picture)
            {
            }
            column(CompanyInfoInsuranceLogo; SalesSetup."JMC Sales Doc Insurance Logo")
            {
            }
            column(CompanyBankCode; Customer.CodBancoEmpresa)
            {
            }
            column(CompanyBankName; BankAccount.Name)
            {
            }
            column(CompanyBankIBAN; BankAccount.IBAN)
            {
            }
            column(SubtotalAmount; SubtotalAmount)
            {
            }
            column(TotalVATAmount; TotalVATAmount)
            {
            }
            column(TotalAmount; TotalAmount)
            {
            }

            dataitem(SalesInvoiceLine; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.");

                column(Type_SalesInvoiceLine; Type)
                {
                }
                column(No_SalesInvoiceLine; "No.")
                {
                }
                column(Description_SalesInvoiceLine; Description)
                {
                }
                column(Quantity_SalesInvoiceLine; Quantity)
                {
                }
                column(UnitofMeasure_SalesInvoiceLine; "Unit of Measure")
                {
                }
                column(UnitPrice_SalesInvoiceLine; "Unit Price")
                {
                }
                column(VATPct_SalesInvoiceLine; "VAT %")
                {
                }
                column(LineAmount_SalesInvoiceLine; "Line Amount")
                {
                }

                trigger OnPreDataItem()
                begin
                    SubtotalAmount := 0;
                    TotalVATAmount := 0;
                    TotalAmount := 0;
                end;

                trigger OnAfterGetRecord()
                begin
                    SubtotalAmount += "Line Amount";
                    TotalVATAmount += "Amount Including VAT" - "Line Amount";
                    TotalAmount += "Amount Including VAT";
                end;
            }

            trigger OnPreDataItem()
            begin
                // Remove automatic customer filter to allow multi-document selection
                SetRange("Sell-to Customer No.");
            end;

            trigger OnAfterGetRecord()
            var
                PaymentTerms: Record "Payment Terms";
            begin
                // Get Payment Terms Description
                PaymentTermsDescription := '';
                if PaymentTerms.Get("Payment Terms Code") then
                    PaymentTermsDescription := PaymentTerms.Description;

                // Get bank information via Customer field
                if Customer.Get("Sell-to Customer No.") then begin
                    if Customer.CodBancoEmpresa <> '' then begin
                        if BankAccount.Get(Customer.CodBancoEmpresa) then;
                    end;
                end;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options', Comment = 'ESP="Opciones"';
                }
            }
        }
    }

    trigger OnPreReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
        SalesSetup.Get();
        SalesSetup.CalcFields("JMC Sales Doc Insurance Logo");
    end;

    var
        CompanyInfo: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        Customer: Record Customer;
        BankAccount: Record "Bank Account";
        PaymentTermsDescription: Text[100];
        SubtotalAmount: Decimal;
        TotalVATAmount: Decimal;
        TotalAmount: Decimal;
}

