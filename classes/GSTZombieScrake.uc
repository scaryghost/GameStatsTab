class GSTZombieScrake extends ZombieScrake;

var bool isRaging;
var GSTPlayerController gsPC;
var bool decapCounted;

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
    gsPC= GSTPlayerController(InstigatedBy.Controller);

	if ( Level.Game.GameDifficulty >= 5.0 && bIsHeadshot && 
            (class<DamTypeCrossbow>(damageType) != none || 
            class<DamTypeCrossbowHeadShot>(damageType) != none)) {
		Damage *= 0.5;
	}

	Super(KFMonster).takeDamage(Damage, instigatedBy, hitLocation, momentum, damageType, HitIndex);

    hpRatio= float(Health)/HealthMax;
    if (!isRaging && kfhp != none && (Level.Game.GameDifficulty >= 5.0 && hpRatio < 0.75 || 
            Level.Game.GameDifficulty < 5.0 && hpRatio < 0.5)) {
        gsPC.statArray[gsPC.EStatKeys.SCRAKES_RAGED]+= 1;
        isRaging= true;
    }
    if (!decapCounted && bDecapitated && gsPC != none) {
        gsPC.statArray[gsPC.EStatKeys.NUM_DECAPS]+= 1;
        decapCounted= true;
    }
	if ( Level.Game.GameDifficulty >= 5.0 && !IsInState('SawingLoop') && 
            !IsInState('RunningState') && float(Health) / HealthMax < 0.75 )
		RangedAttack(InstigatedBy);
}

function bool FlipOver() {
    if (Health > 0 && gsPC != none) {
        gsPC.statArray[gsPC.EStatKeys.SCRAKES_STUNNED]+= 1;
    }

    return super.FlipOver();
}

defaultproperties {
    isRaging= false
}
