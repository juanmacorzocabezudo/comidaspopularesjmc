tableextension 53120 "JMC Customer" extends Customer
{
    fields
    {
        field(53120; "JMC Customer Type"; Code[20])
        {
            Caption = 'Customer Type', Comment = 'ESP="Tipo Cliente"';
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('TIPO CLIENTE'));
            DataClassification = CustomerContent;
        }
    }
}