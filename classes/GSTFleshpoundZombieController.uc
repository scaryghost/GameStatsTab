class GSTFleshpoundZombieController extends FleshpoundZombieController;

/**
 * Copied from FleshpoundZombieController but 
 * reorder how some code is executed in Tick
 */
state ZombieCharge {
    function Tick( float Delta ) {
        local GSTZombieFleshPound ZFP;
        Global.Tick(Delta);

        if( RageFrustrationTimer < RageFrustrationThreshhold ) {
            RageFrustrationTimer += Delta;

            if( RageFrustrationTimer >= RageFrustrationThreshhold ) {
                ZFP = GSTZombieFleshPound(Pawn);

                if( ZFP != none && !ZFP.bChargingPlayer ) {
                    ZFP.bFrustrated = true;
                    ZFP.StartCharging();
                }
            }
        }
    }


    function bool StrafeFromDamage(float Damage, class<DamageType> DamageType, bool bFindDest) {
        return super.StrafeFromDamage(Damage, DamageType, bFindDest);
    }

    function bool TryStrafe(vector sideDir) {
        return super.TryStrafe(sideDir);
    }

    function Timer() {
        super.Timer();
    }

    function BeginState() {
        super.BeginState();
    }

WaitForAnim:

    if ( Monster(Pawn).bShotAnim ) {
        Goto('Moving');
    }
    if ( !FindBestPathToward(Enemy, false,true) )
        GotoState('ZombieRestFormation');
Moving:
    MoveToward(Enemy);
    WhatToDoNext(17);
    if ( bSoaking )
        SoakStop("STUCK IN CHARGING!");
}
