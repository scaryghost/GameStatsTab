class WeldFire extends KFMod.WeldFire;

simulated Function timer() {
    local KFDoorMover targetDoor;
    local float oldWeldStrength;
    local GSTPlayerReplicationInfo pri;

    targetDoor= GetDoor();
    pri= GSTPlayerReplicationInfo(Instigator.Controller.PlayerReplicationInfo);
    if (targetDoor != none) {
        oldWeldStrength= targetDoor.MyTrigger.WeldStrength;
    }
    super.timer();
    if (targetDoor != none) {
        pri.addToPlayerStat(pri.PlayerStat.WELDING, targetDoor.MyTrigger.WeldStrength - oldWeldStrength);
    }
}
