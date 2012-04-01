class DoshPickup extends CashPickup;

function GiveCashTo(Pawn Other) {
    local GSTPlayerReplicationInfo pri;

    super.GiveCashTo(Other);
   
    if (Other.Controller != DroppedBy) { 
        pri= GSTPlayerReplicationInfo(DroppedBy.PlayerReplicationInfo);
        pri.playerStats[pri.PlayerStat.CASH_GIVEN]+= CashAmount;
    }
}

state FadeOut {
    function EndState() {
        local GSTPlayerReplicationInfo pri;

        super.EndState();
        pri= GSTPlayerReplicationInfo(DroppedBy.PlayerReplicationInfo);
        pri.playerStats[pri.PlayerStat.CASH_VANISHED]+= CashAmount;
    }
}
