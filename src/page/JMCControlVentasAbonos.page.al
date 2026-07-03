page 53101 JMCAlxControlVentasAbonos
{
    ApplicationArea = All;
    Caption = 'Credit Memo Sales Control', Comment = 'ESP="Control Ventas Abonos"';
    PageType = List;
    SourceTable = JMCAlxControlVenta;
    UsageCategory = ReportsAndAnalysis;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Cliente No"; Rec."Cliente No") { }
                field("Nombre"; Rec.Nombre) { }
                field("Dirección"; Rec."Dirección") { }
                field("Dirección 2"; Rec."Dirección 2") { }
                field("Código Postal"; Rec."Código Postal") { }
                field("Población"; Rec."Población") { }
                field("Provincia"; Rec.Provincia) { }
                field("Teléfono"; Rec."Teléfono") { }
                field("Correo Electrónico"; Rec."Correo Electrónico") { }
                field(Contacto; Rec.Contacto) { }
                field(Alias; Rec.Alias) { }
                field("Cod. Almacén"; Rec."Cod. Almacén") { }
                field(Bloqueado; Rec.Bloqueado) { }
                field("Crédito Maximo"; Rec."Crédito Maximo") { }
                field("Divisa"; Rec.Divisa) { }
                field("Grupo Dto"; Rec."Grupo Dto") { }
                field("Grupo Contable"; Rec."Grupo Contable") { }
                field("Grupo Precio"; Rec."Grupo Precio") { }
                field("Términos Pago"; Rec."Términos Pago") { }
                field(Vendedor; Rec.Vendedor) { }
                field("Cod Transportista"; Rec."Cod Transportista") { }
                field("Cod Servicio Transportista"; Rec."Cod Servicio Transportista") { }
                field("Aviso Envío"; Rec."Aviso Envío") { }
                field("Facturación Automática"; Rec."Facturación Automática") { }
                field("Fecha Ultima Modificación"; Rec."Fecha Ultima Modificación") { }
                field("Cod Agente"; Rec."Cod Agente") { }
                field("Factura"; Rec.Factura) { }
                field("Fecha"; Rec.Fecha) { }
                field("AÑO"; Rec."AÑO") { }
                field(MES; Rec.MES) { }
                field(CLIENTE; Rec.CLIENTE) { }
                field("Linea Empresa"; Rec."Linea Empresa") { }
                field(Producto; Rec.Producto) { }
                field("Descripción"; Rec."Descripción") { }
                field(CANTIDAD; Rec.CANTIDAD) { }
                field("€ SIN IVA"; Rec."€ SIN IVA") { }
                field("€ CON IVA"; Rec."€ CON IVA") { }
                field("PRECIO"; Rec.PRECIO) { }
                field("Dto"; Rec.Dto) { }
                field("% Descuento"; Rec."% Descuento") { }
                field("Importe"; Rec.Importe) { }
                field("Base IVA"; Rec."Base IVA") { }
                field(Comision; Rec.Comision) { }
                field("LineasNegocio"; Rec.LineasNegocio) { }
                field("TipoLinea"; Rec.TipoLinea) { }
                field("Importe Pendiente"; Rec."Importe Pendiente") { }
                field(Pagado; Rec.Pagado) { }
                field("Forma Pago"; Rec."Forma Pago") { }
                field("Terminos Pago"; Rec."Terminos Pago") { }
                field("Peso Neto Linea"; Rec."Peso Neto Linea") { }
                field("Tipo Documento"; Rec."Tipo Documento") { }
                field("Fecha Servicio"; Rec."Fecha Servicio") { }
                field("Devolucion"; Rec."Devolucion") { }
                field("Comentarios"; Rec."Comentarios") { }
                field(Formato; Rec.Formato) { }
                field("Peso Formato"; Rec."Peso Formato") { }
            }
        }
    }
    var /*   recCust: Record Customer;
      recSIH: Record "Sales Invoice Header";
      _Telefono: Text[150];
      _Correo: Text[150];
      _Contacto: Text[150];
      _Alias: Text[150];
      _Bloqueado: Boolean;
      _CreditoMax: Decimal;
      _ShippingAdvice: Code[50];
      _FacturacionAuto: Integer;
      _FechaUltimaModificacion: date;
      _CodAgente: Code[50];
      _Ano: Integer;
      _Mes: Integer;
      _Cliente: Text;
      _Comision: Text;
      _Pagado: Text;
      _TipoDocumento: Text;
      _PesoNeto: Decimal; */
    //Sales Invoice Header
    /*   "_Sell-to Customer Name": Text[150];
      "_Sell-to Address": Text[150];
      "_Sell-to Address 2": Text[150];
      "_Sell-to Post Code": Code[50];
      "_Sell-to City": Text[150];
      "_Sell-to County": Text[150];
      "_Currency Code": Code[20];
      "_Payment Terms Code": Code[50];
      "_Salesperson Code": Code[50];
      "_Shipping Agent Code": Code[50];
      "_Shipment Method Code": Code[50];
      "_Document Date": Date;
      "_Remaining Amount": Decimal;
      "_Payment Method Code": Code[50]; */
    trigger OnOpenPage()
    var
        recEventos: Record Evento;
        recSH: Record "Sales Header";
        RecSIH: Record "Sales Invoice Header";
        RecSCM: Record "Sales Cr.Memo Header";
        FactVentasQuery: Query AlxSalesInvoiceLine;
        AbonVentasQuery: Query JMCAlxSalesCrMemoLine;
        Item: Record Item;
    begin
        if FactVentasQuery.Open() then begin
            while FactVentasQuery.Read() do begin
                Rec.Init();
                Rec."Line No." := Rec."Line No." + 1;
                Rec."Cliente No" := FactVentasQuery.SelltoCustomerNo;
                Rec.Nombre := FactVentasQuery.SelltoCustomerName;
                Rec."Dirección" := FactVentasQuery.SelltoAddress;
                Rec."Dirección 2" := FactVentasQuery.SelltoAddress2;
                Rec."Código Postal" := FactVentasQuery.SelltoPostCode;
                Rec."Población" := FactVentasQuery.SelltoCity;
                Rec.Provincia := FactVentasQuery.SelltoCounty;
                Rec.Divisa := FactVentasQuery.CurrencyCode;
                Rec."Términos Pago" := FactVentasQuery.PaymentMethodCode;
                Rec.Vendedor := FactVentasQuery.SalespersonCode;
                Rec."Cod Transportista" := FactVentasQuery.ShippingAgentCode;
                Rec."Cod Servicio Transportista" := FactVentasQuery.Shipping_Agent_Service_Code;
                Rec.Fecha := FactVentasQuery.PostingDate;
                Rec."Forma Pago" := FactVentasQuery.PaymentMethodCode;
                Rec."Terminos Pago" := FactVentasQuery.PaymentTermsCode;
                Rec.Factura := FactVentasQuery.HNo;
                Rec."AÑO" := Date2DMY(FactVentasQuery.PostingDate, 3);
                Rec.MES := Date2DMY(FactVentasQuery.PostingDate, 2);
                Rec.CLIENTE := Format(FactVentasQuery.HSelltoCustomerNo + ' ' + FactVentasQuery.SelltoCustomerName);
                //Customer
                if FactVentasQuery.SelltoPhoneNo <> '' then
                    Rec."Teléfono" := FactVentasQuery.SelltoPhoneNo
                else
                    Rec."Teléfono" := FactVentasQuery.Phone_No_;
                if FactVentasQuery.SelltoEMail <> '' then
                    Rec."Correo Electrónico" := FactVentasQuery.SelltoEMail
                else
                    Rec."Correo Electrónico" := FactVentasQuery.E_Mail;
                if FactVentasQuery.SelltoContact <> '' then
                    Rec.Contacto := FactVentasQuery.SelltoContact
                else
                    Rec.Contacto := FactVentasQuery.Contact;
                Rec.Alias := FactVentasQuery.Search_Name;
                Rec.Bloqueado := Format(FactVentasQuery.Blocked);
                Rec."Crédito Maximo" := FactVentasQuery.Credit_Limit__LCY_;
                Rec."Aviso Envío" := Format(FactVentasQuery.Shipping_Advice);
                Rec."Facturación Automática" := '0';
                Rec."Fecha Ultima Modificación" := FactVentasQuery.Last_Date_Modified;
                Rec."Cod Agente" := FactVentasQuery.Shipping_Agent_Code;
                Rec."Linea Empresa" := FactVentasQuery.ShortcutDimension2Code;
                //SL Line
                Rec."Grupo Dto" := FactVentasQuery.CustomerDiscGroup;
                Rec."Grupo Contable" := FactVentasQuery.GenBusPostingGroup;
                Rec."Grupo Precio" := FactVentasQuery.CustomerPriceGroup;
                Rec."Términos Pago" := FactVentasQuery.PaymentMethodCode;
                Rec.Producto := FactVentasQuery.No;
                Rec."Descripción" := FactVentasQuery.Description;
                // Get Item info for Formato and Weight
                if FactVentasQuery.Type = FactVentasQuery.Type::Item then begin
                    if Item.Get(FactVentasQuery.No) then begin
                        Rec.Formato := Item.Formato;
                        Rec."Peso Formato" := Item."JMC Weight";
                    end;
                end;
                Rec.CANTIDAD := FactVentasQuery.Quantity;
                Rec."€ SIN IVA" := FactVentasQuery.LineAmount;
                Rec."€ CON IVA" := FactVentasQuery.AmountIncludingVAT;
                Rec.PRECIO := FactVentasQuery.UnitPrice;
                Rec.Dto := FactVentasQuery.LineDiscountAmount;
                Rec."% Descuento" := FactVentasQuery.LineDiscount;
                Rec.Importe := FactVentasQuery.LineAmount;
                Rec."Base IVA" := FactVentasQuery.VATBaseAmount;
                Rec.Comision := 0;
                Rec.LineasNegocio := FactVentasQuery.ShortcutDimension1Code;
                Rec.TipoLinea := Format(FactVentasQuery.Type);
                Rec."Cod. Almacén" := FactVentasQuery.LocationCode;
                Rec."Importe Pendiente" := FactVentasQuery.RemainingAmount;
                if Rec."Importe Pendiente" = 0 then
                    Rec.Pagado := 'SI'
                else
                    Rec.Pagado := 'NO';
                Rec."Peso Neto Linea" := FactVentasQuery.NetWeight * FactVentasQuery.Quantity;
                Rec."Tipo Documento" := 'Factura';
                if FactVentasQuery.FechaServicio = 0D then begin
                    if Rec.LineasNegocio = 'CATERING' then begin
                        RecSIH.Reset();
                        RecSIH.SetRange("Order No.", FactVentasQuery.OrderNo);
                        if RecSIH.FindFirst() then begin
                            recEventos.Reset();
                            recEventos.SetRange("Codigo Evento", RecSIH.NoEvento);
                            if recEventos.FindFirst() then Rec."Fecha Servicio" := recEventos."Fecha Evento";
                        end;
                    end;
                    if Rec.LineasNegocio = 'ALIMENTACION' then begin
                        recSH.Reset();
                        recSH.SetRange("No.", FactVentasQuery.OrderNo);
                        if recSH.FindFirst() then Rec."Fecha Servicio" := recSH."Shipment Date";
                    end;
                    if Rec."Fecha Servicio" = 0D then begin
                        RecSIH.Reset();
                        RecSIH.SetRange("Order No.", FactVentasQuery.OrderNo);
                        if RecSIH.FindFirst() then Rec."Fecha Servicio" := RecSIH."Posting Date";
                    end;
                end
                else
                    Rec."Fecha Servicio" := FactVentasQuery.FechaServicio;
                Rec.Insert();
            end;
            FactVentasQuery.Close();
        end;
        //Abonos
        if AbonVentasQuery.Open() then begin
            while AbonVentasQuery.Read() do begin
                Rec.Init();
                Rec."Line No." := Rec."Line No." + 1;
                Rec."Cliente No" := AbonVentasQuery.SelltoCustomerNo;
                Rec.Nombre := AbonVentasQuery.SelltoCustomerName;
                Rec."Dirección" := AbonVentasQuery.SelltoAddress;
                Rec."Dirección 2" := AbonVentasQuery.SelltoAddress2;
                Rec."Código Postal" := AbonVentasQuery.SelltoPostCode;
                Rec."Población" := AbonVentasQuery.SelltoCity;
                Rec.Provincia := AbonVentasQuery.SelltoCounty;
                Rec.Divisa := AbonVentasQuery.CurrencyCode;
                Rec."Términos Pago" := AbonVentasQuery.PaymentMethodCode;
                Rec.Vendedor := AbonVentasQuery.SalespersonCode;
                Rec."Cod Transportista" := AbonVentasQuery.ShippingAgentCode;
                Rec."Cod Servicio Transportista" := AbonVentasQuery.Shipping_Agent_Service_Code;
                Rec.Fecha := AbonVentasQuery.PostingDate;
                Rec."Forma Pago" := AbonVentasQuery.PaymentMethodCode;
                Rec."Terminos Pago" := AbonVentasQuery.PaymentTermsCode;
                Rec.Factura := AbonVentasQuery.HNo;
                Rec."AÑO" := Date2DMY(AbonVentasQuery.PostingDate, 3);
                Rec.MES := Date2DMY(AbonVentasQuery.PostingDate, 2);
                Rec.CLIENTE := Format(AbonVentasQuery.HSelltoCustomerNo + ' ' + AbonVentasQuery.SelltoCustomerName);
                //Customer
                if AbonVentasQuery.SelltoPhoneNo <> '' then
                    Rec."Teléfono" := AbonVentasQuery.SelltoPhoneNo
                else
                    Rec."Teléfono" := AbonVentasQuery.Phone_No_;
                if AbonVentasQuery.SelltoEMail <> '' then
                    Rec."Correo Electrónico" := AbonVentasQuery.SelltoEMail
                else
                    Rec."Correo Electrónico" := AbonVentasQuery.E_Mail;
                if AbonVentasQuery.SelltoContact <> '' then
                    Rec.Contacto := AbonVentasQuery.SelltoContact
                else
                    Rec.Contacto := AbonVentasQuery.Contact;
                Rec.Alias := AbonVentasQuery.Search_Name;
                Rec.Bloqueado := Format(AbonVentasQuery.Blocked);
                Rec."Crédito Maximo" := AbonVentasQuery.Credit_Limit__LCY_;
                Rec."Aviso Envío" := Format(AbonVentasQuery.Shipping_Advice);
                Rec."Facturación Automática" := '0';
                Rec."Fecha Ultima Modificación" := AbonVentasQuery.Last_Date_Modified;
                Rec."Cod Agente" := AbonVentasQuery.Shipping_Agent_Code;
                Rec."Linea Empresa" := AbonVentasQuery.ShortcutDimension2Code;
                //SL Line
                Rec."Grupo Dto" := AbonVentasQuery.CustomerDiscGroup;
                Rec."Grupo Contable" := AbonVentasQuery.GenBusPostingGroup;
                Rec."Grupo Precio" := AbonVentasQuery.CustomerPriceGroup;
                Rec."Términos Pago" := AbonVentasQuery.PaymentMethodCode;
                Rec.Producto := AbonVentasQuery.No;
                Rec."Descripción" := AbonVentasQuery.Description;
                // Get Item info for Formato and Weight
                if AbonVentasQuery.Type = AbonVentasQuery.Type::Item then begin
                    if Item.Get(AbonVentasQuery.No) then begin
                        Rec.Formato := Item.Formato;
                        Rec."Peso Formato" := Item."JMC Weight";
                    end;
                end;
                Rec.CANTIDAD := AbonVentasQuery.Quantity * -1;
                Rec."€ SIN IVA" := AbonVentasQuery.LineAmount * -1;
                Rec."€ CON IVA" := AbonVentasQuery.AmountIncludingVAT * -1;
                Rec.PRECIO := AbonVentasQuery.UnitPrice;
                Rec.Dto := AbonVentasQuery.LineDiscountAmount;
                Rec."% Descuento" := AbonVentasQuery.LineDiscount;
                Rec.Importe := AbonVentasQuery.LineAmount * -1;
                Rec."Base IVA" := AbonVentasQuery.VATBaseAmount * -1;
                Rec.Comision := 0;
                Rec.LineasNegocio := AbonVentasQuery.ShortcutDimension1Code;
                Rec.TipoLinea := Format(AbonVentasQuery.Type);
                Rec."Cod. Almacén" := AbonVentasQuery.LocationCode;
                Rec."Importe Pendiente" := AbonVentasQuery.RemainingAmount;
                if Rec."Importe Pendiente" = 0 then
                    Rec.Pagado := 'SI'
                else
                    Rec.Pagado := 'NO';
                Rec."Peso Neto Linea" := AbonVentasQuery.NetWeight * AbonVentasQuery.Quantity * -1;
                Rec."Tipo Documento" := 'Abono';
                if AbonVentasQuery.FechaServicio = 0D then begin
                    if AbonVentasQuery.CorrectedInvoiceNo <> '' then begin
                        RecSIH.Reset();
                        RecSIH.SetRange("No.", AbonVentasQuery.CorrectedInvoiceNo);
                        if RecSIH.FindFirst() then
                            Rec."Fecha Servicio" := RecSIH."Posting Date"
                        else
                            Rec."Fecha Servicio" := AbonVentasQuery.PostingDate;
                    end
                    else
                        Rec."Fecha Servicio" := AbonVentasQuery.PostingDate;
                end
                else
                    Rec."Fecha Servicio" := AbonVentasQuery.FechaServicio;

                //JMC Fields
                Rec."Devolucion" := AbonVentasQuery.JMCReturn;
                Rec."Comentarios" := AbonVentasQuery.JMCComments;

                Rec.Insert();
            end;
            AbonVentasQuery.Close();
            Rec.SetCurrentKey(Fecha);
            Rec.Ascending(false);
        end;
    end;
}