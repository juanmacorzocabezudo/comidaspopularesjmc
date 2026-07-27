report 53108 "JMC Sales Cr. Memo Report"
{
    Caption = 'Sales Credit Memo Report', Comment = 'ESP="Informe de nota de abono de venta"';
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/layout/JMCSalesCrMemoReport.rdlc';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(SalesCrMemoHeader; "Sales Cr.Memo Header")
        {
            RequestFilterFields = "No.";

            column(No_SalesCrMemoHeader; "No.")
            {
            }
            column(PostingDate_SalesCrMemoHeader; Format("Posting Date", 0, '<Day,2>/<Month,2>/<Year4>'))
            {
            }
            column(DueDate_SalesCrMemoHeader; Format("Due Date", 0, '<Day,2>/<Month,2>/<Year4>'))
            {
            }
            column(PaymentTermsCode_SalesCrMemoHeader; "Payment Terms Code")
            {
            }
            column(SelltoCustomerNo_SalesCrMemoHeader; "Sell-to Customer No.")
            {
            }
            column(SelltoCustomerName_SalesCrMemoHeader; "Sell-to Customer Name")
            {
            }
            column(SelltoAddress_SalesCrMemoHeader; "Sell-to Address")
            {
            }
            column(SelltoAddress2_SalesCrMemoHeader; "Sell-to Address 2")
            {
            }
            column(SelltoCity_SalesCrMemoHeader; "Sell-to City")
            {
            }
            column(SelltoPostCode_SalesCrMemoHeader; "Sell-to Post Code")
            {
            }
            column(SelltoCounty_SalesCrMemoHeader; "Sell-to County")
            {
            }
            column(ShiptoName_SalesCrMemoHeader; "Ship-to Name")
            {
            }
            column(ShiptoAddress_SalesCrMemoHeader; "Ship-to Address")
            {
            }
            column(ShiptoAddress2_SalesCrMemoHeader; "Ship-to Address 2")
            {
            }
            column(ShiptoCity_SalesCrMemoHeader; "Ship-to City")
            {
            }
            column(ShiptoPostCode_SalesCrMemoHeader; "Ship-to Post Code")
            {
            }
            column(ShiptoCounty_SalesCrMemoHeader; "Ship-to County")
            {
            }
            column(SelltoContactNo_SalesCrMemoHeader; "Sell-to Contact No.")
            {
            }
            column(SelltoPhoneNo_SalesCrMemoHeader; "Sell-to Phone No.")
            {
            }
            column(SelltoEMail_SalesCrMemoHeader; "Sell-to E-Mail")
            {
            }
            column(ExternalDocumentNo_SalesCrMemoHeader; "External Document No.")
            {
            }
            column(AppliesToDocNo_SalesCrMemoHeader; "Applies-to Doc. No.")
            {
            }
            column(PaymentTermsDescription; PaymentTermsDescription)
            {
            }
            column(CompanyInfoName; CompanyInfo.Name)
            {
            }
            column(CompanyInfoAddress; CompanyInfo.Address)
            {
            }
            column(CompanyInfoAddress2; CompanyInfo."Address 2")
            {
            }
            column(CompanyInfoCity; CompanyInfo.City)
            {
            }
            column(CompanyInfoPostCode; CompanyInfo."Post Code")
            {
            }
            column(CompanyInfoCounty; CompanyInfo.County)
            {
            }
            column(CompanyInfoPhoneNo; CompanyInfo."Phone No.")
            {
            }
            column(CompanyInfoEMail; CompanyInfo."E-Mail")
            {
            }
            column(CompanyInfoHomePage; CompanyInfo."Home Page")
            {
            }
            column(CompanyInfoVATRegNo; CompanyInfo."VAT Registration No.")
            {
            }
            column(CompanyInfoPicture; CompanyInfo.Picture)
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

            dataitem(SalesCrMemoLine; "Sales Cr.Memo Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.");

                column(Type_SalesCrMemoLine; Type)
                {
                }
                column(No_SalesCrMemoLine; "No.")
                {
                }
                column(Description_SalesCrMemoLine; Description)
                {
                }
                column(Quantity_SalesCrMemoLine; Quantity)
                {
                }
                column(UnitofMeasure_SalesCrMemoLine; "Unit of Measure")
                {
                }
                column(UnitPrice_SalesCrMemoLine; "Unit Price")
                {
                }
                column(VATPct_SalesCrMemoLine; "VAT %")
                {
                }
                column(LineAmount_SalesCrMemoLine; "Line Amount")
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
    end;

    var
        CompanyInfo: Record "Company Information";
        Customer: Record Customer;
        BankAccount: Record "Bank Account";
        PaymentTermsDescription: Text[100];
        SubtotalAmount: Decimal;
        TotalVATAmount: Decimal;
        TotalAmount: Decimal;
}
