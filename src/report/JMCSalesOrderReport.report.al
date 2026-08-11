report 53105 "JMC Sales Order Report"
{
    Caption = 'Sales Order Report', Comment = 'ESP="Informe de pedido de venta"';
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/layout/JMCSalesOrderReport.rdlc';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(SalesHeader; "Sales Header")
        {
            DataItemTableView = SORTING("Document Type", "No.") WHERE("Document Type" = CONST(Order));
            RequestFilterFields = "No.";

            column(No_SalesHeader; "No.")
            {
            }
            column(DocumentDate_SalesHeader; Format("Document Date", 0, '<Day,2>/<Month,2>/<Year4>'))
            {
            }
            column(RequestedDeliveryDate_SalesHeader; Format("Requested Delivery Date", 0, '<Day,2>/<Month,2>/<Year4>'))
            {
            }
            column(PaymentTermsCode_SalesHeader; "Payment Terms Code")
            {
            }
            column(SelltoCustomerNo_SalesHeader; "Sell-to Customer No.")
            {
            }
            column(SelltoCustomerName_SalesHeader; "Sell-to Customer Name")
            {
            }
            column(SelltoAddress_SalesHeader; "Sell-to Address")
            {
            }
            column(SelltoAddress2_SalesHeader; "Sell-to Address 2")
            {
            }
            column(SelltoCity_SalesHeader; "Sell-to City")
            {
            }
            column(SelltoPostCode_SalesHeader; "Sell-to Post Code")
            {
            }
            column(SelltoCounty_SalesHeader; "Sell-to County")
            {
            }
            column(ShiptoName_SalesHeader; "Ship-to Name")
            {
            }
            column(ShiptoAddress_SalesHeader; "Ship-to Address")
            {
            }
            column(ShiptoAddress2_SalesHeader; "Ship-to Address 2")
            {
            }
            column(ShiptoCity_SalesHeader; "Ship-to City")
            {
            }
            column(ShiptoPostCode_SalesHeader; "Ship-to Post Code")
            {
            }
            column(ShiptoCounty_SalesHeader; "Ship-to County")
            {
            }
            column(SelltoContactNo_SalesHeader; "Sell-to Contact No.")
            {
            }
            column(SelltoPhoneNo_SalesHeader; "Sell-to Phone No.")
            {
            }
            column(SelltoEMail_SalesHeader; "Sell-to E-Mail")
            {
            }
            column(ExternalDocumentNo_SalesHeader; "External Document No.")
            {
            }

            // Company Information columns
            column(CompanyName; SalesSetup."JMC Company Name")
            {
            }
            column(CompanyAddress; SalesSetup."JMC Company Address")
            {
            }
            column(CompanyAddress2; SalesSetup."JMC Company Address 2")
            {
            }
            column(CompanyCity; SalesSetup."JMC Company City")
            {
            }
            column(CompanyPostCode; SalesSetup."JMC Company Post Code")
            {
            }
            column(CompanyCounty; SalesSetup."JMC Company County")
            {
            }
            column(CompanyPhoneNo; SalesSetup."JMC Company Phone No.")
            {
            }
            column(CompanyEMail; SalesSetup."JMC Company E-Mail")
            {
            }
            column(CompanyHomePage; SalesSetup."JMC Company Home Page")
            {
            }
            column(CompanyVATRegistrationNo; SalesSetup."JMC Company VAT Reg. No.")
            {
            }
            column(CompanyPicture; CompanyInfo.Picture)
            {
            }

            // Customer additional information
            column(CustomerVATRegistrationNo; Customer."VAT Registration No.")
            {
            }
            column(CustomerContactName; SalesHeader."Sell-to Contact")
            {
            }

            // Payment Terms description
            column(PaymentTermsDescription; PaymentTerms.Description)
            {
            }

            // Bank Information
            column(CompanyBankCode; CompanyBankCode)
            {
            }
            column(CompanyBankName; CompanyBankName)
            {
            }
            column(CompanyBankIBAN; CompanyBankIBAN)
            {
            }

            // Totals
            column(SubtotalAmount; SubtotalAmount)
            {
            }
            column(TotalVATAmount; TotalVATAmount)
            {
            }
            column(TotalAmount; TotalAmount)
            {
            }

            dataitem(SalesLine; "Sales Line")
            {
                DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.") WHERE(Type = FILTER(<> ' '), Quantity = FILTER(<> 0));

                column(LineNo_SalesLine; "Line No.")
                {
                }
                column(No_SalesLine; "No.")
                {
                }
                column(Description_SalesLine; Description)
                {
                }
                column(Quantity_SalesLine; Quantity)
                {
                }
                column(UnitofMeasure_SalesLine; "Unit of Measure")
                {
                }
                column(UnitPrice_SalesLine; "Unit Price")
                {
                }
                column(LineDiscount_SalesLine; "Line Discount %")
                {
                }
                column(LineAmount_SalesLine; "Line Amount")
                {
                }
                column(VATPct_SalesLine; "VAT %")
                {
                }
                column(LineAmountInclVAT_SalesLine; "Amount Including VAT")
                {
                }
                column(QtyPerUnitOfMeasure_SalesLine; QtyPerUnitOfMeasure)
                {
                }
                column(LogisticsUnitQty_SalesLine; LogisticsUnitQty)
                {
                }

                trigger OnAfterGetRecord()
                var
                    ItemUnitOfMeasure: Record "Item Unit of Measure";
                    LogisticsUoM: Record "Item Unit of Measure";
                    LogisticsQty: Decimal;
                    LogisticsCode: Code[10];
                begin
                    SubtotalAmount += "Line Amount";
                    TotalVATAmount += "Amount Including VAT" - "Line Amount";
                    TotalAmount += "Amount Including VAT";

                    // Calculate Qty per Unit of Measure
                    QtyPerUnitOfMeasure := 0;
                    if (Type = Type::Item) and (SalesLine."Unit of Measure Code" <> '') then begin
                        if ItemUnitOfMeasure.Get(SalesLine."No.", SalesLine."Unit of Measure Code") then
                            if ItemUnitOfMeasure."Qty. per Unit of Measure" <> 0 then
                                QtyPerUnitOfMeasure := SalesLine.Quantity / ItemUnitOfMeasure."Qty. per Unit of Measure";
                    end;

                    // Calculate Logistics Unit Quantity (Ud. Logística)
                    LogisticsUnitQty := '';
                    if Type = Type::Item then begin
                        LogisticsUoM.SetRange("Item No.", SalesLine."No.");
                        LogisticsUoM.SetRange("Unidad Logística Albaran", true);
                        if LogisticsUoM.FindFirst() then begin
                            if LogisticsUoM."Qty. per Unit of Measure" <> 0 then begin
                                // Ud. Logística: Total unidades logísticas (ej: "70 CJ")
                                LogisticsQty := SalesLine.Quantity / LogisticsUoM."Qty. per Unit of Measure";
                                LogisticsCode := LogisticsUoM.Code;
                                LogisticsUnitQty := Format(LogisticsQty, 0, '<Precision,2:2><Standard Format,0>') + ' ' + LogisticsCode;
                            end;
                        end;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    SubtotalAmount := 0;
                    TotalVATAmount := 0;
                    TotalAmount := 0;
                end;
            }

            trigger OnPreDataItem()
            begin
                // Remove customer filter that BC might add automatically when selecting multiple records
                SetRange("Sell-to Customer No.");
            end;

            trigger OnAfterGetRecord()
            begin
                // Get Company Information
                if not SalesSetupRead then begin
                    CompanyInfo.Get();
                    CompanyInfo.CalcFields(Picture);
                    SalesSetup.Get();
                    SalesSetupRead := true;
                end;

                // Get Customer
                if Customer.Get("Sell-to Customer No.") then begin
                    // Get Bank Information from Customer (CodBancoEmpresa field 50002 from CP-Functionality)
                    CompanyBankName := '';
                    CompanyBankIBAN := '';

                    if BankAccount.Get(Customer.CodBancoEmpresa) then begin
                        CompanyBankName := BankAccount.Name;
                        CompanyBankIBAN := BankAccount.IBAN;
                    end;
                end;

                // Get Payment Terms
                if PaymentTerms.Get("Payment Terms Code") then;
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

    var
        CompanyInfo: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        Customer: Record Customer;
        PaymentTerms: Record "Payment Terms";
        BankAccount: Record "Bank Account";
        SalesSetupRead: Boolean;
        SubtotalAmount: Decimal;
        TotalVATAmount: Decimal;
        TotalAmount: Decimal;
        CompanyBankCode: Code[20];
        CompanyBankName: Text[100];
        CompanyBankIBAN: Code[50];
        QtyPerUnitOfMeasure: Decimal;
        LogisticsUnitQty: Text[50];
}
