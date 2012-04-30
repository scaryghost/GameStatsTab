class SyringeFire extends KFMod.SyringeFire;

function DoFireEffect() {
    local GSTPlayerReplicationInfo pri;

    super.DoFireEffect();
    pri= GSTPlayerReplicationInfo(Instigator.Controller.PlayerReplicationInfo);
    pri.addToPlayerStat(pri.PlayerStat.TEAMMATES_HEALED, 1);
}
