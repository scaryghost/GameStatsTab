class FragProjectile extends Nade;

simulated function Disintegrate(vector HitLocation, vector HitNormal) {
    local GSTPlayerReplicationInfo pri;

    super.Disintegrate(HitLocation,HitNormal);

    pri= GSTPlayerReplicationInfo(Instigator.Controller.PlayerReplicationInfo);
    pri.addToWeaponStat(pri.WeaponStat.EXPLOSIVES_DISINTEGRATED, 1.0);
}
