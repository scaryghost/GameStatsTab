class M79Fire extends KFMod.M79Fire;

function DoFireEffect() {
    local GSTPlayerReplicationInfo pri;

    super.DoFireEffect();
    pri= GSTPlayerReplicationInfo(Instigator.Controller.PlayerReplicationInfo);
    pri.addToWeaponStat(pri.WeaponStat.GRENADES_LAUNCHED, Load);
}

defaultproperties {
    ProjectileClass=class'GameStatsTab.M79Projectile'
}
