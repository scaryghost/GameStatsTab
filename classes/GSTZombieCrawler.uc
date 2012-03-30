class GSTZombieCrawler extends ZombieCrawler;

var GSTPlayerReplicationInfo pri;
var bool decapCounted;

function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, 
        class<DamageType> damageType, optional int HitIndex) {
    pri= GSTPlayerReplicationInfo(GSTPlayerController(InstigatedBy.Controller).PlayerReplicationInfo);
    if (!bDecapitated && bBackstabbed) {
        pri.zedStats[pri.ZedStat.BACKSTABS]+= 1;
    }

    super.TakeDamage(Damage, InstigatedBy, Hitlocation, Momentum, damageType, HitIndex);

    if (!decapCounted && bDecapitated && pri != none) {
        pri.zedStats[pri.ZedStat.NUM_DECAPS]+= 1;
        decapCounted= true;
    }
}
