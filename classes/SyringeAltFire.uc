class SyringeAltFire extends KFMod.SyringeAltFire;

function DoFireEffect() {
    local GSTPlayerReplicationInfo pri;

    super.DoFireEffect();
    pri= GSTPlayerReplicationInfo(Instigator.Controller.PlayerReplicationInfo);
    pri.addToPlayerStat(pri.PlayerStat.SELF_HEALS, 1);
}
