class GSTHumanPawn extends KFHumanPawn;

var GSTPlayerController gsPC;

function timer() {
    super.Timer();
    gsPC= GSTPlayerController(Controller);

    if (gsPC != none && Health > 0) {
        gsPC.statArray[gsPC.EStatKeys.TIME_ALIVE]+= 1.5;
    }
}

simulated function TakeDamage( int Damage, Pawn InstigatedBy, 
        Vector Hitlocation, Vector Momentum, class<DamageType> damageType, 
        optional int HitIndex) {
    local float oldHealth;
    local float oldShield;
    local KFHumanPawn friendPawn;

    oldHealth= Health;
    GSTPlayerController(Controller).prevHealth= oldHealth;
    oldShield= ShieldStrength;
    GSTPlayerController(Controller).prevShield= oldShield;

    Super.TakeDamage(Damage,instigatedBy,hitlocation,momentum,damageType);
    
    friendPawn= KFHumanPawn(InstigatedBy);
    if (friendPawn != none && friendPawn != Self) {
        gsPC= GSTPlayerController(friendPawn.Controller);
        gsPC.statArray[gsPC.EStatKeys.FF_DAMAGE_DEALT]+= fmin(oldHealth - Health, 100.0);
    }
    gsPC= GSTPlayerController(Controller);
    if(gsPC != none) {
        gsPC.statArray[gsPC.EStatKeys.DAMAGE_TAKEN]+= (oldHealth - Health);
        gsPC.statArray[gsPC.EStatKeys.SHIELD_LOST]+= (oldShield - ShieldStrength);
    }
}

/**
 * Copied from KFHumanPawn
 */
function bool GiveHealth(int HealAmount, int HealMax) {
    if( BurnDown > 0 ) {
        if( BurnDown > 1 ) {
            BurnDown *= 0.5;
        }

        LastBurnDamage *= 0.5;
    }

    if( (healAmount + HealthToGive + Health) > HealthMax) {
        healAmount = HealthMax - (Health + HealthToGive);

        if( healAmount == 0 ) {
            return false;
        }
    }

    if( Health<HealMax ) {
        gsPC= GSTPlayerController(Controller);
        gsPC.statArray[gsPC.EStatKeys.HEALING_RECIEVED]+= HealAmount;
        HealthToGive+=HealAmount;
        lastHealTime = level.timeSeconds;
        return true;
    }
    Return False;
}

/**
 * Copied from KFPawn
 */
simulated function StartFiringX(bool bAltFire, bool bRapid) {
    local name FireAnim;
    local int AnimIndex;

    if ( HasUDamage() && (Level.TimeSeconds - LastUDamageSoundTime > 0.25) ) {
        LastUDamageSoundTime = Level.TimeSeconds;
        PlaySound(UDamageSound, SLOT_None, 1.5*TransientSoundVolume,,700);
    }

    if (Physics == PHYS_Swimming)
        return;

    AnimIndex = Rand(4);

    if (bAltFire) {
        if( bIsCrouched ) {
            FireAnim = FireCrouchAltAnims[AnimIndex];
        }
        else {
            FireAnim = FireAltAnims[AnimIndex];
        }
    }
    else {
        if( bIsCrouched ) {
            FireAnim = FireCrouchAnims[AnimIndex];
        }
        else {
            FireAnim = FireAnims[AnimIndex];
        }
    }

    AnimBlendParams(1, 1.0, 0.0, 0.2, FireRootBone);

    if (bRapid) {
        if (FireState != FS_Looping) {
            LoopAnim(FireAnim,, 0.0, 1);
            FireState = FS_Looping;
        }
    }
    else {
        PlayAnim(FireAnim,, 0.0, 1);
        FireState = FS_PlayOnce;
    }
    gsPC= GSTPlayerController(Controller);
    if (gsPC != none) {
        if (KFMeleeGun(Weapon) != none) {
            gsPC.statArray[gsPC.EStatKeys.MELEE_SWINGS]+= 1;
        } else if (PipeBombExplosive(Weapon) != none) {
            gsPC.statArray[gsPC.EStatKeys.PIPES_SET]+= 1;
        } else {
            gsPC.statArray[gsPC.EStatKeys.ROUNDS_FIRED]+= 1;
        }
    }
    IdleTime = Level.TimeSeconds;
}

simulated function ThrowGrenadeFinished() {
    super.ThrowGrenadeFinished();
    gsPC= GSTPlayerController(Controller);
    gsPC.statArray[gsPC.EStatKeys.FRAGS_TOSSED]+= 1 ;
}

