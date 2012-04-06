class FleshpoundZombieController extends KFChar.FleshpoundZombieController;

state ZombieCharge {
    /**
     * Copied from KFChar.FleshpoundZombieController
     * but reordered how some code is executed in Tick
     */
    function Tick( float Delta ) {
        local ZombieFleshPound ZFP;
        Global.Tick(Delta);

        if( RageFrustrationTimer < RageFrustrationThreshhold ) {
            RageFrustrationTimer += Delta;

            if( RageFrustrationTimer >= RageFrustrationThreshhold ) {
                ZFP = ZombieFleshPound(Pawn);

                if( ZFP != none && !ZFP.bChargingPlayer ) {
                    ZFP.bFrustrated = true;
                    ZFP.StartCharging();
                }
            }
        }
    }
}
