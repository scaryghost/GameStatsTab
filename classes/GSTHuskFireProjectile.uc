class GSTHuskFireProjectile extends HuskFireProjectile;

/**
 * Copied from HuskFireProjectile.HurtRadius
 */
simulated function HurtRadius( float DamageAmount, float DamageRadius, 
        class<DamageType> DamageType, float Momentum, vector HitLocation ) {
    local actor Victims;
    local float damageScale, dist;
    local vector dirs;
    local int NumKilled;
    local KFMonster KFMonsterVictim;
    local Pawn P;
    local KFPawn KFP;
    local array<Pawn> CheckedPawns;
    local int i;
    local bool bAlreadyChecked;

    local KFHumanPawn humanVictim;
    local GSTPlayerReplicationInfo pri;

    if ( bHurtEntry )
        return;

    bHurtEntry = true;

    foreach CollidingActors (class 'Actor', Victims, DamageRadius, HitLocation) {
        if( (Victims != self) && (Victims != Instigator) &&(Hurtwall != Victims)
            && (Victims.Role == ROLE_Authority) && !Victims.IsA('FluidSurfaceInfo')
            && ExtendedZCollision(Victims)==None && KFBulletWhipAttachment(Victims)==None ) {
            dirs = Victims.Location - HitLocation;
            dist = FMax(1,VSize(dirs));
            dirs = dirs/dist;
            damageScale = 1 - FMax(0,(dist - Victims.CollisionRadius)/DamageRadius);
            if ( Instigator == None || Instigator.Controller == None )
                Victims.SetDelayedDamageInstigatorController( InstigatorController );
            if ( Victims == LastTouched )
                LastTouched = None;

            P = Pawn(Victims);

            if( P != none ) {
                for (i = 0; i < CheckedPawns.Length; i++) {
                    if (CheckedPawns[i] == P) {
                        bAlreadyChecked = true;
                        break;
                    }
                }

                if( bAlreadyChecked ) {
                    bAlreadyChecked = false;
                    P = none;
                    continue;
                }

                KFMonsterVictim = KFMonster(Victims);
                humanVictim= KFHumanPawn(Victims);

                if( KFMonsterVictim != none && KFMonsterVictim.Health <= 0 ) {
                    KFMonsterVictim = none;
                }

                KFP = KFPawn(Victims);

                if( KFMonsterVictim != none ) {
                    damageScale *= KFMonsterVictim.GetExposureTo(HitLocation);
                }
                else if( KFP != none ) {
                    damageScale *= KFP.GetExposureTo(HitLocation);
                }
                if (humanVictim != none) {
                    pri= GSTPlayerReplicationInfo(humanVictim.Controller.PlayerReplicationInfo);
                    pri.incrementStat(pri.EStatKeys.SHOT_BY_HUSK, 1);
                }

                CheckedPawns[CheckedPawns.Length] = P;

                if ( damageScale <= 0) {
                    P = none;
                    continue;
                }
                else {
                    P = none;
                }
            }

            Victims.TakeDamage
            (
                damageScale * DamageAmount,
                Instigator,
                Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dirs,
                (damageScale * Momentum * dirs),
                DamageType
            );
            if (Vehicle(Victims) != None && Vehicle(Victims).Health > 0)
                Vehicle(Victims).DriverRadiusDamage(DamageAmount, DamageRadius, 
                        InstigatorController, DamageType, Momentum, HitLocation);

            if( Role == ROLE_Authority && KFMonsterVictim != none && KFMonsterVictim.Health <= 0 )
            {
                NumKilled++;
            }
        }
    }
    if ( (LastTouched != None) && (LastTouched != self) && (LastTouched != Instigator) &&
        (LastTouched.Role == ROLE_Authority) && !LastTouched.IsA('FluidSurfaceInfo') ) {
        Victims = LastTouched;
        LastTouched = None;
        dirs = Victims.Location - HitLocation;
        dist = FMax(1,VSize(dirs));
        dirs = dirs/dist;
        damageScale = FMax(Victims.CollisionRadius/(Victims.CollisionRadius + 
                Victims.CollisionHeight),1 - FMax(0,(dist - Victims.CollisionRadius)/DamageRadius));
        if ( Instigator == None || Instigator.Controller == None )
            Victims.SetDelayedDamageInstigatorController(InstigatorController);

        Victims.TakeDamage
        (
            damageScale * DamageAmount,
            Instigator,
            Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dirs,
            (damageScale * Momentum * dirs),
            DamageType
        );
        if (Vehicle(Victims) != None && Vehicle(Victims).Health > 0)
            Vehicle(Victims).DriverRadiusDamage(DamageAmount, DamageRadius, 
                    InstigatorController, DamageType, Momentum, HitLocation);
    }

    if( Role == ROLE_Authority ) {
        if( NumKilled >= 4 ) {
            KFGameType(Level.Game).DramaticEvent(0.05);
        }
        else if( NumKilled >= 2 ) {
            KFGameType(Level.Game).DramaticEvent(0.03);
        }
    }

    bHurtEntry = false;
}

