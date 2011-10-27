class GSTHumanPawn extends KFHumanPawn;

var GSTPlayerController gsPC;
var int prevTimeStamp;

simulated function PostBeginPlay() {
    super.PostBeginPlay();
    prevTimeStamp= Level.GRI.ElapsedTime;
}

function timer() {
    local int currTimeStamp;
    super.Timer();

    gsPC= GSTPlayerController(Controller);
    currTimeStamp= Level.GRI.ElapsedTime;
    if (gsPC != none && Health > 0) {
        gsPC.incrementStat(gsPC.EStatKeys.TIME_ALIVE, currTimeStamp - prevTimeStamp);
    }
    prevTimeStamp= currTimeStamp;
}

simulated function TakeDamage( int Damage, Pawn InstigatedBy, 
        Vector Hitlocation, Vector Momentum, class<DamageType> damageType, 
        optional int HitIndex) {
    local float oldHealth;
    local float oldShield;
    local KFHumanPawn friendPawn;

    oldHealth= Health;
    GSTPlayerController(Controller).prevHealth= oldHealth;
    oldShield= ShieldStrength;
    GSTPlayerController(Controller).prevShield= oldShield;

    Super.TakeDamage(Damage,instigatedBy,hitlocation,momentum,damageType);
    
    friendPawn= KFHumanPawn(InstigatedBy);
    if (friendPawn != none && friendPawn != Self) {
        gsPC= GSTPlayerController(friendPawn.Controller);
        gsPC.incrementStat(gsPC.EStatKeys.FF_DAMAGE_DEALT, oldHealth - fmax(Health, 0.0));
    }
    gsPC= GSTPlayerController(Controller);
    if(gsPC != none) {
        gsPC.incrementStat(gsPC.EStatKeys.DAMAGE_TAKEN, oldHealth - fmax(Health,0.0));
        gsPC.incrementStat(gsPC.EStatKeys.SHIELD_LOST, oldShield - fmax(ShieldStrength,0.0));
    }
}

/**
 * Copied from KFPawn.TakeBileDamage()
 * Had to inject stats tracking code here because the original
 * function uses xPawn.TakeDamage to prevent resetting the bile timer
 */
function TakeBileDamage() {
    local float oldHealth;
    local float oldShield;

    gsPC= GSTPlayerController(Controller);

    oldHealth= Health;
    gsPC.prevHealth= oldHealth;
    oldShield= ShieldStrength;
    gsPC.prevShield= oldShield;

    Super(xPawn).TakeDamage(2+Rand(3), BileInstigator, Location, vect(0,0,0), class'DamTypeVomit');
	healthtoGive-=5;

    if(gsPC != none) {
        gsPC.incrementStat(gsPC.EStatKeys.DAMAGE_TAKEN, oldHealth - fmax(Health,0.0));
        gsPC.incrementStat(gsPC.EStatKeys.SHIELD_LOST, oldShield - fmax(ShieldStrength,0.0));
    }
}

simulated function addHealth() {
    local float oldHealth;
    
    oldHealth= Health;
    super.addHealth();

    gsPC= GSTPlayerController(Controller);
    if (gsPC != none) {
        gsPC.incrementStat(gsPC.EStatKeys.HEALING_RECIEVED, Health - OldHealth);
    }
}

simulated function StartFiringX(bool bAltFire, bool bRapid) {
    local int statArrayIndex;
    local int ammoCount;

    super.StartFiringX(bAltFire, bRapid);    

    gsPC= GSTPlayerController(Controller);
    ammoCount= 1;
    if (gsPC != none) {
        if (KFMeleeGun(Weapon) != none) {
            statArrayIndex= gsPC.EStatKeys.MELEE_SWINGS;
        } else if (PipeBombExplosive(Weapon) != none) {
            statArrayIndex= gsPC.EStatKeys.PIPES_SET;
        } else if (FlameThrower(Weapon) != none) {
            statArrayIndex= gsPC.EStatKeys.UNITS_FUEL;
        } else if (AA12AutoShotgun(Weapon) != none || BoomStick(Weapon) != none || Shotgun(Weapon) != none) {
            statArrayIndex= gsPC.EStatKeys.SHELLS_FIRED;
            if (BoomStick(Weapon) != none && bAltFire) {
                ammoCount= (BoomStick(Weapon).MagAmmoRemaining+1) % 2 + 1;
            }
        } else if (M32GrenadeLauncher(Weapon) != none || M79GrenadeLauncher(Weapon) != none) {
            statArrayIndex= gsPC.EStatKeys.GRENADES_LAUNCHED;
        } else if (LAW(Weapon) != none) {
            statArrayIndex= gsPC.EStatKeys.ROCKETS_LAUNCHED;
        } else if (Crossbow(Weapon) != none) {
            statArrayIndex= gsPC.EStatKeys.BOLTS_FIRED;
        } else {
            statArrayIndex= gsPC.EStatKeys.ROUNDS_FIRED;
        }
        gsPC.incrementStat(statArrayIndex, ammoCount);
    }

}


function addFragToss() {
    gsPC= GSTPlayerController(Controller);
    gsPC.incrementStat(gsPC.EStatKeys.FRAGS_TOSSED, 1);
}

defaultproperties {
    RequiredEquipment(2)= "GameStatsTab_ServerPerks.GSTFrag"
}
