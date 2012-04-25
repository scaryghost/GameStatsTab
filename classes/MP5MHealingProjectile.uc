class MP5MHealingProjectile extends MP5MHealinglProjectile;

simulated function ProcessTouch(Actor Other, Vector HitLocation) {
    local GSTPlayerReplicationInfo pri;

    super.ProcessTouch(Other, HitLocation);
    if (KFHumanPawn(Other) != none) {
        pri= GSTPlayerReplicationInfo(Instigator.PlayerReplicationInfo);
        pri.addToWeaponStat(pri.WeaponStat.HEAL_DARTS_LANDED, 1);
    }
}
