class GSTM4Fire extends M4Fire;

function DoFireEffect() {
    local GSTPlayerReplicationInfo pri;

    super.DoFireEffect();
    pri= GSTPlayerReplicationInfo(Instigator.Controller.PlayerReplicationInfo);
    pri.kfWeaponStats[pri.WeaponStat.ROUNDS_FIRED]+= Load;
}
