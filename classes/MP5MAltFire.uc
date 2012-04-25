class MP5MAltFire extends KFMod.MP5MAltFire;

function DoFireEffect() {
    local GSTPlayerReplicationInfo pri;

    super.DoFireEffect();
    pri= GSTPlayerReplicationInfo(Instigator.Controller.PlayerReplicationInfo);
    pri.addToWeaponStat(pri.WeaponStat.HEAL_DARTS_FIRED, 1);
}

defaultproperties {
    ProjectileClass=class'GameStatsTab.MP5MHealingProjectile'
}
