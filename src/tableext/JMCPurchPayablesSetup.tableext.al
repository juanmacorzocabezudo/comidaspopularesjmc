tableextension 53318 "JMC Purch. Payables Setup" extends "Purchases & Payables Setup"
{
    fields
    {
        field(53300; "JMC Supplier Incident Nos."; Code[20])
        {
            Caption = 'Supplier Incident Nos.', Comment = 'ESP="Nº serie incidencias proveedor"';
            DataClassification = CustomerContent;
            TableRelation = "No. Series".Code;
        }
    }
}