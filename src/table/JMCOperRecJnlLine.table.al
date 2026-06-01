table 53111 "JMC Cronus Jnl. Line"
{
    Caption = 'Cronus Journal Line', Comment = 'ESP="Linea diario CRONUS"';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "JMC Entry No."; Integer)
        {
            Caption = 'Entry No.', Comment = 'ESP="Nº linea"';
            DataClassification = SystemMetadata;
            AutoIncrement = true;
        }
        field(2; "JMC Posting Date"; Date)
        {
            Caption = 'Posting Date', Comment = 'ESP="Fecha registro"';
            DataClassification = CustomerContent;
            NotBlank = true;

            trigger OnValidate()
            begin
                if "JMC Posting Date" = 0D then
                    "JMC Posting Date" := WorkDate();
            end;
        }
        field(3; "JMC Movement Type"; Option)
        {
            Caption = 'Movement Type', Comment = 'ESP="Tipo de movimiento"';
            OptionMembers = Income,Expense;
            OptionCaption = 'Income,Expense', Comment = 'ESP="Ingreso,Gasto"';
            DataClassification = CustomerContent;
        }
        field(4; "JMC Amount"; Decimal)
        {
            Caption = 'Amount', Comment = 'ESP="Importe"';
            DataClassification = CustomerContent;
        }
        field(5; "JMC Concept"; Text[100])
        {
            Caption = 'Concept', Comment = 'ESP="Concepto"';
            DataClassification = CustomerContent;
        }
        field(6; "JMC Detail"; Text[250])
        {
            Caption = 'Detail', Comment = 'ESP="Detalle"';
            DataClassification = CustomerContent;
        }
        field(7; "JMC Business Line"; Code[20])
        {
            Caption = 'Business Line', Comment = 'ESP="Linea de negocio"';
            TableRelation = "JMC Business Line"."JMC Code";
            DataClassification = CustomerContent;
        }
        field(8; "JMC Family"; Code[20])
        {
            Caption = 'Family', Comment = 'ESP="Familia"';
            TableRelation = "JMC Family"."JMC Code";
            DataClassification = CustomerContent;
        }
        field(9; "JMC Responsible User"; Guid)
        {
            Caption = 'Responsible User', Comment = 'ESP="Usuario responsable"';
            TableRelation = User."User Security ID";
            DataClassification = EndUserPseudonymousIdentifiers;

            trigger OnValidate()
            var
                jmcUser: Record User;
            begin
                if not IsNullGuid("JMC Responsible User") then begin
                    if jmcUser.Get("JMC Responsible User") then
                        "JMC Responsible User Name" := jmcUser."User Name"
                    else
                        "JMC Responsible User Name" := '';
                end else
                    "JMC Responsible User Name" := '';
            end;
        }
        field(18; "JMC Responsible User Name"; Code[50])
        {
            Caption = 'User Name', Comment = 'ESP="Nombre de usuario"';
            Editable = false;
            DataClassification = EndUserIdentifiableInformation;
        }
        field(10; "JMC External Reference"; Code[50])
        {
            Caption = 'External Reference', Comment = 'ESP="Referencia externa"';
            DataClassification = CustomerContent;
        }
        field(11; "JMC Comments"; Text[250])
        {
            Caption = 'Comments', Comment = 'ESP="Comentarios"';
            DataClassification = CustomerContent;
        }
        field(12; "JMC Registered"; Boolean)
        {
            Caption = 'Registered', Comment = 'ESP="Registrado"';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(13; "JMC Registered DateTime"; DateTime)
        {
            Caption = 'Registered DateTime', Comment = 'ESP="Fecha/hora registro"';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(14; "JMC Registered By"; Code[50])
        {
            Caption = 'Registered By', Comment = 'ESP="Registrado por"';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(15; "JMC Cash Box"; Enum "JMC Cash Box")
        {
            Caption = 'Cash Box', Comment = 'ESP="Caja"';
            DataClassification = CustomerContent;
        }
        field(16; "JMC G/L Account No."; Code[20])
        {
            Caption = 'No.', Comment = 'ESP="Nº"';
            TableRelation = "G/L Account"."No.";
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                jmcGLAccount: Record "G/L Account";
            begin
                if "JMC G/L Account No." <> '' then begin
                    if jmcGLAccount.Get("JMC G/L Account No.") then
                        "JMC Account Description" := jmcGLAccount.Name
                    else
                        "JMC Account Description" := '';
                end else
                    "JMC Account Description" := '';
            end;
        }
        field(17; "JMC Account Description"; Text[100])
        {
            Caption = 'Account', Comment = 'ESP="Cuenta"';
            Editable = false;
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "JMC Entry No.")
        {
            Clustered = true;
        }

        key(RegistrationStatus; "JMC Registered", "JMC Posting Date")
        {
        }
    }

    trigger OnInsert()
    begin
        if "JMC Posting Date" = 0D then
            "JMC Posting Date" := WorkDate();
    end;
}
