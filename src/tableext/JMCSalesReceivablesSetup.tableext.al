tableextension 53117 "JMC Sales & Receivables Setup" extends "Sales & Receivables Setup"
{
    fields
    {
        field(53100; "JMC Credit Limit Email"; Text[250])
        {
            Caption = 'Credit Limit Notification Email', Comment = 'ESP="Email notificación límite crédito"';
            DataClassification = CustomerContent;
            ExtendedDatatype = EMail;
        }
        field(53101; "JMC Company Name"; Text[100])
        {
            Caption = 'Company Name', Comment = 'ESP="Nombre empresa"';
            DataClassification = CustomerContent;
        }
        field(53102; "JMC Company Address"; Text[100])
        {
            Caption = 'Company Address', Comment = 'ESP="Dirección empresa"';
            DataClassification = CustomerContent;
        }
        field(53103; "JMC Company Address 2"; Text[50])
        {
            Caption = 'Company Address 2', Comment = 'ESP="Dirección empresa 2"';
            DataClassification = CustomerContent;
        }
        field(53104; "JMC Company City"; Text[30])
        {
            Caption = 'Company City', Comment = 'ESP="Ciudad empresa"';
            DataClassification = CustomerContent;
        }
        field(53105; "JMC Company Post Code"; Code[20])
        {
            Caption = 'Company Post Code', Comment = 'ESP="Código postal empresa"';
            DataClassification = CustomerContent;
        }
        field(53106; "JMC Company County"; Text[30])
        {
            Caption = 'Company County', Comment = 'ESP="Provincia empresa"';
            DataClassification = CustomerContent;
        }
        field(53107; "JMC Company Phone No."; Text[30])
        {
            Caption = 'Company Phone No.', Comment = 'ESP="Teléfono empresa"';
            DataClassification = CustomerContent;
            ExtendedDatatype = PhoneNo;
        }
        field(53108; "JMC Company E-Mail"; Text[80])
        {
            Caption = 'Company E-Mail', Comment = 'ESP="Email empresa"';
            DataClassification = CustomerContent;
            ExtendedDatatype = EMail;
        }
        field(53109; "JMC Company Home Page"; Text[80])
        {
            Caption = 'Company Home Page', Comment = 'ESP="Página web empresa"';
            DataClassification = CustomerContent;
            ExtendedDatatype = URL;
        }
        field(53110; "JMC Company VAT Reg. No."; Text[20])
        {
            Caption = 'Company VAT Registration No.', Comment = 'ESP="CIF empresa"';
            DataClassification = CustomerContent;
        }
        field(53112; "JMC Sales Doc Insurance Logo"; Blob)
        {
            Caption = 'Sales Document Insurance Logo', Comment = 'ESP="Logo seguro documentos venta"';
            DataClassification = CustomerContent;
            Subtype = Bitmap;
        }
        field(53113; "JMC Event Type Res. Assign."; Code[100])
        {
            Caption = 'Event Type Res. Assignment', Comment = 'ESP="Tipo Evento Asig. Recursos"';
            DataClassification = CustomerContent;
            TableRelation = Tipo;
        }
        field(53114; "JMC Person Task Res. Assign."; Code[10])
        {
            Caption = 'Person Task Res. Assignment', Comment = 'ESP="Tarea Persona Asig. Recursos"';
            DataClassification = CustomerContent;
            TableRelation = "Work Type";
        }
        field(53115; "JMC Machine Task Res. Assign."; Code[10])
        {
            Caption = 'Machine Task Res. Assignment', Comment = 'ESP="Tarea Máquina Asig. Recursos"';
            DataClassification = CustomerContent;
            TableRelation = "Work Type";
        }
    }

    procedure GetResAssignmentTask(ResourceCode: Code[20]): Code[10]
    var
        Resource: Record Resource;
    begin
        if not Resource.Get(ResourceCode) then
            exit('');
        if not Get() then
            exit('');
        case Resource.Type of
            Resource.Type::Person:
                exit("JMC Person Task Res. Assign.");
            Resource.Type::Machine:
                exit("JMC Machine Task Res. Assign.");
        end;
    end;
}
