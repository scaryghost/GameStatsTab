class GSTZombieStalker extends ZombieStalker;

var GSTPlayerController gsPC;
var bool decapCounted;

function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, 
        class<DamageType> damageType, optional int HitIndex) {
    gsPC= GSTPlayerController(InstigatedBy.Controller);
    if (!bDecapitated && bBackstabbed) {
        gsPC.incrementStat(gsPC.EStatKeys.BACKSTABS, 1);
    }

    super.TakeDamage(Damage, InstigatedBy, Hitlocation, Momentum, damageType, HitIndex);

    if (!decapCounted && bDecapitated && gsPC != none) {
        gsPC.incrementStat(gsPC.EStatKeys.NUM_DECAPS, 1);
        decapCounted= true;
    }
}
