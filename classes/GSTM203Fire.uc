class GSTM203Fire extends M203Fire;

function DoFireEffect() {
    local GSTPlayerReplicationInfo pri;

    super.DoFireEffect();
    pri= GSTPlayerReplicationInfo(Instigator.Controller.PlayerReplicationInfo);
    pri.kfWeaponStats[pri.WeaponStat.GRENADES_LAUNCHED]+= Load;
}

defaultproperties {
    ProjectileClass=class'GameStatsTab.M203Projectile'
}
