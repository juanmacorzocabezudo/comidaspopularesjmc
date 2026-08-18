pageextension 53135 "JMC Report Selection Sales" extends "Report Selection - Sales"
{
    layout
    {
        addafter("Use for Email Body")
        {
            field("JMC Use Industry Report"; Rec."JMC Use Industry Report")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies if the Industry report should be used when sending this document by email.', Comment = 'ESP="Especifica si se debe usar el informe de Industria al enviar este documento por correo electrónico."';
            }
        }
    }
}
