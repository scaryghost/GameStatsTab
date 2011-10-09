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
    
function ThrowGrenade()
{
    local inventory inv;
    local Frag aFrag;
    local GSTStats gs;

    for ( inv = inventory; inv != none; inv = inv.Inventory )
    {
        aFrag = Frag(inv);

        if ( aFrag != none && aFrag.HasAmmo() && !bThrowingNade )
        {
            if ( KFWeapon(Weapon) == none || Weapon.GetFireMode(0).NextFireTime - Level.TimeSeconds > 0.1 ||
                 (KFWeapon(Weapon).bIsReloading && !KFWeapon(Weapon).InterruptReload()) )
            {
                return;
            }

            //TODO: cache this without setting SecItem yet
            //SecondaryItem = aFrag;
            gs= class'GameStatsTabMut'.static.findStats(KFPC.getPlayerIDHash());
            gs.numFragsTossed++;
            KFWeapon(Weapon).ClientGrenadeState = GN_TempDown;
            Weapon.PutDown();
            break;
            //aFrag.StartThrow();
        }
    }
}

