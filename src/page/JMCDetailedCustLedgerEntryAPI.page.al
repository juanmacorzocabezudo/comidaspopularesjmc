page 53105 "JMC Det. Cust. Ledger API"
{
    APIVersion = 'v1.0';
    APIPublisher = 'juanMariaCorzo';
    APIGroup = 'receivables';

    EntityCaption = 'Detailed Customer Ledger Entry', Comment = 'ESP="Movimiento detallado de cliente"';
    EntitySetCaption = 'Detailed Customer Ledger Entries', Comment = 'ESP="Movimientos detallados de cliente"';
    EntityName = 'detailedCustomerLedgerEntry';
    EntitySetName = 'detailedCustomerLedgerEntries';

    PageType = API;
    SourceTable = "Detailed Cust. Ledg. Entry";
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
                field(numeroMovimientoDetallado; Rec."Entry No.")
                {
                    Caption = 'Entry No.', Comment = 'ESP="Nº movimiento detallado"';
                }
                field(numeroMovimientoCliente; Rec."Cust. Ledger Entry No.")
                {
                    Caption = 'Customer Ledger Entry No.', Comment = 'ESP="Nº movimiento de cliente"';
                }
                field(tipoMovimiento; Rec."Entry Type")
                {
                    Caption = 'Entry Type', Comment = 'ESP="Tipo movimiento"';
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
                field(importe; Rec.Amount)
                {
                    Caption = 'Amount', Comment = 'ESP="Importe"';
                }
                field(importeDL; Rec."Amount (LCY)")
                {
                    Caption = 'Amount (LCY)', Comment = 'ESP="Importe (DL)"';
                }
                field(numeroCliente; Rec."Customer No.")
                {
                    Caption = 'Customer No.', Comment = 'ESP="Nº cliente"';
                }
                field(codigoDivisa; Rec."Currency Code")
                {
                    Caption = 'Currency Code', Comment = 'ESP="Código divisa"';
                }
                field(idUsuario; Rec."User ID")
                {
                    Caption = 'User ID', Comment = 'ESP="Id. usuario"';
                }
                field(codigoOrigen; Rec."Source Code")
                {
                    Caption = 'Source Code', Comment = 'ESP="Código origen"';
                }
                field(numeroTransaccion; Rec."Transaction No.")
                {
                    Caption = 'Transaction No.', Comment = 'ESP="Nº transacción"';
                }
                field(nombreSeccionDiario; Rec."Journal Batch Name")
                {
                    Caption = 'Journal Batch Name', Comment = 'ESP="Nombre sección diario"';
                }
                field(codigoMotivo; Rec."Reason Code")
                {
                    Caption = 'Reason Code', Comment = 'ESP="Código motivo"';
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
                field(fechaVencimientoMovimientoInicial; Rec."Initial Entry Due Date")
                {
                    Caption = 'Initial Entry Due Date', Comment = 'ESP="Fecha vencimiento movimiento inicial"';
                }
                field(dimensionGlobalInicial1; Rec."Initial Entry Global Dim. 1")
                {
                    Caption = 'Initial Entry Global Dimension 1', Comment = 'ESP="Dimensión global 1 movimiento inicial"';
                }
                field(dimensionGlobalInicial2; Rec."Initial Entry Global Dim. 2")
                {
                    Caption = 'Initial Entry Global Dimension 2', Comment = 'ESP="Dimensión global 2 movimiento inicial"';
                }
                field(grupoRegistroNegocioGeneral; Rec."Gen. Bus. Posting Group")
                {
                    Caption = 'Gen. Business Posting Group', Comment = 'ESP="Grupo registro negocio general"';
                }
                field(grupoRegistroProductoGeneral; Rec."Gen. Prod. Posting Group")
                {
                    Caption = 'Gen. Product Posting Group', Comment = 'ESP="Grupo registro producto general"';
                }
                field(usarImpuesto; Rec."Use Tax")
                {
                    Caption = 'Use Tax', Comment = 'ESP="Usar impuesto"';
                }
                field(grupoRegistroNegocioIVA; Rec."VAT Bus. Posting Group")
                {
                    Caption = 'VAT Business Posting Group', Comment = 'ESP="Grupo registro negocio IVA"';
                }
                field(grupoRegistroProductoIVA; Rec."VAT Prod. Posting Group")
                {
                    Caption = 'VAT Product Posting Group', Comment = 'ESP="Grupo registro producto IVA"';
                }
                field(tipoDocumentoInicial; Rec."Initial Document Type")
                {
                    Caption = 'Initial Document Type', Comment = 'ESP="Tipo documento inicial"';
                }
                field(numeroMovimientoClienteAplicado; Rec."Applied Cust. Ledger Entry No.")
                {
                    Caption = 'Applied Customer Ledger Entry No.', Comment = 'ESP="Nº movimiento cliente aplicado"';
                }
                field(desliquidado; Rec.Unapplied)
                {
                    Caption = 'Unapplied', Comment = 'ESP="Desliquidado"';
                }
                field(desliquidadoPorMovimientoNro; Rec."Unapplied by Entry No.")
                {
                    Caption = 'Unapplied by Entry No.', Comment = 'ESP="Desliquidado por movimiento nº"';
                }
                field(descuentoPagoPendientePosible; Rec."Remaining Pmt. Disc. Possible")
                {
                    Caption = 'Remaining Payment Discount Possible', Comment = 'ESP="Descuento pago pendiente posible"';
                }
                field(toleranciaMaximaPago; Rec."Max. Payment Tolerance")
                {
                    Caption = 'Max. Payment Tolerance', Comment = 'ESP="Tolerancia máxima pago"';
                }
                field(codigoJurisdiccionFiscal; Rec."Tax Jurisdiction Code")
                {
                    Caption = 'Tax Jurisdiction Code', Comment = 'ESP="Código jurisdicción fiscal"';
                }
                field(numeroAplicacion; Rec."Application No.")
                {
                    Caption = 'Application No.', Comment = 'ESP="Nº aplicación"';
                }
                field(importeMovimientoContable; Rec."Ledger Entry Amount")
                {
                    Caption = 'Ledger Entry Amount', Comment = 'ESP="Importe movimiento contable"';
                }
                field(grupoRegistro; Rec."Posting Group")
                {
                    Caption = 'Posting Group', Comment = 'ESP="Grupo registro"';
                }
                field(numRegistroAjusteTipoCambio; Rec."Exch. Rate Adjmt. Reg. No.")
                {
                    Caption = 'Exchange Rate Adjustment Register No.', Comment = 'ESP="Nº registro ajuste tipo cambio"';
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
                field(excluirDelCalculo; Rec."Excluded from calculation")
                {
                    Caption = 'Excluded from Calculation', Comment = 'ESP="Excluir del cálculo"';
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