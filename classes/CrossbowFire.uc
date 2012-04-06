class CrossbowFire extends KFMod.CrossbowFire;

function DoFireEffect() {
    local GSTPlayerReplicationInfo pri;

    super.DoFireEffect();
    pri= GSTPlayerReplicationInfo(Instigator.Controller.PlayerReplicationInfo);
    pri.addToWeaponStat(pri.WeaponStat.BOLTS_FIRED, Load);
}

defaultproperties {
    ProjectileClass=class'GameStatsTab.CrossbowArrow'
}
