class CrossbowArrow extends KFMod.CrossbowArrow;

simulated state OnWall {
    /**  Copied from KFMod.CrossbowArrow, added bolts retrieved stat */
    function ProcessTouch (Actor Other, vector HitLocation) {
        local Inventory inv;
        local GSTPlayerReplicationInfo pri;

        pri= GSTPlayerReplicationInfo(Pawn(Other).Controller.PlayerReplicationInfo);
        if( Pawn(Other)!=None && Pawn(Other).Inventory!=None ) {
            for( inv=Pawn(Other).Inventory; inv!=None; inv=inv.Inventory ) {
                if( Crossbow(Inv)!=None && Weapon(inv).AmmoAmount(0)<Weapon(inv).MaxAmmo(0) ) {
                    KFweapon(Inv).AddAmmo(1,0) ;
                    PlaySound(Sound'KF_InventorySnd.Ammo_GenericPickup', SLOT_Pain,2*TransientSoundVolume,,400);
                    if(PlayerController(Pawn(Other).Controller) !=none) {
                        PlayerController(Pawn(Other).Controller).ClientMessage( "You picked up a bolt" );
                        pri.kfWeaponStats[pri.WeaponStat.BOLTS_RETRIEVED]+= 1.0;
                    }
                    Destroy();
                }
            }
        }
    }
}
