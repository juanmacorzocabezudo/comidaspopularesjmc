codeunit 53100 "JMC Events"
{
    [EventSubscriber(ObjectType::Table, Database::"G/L Account Category", 'OnGetBalanceOnAfterGetTotaling', '', false, false)]
    local procedure OnGetBalanceOnAfterGetTotaling(var GLAccountCategory: Record "G/L Account Category"; TotalingStr: Text; var Balance: Decimal; var IsHandled: Boolean)
    var
        GLEntry: Record "G/L Entry";
        CorrectedTotaling: Text;
    begin
        if not TotalingStr.EndsWith('|') then
            exit;

        // Fix the truncated filter by removing trailing pipe
        CorrectedTotaling := TotalingStr.TrimEnd('|');

        // Calculate balance with corrected filter
        GLEntry.SetFilter("G/L Account No.", CorrectedTotaling);
        GLEntry.CalcSums(Amount);
        Balance += GLEntry.Amount;

        // Prevent standard code from executing with broken filter
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertPurchaseLine(var Rec: Record "Purchase Line"; RunTrigger: Boolean)
    var
        PurchHeader: Record "Purchase Header";
    begin
        if Rec.IsTemporary() then
            exit;

        // Get header and copy custom fields to the line
        if PurchHeader.Get(Rec."Document Type", Rec."Document No.") then begin
            Rec."JMC Purchase Order Reason Code" := PurchHeader."JMC Purchase Order Reason Code";
            Rec."JMC Purchase Order Method Code" := PurchHeader."JMC Purchase Order Method Code";
            Rec.Modify(true);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterValidateEvent', 'Type', false, false)]
    local procedure OnAfterValidateTypePurchaseLine(var Rec: Record "Purchase Line"; var xRec: Record "Purchase Line"; CurrFieldNo: Integer)
    var
        PurchHeader: Record "Purchase Header";
    begin
        if Rec.IsTemporary() then
            exit;

        // Reapply custom fields after Type validation (Type validation can reset fields)
        if PurchHeader.Get(Rec."Document Type", Rec."Document No.") then begin
            if Rec."JMC Purchase Order Reason Code" = '' then
                Rec."JMC Purchase Order Reason Code" := PurchHeader."JMC Purchase Order Reason Code";
            if Rec."JMC Purchase Order Method Code" = '' then
                Rec."JMC Purchase Order Method Code" := PurchHeader."JMC Purchase Order Method Code";
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterValidateEvent', 'JMC Purchase Order Reason Code', false, false)]
    local procedure OnAfterValidateReasonCodePurchHeader(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header"; CurrFieldNo: Integer)
    var
        PurchLine: Record "Purchase Line";
    begin
        if Rec.IsTemporary() then
            exit;

        // Propagate reason code to all lines when header field is validated
        PurchLine.SetRange("Document Type", Rec."Document Type");
        PurchLine.SetRange("Document No.", Rec."No.");
        if PurchLine.FindSet(true) then
            repeat
                if PurchLine."JMC Purchase Order Reason Code" <> Rec."JMC Purchase Order Reason Code" then begin
                    PurchLine."JMC Purchase Order Reason Code" := Rec."JMC Purchase Order Reason Code";
                    PurchLine.Modify(true);
                end;
            until PurchLine.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterValidateEvent', 'JMC Purchase Order Method Code', false, false)]
    local procedure OnAfterValidateMethodCodePurchHeader(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header"; CurrFieldNo: Integer)
    var
        PurchLine: Record "Purchase Line";
    begin
        if Rec.IsTemporary() then
            exit;

        // Propagate method code to all lines when header field is validated
        PurchLine.SetRange("Document Type", Rec."Document Type");
        PurchLine.SetRange("Document No.", Rec."No.");
        if PurchLine.FindSet(true) then
            repeat
                if PurchLine."JMC Purchase Order Method Code" <> Rec."JMC Purchase Order Method Code" then begin
                    PurchLine."JMC Purchase Order Method Code" := Rec."JMC Purchase Order Method Code";
                    PurchLine.Modify(true);
                end;
            until PurchLine.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeCheckAvailableCreditLimit', '', false, false)]
    local procedure OnBeforeCheckAvailableCreditLimit(var SalesHeader: Record "Sales Header"; var ReturnValue: Decimal; var IsHandled: Boolean)
    var
        Customer: Record Customer;
        CreditLimitMsg: Label 'AVISO: El cliente %1 ha superado su límite de crédito.\\\\Límite de crédito: %2\\Pedidos abiertos: %3\\Pedidos lanzados: %4\\Facturas pendientes: %5\\Facturas sin registrar: %6\\Notas de abono pendientes: %7\\Total: %8\\Excedido: %9', Comment = 'ESP="AVISO: El cliente %1 ha superado su límite de crédito.\\\\Límite de crédito: %2\\Pedidos abiertos: %3\\Pedidos lanzados: %4\\Facturas pendientes: %5\\Facturas sin registrar: %6\\Notas de abono pendientes: %7\\Total: %8\\Excedido: %9"';
        TotalAmount: Decimal;
        ExceededAmount: Decimal;
        OpenOrdersAmount: Decimal;
        ReleasedOrdersAmount: Decimal;
        UnpostedInvoicesAmount: Decimal;
        PendingCreditMemosAmount: Decimal;
    begin
        // Solo verificar en Ofertas, Pedidos y Facturas (no en Abonos ni Devoluciones)
        if not (SalesHeader."Document Type" in [SalesHeader."Document Type"::Quote,
                                                  SalesHeader."Document Type"::Order,
                                                  SalesHeader."Document Type"::Invoice]) then
            exit;

        if not Customer.Get(SalesHeader."Sell-to Customer No.") then
            exit;

        // Verificar si ya se mostró el aviso para este documento
        if SalesHeader."JMC Credit Limit Warning Shown" then
            exit;

        // Verificar si tiene límite de crédito configurado
        if Customer."Credit Limit (LCY)" = 0 then
            exit;

        // Calcular pedidos abiertos (no lanzados) y pedidos lanzados (enviados no facturados)
        OpenOrdersAmount := CalculateOpenSalesOrders(Customer."No.");
        Customer.CalcFields("Balance (LCY)", "Shipped Not Invoiced (LCY)", "Outstanding Invoices (LCY)");
        ReleasedOrdersAmount := Customer."Shipped Not Invoiced (LCY)";
        UnpostedInvoicesAmount := Customer."Outstanding Invoices (LCY)";
        PendingCreditMemosAmount := CalculatePendingCreditMemos(Customer."No.");

        // Calcular total: pedidos abiertos + pedidos lanzados + facturas pendientes (registradas) + facturas sin registrar
        // NOTA: Los abonos pendientes NO se restan del total (solo son informativos hasta que se registren)
        TotalAmount := OpenOrdersAmount + ReleasedOrdersAmount + Customer."Balance (LCY)" + UnpostedInvoicesAmount;

        // Si se excede el límite, mostrar mensaje y enviar email
        if TotalAmount > Customer."Credit Limit (LCY)" then begin
            ExceededAmount := TotalAmount - Customer."Credit Limit (LCY)";
            Message(CreditLimitMsg,
                Customer."No." + ' - ' + Customer.Name,
                Customer."Credit Limit (LCY)",
                OpenOrdersAmount,
                ReleasedOrdersAmount,
                Customer."Balance (LCY)",
                UnpostedInvoicesAmount,
                PendingCreditMemosAmount,
                TotalAmount,
                ExceededAmount);

            // Enviar notificación por email
            SendCreditLimitEmail(Customer, TotalAmount, ExceededAmount, SalesHeader."Document Type", SalesHeader."No.", OpenOrdersAmount, ReleasedOrdersAmount, UnpostedInvoicesAmount, PendingCreditMemosAmount);

            // Marcar que ya se mostró el aviso para este documento
            SalesHeader."JMC Credit Limit Warning Shown" := true;
            SalesHeader.Modify(false);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnUpdateAmountOnBeforeCheckCreditLimit', '', false, false)]
    local procedure OnUpdateAmountOnBeforeCheckCreditLimit(var SalesLine: Record "Sales Line"; var IsHandled: Boolean; CurrentFieldNo: Integer)
    var
        Customer: Record Customer;
        SalesHeader: Record "Sales Header";
        CreditLimitMsg: Label 'AVISO: El cliente %1 ha superado su límite de crédito.\\\\Límite de crédito: %2\\Pedidos abiertos: %3\\Pedidos lanzados: %4\\Facturas pendientes: %5\\Facturas sin registrar: %6\\Notas de abono pendientes: %7\\Total: %8\\Excedido: %9', Comment = 'ESP="AVISO: El cliente %1 ha superado su límite de crédito.\\\\Límite de crédito: %2\\Pedidos abiertos: %3\\Pedidos lanzados: %4\\Facturas pendientes: %5\\Facturas sin registrar: %6\\Notas de abono pendientes: %7\\Total: %8\\Excedido: %9"';
        TotalAmount: Decimal;
        ExceededAmount: Decimal;
        OpenOrdersAmount: Decimal;
        ReleasedOrdersAmount: Decimal;
        UnpostedInvoicesAmount: Decimal;
        PendingCreditMemosAmount: Decimal;
    begin
        // Solo verificar en Ofertas, Pedidos y Facturas (no en Abonos ni Devoluciones)
        if not (SalesLine."Document Type" in [SalesLine."Document Type"::Quote,
                                                SalesLine."Document Type"::Order,
                                                SalesLine."Document Type"::Invoice]) then
            exit;

        // Obtener el header para verificar si ya se mostró el aviso
        if not SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.") then
            exit;

        // Verificar si ya se mostró el aviso para este documento
        if SalesHeader."JMC Credit Limit Warning Shown" then
            exit;

        if not Customer.Get(SalesLine."Sell-to Customer No.") then
            exit;

        // Verificar si tiene límite de crédito configurado
        if Customer."Credit Limit (LCY)" = 0 then
            exit;

        // Calcular pedidos abiertos (no lanzados) y pedidos lanzados (enviados no facturados)
        OpenOrdersAmount := CalculateOpenSalesOrders(Customer."No.");
        Customer.CalcFields("Balance (LCY)", "Shipped Not Invoiced (LCY)", "Outstanding Invoices (LCY)");
        ReleasedOrdersAmount := Customer."Shipped Not Invoiced (LCY)";
        UnpostedInvoicesAmount := Customer."Outstanding Invoices (LCY)";
        PendingCreditMemosAmount := CalculatePendingCreditMemos(Customer."No.");

        // Calcular total: pedidos abiertos + pedidos lanzados + facturas pendientes (registradas) + facturas sin registrar
        // NOTA: Los abonos pendientes NO se restan del total (solo son informativos hasta que se registren)
        TotalAmount := OpenOrdersAmount + ReleasedOrdersAmount + Customer."Balance (LCY)" + UnpostedInvoicesAmount;

        // Si se excede el límite, mostrar mensaje y enviar email
        if TotalAmount > Customer."Credit Limit (LCY)" then begin
            ExceededAmount := TotalAmount - Customer."Credit Limit (LCY)";
            Message(CreditLimitMsg,
                Customer."No." + ' - ' + Customer.Name,
                Customer."Credit Limit (LCY)",
                OpenOrdersAmount,
                ReleasedOrdersAmount,
                Customer."Balance (LCY)",
                UnpostedInvoicesAmount,
                PendingCreditMemosAmount,
                TotalAmount,
                ExceededAmount);

            // Enviar notificación por email
            SendCreditLimitEmail(Customer, TotalAmount, ExceededAmount, SalesLine."Document Type", SalesLine."Document No.", OpenOrdersAmount, ReleasedOrdersAmount, UnpostedInvoicesAmount, PendingCreditMemosAmount);

            // Marcar que ya se mostró el aviso para este documento
            SalesHeader."JMC Credit Limit Warning Shown" := true;
            SalesHeader.Modify(false);
        end;
    end;

    local procedure SendCreditLimitEmail(Customer: Record Customer; TotalAmount: Decimal; ExceededAmount: Decimal; DocumentType: Enum "Sales Document Type"; DocumentNo: Code[20]; OpenOrdersAmount: Decimal; ReleasedOrdersAmount: Decimal; UnpostedInvoicesAmount: Decimal; PendingCreditMemosAmount: Decimal)
    var
        SalesSetup: Record "Sales & Receivables Setup";
        SalesLine: Record "Sales Line";
        Item: Record Item;
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        EmailSubject: Label 'AVISO: Cliente %1 ha superado límite de crédito en %2 %3', Comment = 'ESP="AVISO: Cliente %1 ha superado límite de crédito en %2 %3"';
        EmailBody: TextBuilder;
        RecipientEmail: Text[250];
        DocumentTypeText: Text[50];
        QuoteLbl: Label 'Oferta', Comment = 'ESP="Oferta"';
        OrderLbl: Label 'Pedido', Comment = 'ESP="Pedido"';
        InvoiceLbl: Label 'Factura', Comment = 'ESP="Factura"';
        BrandText: Text[100];
        UnitCostText: Text[50];
        LineTotalCost: Decimal;
    begin
        // Obtener configuración de ventas
        if not SalesSetup.Get() then
            exit;

        RecipientEmail := SalesSetup."JMC Credit Limit Email";

        // Verificar que hay un email configurado
        if RecipientEmail = '' then
            exit;

        // Determinar el tipo de documento en español
        case DocumentType of
            DocumentType::Quote:
                DocumentTypeText := QuoteLbl;
            DocumentType::Order:
                DocumentTypeText := OrderLbl;
            DocumentType::Invoice:
                DocumentTypeText := InvoiceLbl;
        end;

        // Construir el cuerpo del email
        EmailBody.AppendLine('<html><body>');
        EmailBody.AppendLine('<h2 style="color: red;">AVISO: Límite de crédito excedido</h2>');
        EmailBody.AppendLine('<p><strong>Cliente:</strong> ' + Customer."No." + ' - ' + Customer.Name + '</p>');
        EmailBody.AppendLine('<p><strong>Documento:</strong> ' + DocumentTypeText + ' ' + DocumentNo + '</p>');
        EmailBody.AppendLine('<table border="1" cellpadding="5" cellspacing="0" style="border-collapse: collapse;">');
        EmailBody.AppendLine('<tr><td><strong>Límite de crédito:</strong></td><td style="text-align: right;">' + Format(Customer."Credit Limit (LCY)", 0, '<Precision,2:2><Standard Format,0>') + ' €</td></tr>');
        EmailBody.AppendLine('<tr><td><strong>Pedidos abiertos:</strong></td><td style="text-align: right;">' + Format(OpenOrdersAmount, 0, '<Precision,2:2><Standard Format,0>') + ' €</td></tr>');
        EmailBody.AppendLine('<tr><td><strong>Pedidos lanzados:</strong></td><td style="text-align: right;">' + Format(ReleasedOrdersAmount, 0, '<Precision,2:2><Standard Format,0>') + ' €</td></tr>');
        EmailBody.AppendLine('<tr><td><strong>Facturas pendientes:</strong></td><td style="text-align: right;">' + Format(Customer."Balance (LCY)", 0, '<Precision,2:2><Standard Format,0>') + ' €</td></tr>');
        EmailBody.AppendLine('<tr><td><strong>Facturas sin registrar:</strong></td><td style="text-align: right;">' + Format(UnpostedInvoicesAmount, 0, '<Precision,2:2><Standard Format,0>') + ' €</td></tr>');
        EmailBody.AppendLine('<tr style="background-color: #ccffcc;"><td><strong>Notas de abono pendientes:</strong></td><td style="text-align: right;"><strong>-' + Format(PendingCreditMemosAmount, 0, '<Precision,2:2><Standard Format,0>') + ' €</strong></td></tr>');
        EmailBody.AppendLine('<tr style="background-color: #ffcccc;"><td><strong>Total:</strong></td><td style="text-align: right;"><strong>' + Format(TotalAmount, 0, '<Precision,2:2><Standard Format,0>') + ' €</strong></td></tr>');
        EmailBody.AppendLine('<tr style="background-color: #ff6666; color: white;"><td><strong>Excedido:</strong></td><td style="text-align: right;"><strong>' + Format(ExceededAmount, 0, '<Precision,2:2><Standard Format,0>') + ' €</strong></td></tr>');
        EmailBody.AppendLine('</table>');

        // Agregar tabla de líneas del documento (LM Ensamblado)
        EmailBody.AppendLine('<br/>');
        EmailBody.AppendLine('<h3>Detalle de líneas del documento</h3>');
        EmailBody.AppendLine('<table border="1" cellpadding="5" cellspacing="0" style="border-collapse: collapse; width: 100%;">');
        EmailBody.AppendLine('<thead>');
        EmailBody.AppendLine('<tr style="background-color: #4CAF50; color: white;">');
        EmailBody.AppendLine('<th>Nº</th>');
        EmailBody.AppendLine('<th>Descripción</th>');
        EmailBody.AppendLine('<th>Marca</th>');
        EmailBody.AppendLine('<th>Cantidad por Lote</th>');
        EmailBody.AppendLine('<th>Unidad medida</th>');
        EmailBody.AppendLine('<th>Coste Estándar Marcado</th>');
        EmailBody.AppendLine('<th>Coste</th>');
        EmailBody.AppendLine('</tr>');
        EmailBody.AppendLine('</thead>');
        EmailBody.AppendLine('<tbody>');

        // Obtener las líneas del documento
        SalesLine.SetRange("Document Type", DocumentType);
        SalesLine.SetRange("Document No.", DocumentNo);
        SalesLine.SetFilter(Type, '<>%1', SalesLine.Type::" ");
        if SalesLine.FindSet() then
            repeat
                // Obtener información del producto para la marca
                BrandText := '';
                if (SalesLine.Type = SalesLine.Type::Item) and Item.Get(SalesLine."No.") then begin
                    if Item."Item Category Code" <> '' then
                        BrandText := Item."Item Category Code";
                end;

                // Calcular coste total de la línea
                LineTotalCost := SalesLine.Quantity * SalesLine."Unit Cost (LCY)";

                // Agregar fila con los datos de la línea
                EmailBody.AppendLine('<tr>');
                EmailBody.AppendLine('<td>' + SalesLine."No." + '</td>');
                EmailBody.AppendLine('<td>' + SalesLine.Description + '</td>');
                EmailBody.AppendLine('<td>' + BrandText + '</td>');
                EmailBody.AppendLine('<td style="text-align: right;">' + Format(SalesLine.Quantity, 0, '<Precision,2:2><Standard Format,0>') + '</td>');
                EmailBody.AppendLine('<td>' + SalesLine."Unit of Measure Code" + '</td>');
                EmailBody.AppendLine('<td style="text-align: right;">' + Format(SalesLine."Unit Cost (LCY)", 0, '<Precision,2:2><Standard Format,0>') + '</td>');
                EmailBody.AppendLine('<td style="text-align: right;">' + Format(LineTotalCost, 0, '<Precision,2:2><Standard Format,0>') + '</td>');
                EmailBody.AppendLine('</tr>');
            until SalesLine.Next() = 0;

        EmailBody.AppendLine('</tbody>');
        EmailBody.AppendLine('</table>');
        EmailBody.AppendLine('</body></html>');

        // Crear y enviar el mensaje
        EmailMessage.Create(RecipientEmail, StrSubstNo(EmailSubject, Customer."No." + ' - ' + Customer.Name, DocumentTypeText, DocumentNo), EmailBody.ToText(), true);

        // Enviar el email
        Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
    end;

    local procedure CalculateOpenSalesOrders(CustomerNo: Code[20]): Decimal
    var
        SalesHeader: Record "Sales Header";
        TotalAmount: Decimal;
    begin
        TotalAmount := 0;

        // Calculate open (not released) sales orders for the customer
        if CustomerNo = '' then
            exit(0);

        SalesHeader.Reset();
        SalesHeader.SetRange("Sell-to Customer No.", CustomerNo);
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetRange(Status, SalesHeader.Status::Open);
        if SalesHeader.FindSet() then
            repeat
                SalesHeader.CalcFields("Amount Including VAT");
                TotalAmount += SalesHeader."Amount Including VAT";
            until SalesHeader.Next() = 0;

        exit(TotalAmount);
    end;

    local procedure CalculatePendingCreditMemos(CustomerNo: Code[20]): Decimal
    var
        SalesHeader: Record "Sales Header";
        TotalAmount: Decimal;
    begin
        TotalAmount := 0;

        // Calculate pending credit memos for the customer
        if CustomerNo = '' then
            exit(0);

        SalesHeader.Reset();
        SalesHeader.SetRange("Sell-to Customer No.", CustomerNo);
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::"Credit Memo");
        if SalesHeader.FindSet() then
            repeat
                SalesHeader.CalcFields("Amount Including VAT");
                TotalAmount += SalesHeader."Amount Including VAT";
            until SalesHeader.Next() = 0;

        exit(TotalAmount);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnAfterFinalizePosting, '', false, false)]
    local procedure OnAfterFinalizePosting(var PurchHeader: Record "Purchase Header"; var PurchRcptHeader: Record "Purch. Rcpt. Header"; var PurchInvHeader: Record "Purch. Inv. Header"; var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."; var ReturnShptHeader: Record "Return Shipment Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PreviewMode: Boolean; CommitIsSupressed: Boolean)
    begin
        // Solo actualizar si hay una factura registrada
        if PurchInvHeader."No." <> '' then
            UpdateLastDirectUnitCost(PurchInvHeader."No.");
    end;

    local procedure UpdateLastDirectUnitCost(DocumentNo: Code[20])
    var
        PurchInvLine: Record "Purch. Inv. Line";
        Item: Record Item;
        ItemNo: Code[20];
        TotalCostByItem: Decimal;
        LineCountByItem: Integer;
        AverageCost: Decimal;
        ProcessedItems: List of [Code[20]];
    begin
        // Validar que tenemos un número de documento
        if DocumentNo = '' then
            exit;

        // Obtener todas las líneas de tipo Item de la factura
        PurchInvLine.SetRange("Document No.", DocumentNo);
        PurchInvLine.SetRange(Type, PurchInvLine.Type::Item);
        PurchInvLine.SetFilter("No.", '<>%1', '');

        if not PurchInvLine.FindSet() then
            exit;

        // Procesar cada producto único
        repeat
            ItemNo := PurchInvLine."No.";

            // Si NO hemos procesado este producto, procesarlo
            if not ProcessedItems.Contains(ItemNo) then begin
                // Calcular promedio para este producto
                TotalCostByItem := 0;
                LineCountByItem := 0;

                // Recorrer todas las líneas de este producto en la factura
                PurchInvLine.SetRange("Document No.", DocumentNo);
                PurchInvLine.SetRange(Type, PurchInvLine.Type::Item);
                PurchInvLine.SetRange("No.", ItemNo);
                if PurchInvLine.FindSet() then
                    repeat
                        TotalCostByItem += PurchInvLine."Unit Cost (LCY)";
                        LineCountByItem += 1;
                    until PurchInvLine.Next() = 0;

                // Actualizar JMC Average Purchase Cost con el promedio
                if LineCountByItem > 0 then begin
                    AverageCost := TotalCostByItem / LineCountByItem;
                    if Item.Get(ItemNo) then begin
                        Item."JMC Average Purchase Cost" := AverageCost;
                        Item."JMC Last Purch. Invoice No." := DocumentNo;
                        Item.Modify(true);
                    end;
                end;

                // Marcar este producto como procesado
                ProcessedItems.Add(ItemNo);

                // Resetear filtros para continuar con el siguiente producto
                PurchInvLine.SetRange("Document No.", DocumentNo);
                PurchInvLine.SetRange(Type, PurchInvLine.Type::Item);
                PurchInvLine.SetFilter("No.", '<>%1', '');
            end;
        until PurchInvLine.Next() = 0;
    end;
}