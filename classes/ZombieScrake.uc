class ZombieScrake extends KFChar.ZombieScrake;

var bool rageCounted;
var GSTPlayerReplicationInfo lastHitByPri;
var float tempHealth;
var bool decapCounted;

function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, 
        class<DamageType> damageType, optional int HitIndex) {
    local float prevHealth, diffHealth;
    prevHealth= Health;
    lastHitByPri= GSTPlayerReplicationInfo(GSTPlayerController(InstigatedBy.Controller).PlayerReplicationInfo);
    if (lastHitByPri != none && tempHealth == 0 && bBackstabbed) {
        lastHitByPri.addToPlayerStat(lastHitByPri.PlayerStat.BACKSTABS, 1);
    }

    super.TakeDamage(Damage, InstigatedBy, Hitlocation, Momentum, damageType, HitIndex);

    diffHealth= prevHealth - fmax(Health, 0);
    if (decapCounted) {
        diffHealth-= tempHealth;
        tempHealth= 0;
    }
    if (lastHitByPri != none) {
        if (!decapCounted && bDecapitated) {
            lastHitByPri.addToPlayerStat(lastHitByPri.PlayerStat.NUM_DECAPS, 1);
            decapCounted= true;
        }
        lastHitByPri.addToHiddenStat(lastHitByPri.HiddenStat.DAMAGE_DEALT, diffHealth);
    }
}

function RemoveHead() {
    tempHealth= Health;
    super.RemoveHead();
    tempHealth-= fmax(Health, 0);
}

state RunningState {
    function BeginState() {
        super.BeginState();
        if (!rageCounted) {
            lastHitByPri.addToPlayerStat(lastHitByPri.PlayerStat.SCRAKES_RAGED, 1);
            rageCounted= true;
        }
    }
}

function bool FlipOver() {
    if (Health > 0 && lastHitByPri != none) {
        lastHitByPri.addToPlayerStat(lastHitByPri.PlayerStat.SCRAKES_STUNNED, 1);
    }

    return super.FlipOver();
}
