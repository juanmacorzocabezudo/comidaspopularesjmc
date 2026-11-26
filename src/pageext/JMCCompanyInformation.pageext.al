pageextension 53126 "JMC Company Information" extends "Company Information"
{
    layout
    {
        addlast(Content)
        {
            group(JMCCostNotifications)
            {
                Caption = 'Cost Application Notifications', Comment = 'ESP="Notificaciones de aplicación de costes"';

                field("JMC CA Cost Email"; Rec."JMC CA Cost Email")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the recipients notified when costs are applied to CA, MP and MA products. Separate addresses with semicolons. Leave blank to disable notifications.', Comment = 'ESP="Especifica los destinatarios avisados al aplicar costes a productos CA, MP y MA. Separe las direcciones con punto y coma. Déjelo vacío para no enviar avisos."';
                }
                field("JMC PT Cost Email"; Rec."JMC PT Cost Email")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the recipients notified when costs are applied to PT, PI, PR and SER products. Separate addresses with semicolons. Leave blank to disable notifications.', Comment = 'ESP="Especifica los destinatarios avisados al aplicar costes a productos PT, PI, PR y SER. Separe las direcciones con punto y coma. Déjelo vacío para no enviar avisos."';
                }
            }
        }
    }
}
