tableextension 53117 "JMC Sales & Receivables Setup" extends "Sales & Receivables Setup"
{
    fields
    {
        field(53100; "JMC Credit Limit Email"; Text[250])
        {
            Caption = 'Credit Limit Notification Email', Comment = 'ESP="Email notificación límite crédito"';
            DataClassification = CustomerContent;
            ExtendedDatatype = EMail;
        }
    }
}
