class GSTFrag extends Frag;

function ServerThrow() {
    local GSTPlayerReplicationInfo pri;

    super.ServerThrow();
    pri= GSTPlayerReplicationInfo(Instigator.Controller.PlayerReplicationInfo);
    if (pri != none) {
        pri.incrementStat(pri.EStatKeys.FRAGS_TOSSED, 1);
    }
}
