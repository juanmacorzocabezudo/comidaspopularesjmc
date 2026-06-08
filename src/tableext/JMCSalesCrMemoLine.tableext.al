tableextension 53114 "JMC Sales Cr. Memo Line" extends "Sales Cr.Memo Line"
{
    fields
    {
        field(53100; "JMC Return"; Boolean)
        {
            Caption = 'Return', Comment = 'ESP="Devolución"';
            DataClassification = CustomerContent;
        }
        field(53101; "JMC Comments"; Text[2048])
        {
            Caption = 'Comments', Comment = 'ESP="Comentarios"';
            DataClassification = CustomerContent;
        }
    }
}
