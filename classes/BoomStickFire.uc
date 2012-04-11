class BoomStickFire extends KFMod.BoomStickFire;

function DoFireEffect() {
    local GSTPlayerReplicationInfo pri;

    super.DoFireEffect();
    pri.addToWeaponStat(pri.WeaponStat.SHELLS_FIRED, Load);
}
