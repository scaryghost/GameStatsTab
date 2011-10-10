class GSTZombieFleshPound extends ZombieFleshPound;

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

/**
 * Copied from ZombieFleshPound
 */
state BeginRaging {
    Ignores StartCharging;

    function BeginState() {
        local GSTStats gs;

        if (lastHurtBy != none) {
            gs= class'GameStatsTabMut'.static.findStats(lastHurtBy.getPlayerIDHash());
            gs.statArray[gs.EStatKeys.FLESHPOUNDS_RAGED].statValue+= 1;
        }
        
    }

    function bool CanGetOutOfWay() {
        return super.CanGetOutOfWay();
    }

    simulated function bool HitCanInterruptAction() {
        return super.HitCanInterruptAction();
    }

	function Tick( float Delta ) {
        super.tick(Delta);
	}

Begin:
    Sleep(GetAnimDuration('PoundRage'));
    GotoState('RageCharging');
}
