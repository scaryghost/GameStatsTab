class GSTWinchesterFire extends WinchesterFire;

function DoFireEffect() {
    local GSTPlayerReplicationInfo pri;

    super.DoFireEffect();
    pri= GSTPlayerReplicationInfo(Instigator.Controller.PlayerReplicationInfo);
    pri.kfWeaponStats[pri.WeaponStat.ROUNDS_FIRED]+= Load;
}
