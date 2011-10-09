class GSTHumanPawn extends KFHumanPawn;

simulated function PostBeginPlay() {
    super.PostBeginPlay();

    setTimer(1.0, true);
}

function timer() {
    local GSTStats gs;

    if (Health > 0) {
        gs= class'GameStatsTabMut'.static.findStats(KFPC.getPlayerIDHash());
        gs.numSecondsAlive++;
    }
}

simulated function TakeDamage( int Damage, Pawn InstigatedBy, 
        Vector Hitlocation, Vector Momentum, class<DamageType> damageType, 
        optional int HitIndex) {

    local float oldHealth;
    local float oldShield;
    local GSTStats gs;

    oldHealth= Health;
    oldShield= ShieldStrength;

    Super.TakeDamage(Damage,instigatedBy,hitlocation,momentum,damageType);

    gs= class'GameStatsTabMut'.static.findStats(KFPC.getPlayerIDHash());
    gs.totalDamageTaken+= (oldHealth - Health);
    gs.totalShieldLost+= (oldShield - ShieldStrength);
}
    

