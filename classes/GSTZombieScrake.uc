class GSTZombieScrake extends ZombieScrake;

var GSTPlayerReplicationInfo pri;
var bool decapCounted, rageCounted;

function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, 
        class<DamageType> damageType, optional int HitIndex) {
    pri= GSTPlayerReplicationInfo(GSTPlayerController(InstigatedBy.Controller).PlayerReplicationInfo);
    if (!bDecapitated && bBackstabbed) {
        pri.incrementStat(pri.EStatKeys.BACKSTABS, 1);
    }

    super.TakeDamage(Damage, InstigatedBy, Hitlocation, Momentum, damageType, HitIndex);

    if (!decapCounted && bDecapitated && pri != none) {
        pri.incrementStat(pri.EStatKeys.NUM_DECAPS, 1);
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
            pri.incrementStat(pri.EStatKeys.SCRAKES_RAGED,1);
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
    if (Health > 0 && pri != none) {
        pri.incrementStat(pri.EStatKeys.SCRAKES_STUNNED,1);
    }

    return super.FlipOver();
}
