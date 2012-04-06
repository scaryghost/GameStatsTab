class PipeBombFire extends KFMod.PipeBombFire;

function DoFireEffect() {
    local GSTPlayerReplicationInfo pri;

    super.DoFireEffect();
    pri= GSTPlayerReplicationInfo(Instigator.Controller.PlayerReplicationInfo);
    pri.addToWeaponStat(pri.WeaponStat.PIPES_SET, Load);
}

defaultproperties {
    ProjectileClass=class'GameStatsTab.PipeBombProjectile'
}
