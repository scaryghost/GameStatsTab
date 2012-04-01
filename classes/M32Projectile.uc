class M32Projectile extends M32GrenadeProjectile;

simulated function Disintegrate(vector HitLocation, vector HitNormal) {
    local GSTPlayerReplicationInfo pri;

    super.Disintegrate(HitLocation,HitNormal);

    pri= GSTPlayerReplicationInfo(Instigator.Controller.PlayerReplicationInfo);
    if (pri != none) {
        pri.kfWeaponStats[pri.WeaponStat.EXPLOSIVES_DISINTEGRATED]+= 1.0;
    }
}
