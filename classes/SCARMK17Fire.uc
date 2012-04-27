class SCARMK17Fire extends KFMod.SCARMK17Fire;

function DoFireEffect() {
    local GSTPlayerReplicationInfo pri;

    super.DoFireEffect();
    pri= GSTPlayerReplicationInfo(Instigator.Controller.PlayerReplicationInfo);
    pri.addToWeaponStat(pri.WeaponStat.AUTOMATIC_ROUNDS_FIRED, Load);
}
