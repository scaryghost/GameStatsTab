class GSTShotgunFire extends ShotgunFire;

function DoFireEffect() {
    local GSTPlayerReplicationInfo pri;

    super.DoFireEffect();
    pri= GSTPlayerReplicationInfo(Instigator.Controller.PlayerReplicationInfo);
    pri.kfWeaponStats[pri.WeaponStat.SHELLS_FIRED]+= Load;
}
