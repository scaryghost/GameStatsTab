class ClaymoreSwordFireB extends KFMod.ClaymoreSwordFireB;

function DoFireEffect() {
    local GSTPlayerReplicationInfo pri;

    super.DoFireEffect();
    pri= GSTPlayerReplicationInfo(Instigator.Controller.PlayerReplicationInfo);
    pri.addToWeaponStat(pri.WeaponStat.MELEE_SWINGS, 1);
}