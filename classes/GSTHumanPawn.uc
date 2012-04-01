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
        pri.playerStats[pri.PlayerStat.TIME_ALIVE]+= currTimeStamp - prevTimeStamp;
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
        pri.playerStats[pri.PlayerStat.FF_DAMAGE_DEALT]+= oldHealth - fmax(Health, 0.0);
    }
    pri= GSTPlayerReplicationInfo(Controller.PlayerReplicationInfo);
    if(pri != none) {
        pri.playerStats[pri.PlayerStat.DAMAGE_TAKEN]+= oldHealth - fmax(Health,0.0);
        pri.playerStats[pri.PlayerStat.SHIELD_LOST]+= oldShield - fmax(ShieldStrength,0.0);
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
        pri.playerStats[pri.PlayerStat.DAMAGE_TAKEN]+= oldHealth - fmax(Health,0.0);
        pri.playerStats[pri.PlayerStat.SHIELD_LOST]+= oldShield - fmax(ShieldStrength,0.0);
    }
}

simulated function addHealth() {
    local float oldHealth;
    
    oldHealth= Health;
    super.addHealth();

    pri= GSTPlayerReplicationInfo(Controller.PlayerReplicationInfo);
    if (pri != none) {
        pri.playerStats[pri.PlayerStat.HEALING_RECIEVED]+= Health - OldHealth;
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


