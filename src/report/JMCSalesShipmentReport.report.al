report 53106 "JMC Sales Shipment Report"
{
    Caption = 'Sales Shipment Report', Comment = 'ESP="Informe de albarán de venta"';
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/layout/JMCSalesShipmentReport.rdlc';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(SalesShipmentHeader; "Sales Shipment Header")
        {
            RequestFilterFields = "No.";

            column(No_SalesShipmentHeader; "No.")
            {
            }
            column(DocumentDate_SalesShipmentHeader; Format("Document Date", 0, '<Day,2>/<Month,2>/<Year4>'))
            {
            }
            column(ShipmentDate_SalesShipmentHeader; Format("Shipment Date", 0, '<Day,2>/<Month,2>/<Year4>'))
            {
            }
            column(PaymentTermsCode_SalesShipmentHeader; "Payment Terms Code")
            {
            }
            column(SelltoCustomerNo_SalesShipmentHeader; "Sell-to Customer No.")
            {
            }
            column(SelltoCustomerName_SalesShipmentHeader; "Sell-to Customer Name")
            {
            }
            column(SelltoAddress_SalesShipmentHeader; "Sell-to Address")
            {
            }
            column(SelltoAddress2_SalesShipmentHeader; "Sell-to Address 2")
            {
            }
            column(SelltoCity_SalesShipmentHeader; "Sell-to City")
            {
            }
            column(SelltoPostCode_SalesShipmentHeader; "Sell-to Post Code")
            {
            }
            column(SelltoCounty_SalesShipmentHeader; "Sell-to County")
            {
            }
            column(ShiptoName_SalesShipmentHeader; "Ship-to Name")
            {
            }
            column(ShiptoAddress_SalesShipmentHeader; "Ship-to Address")
            {
            }
            column(ShiptoAddress2_SalesShipmentHeader; "Ship-to Address 2")
            {
            }
            column(ShiptoCity_SalesShipmentHeader; "Ship-to City")
            {
            }
            column(ShiptoPostCode_SalesShipmentHeader; "Ship-to Post Code")
            {
            }
            column(ShiptoCounty_SalesShipmentHeader; "Ship-to County")
            {
            }
            column(SelltoContactNo_SalesShipmentHeader; "Sell-to Contact No.")
            {
            }
            column(SelltoPhoneNo_SalesShipmentHeader; "Sell-to Phone No.")
            {
            }
            column(SelltoEMail_SalesShipmentHeader; "Sell-to E-Mail")
            {
            }
            column(ExternalDocumentNo_SalesShipmentHeader; "External Document No.")
            {
            }

            // Company Information columns
            column(CompanyName; CompanyInfo.Name)
            {
            }
            column(CompanyAddress; CompanyInfo.Address)
            {
            }
            column(CompanyAddress2; CompanyInfo."Address 2")
            {
            }
            column(CompanyCity; CompanyInfo.City)
            {
            }
            column(CompanyPostCode; CompanyInfo."Post Code")
            {
            }
            column(CompanyCounty; CompanyInfo.County)
            {
            }
            column(CompanyPhoneNo; CompanyInfo."Phone No.")
            {
            }
            column(CompanyEMail; CompanyInfo."E-Mail")
            {
            }
            column(CompanyHomePage; CompanyInfo."Home Page")
            {
            }
            column(CompanyVATRegistrationNo; CompanyInfo."VAT Registration No.")
            {
            }
            column(CompanyPicture; CompanyInfo.Picture)
            {
            }

            // Customer additional information
            column(CustomerVATRegistrationNo; Customer."VAT Registration No.")
            {
            }
            column(CustomerContactName; SalesShipmentHeader."Sell-to Contact")
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
            column(TotalBultos; TotalBultos)
            {
            }
            column(TotalKg; TotalKg)
            {
            }

            dataitem(SalesShipmentLine; "Sales Shipment Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.") WHERE(Type = FILTER(<> ' '), Quantity = FILTER(<> 0));

                column(LineNo_SalesShipmentLine; "Line No.")
                {
                }
                column(No_SalesShipmentLine; "No.")
                {
                }
                column(Description_SalesShipmentLine; Description)
                {
                }
                column(Quantity_SalesShipmentLine; Quantity)
                {
                }
                column(UnitofMeasure_SalesShipmentLine; "Unit of Measure")
                {
                }
                column(UnitPrice_SalesShipmentLine; "Unit Price")
                {
                }
                column(LineDiscount_SalesShipmentLine; "Line Discount %")
                {
                }
                column(LineAmount_SalesShipmentLine; CalcLineAmount)
                {
                }
                column(VATPct_SalesShipmentLine; "VAT %")
                {
                }
                column(LineAmountInclVAT_SalesShipmentLine; CalcAmountInclVAT)
                {
                }
                column(QtyPerUnitOfMeasure_SalesShipmentLine; QtyPerUnitOfMeasure)
                {
                }

                trigger OnAfterGetRecord()
                var
                    ItemUnitOfMeasure: Record "Item Unit of Measure";
                    Item: Record Item;
                begin
                    // Calculate amounts (not stored in posted shipment)
                    CalcLineAmount := Round(Quantity * "Unit Price");
                    CalcAmountInclVAT := CalcLineAmount + Round(CalcLineAmount * "VAT %" / 100);

                    SubtotalAmount += CalcLineAmount;
                    TotalVATAmount += CalcAmountInclVAT - CalcLineAmount;
                    TotalAmount += CalcAmountInclVAT;

                    // Calculate Qty per Unit of Measure and Total Bultos
                    QtyPerUnitOfMeasure := 0;
                    if (Type = Type::Item) and (SalesShipmentLine."Unit of Measure Code" <> '') then begin
                        if ItemUnitOfMeasure.Get(SalesShipmentLine."No.", SalesShipmentLine."Unit of Measure Code") then
                            if ItemUnitOfMeasure."Qty. per Unit of Measure" <> 0 then begin
                                QtyPerUnitOfMeasure := SalesShipmentLine.Quantity / ItemUnitOfMeasure."Qty. per Unit of Measure";
                                TotalBultos += QtyPerUnitOfMeasure;
                            end;

                        // Calculate Total Kg
                        if Item.Get(SalesShipmentLine."No.") then
                            TotalKg += SalesShipmentLine.Quantity * Item."JMC Weight";
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    SubtotalAmount := 0;
                    TotalVATAmount := 0;
                    TotalAmount := 0;
                    TotalBultos := 0;
                    TotalKg := 0;
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
                if not CompanyInfoRead then begin
                    CompanyInfo.Get();
                    CompanyInfo.CalcFields(Picture);
                    CompanyInfoRead := true;
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
        Customer: Record Customer;
        PaymentTerms: Record "Payment Terms";
        BankAccount: Record "Bank Account";
        CompanyInfoRead: Boolean;
        SubtotalAmount: Decimal;
        TotalVATAmount: Decimal;
        TotalAmount: Decimal;
        CompanyBankCode: Code[20];
        CompanyBankName: Text[100];
        CompanyBankIBAN: Code[50];
        QtyPerUnitOfMeasure: Decimal;
        CalcLineAmount: Decimal;
        CalcAmountInclVAT: Decimal;
        TotalBultos: Decimal;
        TotalKg: Decimal;
}
