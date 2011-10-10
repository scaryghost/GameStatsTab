class GSTZombieHusk extends ZombieHusk;

var KFPlayerController lastHurtBy;

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, 
        class<DamageType> damageType, optional int HitIndex ) {
    if (KFHumanPawn(instigatedBy) != none) {
        lastHurtBy= KFHumanPawn(instigatedBy).KFPC;
    }

    super.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType, HitIndex);
}

function RemoveHead() {
    local GSTStats gs;

    super.RemoveHead();
    if (lastHurtBy != none) {
        gs= class'GameStatsTabMut'.static.findStats(lastHurtBy.getPlayerIDHash());
        gs.statArray[gs.EStatKeys.NUM_DECAPS].statValue+= 1;
    }
}

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

