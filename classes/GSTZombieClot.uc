class GSTZombieClot extends ZombieClot;

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
