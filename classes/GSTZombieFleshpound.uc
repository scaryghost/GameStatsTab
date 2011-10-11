class GSTZombieFleshPound extends ZombieFleshPound;

var GSTPlayerController gsPC;

function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, 
        class<DamageType> damageType, optional int HitIndex) {
    super.TakeDamage(Damage, InstigatedBy, Hitlocation, Momentum, damageType, HitIndex);

    if (bDecapitated) {
        gsPC= GSTPlayerController(InstigatedBy.Controller);
        if (gsPC != none) {
            //RemoveHead makes another call to TakeDamage
            gsPC.statArray[gsPC.EStatKeys.NUM_DECAPS]+= 0.5;
        }
    }
}

/**
 * Copied from ZombieFleshPound
 */
function StartCharging() {
    super.StartCharging();
    gsPC= GSTPlayerController(lastHitBy);
    if (Health > 0 && gsPC != none) {
        gsPC.statArray[gsPC.EStatKeys.FLESHPOUNDS_RAGED]+= 1;
    }
}
