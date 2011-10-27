class GSTZombieBoss extends ZombieBoss;

var GSTPlayerController gsPC;

function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, 
        class<DamageType> damageType, optional int HitIndex) {
    gsPC= GSTPlayerController(InstigatedBy.Controller);
    if (bBackstabbed) {
        gsPC.incrementStat(gsPC.EStatKeys.BACKSTABS, 1);
    }

    super.TakeDamage(Damage, InstigatedBy, Hitlocation, Momentum, damageType, HitIndex);
}
