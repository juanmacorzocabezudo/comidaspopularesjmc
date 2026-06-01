table 53110 "JMC Cronus"
{
    Caption = 'Cronus', Comment = 'ESP="Cronus"';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "JMC Entry No."; Integer)
        {
            Caption = 'Entry No.', Comment = 'ESP="Nº movimiento"';
            DataClassification = SystemMetadata;
            AutoIncrement = true;
        }
        field(2; "JMC Posting Date"; Date)
        {
            Caption = 'Posting Date', Comment = 'ESP="Fecha registro"';
            DataClassification = CustomerContent;
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
        }
        field(17; "JMC Responsible User Name"; Code[50])
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
        field(12; "JMC Creation DateTime"; DateTime)
        {
            Caption = 'Creation DateTime', Comment = 'ESP="Fecha/hora creacion"';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(13; "JMC Creation User"; Code[50])
        {
            Caption = 'Responsible User', Comment = 'ESP="Usuario responsable"';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(14; "JMC Cash Box"; Enum "JMC Cash Box")
        {
            Caption = 'Cash Box', Comment = 'ESP="Caja"';
            DataClassification = CustomerContent;
        }
        field(15; "JMC G/L Account No."; Code[20])
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
        field(16; "JMC Account Description"; Text[100])
        {
            Caption = 'Account', Comment = 'ESP="Cuenta"';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(19; "JMC Cronus"; Boolean)
        {
            Caption = 'Cronus', Comment = 'ESP="Cronus"';
            Editable = true;
            InitValue = true;
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(PK; "JMC Entry No.")
        {
            Clustered = true;
        }

        key(PostingDate; "JMC Posting Date")
        {
        }
    }

    procedure AddFromJournalLine(var jmcAnalysisJournalLine: Record "JMC Cronus Jnl. Line")
    begin
        jmcAnalysisJournalLine.TestField("JMC Posting Date");
        jmcAnalysisJournalLine.TestField("JMC Amount");

        Init();
        "JMC Entry No." := 0;
        "JMC Posting Date" := jmcAnalysisJournalLine."JMC Posting Date";
        "JMC Movement Type" := jmcAnalysisJournalLine."JMC Movement Type";
        "JMC Amount" := NormalizeAmount(jmcAnalysisJournalLine."JMC Amount", jmcAnalysisJournalLine."JMC Movement Type");
        "JMC Concept" := jmcAnalysisJournalLine."JMC Concept";
        "JMC Detail" := jmcAnalysisJournalLine."JMC Detail";
        "JMC Business Line" := jmcAnalysisJournalLine."JMC Business Line";
        "JMC Family" := jmcAnalysisJournalLine."JMC Family";
        "JMC External Reference" := jmcAnalysisJournalLine."JMC External Reference";
        "JMC Comments" := jmcAnalysisJournalLine."JMC Comments";
        "JMC Cash Box" := jmcAnalysisJournalLine."JMC Cash Box";
        "JMC G/L Account No." := jmcAnalysisJournalLine."JMC G/L Account No.";
        "JMC Account Description" := jmcAnalysisJournalLine."JMC Account Description";
        "JMC Creation DateTime" := CurrentDateTime();
        "JMC Creation User" := CopyStr(UserId(), 1, MaxStrLen("JMC Creation User"));

        Insert(true);
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
