class LAWFire extends KFMod.LAWFire;

function DoFireEffect() {
    local GSTPlayerReplicationInfo pri;

    super.DoFireEffect();
    pri= GSTPlayerReplicationInfo(Instigator.Controller.PlayerReplicationInfo);
    pri.addToWeaponStat(pri.WeaponStat.ROCKETS_LAUNCHED, Load);
}

defaultproperties {
    ProjectileClass=class'GameStatsTab.LAWProjectile'
}
