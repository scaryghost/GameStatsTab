class GSTHumanPawn extends KFHumanPawn;

var GSTPlayerController gsPC;

function timer() {
    super.Timer();
    gsPC= GSTPlayerController(Controller);

    if (gsPC != none && Health > 0) {
        gsPC.statArray[gsPC.EStatKeys.TIME_ALIVE]+= 1.5;
    }
}

simulated function TakeDamage( int Damage, Pawn InstigatedBy, 
        Vector Hitlocation, Vector Momentum, class<DamageType> damageType, 
        optional int HitIndex) {
    local float oldHealth;
    local float oldShield;
    local KFHumanPawn friendPawn;

    oldHealth= Health;
    oldShield= ShieldStrength;

    Super.TakeDamage(Damage,instigatedBy,hitlocation,momentum,damageType);
    
    friendPawn= KFHumanPawn(InstigatedBy);
    if (friendPawn != none && friendPawn != Self) {
        gsPC= GSTPlayerController(friendPawn.Controller);
        gsPC.statArray[gsPC.EStatKeys.FF_DAMAGE_DEALT]+= (oldHealth - Health);
    }
    gsPC= GSTPlayerController(Controller);
    gsPC.statArray[gsPC.EStatKeys.DAMAGE_TAKEN]+= (oldHealth - Health);
    gsPC.statArray[gsPC.EStatKeys.SHIELD_LOST]+= (oldShield - ShieldStrength);
}

function bool GiveHealth(int HealAmount, int HealMax) {
    // If someone gets healed while burning, reduce the burn length/damage
    if( BurnDown > 0 ) {
        if( BurnDown > 1 ) {
            BurnDown *= 0.5;
        }

        LastBurnDamage *= 0.5;
    }

    // Don't let them heal more than the max health
    if( (healAmount + HealthToGive + Health) > HealthMax) {
        healAmount = HealthMax - (Health + HealthToGive);

        if( healAmount == 0 ) {
            return false;
        }
    }

    if( Health<HealMax ) {
        gsPC= GSTPlayerController(Controller);
        gsPC.statArray[gsPC.EStatKeys.HEALING_RECIEVED]+= HealAmount;
        HealthToGive+=HealAmount;
        lastHealTime = level.timeSeconds;
        return true;
    }
    Return False;
}
 
function ThrowGrenade() {
    local inventory inv;
    local Frag aFrag;

    for ( inv = inventory; inv != none; inv = inv.Inventory ) {
        aFrag = Frag(inv);

        if ( aFrag != none && aFrag.HasAmmo() && !bThrowingNade ) {
            if ( KFWeapon(Weapon) == none || Weapon.GetFireMode(0).NextFireTime - Level.TimeSeconds > 0.1 ||
                 (KFWeapon(Weapon).bIsReloading && !KFWeapon(Weapon).InterruptReload()) ) {
                return;
            }

            //TODO: cache this without setting SecItem yet
            //SecondaryItem = aFrag;
            gsPC= GSTPlayerController(Controller);
            gsPC.statArray[gsPC.EStatKeys.FRAGS_TOSSED]+= 1 ;
            KFWeapon(Weapon).ClientGrenadeState = GN_TempDown;
            Weapon.PutDown();
            break;
            //aFrag.StartThrow();
        }
    }
}

