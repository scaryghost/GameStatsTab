class ZombieFleshPound extends KFChar.ZombieFleshPound;

var GSTPlayerReplicationInfo pri;
var float tempHealth;
var bool decapCounted;

function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, 
        class<DamageType> damageType, optional int HitIndex) {
    local float prevHealth, diffHealth;
    prevHealth= Health;
    pri= GSTPlayerReplicationInfo(GSTPlayerController(InstigatedBy.Controller).PlayerReplicationInfo);
    if (!bDecapitated && bBackstabbed) {
        pri.addToPlayerStat(pri.PlayerStat.BACKSTABS, 1);
    }

    super.TakeDamage(Damage, InstigatedBy, Hitlocation, Momentum, damageType, HitIndex);

    diffHealth= prevHealth - fmax(Health, 0);
    if (decapCounted) {
        diffHealth-= tempHealth;
        tempHealth= 0;
    }
    if (!decapCounted && bDecapitated && pri != none) {
        pri.addToPlayerStat(pri.PlayerStat.NUM_DECAPS, 1);
        decapCounted= true;
    }
    pri.addToHiddenStat(pri.HiddenStat.DAMAGE_DEALT, diffHealth);
}

function RemoveHead() {
    tempHealth= Health;
    super.RemoveHead();
    tempHealth-= fmax(Health, 0);
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
        pri.addToPlayerStat(pri.PlayerStat.FLESHPOUNDS_RAGED, 1);
    }
}

defaultproperties {
    ControllerClass=class'GameStatsTab.FleshpoundZombieController'
}
