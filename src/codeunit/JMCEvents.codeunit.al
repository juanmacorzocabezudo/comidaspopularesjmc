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
        CreditLimitMsg: Label 'AVISO: El cliente %1 ha superado su límite de crédito.\\\\Límite de crédito: %2\\Saldo pendiente: %3\\Pedidos pendientes: %4\\Enviado no facturado: %5\\Facturas pendientes: %6\\Total: %7\\Excedido: %8', Comment = 'ESP="AVISO: El cliente %1 ha superado su límite de crédito.\\\\Límite de crédito: %2\\Saldo pendiente: %3\\Pedidos pendientes: %4\\Enviado no facturado: %5\\Facturas pendientes: %6\\Total: %7\\Excedido: %8"';
        TotalAmount: Decimal;
        ExceededAmount: Decimal;
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

        // Los FlowFields ya incluyen todos los documentos guardados, incluido el actual
        Customer.CalcFields("Balance (LCY)", "Outstanding Orders (LCY)", "Shipped Not Invoiced (LCY)", "Outstanding Invoices (LCY)");
        // Calcular total: saldo pendiente + pedidos pendientes + enviado no facturado + facturas pendientes
        TotalAmount := Customer."Balance (LCY)" + Customer."Outstanding Orders (LCY)" + Customer."Shipped Not Invoiced (LCY)" + Customer."Outstanding Invoices (LCY)";

        // Si se excede el límite, mostrar mensaje y enviar email
        if TotalAmount > Customer."Credit Limit (LCY)" then begin
            ExceededAmount := TotalAmount - Customer."Credit Limit (LCY)";
            Message(CreditLimitMsg,
                Customer."No." + ' - ' + Customer.Name,
                Customer."Credit Limit (LCY)",
                Customer."Balance (LCY)",
                Customer."Outstanding Orders (LCY)",
                Customer."Shipped Not Invoiced (LCY)",
                Customer."Outstanding Invoices (LCY)",
                TotalAmount,
                ExceededAmount);

            // Enviar notificación por email
            SendCreditLimitEmail(Customer, TotalAmount, ExceededAmount, SalesHeader."Document Type", SalesHeader."No.");

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
        CreditLimitMsg: Label 'AVISO: El cliente %1 ha superado su límite de crédito.\\\\Límite de crédito: %2\\Saldo pendiente: %3\\Pedidos pendientes: %4\\Enviado no facturado: %5\\Facturas pendientes: %6\\Total: %7\\Excedido: %8', Comment = 'ESP="AVISO: El cliente %1 ha superado su límite de crédito.\\\\Límite de crédito: %2\\Saldo pendiente: %3\\Pedidos pendientes: %4\\Enviado no facturado: %5\\Facturas pendientes: %6\\Total: %7\\Excedido: %8"';
        TotalAmount: Decimal;
        ExceededAmount: Decimal;
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

        // Los FlowFields ya incluyen todos los documentos guardados, incluido el actual
        Customer.CalcFields("Balance (LCY)", "Outstanding Orders (LCY)", "Shipped Not Invoiced (LCY)", "Outstanding Invoices (LCY)");
        // Calcular total: saldo pendiente + pedidos pendientes + enviado no facturado + facturas pendientes
        TotalAmount := Customer."Balance (LCY)" + Customer."Outstanding Orders (LCY)" + Customer."Shipped Not Invoiced (LCY)" + Customer."Outstanding Invoices (LCY)";

        // Si se excede el límite, mostrar mensaje y enviar email
        if TotalAmount > Customer."Credit Limit (LCY)" then begin
            ExceededAmount := TotalAmount - Customer."Credit Limit (LCY)";
            Message(CreditLimitMsg,
                Customer."No." + ' - ' + Customer.Name,
                Customer."Credit Limit (LCY)",
                Customer."Balance (LCY)",
                Customer."Outstanding Orders (LCY)",
                Customer."Shipped Not Invoiced (LCY)",
                Customer."Outstanding Invoices (LCY)",
                TotalAmount,
                ExceededAmount);

            // Enviar notificación por email
            SendCreditLimitEmail(Customer, TotalAmount, ExceededAmount, SalesLine."Document Type", SalesLine."Document No.");

            // Marcar que ya se mostró el aviso para este documento
            SalesHeader."JMC Credit Limit Warning Shown" := true;
            SalesHeader.Modify(false);
        end;
    end;

    local procedure SendCreditLimitEmail(Customer: Record Customer; TotalAmount: Decimal; ExceededAmount: Decimal; DocumentType: Enum "Sales Document Type"; DocumentNo: Code[20])
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

        // Calcular campos adicionales del cliente para mostrar desglose
        Customer.CalcFields("Outstanding Orders (LCY)", "Shipped Not Invoiced (LCY)", "Outstanding Invoices (LCY)");

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
        EmailBody.AppendLine('<tr><td><strong>Saldo pendiente:</strong></td><td style="text-align: right;">' + Format(Customer."Balance (LCY)", 0, '<Precision,2:2><Standard Format,0>') + ' €</td></tr>');
        EmailBody.AppendLine('<tr><td><strong>Pedidos pendientes:</strong></td><td style="text-align: right;">' + Format(Customer."Outstanding Orders (LCY)", 0, '<Precision,2:2><Standard Format,0>') + ' €</td></tr>');
        EmailBody.AppendLine('<tr><td><strong>Enviado no facturado:</strong></td><td style="text-align: right;">' + Format(Customer."Shipped Not Invoiced (LCY)", 0, '<Precision,2:2><Standard Format,0>') + ' €</td></tr>');
        EmailBody.AppendLine('<tr><td><strong>Facturas pendientes:</strong></td><td style="text-align: right;">' + Format(Customer."Outstanding Invoices (LCY)", 0, '<Precision,2:2><Standard Format,0>') + ' €</td></tr>');
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

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPurchInvHeaderInsert', '', false, false)]
    local procedure OnAfterPurchInvHeaderInsert(var PurchHeader: Record "Purchase Header"; var PurchInvHeader: Record "Purch. Inv. Header")
    begin
        UpdateLastDirectUnitCost(PurchInvHeader."No.");
    end;

    local procedure UpdateLastDirectUnitCost(DocumentNo: Code[20])
    var
        PurchInvLine: Record "Purch. Inv. Line";
        Item: Record Item;
        TempItemCostBuffer: Record Item temporary;
        TotalCost: Decimal;
        TotalQty: Decimal;
        AverageCost: Decimal;
    begin
        // Obtener todas las líneas de tipo Item de la factura
        PurchInvLine.SetRange("Document No.", DocumentNo);
        PurchInvLine.SetRange(Type, PurchInvLine.Type::Item);
        PurchInvLine.SetFilter("No.", '<>%1', '');

        if not PurchInvLine.FindSet() then
            exit;

        // Agrupar por producto y calcular totales con media ponderada
        repeat
            // Buscar si ya procesamos este producto
            TempItemCostBuffer.SetRange("No.", PurchInvLine."No.");
            if TempItemCostBuffer.FindFirst() then begin
                // Acumular valores ponderados
                TempItemCostBuffer."Standard Cost" += PurchInvLine."Direct Unit Cost" * PurchInvLine.Quantity;
                TempItemCostBuffer."Unit Cost" += PurchInvLine.Quantity;
                TempItemCostBuffer.Modify();
            end else begin
                // Crear nuevo registro temporal
                TempItemCostBuffer.Init();
                TempItemCostBuffer."No." := PurchInvLine."No.";
                TempItemCostBuffer."Standard Cost" := PurchInvLine."Direct Unit Cost" * PurchInvLine.Quantity; // Coste total ponderado
                TempItemCostBuffer."Unit Cost" := PurchInvLine.Quantity; // Cantidad total
                TempItemCostBuffer.Insert();
            end;
        until PurchInvLine.Next() = 0;

        // Actualizar Last Direct Cost de cada producto con la media ponderada
        TempItemCostBuffer.Reset();
        if TempItemCostBuffer.FindSet() then
            repeat
                if Item.Get(TempItemCostBuffer."No.") then begin
                    TotalCost := TempItemCostBuffer."Standard Cost";
                    TotalQty := TempItemCostBuffer."Unit Cost";

                    if TotalQty <> 0 then begin
                        AverageCost := TotalCost / TotalQty;
                        Item.Validate("Last Direct Cost", AverageCost);
                        Item.Modify(true);
                    end;
                end;
            until TempItemCostBuffer.Next() = 0;
    end;
}