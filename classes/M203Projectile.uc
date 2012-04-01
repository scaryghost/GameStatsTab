class M203Projectile extends M203GrenadeProjectile;

simulated function Disintegrate(vector HitLocation, vector HitNormal) {
    local GSTPlayerReplicationInfo pri;

    super.Disintegrate(HitLocation,HitNormal);

    pri= GSTPlayerReplicationInfo(Instigator.Controller.PlayerReplicationInfo);
    if (pri != none) {
        pri.kfWeaponStats[pri.WeaponStat.EXPLOSIVES_DISINTEGRATED]+= 1.0;
    }
}
