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
    local KFHumanPawn friendPawn;

    oldHealth= Health;
    prevHealth= oldHealth;
    oldShield= ShieldStrength;
    prevShield= oldShield;

    Super.TakeDamage(Damage,instigatedBy,hitlocation,momentum,damageType);
    
    friendPawn= KFHumanPawn(InstigatedBy);
    if (friendPawn != none && friendPawn != Self) {
        pri= GSTPlayerReplicationInfo(friendPawn.Controller.PlayerReplicationInfo);
        pri.addToPlayerStat(pri.PlayerStat.FF_DAMAGE_DEALT, oldHealth - fmax(Health, 0.0));
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

        if(GSTPlayerController(Controller).forcedSuicideAttempt) {
            pri.addToPlayerStat(pri.PlayerStat.FORCED_SUICIDE, 1);
        }
        prevHealth= 0;
        prevShield= 0;
    }

    super.Died(Killer, damageType, HitLocation);
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

simulated function addHealth() {
    local float oldHealth;
    
    oldHealth= Health;
    super.addHealth();

    pri= GSTPlayerReplicationInfo(Controller.PlayerReplicationInfo);
    if (pri != none) {
        pri.addToPlayerStat(pri.PlayerStat.HEALING_RECIEVED, Health - OldHealth);
    }
}

exec function TossCash( int Amount ) {
    local Vector X,Y,Z;
    local CashPickup CashPickup ;
    local Vector TossVel;

    if( Amount<=0 )
        Amount = 50;
    Controller.PlayerReplicationInfo.Score = int(Controller.PlayerReplicationInfo.Score); // To fix issue with throwing 0 pounds.
    if( Controller.PlayerReplicationInfo.Score<=0 || Amount<=0 )
        return;
    Amount = Min(Amount,int(Controller.PlayerReplicationInfo.Score));

    GetAxes(Rotation,X,Y,Z);

    TossVel = Vector(GetViewRotation());
    TossVel = TossVel * ((Velocity Dot TossVel) + 500) + Vect(0,0,200);

    CashPickup = Spawn(class'GameStatsTab.DoshPickup',,, Location + 0.8 * CollisionRadius * X - 0.5 * CollisionRadius * Y);

    if(CashPickup != none) {
        CashPickup.CashAmount = Amount;
        CashPickup.bDroppedCash = true;
        CashPickup.RespawnTime = 0; // Dropped cash doesnt respawn. For obvious reasons.
        CashPickup.Velocity = TossVel;
        CashPickup.DroppedBy = Controller;
        CashPickup.InitDroppedPickupFor(None);
        Controller.PlayerReplicationInfo.Score -= Amount;

        if ( Level.Game.NumPlayers > 1 && Level.TimeSeconds - LastDropCashMessageTime > DropCashMessageDelay ) {
            PlayerController(Controller).Speech('AUTO', 4, "");
        }
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
