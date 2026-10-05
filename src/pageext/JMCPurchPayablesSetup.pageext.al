pageextension 53319 "JMC Purch. Payables Setup" extends "Purchases & Payables Setup"
{
    layout
    {
        addlast(General)
        {
            field("JMC Supplier Incident Nos."; Rec."JMC Supplier Incident Nos.")
            {
                ApplicationArea = All;
                Caption = 'Supplier Incident Nos.', Comment = 'ESP="Nº serie incidencias proveedor"';
                ToolTip = 'Specifies the number series used for supplier incidents.', Comment = 'ESP="Especifica la serie numérica utilizada para las incidencias de proveedor."';
            }
        }
    }
}