class GSTLAWFire extends LAWFire;

function DoFireEffect() {
    local GSTPlayerReplicationInfo pri;

    super.DoFireEffect();
    pri= GSTPlayerReplicationInfo(Instigator.Controller.PlayerReplicationInfo);
    pri.incrementStat(pri.EStatKeys.ROCKETS_LAUNCHED, Load);
}
