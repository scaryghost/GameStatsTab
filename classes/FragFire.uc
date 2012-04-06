class FragFire extends KFMod.FragFire;

var class<Grenade> flameFragClass;

function DoFireEffect() {
    local GSTPlayerReplicationInfo pri;

    super.DoFireEffect();

    pri= GSTPlayerReplicationInfo(Instigator.Controller.PlayerReplicationInfo);
    pri.addToWeaponStat(pri.WeaponStat.FRAGS_TOSSED, 1);
}

/** Copied from KFMod.FragFire */
function projectile SpawnProjectile(Vector Start, Rotator Dir) {
    local Grenade g;
    local vector X, Y, Z;
    local float pawnSpeed;
    local class<Grenade> fragClass;

    if ( KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo) != none && 
        KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill != none ) {
        fragClass= KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill.Static.GetNadeType(KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo));
        if (fragClass == class'FlameNade') {
            fragClass= flameFragClass;
        } else {
            fragClass= class<Grenade>(ProjectileClass);
        }
    }
    else {
        fragClass= class<Grenade>(ProjectileClass);
    }

    g = Weapon.Spawn(fragClass, instigator,, Start, Dir);
    if (g != None) {
        Weapon.GetViewAxes(X,Y,Z);
        pawnSpeed = X dot Instigator.Velocity;

        if ( Bot(Instigator.Controller) != None ) {
            g.Speed = mHoldSpeedMax;
        }
        else {
            g.Speed = mHoldSpeedMin + HoldTime*mHoldSpeedGainPerSec;
        }

        g.Speed = FClamp(g.Speed, mHoldSpeedMin, mHoldSpeedMax);
        g.Speed = pawnSpeed + g.Speed;
        g.Velocity = g.Speed * Vector(Dir);
        g.Damage *= DamageAtten;
    }

    return g;
}

defaultproperties {
    flameFragClass= class'GameStatsTab.FlameFragProjectile'
    ProjectileClass= class'GameStatsTab.FragProjectile'
}
