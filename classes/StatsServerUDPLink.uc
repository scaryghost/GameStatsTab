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
    SendText(serverAddr, "action:auth;password:"$class'GameStatsTabMut'.default.serverPassword);
}

function saveStats(GSTPlayerReplicationInfo pri) {
    local string baseMsg, statVals;
    local int i;
    local bool addComma;

    baseMsg= "action:accum;playerid:" $ pri.playerIDHash $ ";";
    baseMsg$= "timestamp:";
    baseMsg$= Level.Year$Level.Month$Level.Day$"_"$Level.Hour$":"$Level.Minute$":"$Level.Second$";";
    baseMsg$= "isunix:" $ PlatformIsUnix() $ ";stat:";

    statVals= "";
    for(i= 0; i < pri.PlayerStat.EnumCount; i++) {
        if (pri.playerStats[i] != 0) {
            if (addComma) {
                statVals$= ",";
            }
            statVals$= GetEnum(Enum'GSTPlayerReplicationInfo.PlayerStat',i) $ "=" $ pri.playerStats[i];
            addComma= true;
        }
    }
    if (addComma) {
        SendText(serverAddr, baseMsg $ statVals);
    }

    statVals= "";
    addComma= false;
    for(i= 0; i < pri.WeaponStat.EnumCount; i++) {
        if (pri.kfWeaponStats[i] != 0) {
            if (addComma) {
                statVals$= ",";
            }
            statVals$= GetEnum(Enum'GSTPlayerReplicationInfo.WeaponStat',i) $ "=" $ pri.kfWeaponStats[i];
            addComma= true;
        }
    }
    if (addComma) {
        SendText(serverAddr, baseMsg $ statVals);
    }
    
    statVals= "";
    addComma= false;
    for(i= 0; i < pri.KillStat.EnumCount; i++) {
        if (pri.zedStats[i] != 0) {
            if (addComma) {
                statVals$= ",";
            }
            statVals$= GetEnum(Enum'GSTPlayerReplicationInfo.KillStat',i) $ "=" $ pri.zedStats[i];
            addComma= true;
        }
    }
    if (addComma) {
        SendText(serverAddr, baseMsg $ statVals);
    }
    
    statVals= "";
    addComma= false;
    for(i= 0; i < pri.HiddenStat.EnumCount; i++) {
        if (pri.hiddenStats[i] != 0) {
            if (addComma) {
                statVals$= ",";
            }
            statVals$= GetEnum(Enum'GSTPlayerReplicationInfo.HiddenStat',i) $ "=" $ pri.hiddenStats[i];
            addComma= true;
        }
    }
    if (addComma) {
        SendText(serverAddr, baseMsg $ statVals);
    }

}
