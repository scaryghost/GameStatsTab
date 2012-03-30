class GSTChainsawFire extends ChainsawFire;

function DoFireEffect() {
    local GSTPlayerReplicationInfo pri;

    super.DoFireEffect();
    pri= GSTPlayerReplicationInfo(Instigator.Controller.PlayerReplicationInfo);
    pri.kfWeaponStats[pri.WeaponStat.MELEE_SWINGS]+= 1.0;
}
