class M203Fire extends KFMod.M203Fire;

function DoFireEffect() {
    local GSTPlayerReplicationInfo pri;

    super.DoFireEffect();
    pri= GSTPlayerReplicationInfo(Instigator.Controller.PlayerReplicationInfo);
    pri.addToWeaponStat(pri.WeaponStat.GRENADES_LAUNCHED, Load);
}

defaultproperties {
    ProjectileClass=class'GameStatsTab.M203Projectile'
}
