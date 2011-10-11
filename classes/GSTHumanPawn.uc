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
    oldShield= ShieldStrength;

    Super.TakeDamage(Damage,instigatedBy,hitlocation,momentum,damageType);
    
    friendPawn= KFHumanPawn(InstigatedBy);
    if (friendPawn != none && friendPawn != Self) {
        gsPC= GSTPlayerController(friendPawn.Controller);
        gsPC.statArray[gsPC.EStatKeys.FF_DAMAGE_DEALT]+= (oldHealth - Health);
    }
    gsPC= GSTPlayerController(Controller);
    gsPC.statArray[gsPC.EStatKeys.DAMAGE_TAKEN]+= (oldHealth - Health);
    gsPC.statArray[gsPC.EStatKeys.SHIELD_LOST]+= (oldShield - ShieldStrength);
}

simulated function ThrowGrenadeFinished() {
    super.ThrowGrenadeFinished();
    gsPC= GSTPlayerController(Controller);
    gsPC.statArray[gsPC.EStatKeys.FRAGS_TOSSED]+= 1 ;
}

