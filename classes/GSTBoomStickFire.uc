class GSTBoomStickFire extends BoomStickFire;

function DoFireEffect() {
    local GSTPlayerReplicationInfo pri;

    super.DoFireEffect();
    pri= GSTPlayerReplicationInfo(Instigator.Controller.PlayerReplicationInfo);
    pri.KFWeaponStats[pri.WeaponStat.SHELLS_FIRED]+= Load;
}
