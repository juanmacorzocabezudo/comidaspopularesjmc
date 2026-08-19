pageextension 53123 "JMC Sales & Receivables Setup" extends "Sales & Receivables Setup"
{
    layout
    {
        addlast(General)
        {
            field("JMC Credit Limit Email"; Rec."JMC Credit Limit Email")
            {
                ApplicationArea = All;
                Caption = 'Credit Limit Notification Email', Comment = 'ESP="Email notificación límite crédito"';
                ToolTip = 'Specifies the email address to send credit limit notifications to.', Comment = 'ESP="Especifica la dirección de email a la que se enviarán las notificaciones de límite de crédito."';
            }
        }
        addlast(content)
        {
            group("JMC Company Information")
            {
                Caption = 'Company Information for Sales Documents', Comment = 'ESP="Información empresa para documentos de venta"';

                field("JMC Company Name"; Rec."JMC Company Name")
                {
                    ApplicationArea = All;
                    Caption = 'Company Name', Comment = 'ESP="Nombre empresa"';
                    ToolTip = 'Specifies the company name to display on sales documents.', Comment = 'ESP="Especifica el nombre de la empresa que se mostrará en los documentos de venta."';
                }
                field("JMC Company Address"; Rec."JMC Company Address")
                {
                    ApplicationArea = All;
                    Caption = 'Address', Comment = 'ESP="Dirección"';
                    ToolTip = 'Specifies the company address to display on sales documents.', Comment = 'ESP="Especifica la dirección de la empresa que se mostrará en los documentos de venta."';
                }
                field("JMC Company Address 2"; Rec."JMC Company Address 2")
                {
                    ApplicationArea = All;
                    Caption = 'Address 2', Comment = 'ESP="Dirección 2"';
                    ToolTip = 'Specifies additional address information to display on sales documents.', Comment = 'ESP="Especifica información adicional de dirección que se mostrará en los documentos de venta."';
                }
                field("JMC Company City"; Rec."JMC Company City")
                {
                    ApplicationArea = All;
                    Caption = 'City', Comment = 'ESP="Ciudad"';
                    ToolTip = 'Specifies the company city to display on sales documents.', Comment = 'ESP="Especifica la ciudad de la empresa que se mostrará en los documentos de venta."';
                }
                field("JMC Company Post Code"; Rec."JMC Company Post Code")
                {
                    ApplicationArea = All;
                    Caption = 'Post Code', Comment = 'ESP="Código postal"';
                    ToolTip = 'Specifies the company post code to display on sales documents.', Comment = 'ESP="Especifica el código postal de la empresa que se mostrará en los documentos de venta."';
                }
                field("JMC Company County"; Rec."JMC Company County")
                {
                    ApplicationArea = All;
                    Caption = 'County', Comment = 'ESP="Provincia"';
                    ToolTip = 'Specifies the company county/province to display on sales documents.', Comment = 'ESP="Especifica la provincia de la empresa que se mostrará en los documentos de venta."';
                }
                field("JMC Company Phone No."; Rec."JMC Company Phone No.")
                {
                    ApplicationArea = All;
                    Caption = 'Phone No.', Comment = 'ESP="Nº teléfono"';
                    ToolTip = 'Specifies the company phone number to display on sales documents.', Comment = 'ESP="Especifica el número de teléfono de la empresa que se mostrará en los documentos de venta."';
                }
                field("JMC Company E-Mail"; Rec."JMC Company E-Mail")
                {
                    ApplicationArea = All;
                    Caption = 'E-Mail', Comment = 'ESP="Email"';
                    ToolTip = 'Specifies the company email to display on sales documents.', Comment = 'ESP="Especifica el email de la empresa que se mostrará en los documentos de venta."';
                }
                field("JMC Company Home Page"; Rec."JMC Company Home Page")
                {
                    ApplicationArea = All;
                    Caption = 'Home Page', Comment = 'ESP="Página web"';
                    ToolTip = 'Specifies the company website to display on sales documents.', Comment = 'ESP="Especifica la página web de la empresa que se mostrará en los documentos de venta."';
                }
                field("JMC Company VAT Reg. No."; Rec."JMC Company VAT Reg. No.")
                {
                    ApplicationArea = All;
                    Caption = 'VAT Registration No.', Comment = 'ESP="CIF/NIF"';
                    ToolTip = 'Specifies the company VAT registration number to display on sales documents.', Comment = 'ESP="Especifica el CIF/NIF de la empresa que se mostrará en los documentos de venta."';
                }
                field("JMC Sales Doc Insurance Logo"; Rec."JMC Sales Doc Insurance Logo")
                {
                    ApplicationArea = All;
                    Caption = 'Insurance Logo', Comment = 'ESP="Logo aseguradora"';
                    ToolTip = 'Specifies the insurance logo to display on sales documents.', Comment = 'ESP="Especifica el logo de la aseguradora que se mostrará en los documentos de venta."';
                }
            }


        }
        addafter("Linea Evento Otros")
        {
            field("JMC Event Type Res. Assign."; Rec."JMC Event Type Res. Assign.")
            {
                ApplicationArea = All;
                Caption = 'Event Type Res. Assignment', Comment = 'ESP="Tipo Evento Asig. Recursos"';
                ToolTip = 'Specifies the event type to use in resource assignment when an event is selected.', Comment = 'ESP="Especifica el tipo de evento a usar en asignación de recursos cuando se selecciona un evento."';
            }
        }
    }
}
