tableextension 53118 "JMC Company Information" extends "Company Information"
{
    fields
    {
        field(53100; "JMC CA Cost Email"; Text[250])
        {
            Caption = 'CA Cost Notification Email', Comment = 'ESP="Email notificación costes CA"';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                jmcMailManagement: Codeunit "Mail Management";
            begin
                if "JMC CA Cost Email" <> '' then
                    jmcMailManagement.CheckValidEmailAddresses("JMC CA Cost Email");
            end;
        }
        field(53101; "JMC PT Cost Email"; Text[250])
        {
            Caption = 'PT Cost Notification Email', Comment = 'ESP="Email notificación costes PT"';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                jmcMailManagement: Codeunit "Mail Management";
            begin
                if "JMC PT Cost Email" <> '' then
                    jmcMailManagement.CheckValidEmailAddresses("JMC PT Cost Email");
            end;
        }
    }
}
