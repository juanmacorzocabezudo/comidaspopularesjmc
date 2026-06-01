permissionset 53111 "JMC OPER. REC. MGT"
{
    Caption = 'Operation Record Maintenance', Comment = 'ESP="Mantenimiento registro operativo"';
    Assignable = true;

    Permissions =
        table "JMC Cronus" = X,
        tabledata "JMC Cronus" = RIMD,
        table "JMC Cronus Jnl. Line" = X,
        tabledata "JMC Cronus Jnl. Line" = RIMD,
        page "JMC Cronus" = X,
        page "JMC Oper. Rec. Journal" = X,
        page "JMC Cronus Statistics" = X,
        codeunit "JMC Oper. Rec. Jnl. Mgt" = X;
}
