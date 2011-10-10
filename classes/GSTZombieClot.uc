class GSTZombieClot extends ZombieClot;

var KFPlayerController lastHurtBy;

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, 
        class<DamageType> damageType, optional int HitIndex ) {
    if (KFHumanPawn(instigatedBy) != none) {
        lastHurtBy= KFHumanPawn(instigatedBy).KFPC;
    }

    super.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType, HitIndex);
}

function RemoveHead() {
    local GSTStats gs;

    super.RemoveHead();
    if (lastHurtBy != none) {
        gs= class'GameStatsTabMut'.static.findStats(lastHurtBy.getPlayerIDHash());
        gs.statArray[gs.EStatKeys.NUM_DECAPS].statValue+= 1;
    }
}
