class GSTZombieClot extends ZombieClot;

var GSTPlayerController gsPC;

function RemoveHead() {
    super.RemoveHead();

    gsPC= GSTPlayerController(lastHitBy);
    if (gsPC != none) {
        gsPC.statArray[gsPC.EStatKeys.NUM_DECAPS]+= 1;
    }
}
