class GSTZombieFleshPound extends ZombieFleshPound;

var GSTPlayerController gsPC;

function RemoveHead() {
    super.RemoveHead();

    gsPC= GSTPlayerController(lastHitBy);
    if (gsPC != none) {
        gsPC.statArray[gsPC.EStatKeys.NUM_DECAPS]+= 1;
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
