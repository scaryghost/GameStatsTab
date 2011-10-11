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

simulated function ThrowGrenadeFinished() {
    super.ThrowGrenadeFinished();
    gsPC= GSTPlayerController(Controller);
    gsPC.statArray[gsPC.EStatKeys.FRAGS_TOSSED]+= 1 ;
}

