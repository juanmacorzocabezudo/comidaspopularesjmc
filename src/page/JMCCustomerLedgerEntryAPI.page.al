page 53104 "JMC Customer Ledger Entry API"
{
    APIVersion = 'v1.0';
    APIPublisher = 'juanMariaCorzo';
    APIGroup = 'receivables';

    EntityCaption = 'Customer Ledger Entry', Comment = 'ESP="Movimiento de cliente"';
    EntitySetCaption = 'Customer Ledger Entries', Comment = 'ESP="Movimientos de cliente"';
    EntityName = 'customerLedgerEntry';
    EntitySetName = 'customerLedgerEntries';

    PageType = API;
    SourceTable = "Cust. Ledger Entry";
    DelayedInsert = true;
    ODataKeyFields = SystemId;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(identificador; Rec.SystemId)
                {
                    Caption = 'Id', Comment = 'ESP="Id"';
                    Editable = false;
                }
                field(numeroMovimiento; Rec."Entry No.")
                {
                    Caption = 'Entry No.', Comment = 'ESP="Nº movimiento"';
                }
                field(numeroCliente; Rec."Customer No.")
                {
                    Caption = 'Customer No.', Comment = 'ESP="Nº cliente"';
                }
                field(fechaRegistro; Rec."Posting Date")
                {
                    Caption = 'Posting Date', Comment = 'ESP="Fecha registro"';
                }
                field(tipoDocumento; Rec."Document Type")
                {
                    Caption = 'Document Type', Comment = 'ESP="Tipo documento"';
                }
                field(numeroDocumento; Rec."Document No.")
                {
                    Caption = 'Document No.', Comment = 'ESP="Nº documento"';
                }
                field(descripcion; Rec.Description)
                {
                    Caption = 'Description', Comment = 'ESP="Descripción"';
                }
                field(nombreCliente; Rec."Customer Name")
                {
                    Caption = 'Customer Name', Comment = 'ESP="Nombre cliente"';
                }
                field(suReferencia; Rec."Your Reference")
                {
                    Caption = 'Your Reference', Comment = 'ESP="Su referencia"';
                }
                field(codigoDivisa; Rec."Currency Code")
                {
                    Caption = 'Currency Code', Comment = 'ESP="Código divisa"';
                }
                field(importe; Rec.Amount)
                {
                    Caption = 'Amount', Comment = 'ESP="Importe"';
                }
                field(importePendiente; Rec."Remaining Amount")
                {
                    Caption = 'Remaining Amount', Comment = 'ESP="Importe pendiente"';
                }
                field(importeOriginalDL; Rec."Original Amt. (LCY)")
                {
                    Caption = 'Original Amount (LCY)', Comment = 'ESP="Importe original (DL)"';
                }
                field(importePendienteDL; Rec."Remaining Amt. (LCY)")
                {
                    Caption = 'Remaining Amount (LCY)', Comment = 'ESP="Importe pendiente (DL)"';
                }
                field(importeDL; Rec."Amount (LCY)")
                {
                    Caption = 'Amount (LCY)', Comment = 'ESP="Importe (DL)"';
                }
                field(ventasDL; Rec."Sales (LCY)")
                {
                    Caption = 'Sales (LCY)', Comment = 'ESP="Ventas (DL)"';
                }
                field(beneficioDL; Rec."Profit (LCY)")
                {
                    Caption = 'Profit (LCY)', Comment = 'ESP="Beneficio (DL)"';
                }
                field(descuentoFacturaDL; Rec."Inv. Discount (LCY)")
                {
                    Caption = 'Invoice Discount (LCY)', Comment = 'ESP="Descuento factura (DL)"';
                }
                field(numeroClienteVenta; Rec."Sell-to Customer No.")
                {
                    Caption = 'Sell-to Customer No.', Comment = 'ESP="Nº cliente venta"';
                }
                field(grupoRegistroCliente; Rec."Customer Posting Group")
                {
                    Caption = 'Customer Posting Group', Comment = 'ESP="Grupo registro cliente"';
                }
                field(codigoDimensionGlobal1; Rec."Global Dimension 1 Code")
                {
                    Caption = 'Global Dimension 1 Code', Comment = 'ESP="Código dimensión global 1"';
                }
                field(codigoDimensionGlobal2; Rec."Global Dimension 2 Code")
                {
                    Caption = 'Global Dimension 2 Code', Comment = 'ESP="Código dimensión global 2"';
                }
                field(codigoVendedor; Rec."Salesperson Code")
                {
                    Caption = 'Salesperson Code', Comment = 'ESP="Código vendedor"';
                }
                field(idUsuario; Rec."User ID")
                {
                    Caption = 'User ID', Comment = 'ESP="Id. usuario"';
                }
                field(codigoOrigen; Rec."Source Code")
                {
                    Caption = 'Source Code', Comment = 'ESP="Código origen"';
                }
                field(retenido; Rec."On Hold")
                {
                    Caption = 'On Hold', Comment = 'ESP="Retenido"';
                }
                field(tipoDocumentoLiquidar; Rec."Applies-to Doc. Type")
                {
                    Caption = 'Applies-to Document Type', Comment = 'ESP="Tipo documento a liquidar"';
                }
                field(numeroDocumentoLiquidar; Rec."Applies-to Doc. No.")
                {
                    Caption = 'Applies-to Document No.', Comment = 'ESP="Nº documento a liquidar"';
                }
                field(abierto; Rec.Open)
                {
                    Caption = 'Open', Comment = 'ESP="Abierto"';
                }
                field(fechaVencimiento; Rec."Due Date")
                {
                    Caption = 'Due Date', Comment = 'ESP="Fecha vencimiento"';
                }
                field(fechaDescuentoPago; Rec."Pmt. Discount Date")
                {
                    Caption = 'Payment Discount Date', Comment = 'ESP="Fecha descuento pago"';
                }
                field(descuentoPagoOriginalPosible; Rec."Original Pmt. Disc. Possible")
                {
                    Caption = 'Original Payment Discount Possible', Comment = 'ESP="Descuento pago original posible"';
                }
                field(descuentoPagoConcedidoDL; Rec."Pmt. Disc. Given (LCY)")
                {
                    Caption = 'Payment Discount Given (LCY)', Comment = 'ESP="Descuento pago concedido (DL)"';
                }
                field(descuentoPagoOrigPosibleDL; Rec."Orig. Pmt. Disc. Possible(LCY)")
                {
                    Caption = 'Original Payment Discount Possible (LCY)', Comment = 'ESP="Descuento pago original posible (DL)"';
                }
                field(positivo; Rec.Positive)
                {
                    Caption = 'Positive', Comment = 'ESP="Positivo"';
                }
                field(cerradoPorMovimientoNro; Rec."Closed by Entry No.")
                {
                    Caption = 'Closed by Entry No.', Comment = 'ESP="Cerrado por movimiento nº"';
                }
                field(fechaCierre; Rec."Closed at Date")
                {
                    Caption = 'Closed at Date', Comment = 'ESP="Fecha cierre"';
                }
                field(importeCerradoPor; Rec."Closed by Amount")
                {
                    Caption = 'Closed by Amount', Comment = 'ESP="Importe cerrado por"';
                }
                field(idLiquidacion; Rec."Applies-to ID")
                {
                    Caption = 'Applies-to ID', Comment = 'ESP="Id. liquidación"';
                }
                field(nombrePlantillaDiario; Rec."Journal Templ. Name")
                {
                    Caption = 'Journal Template Name', Comment = 'ESP="Nombre plantilla diario"';
                }
                field(nombreSeccionDiario; Rec."Journal Batch Name")
                {
                    Caption = 'Journal Batch Name', Comment = 'ESP="Nombre sección diario"';
                }
                field(codigoMotivo; Rec."Reason Code")
                {
                    Caption = 'Reason Code', Comment = 'ESP="Código motivo"';
                }
                field(tipoCuentaContrapartida; Rec."Bal. Account Type")
                {
                    Caption = 'Balancing Account Type', Comment = 'ESP="Tipo cuenta contrapartida"';
                }
                field(numeroCuentaContrapartida; Rec."Bal. Account No.")
                {
                    Caption = 'Balancing Account No.', Comment = 'ESP="Nº cuenta contrapartida"';
                }
                field(numeroTransaccion; Rec."Transaction No.")
                {
                    Caption = 'Transaction No.', Comment = 'ESP="Nº transacción"';
                }
                field(importeCerradoPorDL; Rec."Closed by Amount (LCY)")
                {
                    Caption = 'Closed by Amount (LCY)', Comment = 'ESP="Importe cerrado por (DL)"';
                }
                field(importeDebe; Rec."Debit Amount")
                {
                    Caption = 'Debit Amount', Comment = 'ESP="Importe debe"';
                }
                field(importeHaber; Rec."Credit Amount")
                {
                    Caption = 'Credit Amount', Comment = 'ESP="Importe haber"';
                }
                field(importeDebeDL; Rec."Debit Amount (LCY)")
                {
                    Caption = 'Debit Amount (LCY)', Comment = 'ESP="Importe debe (DL)"';
                }
                field(importeHaberDL; Rec."Credit Amount (LCY)")
                {
                    Caption = 'Credit Amount (LCY)', Comment = 'ESP="Importe haber (DL)"';
                }
                field(fechaDocumento; Rec."Document Date")
                {
                    Caption = 'Document Date', Comment = 'ESP="Fecha documento"';
                }
                field(numeroDocumentoExterno; Rec."External Document No.")
                {
                    Caption = 'External Document No.', Comment = 'ESP="Nº documento externo"';
                }
                field(calcularIntereses; Rec."Calculate Interest")
                {
                    Caption = 'Calculate Interest', Comment = 'ESP="Calcular intereses"';
                }
                field(interesesCierreCalculados; Rec."Closing Interest Calculated")
                {
                    Caption = 'Closing Interest Calculated', Comment = 'ESP="Intereses de cierre calculados"';
                }
                field(numeroSerie; Rec."No. Series")
                {
                    Caption = 'No. Series', Comment = 'ESP="Nº serie"';
                }
                field(codigoDivisaCierre; Rec."Closed by Currency Code")
                {
                    Caption = 'Closed by Currency Code', Comment = 'ESP="Código divisa cierre"';
                }
                field(importeDivisaCierre; Rec."Closed by Currency Amount")
                {
                    Caption = 'Closed by Currency Amount', Comment = 'ESP="Importe divisa cierre"';
                }
                field(factorDivisaAjustado; Rec."Adjusted Currency Factor")
                {
                    Caption = 'Adjusted Currency Factor', Comment = 'ESP="Factor divisa ajustado"';
                }
                field(factorDivisaOriginal; Rec."Original Currency Factor")
                {
                    Caption = 'Original Currency Factor', Comment = 'ESP="Factor divisa original"';
                }
                field(importeOriginal; Rec."Original Amount")
                {
                    Caption = 'Original Amount', Comment = 'ESP="Importe original"';
                }
                field(descuentoPagoPendientePosible; Rec."Remaining Pmt. Disc. Possible")
                {
                    Caption = 'Remaining Payment Discount Possible', Comment = 'ESP="Descuento pago pendiente posible"';
                }
                field(fechaToleranciaDescuentoPago; Rec."Pmt. Disc. Tolerance Date")
                {
                    Caption = 'Payment Discount Tolerance Date', Comment = 'ESP="Fecha tolerancia descuento pago"';
                }
                field(toleranciaMaximaPago; Rec."Max. Payment Tolerance")
                {
                    Caption = 'Max. Payment Tolerance', Comment = 'ESP="Tolerancia máxima pago"';
                }
                field(ultimoNivelRecordatorioEmitido; Rec."Last Issued Reminder Level")
                {
                    Caption = 'Last Issued Reminder Level', Comment = 'ESP="Último nivel de recordatorio emitido"';
                }
                field(toleranciaPagoAceptada; Rec."Accepted Payment Tolerance")
                {
                    Caption = 'Accepted Payment Tolerance', Comment = 'ESP="Tolerancia de pago aceptada"';
                }
                field(toleranciaDescuentoPagoAceptada; Rec."Accepted Pmt. Disc. Tolerance")
                {
                    Caption = 'Accepted Payment Discount Tolerance', Comment = 'ESP="Tolerancia descuento pago aceptada"';
                }
                field(toleranciaPagoDL; Rec."Pmt. Tolerance (LCY)")
                {
                    Caption = 'Payment Tolerance (LCY)', Comment = 'ESP="Tolerancia pago (DL)"';
                }
                field(importeALiquidar; Rec."Amount to Apply")
                {
                    Caption = 'Amount to Apply', Comment = 'ESP="Importe a liquidar"';
                }
                field(codigoSocioIC; Rec."IC Partner Code")
                {
                    Caption = 'IC Partner Code', Comment = 'ESP="Código socio IC"';
                }
                field(movimientoLiquidador; Rec."Applying Entry")
                {
                    Caption = 'Applying Entry', Comment = 'ESP="Movimiento liquidador"';
                }
                field(revertido; Rec.Reversed)
                {
                    Caption = 'Reversed', Comment = 'ESP="Revertido"';
                }
                field(revertidoPorMovimientoNro; Rec."Reversed by Entry No.")
                {
                    Caption = 'Reversed by Entry No.', Comment = 'ESP="Revertido por movimiento nº"';
                }
                field(movimientoRevertidoNro; Rec."Reversed Entry No.")
                {
                    Caption = 'Reversed Entry No.', Comment = 'ESP="Movimiento revertido nº"';
                }
                field(anticipo; Rec.Prepayment)
                {
                    Caption = 'Prepayment', Comment = 'ESP="Anticipo"';
                }
                field(codigoTerminosPago; Rec."Payment Terms Code")
                {
                    Caption = 'Payment Terms Code', Comment = 'ESP="Código términos pago"';
                }
                field(referenciaPago; Rec."Payment Reference")
                {
                    Caption = 'Payment Reference', Comment = 'ESP="Referencia pago"';
                }
                field(codigoMetodoPago; Rec."Payment Method Code")
                {
                    Caption = 'Payment Method Code', Comment = 'ESP="Código forma pago"';
                }
                field(numeroDocumentoExternoLiquidar; Rec."Applies-to Ext. Doc. No.")
                {
                    Caption = 'Applies-to External Document No.', Comment = 'ESP="Nº documento externo a liquidar"';
                }
                field(cuentaBancariaDestinatario; Rec."Recipient Bank Account")
                {
                    Caption = 'Recipient Bank Account', Comment = 'ESP="Cuenta bancaria destinatario"';
                }
                field(mensajeDestinatario; Rec."Message to Recipient")
                {
                    Caption = 'Message to Recipient', Comment = 'ESP="Mensaje al destinatario"';
                }
                field(exportadoFicheroPago; Rec."Exported to Payment File")
                {
                    Caption = 'Exported to Payment File', Comment = 'ESP="Exportado a fichero de pagos"';
                }
                field(idConjuntoDimensiones; Rec."Dimension Set ID")
                {
                    Caption = 'Dimension Set ID', Comment = 'ESP="Id. conjunto dimensiones"';
                }
                field(codigoDimensionAbreviada3; Rec."Shortcut Dimension 3 Code")
                {
                    Caption = 'Shortcut Dimension 3 Code', Comment = 'ESP="Código dimensión abreviada 3"';
                }
                field(codigoDimensionAbreviada4; Rec."Shortcut Dimension 4 Code")
                {
                    Caption = 'Shortcut Dimension 4 Code', Comment = 'ESP="Código dimensión abreviada 4"';
                }
                field(codigoDimensionAbreviada5; Rec."Shortcut Dimension 5 Code")
                {
                    Caption = 'Shortcut Dimension 5 Code', Comment = 'ESP="Código dimensión abreviada 5"';
                }
                field(codigoDimensionAbreviada6; Rec."Shortcut Dimension 6 Code")
                {
                    Caption = 'Shortcut Dimension 6 Code', Comment = 'ESP="Código dimensión abreviada 6"';
                }
                field(codigoDimensionAbreviada7; Rec."Shortcut Dimension 7 Code")
                {
                    Caption = 'Shortcut Dimension 7 Code', Comment = 'ESP="Código dimensión abreviada 7"';
                }
                field(codigoDimensionAbreviada8; Rec."Shortcut Dimension 8 Code")
                {
                    Caption = 'Shortcut Dimension 8 Code', Comment = 'ESP="Código dimensión abreviada 8"';
                }
                field(idMandatoAdeudoDirecto; Rec."Direct Debit Mandate ID")
                {
                    Caption = 'Direct Debit Mandate ID', Comment = 'ESP="Id. mandato domiciliación"';
                }
                field(estadoDisputa; Rec."Dispute Status")
                {
                    Caption = 'Dispute Status', Comment = 'ESP="Estado de disputa"';
                }
                field(fechaPagoPrometida; Rec."Promised Pay Date")
                {
                    Caption = 'Promised Pay Date', Comment = 'ESP="Fecha pago prometida"';
                }
                field(tipoFactura; Rec."Invoice Type")
                {
                    Caption = 'Invoice Type', Comment = 'ESP="Tipo factura"';
                }
                field(tipoAbono; Rec."Cr. Memo Type")
                {
                    Caption = 'Credit Memo Type', Comment = 'ESP="Tipo abono"';
                }
                field(codigoRegimenEspecial; Rec."Special Scheme Code")
                {
                    Caption = 'Special Scheme Code', Comment = 'ESP="Código régimen especial"';
                }
                field(tipoCorreccion; Rec."Correction Type")
                {
                    Caption = 'Correction Type', Comment = 'ESP="Tipo corrección"';
                }
                field(numeroFacturaRectificada; Rec."Corrected Invoice No.")
                {
                    Caption = 'Corrected Invoice No.', Comment = 'ESP="Nº factura rectificada"';
                }
                field(nombreEmpresaSucesora; Rec."Succeeded Company Name")
                {
                    Caption = 'Succeeded Company Name', Comment = 'ESP="Nombre empresa sucesora"';
                }
                field(numRegistroIVAEmpSucesora; Rec."Succeeded VAT Registration No.")
                {
                    Caption = 'Succeeded VAT Registration No.', Comment = 'ESP="Nº registro IVA empresa sucesora"';
                }
                field(tipoIdentificacion; Rec."ID Type")
                {
                    Caption = 'ID Type', Comment = 'ESP="Tipo identificación"';
                }
                field(noEnviarAlSII; Rec."Do Not Send To SII")
                {
                    Caption = 'Do Not Send To SII', Comment = 'ESP="No enviar al SII"';
                }
                field(emitidoPorTercero; Rec."Issued By Third Party")
                {
                    Caption = 'Issued By Third Party', Comment = 'ESP="Emitido por tercero"';
                }
                field(fechaDeclaracionIVA; Rec."VAT Reporting Date")
                {
                    Caption = 'VAT Reporting Date', Comment = 'ESP="Fecha declaración IVA"';
                }
                field(numeroEfecto; Rec."Bill No.")
                {
                    Caption = 'Bill No.', Comment = 'ESP="Nº efecto"';
                }
                field(situacionDocumento; Rec."Document Situation")
                {
                    Caption = 'Document Situation', Comment = 'ESP="Situación documento"';
                }
                field(numeroEfectoLiquidar; Rec."Applies-to Bill No.")
                {
                    Caption = 'Applies-to Bill No.', Comment = 'ESP="Nº efecto a liquidar"';
                }
                field(estadoDocumento; Rec."Document Status")
                {
                    Caption = 'Document Status', Comment = 'ESP="Estado documento"';
                }
                field(estadisticaImportePendienteDL; Rec."Remaining Amount (LCY) stats.")
                {
                    Caption = 'Remaining Amount (LCY) Statistics', Comment = 'ESP="Estadística importe pendiente (DL)"';
                }
                field(estadisticaImporteDL; Rec."Amount (LCY) stats.")
                {
                    Caption = 'Amount (LCY) Statistics', Comment = 'ESP="Estadística importe (DL)"';
                }
                field(creadoElSistema; Rec.SystemCreatedAt)
                {
                    Caption = 'System Created At', Comment = 'ESP="Creado el"';
                }
                field(creadoPorSistema; Rec.SystemCreatedBy)
                {
                    Caption = 'System Created By', Comment = 'ESP="Creado por"';
                }
                field(modificadoElSistema; Rec.SystemModifiedAt)
                {
                    Caption = 'System Modified At', Comment = 'ESP="Modificado el"';
                }
                field(modificadoPorSistema; Rec.SystemModifiedBy)
                {
                    Caption = 'System Modified By', Comment = 'ESP="Modificado por"';
                }
                field(versionFilaSistema; Rec.SystemRowVersion)
                {
                    Caption = 'System Row Version', Comment = 'ESP="Versión fila"';
                }
            }
        }
    }
}