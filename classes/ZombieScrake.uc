class ZombieScrake extends KFChar.ZombieScrake;

var GSTPlayerReplicationInfo pri;
var bool decapCounted, rageCounted;

function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, 
        class<DamageType> damageType, optional int HitIndex) {
    pri= GSTPlayerReplicationInfo(GSTPlayerController(InstigatedBy.Controller).PlayerReplicationInfo);
    if (!bDecapitated && bBackstabbed) {
        pri.addToZedStat(pri.ZedStat.BACKSTABS, 1);
    }

    super.TakeDamage(Damage, InstigatedBy, Hitlocation, Momentum, damageType, HitIndex);

    if (!decapCounted && bDecapitated && pri != none) {
        pri.addToZedStat(pri.ZedStat.NUM_DECAPS, 1);
        decapCounted= true;
    }
}

state RunningState {
    function BeginState() {
        super.BeginState();
        if (!rageCounted) {
            pri.addToZedStat(pri.ZedStat.SCRAKES_RAGED, 1);
            rageCounted= true;
        }
    }
}

function bool FlipOver() {
    if (Health > 0 && pri != none) {
        pri.addToZedStat(pri.ZedStat.SCRAKES_STUNNED, 1);
    }

    return super.FlipOver();
}
