class DeagleFire extends KFMod.DeagleFire;

function DoFireEffect() {
    local GSTPlayerReplicationInfo pri;

    super.DoFireEffect();
    pri= GSTPlayerReplicationInfo(Instigator.Controller.PlayerReplicationInfo);
    pri.addToWeaponStat(pri.WeaponStat.PISTOL_ROUNDS_FIRED, Load);
}
