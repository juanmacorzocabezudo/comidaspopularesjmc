tableextension 53118 "JMC Company Information" extends "Company Information"
{
    fields
    {
        field(53100; "JMC Sales Doc Insurance Logo"; Blob)
        {
            Caption = 'Sales Doc Insurance Logo', Comment = 'ESP="Logo seguro doc. venta"';
            DataClassification = CustomerContent;
            Subtype = Bitmap;
        }
    }
}
