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
}

function string getStatValues(array<float> stats[15], int numStats, Object statEnum) {
    local string statVals;
    local int i;
    local bool addComma;

    for(i= 0; i < numStats; i++) {
        if (stats[i] != 0) {
            if (addComma) statVals$= ",";
            statVals$= GetEnum(statEnum,i) $ "=" $ stats[i];
            addComma= true;
        }
    }
    return statVals;
}

function saveStats(GSTPlayerReplicationInfo pri) {
    local string baseMsg;
    local array<string> statValues;
    local int index;

    baseMsg= "action:accum;playerid:"$pri.playerIDHash$";authkey:"$class'GameStatsTabMut'.default.serverPassword$";";
    baseMsg$= "timestamp:"$Level.Year$Level.Month$Level.Day$"_"$Level.Hour$":"$Level.Minute$":"$Level.Second$";";
    baseMsg$= "isunix:" $ PlatformIsUnix() $ ";stat:";

    statValues[statValues.Length]= getStatValues(pri.playerStats, pri.PlayerStat.EnumCount, Enum'PlayerStat');
    statValues[statValues.Length]= getStatValues(pri.kfWeaponStats, pri.WeaponStat.EnumCount, Enum'WeaponStat');
    statValues[statValues.Length]= getStatValues(pri.zedStats, pri.KillStat.EnumCount, Enum'KillStat');
    statValues[statValues.Length]= getStatValues(pri.hiddenStats, pri.HiddenStat.EnumCount, Enum'HiddenStat');
    for(index= 0; index < statValues.Length; index++) {
        if (statValues[index] != "") SendText(serverAddr, baseMsg $ statValues[index]);
    }
}
