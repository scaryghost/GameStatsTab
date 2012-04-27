class Dual44MagnumFire extends KFMod.Dual44MagnumFire;

function DoFireEffect() {
    local GSTPlayerReplicationInfo pri;

    super.DoFireEffect();
    pri= GSTPlayerReplicationInfo(Instigator.Controller.PlayerReplicationInfo);
    pri.addToWeaponStat(pri.WeaponStat.PISTOL_ROUNDS_FIRED, Load);
}
