tableextension 53121 "JMC G/L Entry" extends "G/L Entry"
{
    fields
    {
        field(53100; "JMC Resource No."; Code[20])
        {
            Caption = 'Resource Code', Comment = 'ESP="Código recurso"';
            ToolTip = 'Identifies the resource associated with this accounting expense. Payroll integration supplies this value.', Comment = 'ESP="Identifica el recurso asociado a este gasto contable. La integración de nóminas informa este valor."';
            DataClassification = CustomerContent;
            TableRelation = Resource."No.";
        }
    }
}
