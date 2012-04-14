class StatsServerUDPLink extends UDPLink;

var int udpPort;
var IpAddr serverAddr;

function PostBeginPlay() {
    udpPort= bindPort(class'GameStatsTabMut'.default.serverPort+1, true);
    if (udpPort > 0) {
        Resolve(class'GameStatsTabMut'.default.serverIp);
    }
}

event Resolved(IpAddr addr) {
    serverAddr= addr;
    serverAddr.port= class'GameStatsTabMut'.default.serverPort;
    SendText(serverAddr, "Hello Server!");
}

function sendStats(GSTPlayerReplicationInfo pri) {
    local string baseMsg, statVals;
    local int i;

    baseMsg= "action:write;playerid:";
    baseMsg= baseMsg $ pri.playerIDHash $ ";";

    statVals= "";
    for(i= 0; i < pri.PlayerStat.EnumCount; i++) {
        if (pri.playerStats[i] != 0) {
            statVals$= GetEnum(Enum'GSTPlayerReplicationInfo.PlayerStat',i) $ "=" $ pri.playerStats[i];
            if (i < pri.PlayerStat.EnumCount - 1) {
                statVals$= ",";
            }
        }
    }
    SendText(serverAddr, baseMsg $ statVals);

    statVals= "";
    for(i= 0; i < pri.WeaponStat.EnumCount; i++) {
        if (pri.kfWeaponStats[i] != 0) {
            statVals$= GetEnum(Enum'GSTPlayerReplicationInfo.WeaponStat',i) $ "=" $ pri.kfWeaponStats[i];
            if (i < pri.WeaponStat.EnumCount - 1) {
                statVals$= ",";
            }
        }
    }
    SendText(serverAddr, baseMsg $ statVals);

    statVals= "";
    for(i= 0; i < pri.ZedStat.EnumCount; i++) {
        if (pri.zedStats[i] != 0) {
            statVals$= GetEnum(Enum'GSTPlayerReplicationInfo.ZedStat',i) $ "=" $ pri.zedStats[i];
            if (i < pri.ZedStat.EnumCount - 1) {
                statVals$= ",";
            }
        }
    }
    SendText(serverAddr, baseMsg $ statVals);

    statVals= "";
    for(i= 0; i < pri.HiddenStat.EnumCount; i++) {
        if (pri.hiddenStats[i] != 0) {
            statVals$= GetEnum(Enum'GSTPlayerReplicationInfo.HiddenStat',i) $ "=" $ pri.hiddenStats[i];
            if (i < pri.HiddenStat.EnumCount - 1) {
                statVals$= ",";
            }
        }
    }
    SendText(serverAddr, baseMsg $ statVals);

}
