class GSTZombieScrake extends ZombieScrake;

var GSTStats gs;
var Pawn lastHitBy;
/**
 * Copied from ZombieScrake.TakeDamage
 */
function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, 
        class<DamageType> damageType, optional int HitIndex) {
	local bool bIsHeadShot;
    local KFHumanPawn kfhp;
    local float hpRatio;

	bIsHeadShot = IsHeadShot(Hitlocation, normal(Momentum), 1.0);
    kfhp= KFHumanPawn(InstigatedBy);

	if ( Level.Game.GameDifficulty >= 5.0 && bIsHeadshot && 
            (class<DamTypeCrossbow>(damageType) != none || class<DamTypeCrossbowHeadShot>(damageType) != none)) {
		Damage *= 0.5;
	}

	Super(KFMonster).takeDamage(Damage, instigatedBy, hitLocation, momentum, damageType, HitIndex);

    hpRatio= float(Health)/HealthMax;
    if (kfhp != none && (Level.Game.GameDifficulty >= 5.0 && hpRatio < 0.75 || Level.Game.GameDifficulty < 5.0 && hpRatio < 0.5)) {
        gs= class'GameStatsTabMut'.static.findStats(kfhp.KFPC.getPlayerIDHash());
        gs.statArray[gs.EStatKeys.SCRAKES_RAGED].statValue++;
    }
	if ( Level.Game.GameDifficulty >= 5.0 && !IsInState('SawingLoop') && 
            !IsInState('RunningState') && float(Health) / HealthMax < 0.75 )
		RangedAttack(InstigatedBy);
    lastHitBy= instigatedBy;
}

function bool FlipOver() {
    local KFHumanPawn kfhp;
    
    kfhp= KFHumanPawn(lastHitBy);
    if (kfhp != none) {
        gs= class'GameStatsTabMut'.static.findStats(kfhp.KFPC.getPlayerIDHash());
        gs.statArray[gs.EStatKeys.SCRAKES_STUNNED].statValue++;
    }

    return super.FlipOver();
}
