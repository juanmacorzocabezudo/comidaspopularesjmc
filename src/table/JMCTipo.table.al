table 53101 "Tipo"
{
    DataClassification = CustomerContent;
    Caption = 'Tipo';
    LookupPageId = "JMC Tipo";
    DrillDownPageId = "JMC Tipo";

    fields
    {
        field(1; Codigo; Code[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Código';
        }
        field(2; Descripcion; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Descripción';
        }
    }

    keys
    {
        key(Key1; Codigo)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Codigo, Descripcion)
        {
        }
    }
}