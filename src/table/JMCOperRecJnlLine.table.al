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

            trigger OnValidate()
            begin
                if "JMC Amount" <> 0 then
                    "JMC Amount" := NormalizeAmount("JMC Amount", "JMC Movement Type");
            end;
        }
        field(4; "JMC Amount"; Decimal)
        {
            Caption = 'Amount', Comment = 'ESP="Importe"';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "JMC Amount" <> 0 then
                    "JMC Amount" := NormalizeAmount("JMC Amount", "JMC Movement Type");
            end;
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
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('LINEA'));
            DataClassification = CustomerContent;
        }
        field(22; "JMC Business Line Name"; Text[100])
        {
            Caption = 'Business Line Name', Comment = 'ESP="Nombre línea negocio"';
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Value".Name where("Dimension Code" = const('LINEA'), Code = field("JMC Business Line")));
            Editable = false;
        }
        field(8; "JMC Family"; Code[20])
        {
            Caption = 'Family', Comment = 'ESP="Familia"';
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('FAMILIA'));
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                CalcFields("JMC Family Name");
            end;
        }
        field(23; "JMC Family Name"; Text[100])
        {
            Caption = 'Family Name', Comment = 'ESP="Nombre familia"';
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Value".Name where("Dimension Code" = const('FAMILIA'), Code = field("JMC Family")));
            Editable = false;
        }
        field(24; "JMC Customer Type"; Code[20])
        {
            Caption = 'Customer Type', Comment = 'ESP="Tipo cliente"';
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('TIPO CLIENTE'));
            DataClassification = CustomerContent;
        }
        field(25; "JMC Customer Type Name"; Text[100])
        {
            Caption = 'Customer Type Name', Comment = 'ESP="Nombre tipo cliente"';
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Value".Name where("Dimension Code" = const('TIPO CLIENTE'), Code = field("JMC Customer Type")));
            Editable = false;
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

            trigger OnLookup()
            var
                jmcGLAccount: Record "G/L Account";
            begin
                jmcGLAccount.Reset();
                if jmcGLAccount.FindSet() then
                    repeat
                        if StrLen(jmcGLAccount."No.") < 8 then
                            jmcGLAccount.Mark(false)
                        else
                            jmcGLAccount.Mark(true);
                    until jmcGLAccount.Next() = 0;
                jmcGLAccount.MarkedOnly(true);
                if Page.RunModal(Page::"G/L Account List", jmcGLAccount) = Action::LookupOK then begin
                    "JMC G/L Account No." := jmcGLAccount."No.";
                    Validate("JMC G/L Account No.");
                end;
            end;

            trigger OnValidate()
            var
                jmcGLAccount: Record "G/L Account";
            begin
                if "JMC G/L Account No." <> '' then begin
                    if jmcGLAccount.Get("JMC G/L Account No.") then begin
                        "JMC Account Description" := jmcGLAccount.Name;
                        if "JMC Resource No." = '' then
                            "JMC Cost Type" := jmcGLAccount."JMC Cost Type";
                    end else
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
        field(19; "JMC Resource No."; Code[20])
        {
            Caption = 'Resource No.', Comment = 'ESP="Nº recurso"';
            TableRelation = Resource."No." where(Type = const(Person));
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                jmcResource: Record Resource;
            begin
                if "JMC Resource No." <> '' then begin
                    if jmcResource.Get("JMC Resource No.") then begin
                        "JMC Resource Name" := jmcResource.Name;
                        "JMC Cost Type" := jmcResource."JMC Cost Type";
                    end else
                        "JMC Resource Name" := '';
                end else
                    "JMC Resource Name" := '';
            end;
        }
        field(20; "JMC Resource Name"; Text[100])
        {
            Caption = 'Resource Name', Comment = 'ESP="Nombre recurso"';
            DataClassification = CustomerContent;
        }
        field(21; "JMC Cost Type"; Enum "JMC Cost Type")
        {
            Caption = 'Type', Comment = 'ESP="Tipo"';
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

    local procedure NormalizeAmount(jmcAmount: Decimal; jmcMovementType: Option Income,Expense): Decimal
    var
        jmcAmountCannotBeZeroErr: Label 'Amount must be different from zero.', Comment = 'ESP="El importe debe ser distinto de cero."';
    begin
        if jmcAmount = 0 then
            Error(jmcAmountCannotBeZeroErr);

        case jmcMovementType of
            jmcMovementType::Income:
                exit(Abs(jmcAmount));
            jmcMovementType::Expense:
                exit(-Abs(jmcAmount));
        end;
    end;
}
