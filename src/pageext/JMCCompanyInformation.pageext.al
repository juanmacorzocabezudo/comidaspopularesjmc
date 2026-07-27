pageextension 53126 "JMC Company Information" extends "Company Information"
{
    layout
    {
        addlast(content)
        {
            group("JMC Sales Report Data")
            {
                Caption = 'Sales Report Data', Comment = 'ESP="Datos informes de venta"';

                field("JMC SR Name"; Rec.Name)
                {
                    ApplicationArea = All;
                    Caption = 'Company Name', Comment = 'ESP="Nombre empresa"';
                    ToolTip = 'Specifies the company name for sales reports.', Comment = 'ESP="Especifica el nombre de la empresa para informes de venta."';
                    Importance = Promoted;
                    ShowMandatory = true;
                }

                field("JMC SR VAT Registration No."; Rec."VAT Registration No.")
                {
                    ApplicationArea = All;
                    Caption = 'VAT Registration No. (CIF)', Comment = 'ESP="CIF"';
                    ToolTip = 'Specifies the company VAT registration number (CIF) for sales reports.', Comment = 'ESP="Especifica el CIF de la empresa para informes de venta."';
                    Importance = Promoted;
                    ShowMandatory = true;
                }

                field("JMC SR Address"; Rec.Address)
                {
                    ApplicationArea = All;
                    Caption = 'Address', Comment = 'ESP="Dirección"';
                    ToolTip = 'Specifies the company address for sales reports.', Comment = 'ESP="Especifica la dirección de la empresa para informes de venta."';
                    Importance = Promoted;
                    ShowMandatory = true;
                }

                field("JMC SR Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                    Caption = 'Phone No.', Comment = 'ESP="Teléfono"';
                    ToolTip = 'Specifies the company phone number for sales reports.', Comment = 'ESP="Especifica el teléfono de la empresa para informes de venta."';
                    Importance = Promoted;
                    ShowMandatory = true;
                }

                field("JMC SR E-Mail"; Rec."E-Mail")
                {
                    ApplicationArea = All;
                    Caption = 'Email', Comment = 'ESP="Email"';
                    ToolTip = 'Specifies the company email address for sales reports.', Comment = 'ESP="Especifica el email de la empresa para informes de venta."';
                    Importance = Promoted;
                    ShowMandatory = true;
                }

                field("JMC SR Home Page"; Rec."Home Page")
                {
                    ApplicationArea = All;
                    Caption = 'Website', Comment = 'ESP="Página web"';
                    ToolTip = 'Specifies the company website for sales reports.', Comment = 'ESP="Especifica la página web de la empresa para informes de venta."';
                    Importance = Promoted;
                    ShowMandatory = true;
                }

                field("JMC Sales Doc Insurance Logo"; Rec."JMC Sales Doc Insurance Logo")
                {
                    ApplicationArea = All;
                    Caption = 'Insurance Logo', Comment = 'ESP="Logo seguro"';
                    ToolTip = 'Specifies the insurance logo image to display in the top-right corner of sales invoices.', Comment = 'ESP="Especifica la imagen del logo de seguro para mostrar en la esquina superior derecha de las facturas de venta."';
                }
            }
        }
    }
}
