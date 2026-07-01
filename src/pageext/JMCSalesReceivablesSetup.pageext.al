pageextension 53123 "JMC Sales & Receivables Setup" extends "Sales & Receivables Setup"
{
    layout
    {
        addlast(General)
        {
            field("JMC Credit Limit Email"; Rec."JMC Credit Limit Email")
            {
                ApplicationArea = All;
                Caption = 'Credit Limit Notification Email', Comment = 'ESP="Email notificación límite crédito"';
                ToolTip = 'Specifies the email address to send credit limit notifications to.', Comment = 'ESP="Especifica la dirección de email a la que se enviarán las notificaciones de límite de crédito."';
            }
        }
    }
}
