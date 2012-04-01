class GSTFragFire extends FragFire;

function DoFireEffect() {
    local GSTPlayerReplicationInfo pri;

    super.DoFireEffect();
    pri= GSTPlayerReplicationInfo(Instigator.Controller.PlayerReplicationInfo);
    pri.kfWeaponStats[pri.WeaponStat.FRAGS_TOSSED]+= 1;
}

defaultproperties {
    ProjectileClass=class'GameStatsTab.FragProjectile'
}
