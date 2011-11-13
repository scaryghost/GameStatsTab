class GSTChainsawFire extends ChainsawFire;

function DoFireEffect() {
    local GSTPlayerReplicationInfo pri;

    super.DoFireEffect();
    pri= GSTPlayerReplicationInfo(Instigator.Controller.PlayerReplicationInfo);
    pri.incrementStat(pri.EStatKeys.MELEE_SWINGS, 1.0);
}
