class GSTHumanPawn extends KFHumanPawn;

var GSTStats gs;

simulated function PostBeginPlay() {
    super.PostBeginPlay();

    setTimer(1.0, true);
}

function timer() {
    if (Health > 0) {
        gs= class'GameStatsTabMut'.static.findStats(KFPC.getPlayerIDHash());
        gs.statArray[gs.EStatKeys.TIME_ALIVE].statValue++;
    }
}

simulated function TakeDamage( int Damage, Pawn InstigatedBy, 
        Vector Hitlocation, Vector Momentum, class<DamageType> damageType, 
        optional int HitIndex) {
    local float oldHealth;
    local float oldShield;
    local KFHumanPawn friendPawn;
    local GSTStats friendStats;

    oldHealth= Health;
    oldShield= ShieldStrength;

    Super.TakeDamage(Damage,instigatedBy,hitlocation,momentum,damageType);
    
    friendPawn= KFHumanPawn(InstigatedBy);
    if (friendPawn != none && friendPawn != Self) {
        friendStats= class'GameStatsTabMut'.static.findStats(KFPC.getPlayerIDHash());
        friendStats.statArray[gs.EStatKeys.FF_DAMAGE_DEALT].statValue+= (oldHealth - Health);
    }
    gs= class'GameStatsTabMut'.static.findStats(KFPC.getPlayerIDHash());
    gs.statArray[gs.EStatKeys.DAMAGE_TAKEN].statValue+= (oldHealth - Health);
    gs.statArray[gs.EStatKeys.SHIELD_LOST].statValue+= (oldShield - ShieldStrength);
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
        gs= class'GameStatsTabMut'.static.findStats(KFPC.getPlayerIDHash());
        gs.statArray[gs.EStatKeys.HEALING_RECIEVED].statValue+= HealAmount;
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
            gs= class'GameStatsTabMut'.static.findStats(KFPC.getPlayerIDHash());
            gs.statArray[gs.EStatKeys.FRAGS_TOSSED].statValue++;
            KFWeapon(Weapon).ClientGrenadeState = GN_TempDown;
            Weapon.PutDown();
            break;
            //aFrag.StartThrow();
        }
    }
}

