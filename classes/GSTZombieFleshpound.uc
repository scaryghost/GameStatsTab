class GSTZombieFleshPound extends ZombieFleshPound;

var GSTPlayerController gsPC;
var bool decapCounted;

function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, 
        class<DamageType> damageType, optional int HitIndex) {
    super.TakeDamage(Damage, InstigatedBy, Hitlocation, Momentum, damageType, HitIndex);

    gsPC= GSTPlayerController(InstigatedBy.Controller);
    if (!decapCounted && bDecapitated && gsPC != none) {
        gsPC.statArray[gsPC.EStatKeys.NUM_DECAPS]+= 1;
        decapCounted= true;
    }
}

/**
 * Copied from ZombieFleshPound
 */
function StartCharging() {
    super.StartCharging();

    if(bFrustrated) {
        gsPC= GSTPlayerController(GSTHumanPawn(GSTFleshpoundZombieController(Controller).Target).Controller);
    } else {
        gsPC= GSTPlayerController(lastHitBy);
    }
    if (Health > 0 && gsPC != none) {
        gsPC.statArray[gsPC.EStatKeys.FLESHPOUNDS_RAGED]+= 1;
    }
}

defaultproperties {
    ControllerClass=class'GameStatsTab.GSTFleshpoundZombieController'
}
