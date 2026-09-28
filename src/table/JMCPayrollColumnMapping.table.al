table 53152 "JMC Payroll Column Mapping"
{
    Caption = 'Payroll Column Mapping', Comment = 'ESP="Mapeo columnas nómina"';
    DataClassification = CustomerContent;
    DrillDownPageId = "JMC Payroll Column Mapping";
    LookupPageId = "JMC Payroll Column Mapping";

    fields
    {
        field(1; "JMC Excel Column"; Enum "JMC Payroll Excel Column")
        {
            Caption = 'Excel Column', Comment = 'ESP="Columna Excel"';
            ToolTip = 'Specifies the column of the payroll Excel file.', Comment = 'ESP="Especifica la columna del Excel de nóminas."';
        }
        field(2; "JMC Informative"; Boolean)
        {
            Caption = 'Informative', Comment = 'ESP="Informativa"';
            ToolTip = 'Specifies that the column is imported for information only and does not generate entry lines.', Comment = 'ESP="Especifica que la columna se importa solo como información y no genera líneas de asiento."';

            trigger OnValidate()
            begin
                if "JMC Informative" then begin
                    "JMC Concept Type" := "JMC Concept Type"::" ";
                    "JMC Balancing Concept Type" := "JMC Balancing Concept Type"::" ";
                end;
            end;
        }
        field(3; "JMC Concept Type"; Enum "JMC Payroll Concept Type")
        {
            Caption = 'Concept Type', Comment = 'ESP="Tipo concepto"';
            ToolTip = 'Specifies the concept of the entry line generated from this column.', Comment = 'ESP="Especifica el concepto de la línea de asiento que genera esta columna."';

            trigger OnValidate()
            begin
                if "JMC Concept Type" <> "JMC Concept Type"::" " then
                    "JMC Informative" := false;
            end;
        }
        field(4; "JMC Posting Sign"; Option)
        {
            Caption = 'Posting Sign', Comment = 'ESP="Signo contable"';
            ToolTip = 'Specifies how the Excel amount becomes the entry amount. Same as Excel: a positive value is posted as debit and a negative value as credit. Reverse: a positive value is posted as credit.', Comment = 'ESP="Especifica cómo se convierte el importe del Excel en el importe del asiento. Igual que Excel: un valor positivo va al debe y uno negativo al haber. Invertido: un valor positivo va al haber."';
            OptionMembers = "Same as Excel",Reverse;
            OptionCaption = 'Same as Excel,Reverse', Comment = 'ESP="Igual que Excel,Invertido"';
        }
        field(5; "JMC Balancing Concept Type"; Enum "JMC Payroll Concept Type")
        {
            Caption = 'Balancing Concept Type', Comment = 'ESP="Tipo concepto contrapartida"';
            ToolTip = 'Specifies an optional concept that receives the opposite amount, for columns that are not part of the net pay (for example, extra pay accrual and provision).', Comment = 'ESP="Especifica un concepto opcional que recibe el importe contrario, para columnas que no forman parte del líquido (por ejemplo, devengo y provisión de paga extra)."';

            trigger OnValidate()
            begin
                if "JMC Balancing Concept Type" <> "JMC Balancing Concept Type"::" " then
                    "JMC Informative" := false;
            end;
        }
    }

    keys
    {
        key(PK; "JMC Excel Column")
        {
            Clustered = true;
        }
    }
}
