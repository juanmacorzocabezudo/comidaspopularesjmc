tableextension 53101 "JMC Sales Header" extends "Sales Header"
{
    fields
    {
        field(53100; "JMC Credit Limit Warning Shown"; Boolean)
        {
            Caption = 'Credit Limit Warning Shown', Comment = 'ESP="Aviso límite crédito mostrado"';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
}
