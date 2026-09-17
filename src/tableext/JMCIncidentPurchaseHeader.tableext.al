tableextension 53317 "JMC Incident Purchase Header" extends "Purchase Header"
{
    fields
    {
        field(53300; "JMC Related Incident No."; Code[20])
        {
            Caption = 'Related Incident', Comment = 'ESP="Incidencia relacionada"';
            DataClassification = CustomerContent;
            TableRelation = "JMC Supplier Incident"."JMC No." where("JMC Vendor No." = field("Buy-from Vendor No."));
        }
    }
}