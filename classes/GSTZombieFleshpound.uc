class GSTZombieFleshPound extends ZombieFleshPound;

var GSTPlayerController gsPC;

function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, 
        class<DamageType> damageType, optional int HitIndex) {
    super.TakeDamage(Damage, InstigatedBy, Hitlocation, Momentum, damageType, HitIndex);

    if (bDecapitated) {
        gsPC= GSTPlayerController(InstigatedBy.Controller);
        if (gsPC != none) {
            //RemoveHead makes another call to TakeDamage
            gsPC.statArray[gsPC.EStatKeys.NUM_DECAPS]+= 0.5;
        }
    }
}

/**
 * Copied from ZombieFleshPound
 */
state BeginRaging {
    Ignores StartCharging;

    function BeginState() {

        gsPC= GSTPlayerController(lastHitBy);
        if (gsPC != none) {
            gsPC.statArray[gsPC.EStatKeys.FLESHPOUNDS_RAGED]+= 1;
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
