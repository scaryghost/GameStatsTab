class M4203BulletFire extends KFMod.M4203BulletFire;

function DoFireEffect() {
    local GSTPlayerReplicationInfo pri;

    super.DoFireEffect();
    pri= GSTPlayerReplicationInfo(Instigator.Controller.PlayerReplicationInfo);
    pri.addToWeaponStat(pri.WeaponStat.AUTOMATIC_ROUNDS_FIRED, Load);
}
