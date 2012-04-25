class MP7MAltFire extends KFMod.MP7MAltFire;

function DoFireEffect() {
    local GSTPlayerReplicationInfo pri;

    super.DoFireEffect();
    pri= GSTPlayerReplicationInfo(Instigator.Controller.PlayerReplicationInfo);
    pri.addToWeaponStat(pri.WeaponStat.HEAL_DARTS_FIRED, 1);
}

defaultproperties {
    ProjectileClass=class'GameStatsTab.MP7MHealingProjectile'
}
