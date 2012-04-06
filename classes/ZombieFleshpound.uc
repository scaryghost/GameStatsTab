class ZombieFleshPound extends KFChar.ZombieFleshPound;

var GSTPlayerReplicationInfo pri;
var bool decapCounted;

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

/**
 * Copied from ZombieFleshPound
 */
function StartCharging() {
    super.StartCharging();

    if(bFrustrated) {
        pri= GSTPlayerReplicationInfo(GSTHumanPawn(FleshpoundZombieController(Controller).Target).Controller.PlayerReplicationInfo);
    } else {
        pri= GSTPlayerReplicationInfo(lastHitBy.PlayerReplicationInfo);
    }
    if (Health > 0 && pri != none) {
        pri.addToZedStat(pri.ZedStat.FLESHPOUNDS_RAGED, 1);
    }
}

defaultproperties {
    ControllerClass=class'GameStatsTab.FleshpoundZombieController'
}