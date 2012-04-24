class DoshPickup extends CashPickup;

state FadeOut {
    function EndState() {
        local GSTPlayerReplicationInfo pri;

        super.EndState();
        pri= GSTPlayerReplicationInfo(DroppedBy.PlayerReplicationInfo);
        pri.addToPlayerStat(pri.PlayerStat.CASH_VANISHED, CashAmount);
    }
}
