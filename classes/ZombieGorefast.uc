class ZombieGorefast extends KFChar.ZombieGorefast;

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
