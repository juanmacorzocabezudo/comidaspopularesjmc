table 53154 "JMC Payroll Import Header"
{
    Caption = 'Payroll Import', Comment = 'ESP="Importación nóminas"';
    DataClassification = CustomerContent;
    DrillDownPageId = "JMC Payroll Import List";
    LookupPageId = "JMC Payroll Import List";

    fields
    {
        field(1; "JMC No."; Integer)
        {
            Caption = 'No.', Comment = 'ESP="Nº"';
            ToolTip = 'Specifies the number of the payroll import.', Comment = 'ESP="Especifica el número de la importación de nóminas."';
            AutoIncrement = true;
            Editable = false;
        }
        field(2; "JMC Description"; Text[100])
        {
            Caption = 'Description', Comment = 'ESP="Descripción"';
            ToolTip = 'Specifies a description of the payroll import.', Comment = 'ESP="Especifica una descripción de la importación de nóminas."';
        }
        field(3; "JMC File Name"; Text[250])
        {
            Caption = 'File Name', Comment = 'ESP="Nombre fichero"';
            ToolTip = 'Specifies the name of the imported Excel file.', Comment = 'ESP="Especifica el nombre del fichero Excel importado."';
            Editable = false;
        }
        field(4; "JMC Import DateTime"; DateTime)
        {
            Caption = 'Import Date/Time', Comment = 'ESP="Fecha/hora importación"';
            ToolTip = 'Specifies when the Excel file was imported.', Comment = 'ESP="Especifica cuándo se importó el fichero Excel."';
            Editable = false;
        }
        field(5; "JMC Imported By"; Code[50])
        {
            Caption = 'Imported By', Comment = 'ESP="Importado por"';
            ToolTip = 'Specifies the user who imported the Excel file.', Comment = 'ESP="Especifica el usuario que importó el fichero Excel."';
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
        }
        field(6; "JMC Status"; Enum "JMC Payroll Import Status")
        {
            Caption = 'Status', Comment = 'ESP="Estado"';
            ToolTip = 'Specifies the status of the payroll import.', Comment = 'ESP="Especifica el estado de la importación de nóminas."';
            Editable = false;
        }
        field(7; "JMC Date From"; Date)
        {
            Caption = 'Date From', Comment = 'ESP="Fecha desde"';
            ToolTip = 'Specifies the first payment date found in the import.', Comment = 'ESP="Especifica la primera fecha de cobro de la importación."';
            Editable = false;
        }
        field(8; "JMC Date To"; Date)
        {
            Caption = 'Date To', Comment = 'ESP="Fecha hasta"';
            ToolTip = 'Specifies the last payment date found in the import.', Comment = 'ESP="Especifica la última fecha de cobro de la importación."';
            Editable = false;
        }
        field(9; "JMC Excel Total Gross"; Decimal)
        {
            Caption = 'Excel Total Gross', Comment = 'ESP="Total bruto Excel"';
            ToolTip = 'Specifies the gross total of the TOTAL EMPRESA row of the Excel file.', Comment = 'ESP="Especifica el total bruto de la fila TOTAL EMPRESA del Excel."';
            AutoFormatType = 1;
            Editable = false;
        }
        field(10; "JMC Excel Total Company SS"; Decimal)
        {
            Caption = 'Excel Total Company SS', Comment = 'ESP="Total SS empresa Excel"';
            ToolTip = 'Specifies the company Social Security total of the TOTAL EMPRESA row of the Excel file.', Comment = 'ESP="Especifica el total de SS empresa de la fila TOTAL EMPRESA del Excel."';
            AutoFormatType = 1;
            Editable = false;
        }
        field(11; "JMC Excel Total Net Pay"; Decimal)
        {
            Caption = 'Excel Total Net Pay', Comment = 'ESP="Total líquido Excel"';
            ToolTip = 'Specifies the net pay total of the TOTAL EMPRESA row of the Excel file.', Comment = 'ESP="Especifica el total líquido de la fila TOTAL EMPRESA del Excel."';
            AutoFormatType = 1;
            Editable = false;
        }
        field(12; "JMC Total Gross"; Decimal)
        {
            Caption = 'Total Gross', Comment = 'ESP="Total bruto"';
            ToolTip = 'Specifies the gross total of the payroll lines.', Comment = 'ESP="Especifica el total bruto de las nóminas."';
            AutoFormatType = 1;
            FieldClass = FlowField;
            CalcFormula = sum("JMC Payroll Import Line"."JMC Gross" where("JMC Import No." = field("JMC No.")));
            Editable = false;
        }
        field(13; "JMC Total Company SS"; Decimal)
        {
            Caption = 'Total Company SS', Comment = 'ESP="Total SS empresa"';
            ToolTip = 'Specifies the company Social Security total of the payroll lines.', Comment = 'ESP="Especifica el total de SS empresa de las nóminas."';
            AutoFormatType = 1;
            FieldClass = FlowField;
            CalcFormula = sum("JMC Payroll Import Line"."JMC Company SS" where("JMC Import No." = field("JMC No.")));
            Editable = false;
        }
        field(14; "JMC Total Net Pay"; Decimal)
        {
            Caption = 'Total Net Pay', Comment = 'ESP="Total líquido"';
            ToolTip = 'Specifies the net pay total of the payroll lines.', Comment = 'ESP="Especifica el total líquido de las nóminas."';
            AutoFormatType = 1;
            FieldClass = FlowField;
            CalcFormula = sum("JMC Payroll Import Line"."JMC Net Pay" where("JMC Import No." = field("JMC No.")));
            Editable = false;
        }
        field(15; "JMC No. of Lines"; Integer)
        {
            Caption = 'No. of Payrolls', Comment = 'ESP="Nº nóminas"';
            ToolTip = 'Specifies the number of payroll lines.', Comment = 'ESP="Especifica el número de nóminas."';
            FieldClass = FlowField;
            CalcFormula = count("JMC Payroll Import Line" where("JMC Import No." = field("JMC No.")));
            Editable = false;
        }
        field(16; "JMC No. of Errors"; Integer)
        {
            Caption = 'No. of Errors', Comment = 'ESP="Nº errores"';
            ToolTip = 'Specifies the number of payroll lines with errors.', Comment = 'ESP="Especifica el número de nóminas con errores."';
            FieldClass = FlowField;
            CalcFormula = count("JMC Payroll Import Line" where("JMC Import No." = field("JMC No."), "JMC Validation Status" = const(Error)));
            Editable = false;
        }
        field(17; "JMC No. of Warnings"; Integer)
        {
            Caption = 'No. of Warnings', Comment = 'ESP="Nº avisos"';
            ToolTip = 'Specifies the number of payroll lines with warnings.', Comment = 'ESP="Especifica el número de nóminas con avisos."';
            FieldClass = FlowField;
            CalcFormula = count("JMC Payroll Import Line" where("JMC Import No." = field("JMC No."), "JMC Validation Status" = const(Warning)));
            Editable = false;
        }
        field(18; "JMC No. of Pending"; Integer)
        {
            Caption = 'No. Pending Validation', Comment = 'ESP="Nº pendientes de validar"';
            ToolTip = 'Specifies the number of payroll lines that must be validated again.', Comment = 'ESP="Especifica el número de nóminas que hay que volver a validar."';
            FieldClass = FlowField;
            CalcFormula = count("JMC Payroll Import Line" where("JMC Import No." = field("JMC No."), "JMC Validation Status" = const(Pending)));
            Editable = false;
        }
        field(19; "JMC Totals Mismatch"; Boolean)
        {
            Caption = 'Totals Mismatch', Comment = 'ESP="Totales no coinciden"';
            ToolTip = 'Specifies that the totals of the payroll lines do not match the TOTAL EMPRESA row of the Excel file.', Comment = 'ESP="Especifica que los totales de las nóminas no coinciden con la fila TOTAL EMPRESA del Excel."';
            Editable = false;
        }
        field(20; "JMC Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name', Comment = 'ESP="Nombre libro diario"';
            ToolTip = 'Specifies the journal template where the lines were created.', Comment = 'ESP="Especifica el libro del diario donde se crearon las líneas."';
            Editable = false;
        }
        field(21; "JMC Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name', Comment = 'ESP="Nombre sección diario"';
            ToolTip = 'Specifies the journal batch where the lines were created.', Comment = 'ESP="Especifica la sección del diario donde se crearon las líneas."';
            Editable = false;
        }
        field(22; "JMC First Document No."; Code[20])
        {
            Caption = 'First Document No.', Comment = 'ESP="Primer nº documento"';
            ToolTip = 'Specifies the first document number created in the journal.', Comment = 'ESP="Especifica el primer nº de documento creado en el diario."';
            Editable = false;
        }
        field(23; "JMC Last Document No."; Code[20])
        {
            Caption = 'Last Document No.', Comment = 'ESP="Último nº documento"';
            ToolTip = 'Specifies the last document number created in the journal.', Comment = 'ESP="Especifica el último nº de documento creado en el diario."';
            Editable = false;
        }
    }

    keys
    {
        key(PK; "JMC No.")
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    var
        jmcPayrollLine: Record "JMC Payroll Import Line";
        jmcPayrollEntry: Record "JMC Payroll Import Entry";
    begin
        TestEditable();
        jmcPayrollEntry.SetRange("JMC Import No.", "JMC No.");
        jmcPayrollEntry.DeleteAll(false);
        jmcPayrollLine.SetRange("JMC Import No.", "JMC No.");
        jmcPayrollLine.DeleteAll(false);
    end;

    procedure IsEditable(): Boolean
    begin
        exit(not ("JMC Status" in ["JMC Status"::"Journal Created", "JMC Status"::Processed]));
    end;

    procedure TestEditable()
    var
        jmcNotEditableErr: Label 'Payroll import %1 cannot be changed because its status is %2.', Comment = 'ESP="La importación de nóminas %1 no se puede modificar porque su estado es %2."';
    begin
        if not IsEditable() then
            Error(jmcNotEditableErr, "JMC No.", "JMC Status");
    end;

    procedure SetPendingValidation()
    begin
        if "JMC Status" = "JMC Status"::Validated then begin
            "JMC Status" := "JMC Status"::Pending;
            Modify(false);
        end;
    end;
}
