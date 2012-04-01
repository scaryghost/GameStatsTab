class GSTFragFire extends FragFire;

function DoFireEffect() {
    local GSTPlayerReplicationInfo pri;

    super.DoFireEffect();

    pri= GSTPlayerReplicationInfo(Instigator.Controller.PlayerReplicationInfo);
    pri.kfWeaponStats[pri.WeaponStat.FRAGS_TOSSED]+= 1;
}

function projectile SpawnProjectile(Vector Start, Rotator Dir) {
    local Projectile p;

    if( ProjectileClass != None )
        p = Weapon.Spawn(ProjectileClass,,, Start, Dir);

    if( p == None )
        return None;

    p.Damage *= DamageAtten;
    return p;
}

defaultproperties {
    ProjectileClass=class'GameStatsTab.FragProjectile'
}
