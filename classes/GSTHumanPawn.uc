class GSTHumanPawn extends KFHumanPawn;

var float prevHealth, prevShield;
var GSTPlayerReplicationInfo pri;
var int prevTimeStamp;

simulated function PostBeginPlay() {
    super.PostBeginPlay();
    prevTimeStamp= Level.GRI.ElapsedTime;
}

function timer() {
    local int currTimeStamp, timeDiff;
    super.Timer();

    pri= GSTPlayerReplicationInfo(Controller.PlayerReplicationInfo);
    currTimeStamp= Level.GRI.ElapsedTime;
    if (pri != none && Health > 0) {
        timeDiff= currTimeStamp - prevTimeStamp;
        pri.addToPlayerStat(pri.PlayerStat.TIME_ALIVE, timeDiff);
        if (pri.ClientVeteranSkill == class'KFMod.KFVetBerserker') {
            pri.addToHiddenStat(pri.HiddenStat.TIME_BERSERKER, timeDiff);
        } else if (pri.ClientVeteranSkill == class'KFMod.KFVetCommando') {
            pri.addToHiddenStat(pri.HiddenStat.TIME_COMMANDO, timeDiff);
        } else if (pri.ClientVeteranSkill == class'KFMod.KFVetDemolitions') {
            pri.addToHiddenStat(pri.HiddenStat.TIME_DEMO, timeDiff);
        } else if (pri.ClientVeteranSkill == class'KFMod.KFVetFirebug') {
            pri.addToHiddenStat(pri.HiddenStat.TIME_FIREBUG, timeDiff);
        } else if (pri.ClientVeteranSkill == class'KFMod.KFVetFieldMedic') {
            pri.addToHiddenStat(pri.HiddenStat.TIME_MEDIC, timeDiff);
        } else if (pri.ClientVeteranSkill == class'KFMod.KFVetSharpshooter') {
            pri.addToHiddenStat(pri.HiddenStat.TIME_SHARP, timeDiff);
        } else if (pri.ClientVeteranSkill == class'KFMod.KFVetSupportSpec') {
            pri.addToHiddenStat(pri.HiddenStat.TIME_SUPPORT, timeDiff);
        }
    }
    prevTimeStamp= currTimeStamp;
}

simulated function TakeDamage( int Damage, Pawn InstigatedBy, 
        Vector Hitlocation, Vector Momentum, class<DamageType> damageType, 
        optional int HitIndex) {
    local float oldHealth;
    local float oldShield;

    oldHealth= Health;
    prevHealth= oldHealth;
    oldShield= ShieldStrength;
    prevShield= oldShield;

    Super.TakeDamage(Damage,instigatedBy,hitlocation,momentum,damageType);
   
    pri= GSTPlayerReplicationInfo(InstigatedBy.Controller.PlayerReplicationInfo);
    if (pri.Team == Controller.PlayerReplicationInfo.Team) {
        pri.addToHiddenStat(pri.HiddenStat.FF_DAMAGE_DEALT, oldHealth - fmax(Health, 0.0));
    }
    pri= GSTPlayerReplicationInfo(Controller.PlayerReplicationInfo);
    if(pri != none) {
        pri.addToPlayerStat(pri.PlayerStat.DAMAGE_TAKEN, oldHealth - fmax(Health,0.0));
        pri.addToPlayerStat(pri.PlayerStat.SHIELD_LOST, oldShield - fmax(ShieldStrength,0.0));
    }
    prevHealth= 0;
    prevShield= 0;
}


function Died(Controller Killer, class<DamageType> damageType, vector HitLocation) {
    pri= GSTPlayerReplicationInfo(Controller.PlayerReplicationInfo);
    if(pri != none) {
        pri.addToPlayerStat(pri.PlayerStat.DAMAGE_TAKEN, prevHealth);
        pri.addToPlayerStat(pri.PlayerStat.SHIELD_LOST, prevShield);
        pri.addToHiddenStat(pri.HiddenStat.DEATHS, 1);

        if(GSTPlayerController(Controller).forcedSuicideAttempt) {
            pri.addToHiddenStat(pri.HiddenStat.FORCED_SUICIDE, 1);
        }
        prevHealth= 0;
        prevShield= 0;
    }

    super.Died(Killer, damageType, HitLocation);
}

function bool GiveHealth(int HealAmount, int HealMax) {
    local bool result;

    result= super.GiveHealth(HealAmount, HealMax);
    if (result) {
        pri= GSTPlayerReplicationInfo(Controller.PlayerReplicationInfo);
        if (pri != none) {
            pri.addToPlayerStat(pri.PlayerStat.HEALS_RECEIVED, 1);
        }
    }
    return result;
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
    prevHealth= oldHealth;
    oldShield= ShieldStrength;
    prevShield= oldShield;

    Super(xPawn).TakeDamage(2+Rand(3), BileInstigator, Location, vect(0,0,0), class'DamTypeVomit');
    healthtoGive-=5;

    if(pri != none) {
        pri.addToPlayerStat(pri.PlayerStat.DAMAGE_TAKEN, oldHealth - fmax(Health,0.0));
        pri.addToPlayerStat(pri.PlayerStat.SHIELD_LOST, oldShield - fmax(ShieldStrength,0.0));
    }
}

function ServerBuyWeapon( Class<Weapon> WClass ) {
    local int oldScore;

    oldScore= PlayerReplicationInfo.Score;
    super.ServerBuyWeapon(WClass);
    pri= GSTPlayerReplicationInfo(PlayerReplicationInfo);
    pri.addToPlayerStat(pri.PlayerStat.CASH_SPENT, oldScore - pri.Score);
}

function ServerBuyAmmo( Class<Ammunition> AClass, bool bOnlyClip ) {
    local int oldScore;

    oldScore= PlayerReplicationInfo.Score;
    super.ServerBuyAmmo(AClass, bOnlyClip);
    pri= GSTPlayerReplicationInfo(PlayerReplicationInfo);
    pri.addToPlayerStat(pri.PlayerStat.CASH_SPENT, oldScore - pri.Score);
}

function ServerBuyKevlar() {
    local int oldScore;

    oldScore= PlayerReplicationInfo.Score;
    super.ServerBuyKevlar();
    pri= GSTPlayerReplicationInfo(PlayerReplicationInfo);
    pri.addToPlayerStat(pri.PlayerStat.CASH_SPENT, oldScore - pri.Score);
}
