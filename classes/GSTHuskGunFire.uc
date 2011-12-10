class GSTHuskGunFire extends HuskGunFire;

function DoFireEffect() {
    local GSTPlayerReplicationInfo pri;
    local int fuelAmount;

    super.DoFireEffect();
    pri= GSTPlayerReplicationInfo(Instigator.Controller.PlayerReplicationInfo);
    /**
     * Use the same ammo formula as in HuskGunFire.ModeDoFire()
     */
    if (HoldTime < MaxChargeTime) {
        fuelAmount= 1.0 + (HoldTime/(MaxChargeTime/9.0));
    } else {
        fuelAmount= 10;
    }
    pri.incrementStat(pri.EStatKeys.UNITS_FUEL, fuelAmount);
}
