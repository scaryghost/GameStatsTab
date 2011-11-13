class GSTHumanPawn extends KFHumanPawn;

var GSTPlayerReplicationInfo pri;
var int prevTimeStamp;

simulated function PostBeginPlay() {
    super.PostBeginPlay();
    prevTimeStamp= Level.GRI.ElapsedTime;
}

function timer() {
    local int currTimeStamp;
    super.Timer();

    pri= GSTPlayerReplicationInfo(Controller.PlayerReplicationInfo);
    currTimeStamp= Level.GRI.ElapsedTime;
    if (pri != none && Health > 0) {
        pri.incrementStat(pri.EStatKeys.TIME_ALIVE, currTimeStamp - prevTimeStamp);
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
        pri= GSTPlayerReplicationInfo(friendPawn.Controller.PlayerReplicationInfo);
        pri.incrementStat(pri.EStatKeys.FF_DAMAGE_DEALT, oldHealth - fmax(Health, 0.0));
    }
    pri= GSTPlayerReplicationInfo(Controller.PlayerReplicationInfo);
    if(pri != none) {
        pri.incrementStat(pri.EStatKeys.DAMAGE_TAKEN, oldHealth - fmax(Health,0.0));
        pri.incrementStat(pri.EStatKeys.SHIELD_LOST, oldShield - fmax(ShieldStrength,0.0));
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

    pri= GSTPlayerReplicationInfo(Controller.PlayerReplicationInfo);

    oldHealth= Health;
    GSTPlayerController(Controller).prevHealth= oldHealth;
    oldShield= ShieldStrength;
    GSTPlayerController(Controller).prevShield= oldShield;

    Super(xPawn).TakeDamage(2+Rand(3), BileInstigator, Location, vect(0,0,0), class'DamTypeVomit');
	healthtoGive-=5;

    if(pri != none) {
        pri.incrementStat(pri.EStatKeys.DAMAGE_TAKEN, oldHealth - fmax(Health,0.0));
        pri.incrementStat(pri.EStatKeys.SHIELD_LOST, oldShield - fmax(ShieldStrength,0.0));
    }
}

simulated function addHealth() {
    local float oldHealth;
    
    oldHealth= Health;
    super.addHealth();

    pri= GSTPlayerReplicationInfo(Controller.PlayerReplicationInfo);
    if (pri != none) {
        pri.incrementStat(pri.EStatKeys.HEALING_RECIEVED, Health - OldHealth);
    }
}

simulated function StartFiringX(bool bAltFire, bool bRapid) {
    local int statArrayIndex;
    local int ammoCount;

    super.StartFiringX(bAltFire, bRapid);    

    pri= GSTPlayerReplicationInfo(Controller.PlayerReplicationInfo);
    ammoCount= 1;
    if (pri != none && class<BaseProjectileFire>(Weapon.FireModeClass[0]) == none) {
        if (KFMeleeGun(Weapon) != none) {
            statArrayIndex= pri.EStatKeys.MELEE_SWINGS;
        } else if (PipeBombExplosive(Weapon) != none) {
            statArrayIndex= pri.EStatKeys.PIPES_SET;
        } else if (FlameThrower(Weapon) != none) {
            statArrayIndex= pri.EStatKeys.UNITS_FUEL;
        } else if (M79GrenadeLauncher(Weapon) != none) {
            statArrayIndex= pri.EStatKeys.GRENADES_LAUNCHED;
        } else {
            statArrayIndex= pri.EStatKeys.ROUNDS_FIRED;
        }
        pri.incrementStat(statArrayIndex, ammoCount);
    }

}


function addFragToss() {
    pri= GSTPlayerReplicationInfo(Controller.PlayerReplicationInfo);
    pri.incrementStat(pri.EStatKeys.FRAGS_TOSSED, 1);
}

defaultproperties {
    RequiredEquipment(2)= "GameStatsTab.GSTFrag"
}
