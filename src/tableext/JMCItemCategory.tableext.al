tableextension 53324 "JMC Item Category" extends "Item Category"
{
    fields
    {
        field(53100; "JMC Category Type"; Enum "JMC Category Type")
        {
            Caption = 'Category Type', Comment = 'ESP="Tipo categoría"';
            DataClassification = CustomerContent;
        }
    }
}
