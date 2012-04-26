class UnWeldFire extends KFMod.UnWeldFire;

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
        pri.addToPlayerStat(pri.PlayerStat.WELDING, oldWeldStrength - targetDoor.MyTrigger.WeldStrength);
    }
}
