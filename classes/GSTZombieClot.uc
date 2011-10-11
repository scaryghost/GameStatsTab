class GSTZombieClot extends ZombieClot;

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
