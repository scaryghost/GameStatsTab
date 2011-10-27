class GSTZombieScrake extends ZombieScrake;

var GSTPlayerController gsPC;
var bool decapCounted, rageCounted;

function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, 
        class<DamageType> damageType, optional int HitIndex) {

    gsPC= GSTPlayerController(InstigatedBy.Controller);
    if (!bDecapitated && bBackstabbed) {
        gsPC.incrementStat(gsPC.EStatKeys.BACKSTABS, 1);
    }

    Super.takeDamage(Damage, instigatedBy, hitLocation, momentum, damageType, HitIndex);

    if (!decapCounted && bDecapitated && gsPC != none) {
        gsPC.incrementStat(gsPC.EStatKeys.NUM_DECAPS,1);
        decapCounted= true;
    }
}

state RunningState {
    // Don't override speed in this state
    function bool CanSpeedAdjust() {
        return super.CanSpeedAdjust();
    }

    function BeginState() {
        super.BeginState();
        if (!rageCounted) {
            gsPC.incrementStat(gsPC.EStatKeys.SCRAKES_RAGED,1);
            rageCounted= true;
        }
    }

    function EndState() {
        super.EndState();
    }

    function RemoveHead() {
        super.RemoveHead();
    }

    function RangedAttack(Actor A) {
        super.RangedAttack(A);
    }
}

function bool FlipOver() {
    if (Health > 0 && gsPC != none) {
        gsPC.incrementStat(gsPC.EStatKeys.SCRAKES_STUNNED,1);
    }

    return super.FlipOver();
}
