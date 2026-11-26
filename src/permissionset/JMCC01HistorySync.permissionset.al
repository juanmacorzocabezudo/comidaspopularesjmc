permissionset 53102 "JMC C01 HISTORY SYNC"
{
    Caption = 'C01 History Synchronization', Comment = 'ESP="Sincronización del histórico C01"';
    Assignable = true;

    Permissions =
        tabledata "JMC C01 Cost History" = Rm,
        codeunit "JMC C01 Cost History Events" = X;
}
