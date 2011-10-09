class GSTZombieFleshPound extends ZombieFleshPound;

var Pawn lastHurtBy;

function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, 
        Vector Momentum, class<DamageType> damageType, optional int HitIndex) {
    lastHurtBy= InstigatedBy;

    super.TakeDamage(Damage, instigatedBy, hitLocation, momentum, damageType,HitIndex);
}

/**
 * Copied from ZombieFleshPound
 */
state BeginRaging {
    Ignores StartCharging;

    function BeginState() {
        local KFHumanPawn kfhp;
        local GSTStats gs;

        kfhp= KFHumanPawn(lastHurtBy);
        if (kfhp != none) {
            gs= class'GameStatsTabMut'.static.findStats(kfhp.KFPC.getPlayerIDHash());
            gs.statArray[gs.EStatKeys.FLESHPOUNDS_RAGED].statValue++;
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
