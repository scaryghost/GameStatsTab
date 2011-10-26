class GSTZombieHusk extends ZombieHusk;

var GSTPlayerController gsPC;
var bool decapCounted;

function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, 
        class<DamageType> damageType, optional int HitIndex) {
    gsPC= GSTPlayerController(InstigatedBy.Controller);
    if (!bDecapitated && bBackstabbed) {
        gsPC.incrementStat(gsPC.EStatKeys.BACKSTABS, 1);
    }

    super.TakeDamage(Damage, InstigatedBy, Hitlocation, Momentum, damageType, HitIndex);

    if (!decapCounted && bDecapitated && gsPC != none) {
        gsPC.incrementStat(gsPC.EStatKeys.NUM_DECAPS, 1);
        decapCounted= true;
    }
}

/**
 * Copied from ZombieHusk.SpawnTwoShots()
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
		SavedFireProperties.ProjectileClass = Class'GameStatsTab.GSTHuskFireProjectile';
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

    Spawn(Class'GameStatsTab.GSTHuskFireProjectile',,,FireStart,FireRotation);

	// Turn extra collision back on
	ToggleAuxCollision(true);
}

