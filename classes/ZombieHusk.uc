class ZombieHusk extends KFChar.ZombieHusk;

var GSTPlayerReplicationInfo lastHitByPri;
var float tempHealth;
var bool decapCounted;

function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, 
        class<DamageType> damageType, optional int HitIndex) {
    local float prevHealth, diffHealth;
    prevHealth= Health;
    lastHitByPri= GSTPlayerReplicationInfo(GSTPlayerController(InstigatedBy.Controller).PlayerReplicationInfo);
    if (lastHitByPri != none && tempHealth == 0 && bBackstabbed) {
        lastHitByPri.addToPlayerStat(lastHitByPri.PlayerStat.BACKSTABS, 1);
    }

    super.TakeDamage(Damage, InstigatedBy, Hitlocation, Momentum, damageType, HitIndex);

    diffHealth= prevHealth - fmax(Health, 0);
    if (decapCounted) {
        diffHealth-= tempHealth;
        tempHealth= 0;
    }
    if (lastHitByPri != none) {
        if (!decapCounted && bDecapitated) {
            lastHitByPri.addToPlayerStat(lastHitByPri.PlayerStat.NUM_DECAPS, 1);
            decapCounted= true;
        }
        lastHitByPri.addToHiddenStat(lastHitByPri.HiddenStat.DAMAGE_DEALT, diffHealth);
    }
}

function RemoveHead() {
    tempHealth= Health;
    super.RemoveHead();
    tempHealth-= fmax(Health, 0);
}

function bool FlipOver() {
    if (Health > 0 && lastHitByPri != none) {
        lastHitByPri.addToPlayerStat(lastHitByPri.PlayerStat.HUSKS_STUNNED, 1);
    }

    return super.FlipOver();
}

/**
 * Copied from ZombieHusk.SpawnTwoShots()
 * Changed projectile to use stats tacking projectile
 */
function SpawnTwoShots() {
	local vector X,Y,Z, FireStart;
	local rotator FireRotation;
	local KFMonsterController KFMonstControl;

	if( Controller!=None && KFDoorMover(Controller.Target)!=None ) {
		Controller.Target.TakeDamage(22,Self,Location,vect(0,0,0),Class'DamTypeVomit');
		return;
	}

	GetAxes(Rotation,X,Y,Z);
	FireStart = GetBoneCoords('Barrel').Origin;
	if ( !SavedFireProperties.bInitialized ) {
		SavedFireProperties.AmmoClass = Class'SkaarjAmmo';
		SavedFireProperties.ProjectileClass = Class'GameStatsTab.HuskFireProjectile';
		SavedFireProperties.WarnTargetPct = 1;
		SavedFireProperties.MaxRange = 65535;
		SavedFireProperties.bTossed = False;
		SavedFireProperties.bTrySplash = true;
		SavedFireProperties.bLeadTarget = True;
		SavedFireProperties.bInstantHit = False;
		SavedFireProperties.bInitialized = True;
	}

    // Turn off extra collision before spawning vomit, otherwise spawn fails
    ToggleAuxCollision(false);

	FireRotation = Controller.AdjustAim(SavedFireProperties,FireStart,600);

	foreach DynamicActors(class'KFMonsterController', KFMonstControl) {
        if( KFMonstControl != Controller ) {
            if( PointDistToLine(KFMonstControl.Pawn.Location, vector(FireRotation), FireStart) < 75 ) {
                KFMonstControl.GetOutOfTheWayOfShot(vector(FireRotation),FireStart);
            }
        }
	}

    Spawn(Class'GameStatsTab.HuskFireProjectile',,,FireStart,FireRotation);

	// Turn extra collision back on
	ToggleAuxCollision(true);
}

