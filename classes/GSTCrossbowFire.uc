class GSTCrossbowFire extends CrossbowFire;

function DoFireEffect() {
    local GSTPlayerReplicationInfo pri;

    super.DoFireEffect();
    pri= GSTPlayerReplicationInfo(Instigator.Controller.PlayerReplicationInfo);
    pri.kfWeaponStats[pri.WeaponStat.BOLTS_FIRED]+= Load;
}

defaultproperties {
    ProjectileClass=class'GameStatsTab.CrossbowArrow'
}
