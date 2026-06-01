permissionset 53110 "JMC OPER. REC. READ"
{
    Caption = 'Operation Record Read', Comment = 'ESP="Consulta registro operativo"';
    Assignable = true;

    Permissions =
        table "JMC Cronus" = X,
        tabledata "JMC Cronus" = R,
        page "JMC Cronus" = X,
        page "JMC Cronus Statistics" = X;
}
