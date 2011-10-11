class GSTFleshpoundZombieController extends FleshpoundZombieController;

var GSTPlayerController lastSeenPC;
/**
 * Copied from FleshpoundZombieController
 */
state ZombieHunt {
    event SeePlayer(Pawn SeenPlayer) {
        local GSTHumanPawn gstHP;
        if ( !bDoneSpottedCheck && PlayerController(SeenPlayer.Controller) != none ) {
            if ( !KFGameType(Level.Game).bDidSpottedFleshpoundMessage && FRand() < 0.25 ) {
                PlayerController(SeenPlayer.Controller).Speech('AUTO', 12, "");
                KFGameType(Level.Game).bDidSpottedFleshpoundMessage = true;
            }

            bDoneSpottedCheck = true;
            gstHP= GSTHumanPawn(SeenPlayer);
            if (gstHp != none && GSTPlayerController(gstHP.Controller) != none) {
                lastSeenPC= GSTPlayerController(gstHP.Controller);
            }
        }
        super(KFMonsterController).SeePlayer(SeenPlayer);
    }
}

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
