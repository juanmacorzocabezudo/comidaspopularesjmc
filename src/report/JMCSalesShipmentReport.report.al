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
            column(ShipmentDate_SalesShipmentHeader; Format("Requested Delivery Date", 0, '<Day,2>/<Month,2>/<Year4>'))
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
            column(OrderNo_SalesShipmentHeader; "Order No.")
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
            column(TotalLogisticsText; TotalLogisticsText)
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
                column(QtyPerLogisticsUnit_SalesShipmentLine; QtyPerLogisticsUnit)
                {
                }
                column(LogisticsUnitQty_SalesShipmentLine; LogisticsUnitQty)
                {
                }
                column(TrackingInfo_SalesShipmentLine; TrackingInfoText)
                {
                }

                trigger OnAfterGetRecord()
                var
                    ItemUnitOfMeasure: Record "Item Unit of Measure";
                    Item: Record Item;
                    ItemLedgerEntry: Record "Item Ledger Entry";
                    LogisticsUoM: Record "Item Unit of Measure";
                    LogisticsQty: Decimal;
                    LogisticsCode: Code[10];
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

                        // Calculate Total Kg (Quantity * Gross Weight)
                        TotalKg += SalesShipmentLine.Quantity * SalesShipmentLine."Gross Weight";
                    end;

                    // Calculate Logistics Unit Quantity (Cantidad / UL and Ud. Logística)
                    QtyPerLogisticsUnit := '';
                    LogisticsUnitQty := '';
                    if Type = Type::Item then begin
                        LogisticsUoM.Reset();
                        LogisticsUoM.SetRange("Item No.", "No.");
                        LogisticsUoM.SetRange("Unidad Logística Albaran", true);
                        if LogisticsUoM.FindFirst() then begin
                            if LogisticsUoM."Qty. per Unit of Measure" <> 0 then begin
                                // Cantidad / U.L.: "X UNIDAD / CÓDIGO" (ej: "4 KG / CAJA")
                                QtyPerLogisticsUnit := Format(LogisticsUoM."Qty. per Unit of Measure", 0, '<Precision,2:2><Standard Format,0>') + ' ' + "Unit of Measure Code" + ' / ' + LogisticsUoM.Code;

                                // Ud. Logística: Total unidades logísticas (ej: "70 CJ")
                                LogisticsQty := Quantity / LogisticsUoM."Qty. per Unit of Measure";
                                LogisticsCode := LogisticsUoM.Code;
                                LogisticsUnitQty := Format(LogisticsQty, 0, '<Precision,2:2><Standard Format,0>') + ' ' + LogisticsCode;

                                // Accumulate logistics totals by UoM code
                                AccumulateLogisticsTotal(LogisticsCode, LogisticsQty);

                                // Build the total text after each accumulation
                                BuildLogisticsTotalText();
                            end;
                        end;
                    end;

                    // Get Item Tracking Information
                    TrackingInfoText := '';
                    if Type = Type::Item then begin
                        ItemLedgerEntry.SetRange("Document No.", SalesShipmentLine."Document No.");
                        ItemLedgerEntry.SetRange("Document Line No.", SalesShipmentLine."Line No.");
                        ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::Sale);
                        ItemLedgerEntry.SetFilter("Lot No.", '<>%1', '');
                        if ItemLedgerEntry.FindSet() then begin
                            repeat
                                if TrackingInfoText <> '' then
                                    TrackingInfoText += ' | ';
                                TrackingInfoText += 'Lote: ' + ItemLedgerEntry."Lot No." + ', Cantidad: ' + Format(Abs(ItemLedgerEntry.Quantity), 0, '<Precision,0:3><Standard Format,0>');
                                if ItemLedgerEntry."Expiration Date" <> 0D then
                                    TrackingInfoText += ', Fecha de caducidad: ' + Format(ItemLedgerEntry."Expiration Date", 0, '<Day,2>/<Month,2>/<Year,2>');
                            until ItemLedgerEntry.Next() = 0;
                        end;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    SubtotalAmount := 0;
                    TotalVATAmount := 0;
                    TotalAmount := 0;
                    TotalBultos := 0;
                    TotalKg := 0;

                    // Initialize logistics totals
                    Clear(LogisticsUoMCodes);
                    Clear(LogisticsUoMQuantities);
                end;

                trigger OnPostDataItem()
                begin
                    // Build the total logistics text from accumulated values
                    BuildLogisticsTotalText();
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
        CalcLineAmount: Decimal;
        CalcAmountInclVAT: Decimal;
        TotalBultos: Decimal;
        TotalKg: Decimal;
        QtyPerLogisticsUnit: Text[50];
        LogisticsUnitQty: Text[50];
        TrackingInfoText: Text[250];
        LogisticsUoMCodes: List of [Code[10]];
        LogisticsUoMQuantities: List of [Decimal];
        TotalLogisticsText: Text[250];

    local procedure AccumulateLogisticsTotal(UoMCode: Code[10]; Quantity: Decimal)
    var
        i: Integer;
        CurrentCode: Code[10];
        CurrentQty: Decimal;
        Found: Boolean;
    begin
        Found := false;

        // Search if the UoM code already exists
        for i := 1 to LogisticsUoMCodes.Count do begin
            LogisticsUoMCodes.Get(i, CurrentCode);
            if CurrentCode = UoMCode then begin
                // Update existing quantity
                LogisticsUoMQuantities.Get(i, CurrentQty);
                LogisticsUoMQuantities.Set(i, CurrentQty + Quantity);
                Found := true;
                break;
            end;
        end;

        // If not found, add new entry
        if not Found then begin
            LogisticsUoMCodes.Add(UoMCode);
            LogisticsUoMQuantities.Add(Quantity);
        end;
    end;

    local procedure BuildLogisticsTotalText()
    var
        i: Integer;
        UoMCode: Code[10];
        Qty: Decimal;
    begin
        TotalLogisticsText := '';

        for i := 1 to LogisticsUoMCodes.Count do begin
            LogisticsUoMCodes.Get(i, UoMCode);
            LogisticsUoMQuantities.Get(i, Qty);

            if TotalLogisticsText <> '' then
                TotalLogisticsText += ' y ';

            TotalLogisticsText += Format(Qty, 0, '<Precision,2:2><Standard Format,0>') + ' ' + UoMCode;
        end;
    end;
}
