class GSTM4203BulletFire extends M4203BulletFire;

function DoFireEffect() {
    local GSTPlayerReplicationInfo pri;

    super.DoFireEffect();
    pri= GSTPlayerReplicationInfo(Instigator.Controller.PlayerReplicationInfo);
    pri.kfWeaponStats[pri.WeaponStat.ROUNDS_FIRED]+= Load;
}
