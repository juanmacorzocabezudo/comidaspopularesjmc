table 53100 JMCAlxControlVenta
{
    TableType = Temporary;
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(2; "Cliente No"; Code[20])
        {
            Caption = 'Customer No.', Comment = 'ESP="Cliente No"';
        }
        field(3; Nombre; Text[150])
        {
            Caption = 'Name', Comment = 'ESP="Nombre"';
        }
        field(4; "Dirección"; Text[150])
        {
            Caption = 'Address', Comment = 'ESP="Dirección"';
        }
        field(5; "Dirección 2"; Text[150])
        {
            Caption = 'Address 2', Comment = 'ESP="Dirección 2"';
        }
        field(6; "Código Postal"; Code[50])
        {
            Caption = 'Post Code', Comment = 'ESP="Código Postal"';
        }
        field(7; "Población"; Text[150])
        {
            Caption = 'City', Comment = 'ESP="Población"';
        }
        field(8; Provincia; Text[150])
        {
            Caption = 'County', Comment = 'ESP="Provincia"';
        }
        field(9; "Teléfono"; Text[150])
        {
            Caption = 'Phone', Comment = 'ESP="Teléfono"';
        }
        field(10; "Correo Electrónico"; Text[150])
        {
            Caption = 'Email', Comment = 'ESP="Correo Electrónico"';
        }
        field(11; Contacto; Text[150])
        {
            Caption = 'Contact', Comment = 'ESP="Contacto"';
        }
        field(12; "Cod. Almacén"; Text[150])
        {
            Caption = 'Location Code', Comment = 'ESP="Cod. Almacén"';
        }
        field(13; Bloqueado; Text[50])
        {
            Caption = 'Blocked', Comment = 'ESP="Bloqueado"';
        }
        field(14; "Crédito Maximo"; Decimal)
        {
            Caption = 'Credit Limit', Comment = 'ESP="Crédito Maximo"';
        }
        field(15; Divisa; Code[50])
        {
            Caption = 'Currency', Comment = 'ESP="Divisa"';
        }
        field(16; "Grupo Dto"; Code[50])
        {
            Caption = 'Discount Group', Comment = 'ESP="Grupo Dto"';
        }
        field(17; "Grupo Contable"; Code[50])
        {
            Caption = 'Posting Group', Comment = 'ESP="Grupo Contable"';
        }
        field(18; "Grupo Precio"; Code[50])
        {
            Caption = 'Price Group', Comment = 'ESP="Grupo Precio"';
        }
        field(19; "Términos Pago"; Code[50])
        {
            Caption = 'Payment Terms', Comment = 'ESP="Términos Pago"';
        }
        field(20; Vendedor; Code[50])
        {
            Caption = 'Salesperson', Comment = 'ESP="Vendedor"';
        }
        field(21; "Cod Transportista"; Code[50])
        {
            Caption = 'Shipping Agent Code', Comment = 'ESP="Cod Transportista"';
        }
        field(22; "Cod Servicio Transportista"; Code[50])
        {
            Caption = 'Shipping Agent Service Code', Comment = 'ESP="Cod Servicio Transportista"';
        }
        field(23; "Aviso Envío"; Code[50])
        {
            Caption = 'Shipping Advice', Comment = 'ESP="Aviso Envío"';
        }
        field(24; "Facturación Automática"; Text[150])
        {
            Caption = 'Automatic Invoicing', Comment = 'ESP="Facturación Automática"';
        }
        field(25; "Fecha Ultima Modificación"; Date)
        {
            Caption = 'Last Modified Date', Comment = 'ESP="Fecha Ultima Modificación"';
        }
        field(26; "Cod Agente"; Code[50])
        {
            Caption = 'Agent Code', Comment = 'ESP="Cod Agente"';
        }
        field(27; Factura; Text[50])
        {
            Caption = 'Invoice', Comment = 'ESP="Factura"';
        }
        field(28; Fecha; Date)
        {
            Caption = 'Date', Comment = 'ESP="Fecha"';
        }
        field(29; "AÑO"; Integer)
        {
            Caption = 'YEAR', Comment = 'ESP="AÑO"';
        }
        field(30; MES; Integer)
        {
            Caption = 'MONTH', Comment = 'ESP="MES"';
        }
        field(31; CLIENTE; Text[150])
        {
            Caption = 'CUSTOMER', Comment = 'ESP="CLIENTE"';
        }
        field(32; "Linea Empresa"; Code[20])
        {
            Caption = 'Business Line', Comment = 'ESP="Linea Empresa"';
        }
        field(33; Producto; Code[20])
        {
            Caption = 'Product', Comment = 'ESP="Producto"';
        }
        field(34; "Descripción"; Text[150])
        {
            Caption = 'Description', Comment = 'ESP="Descripción"';
        }
        field(35; CANTIDAD; Decimal)
        {
            Caption = 'QUANTITY', Comment = 'ESP="CANTIDAD"';
        }
        field(36; "€ SIN IVA"; Decimal)
        {
            Caption = '€ W/O VAT', Comment = 'ESP="€ SIN IVA"';
        }
        field(37; "€ CON IVA"; Decimal)
        {
            Caption = '€ W/ VAT', Comment = 'ESP="€ CON IVA"';
        }
        field(38; PRECIO; Decimal)
        {
            Caption = 'PRICE', Comment = 'ESP="PRECIO"';
        }
        field(39; Dto; Decimal)
        {
            Caption = 'Discount', Comment = 'ESP="Dto"';
        }
        field(40; "% Descuento"; Decimal)
        {
            Caption = 'Discount %', Comment = 'ESP="% Descuento"';
        }
        field(41; Importe; Decimal)
        {
            Caption = 'Amount', Comment = 'ESP="Importe"';
        }
        field(42; "Base IVA"; Decimal)
        {
            Caption = 'VAT Base', Comment = 'ESP="Base IVA"';
        }
        field(43; Comision; Decimal)
        {
            Caption = 'Commission', Comment = 'ESP="Comision"';
        }
        field(44; LineasNegocio; Code[50])
        {
            Caption = 'Business Lines', Comment = 'ESP="LineasNegocio"';
        }
        field(45; TipoLinea; Text[50])
        {
            Caption = 'Line Type', Comment = 'ESP="TipoLinea"';
        }
        field(46; "Importe Pendiente"; Decimal)
        {
            Caption = 'Remaining Amount', Comment = 'ESP="Importe Pendiente"';
        }
        field(47; Pagado; Text[10])
        {
            Caption = 'Paid', Comment = 'ESP="Pagado"';
        }
        field(48; "Forma Pago"; Code[50])
        {
            Caption = 'Payment Method', Comment = 'ESP="Forma Pago"';
        }
        field(49; "Peso Neto Linea"; Decimal)
        {
            Caption = 'Net Weight Line', Comment = 'ESP="Peso Neto Linea"';
        }
        field(50; "Tipo Documento"; Text[150])
        {
            Caption = 'Document Type', Comment = 'ESP="Tipo Documento"';
        }
        field(51; Alias; Text[150])
        {
            Caption = 'Alias', Comment = 'ESP="Alias"';
        }
        field(52; "Fecha Servicio"; Date)
        {
            Caption = 'Service Date', Comment = 'ESP="Fecha Servicio"';
        }
        field(53; "Terminos Pago"; Code[10])
        {
            Caption = 'Payment Terms', Comment = 'ESP="Termino Pago"';
        }
        field(54; "Devolucion"; Boolean)
        {
            Caption = 'Return', Comment = 'ESP="Devolución"';
        }
        field(55; "Comentarios"; Text[150])
        {
            Caption = 'Comments', Comment = 'ESP="Comentarios"';
        }
        field(56; Formato; Code[20])
        {
            Caption = 'Format', Comment = 'ESP="Formato"';
        }
        field(57; "Peso Formato"; Decimal)
        {
            Caption = 'Format Weight', Comment = 'ESP="Peso Formato"';
            DecimalPlaces = 0 : 5;
        }
    }
    keys
    {
        key(PK; "Line No.", "Cliente No")
        {
            Clustered = true;
        }
    }
}
