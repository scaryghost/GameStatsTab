class StatsServerUDPLink extends UDPLink;

var int udpPort;
var IpAddr serverAddr;
var string timeStamp;

enum Actions {
    ACCUM,
    WRITE
};

enum Events {
    MATCH_BEGIN,
    MATCH_END,
    PLAYER_LOGOUT
};

function PostBeginPlay() {
    udpPort= bindPort(class'GameStatsTabMut'.default.serverPort+1, true);
    if (udpPort > 0) Resolve(class'GameStatsTabMut'.default.serverAddress);
}

event Resolved(IpAddr addr) {
    serverAddr= addr;
    serverAddr.port= class'GameStatsTabMut'.default.serverPort;
}

function broadcastMatchStart() {
    local string matchStats;

    timeStamp= getDateTime();
    matchStats= "event:" $ GetEnum(Enum'Events', 0) $ ";";
    matchStats$= timeStamp $ "stat:map=" $ Left(string(Level), InStr(string(Level), ".")) $ ",";
    matchStats$= "difficulty=" $ Level.Game.GameDifficulty $ ",";
    matchStats$= "length=" $ KFGameType(Level.Game).KFGameLength;
    SendText(serverAddr, "action:" $ GetEnum(Enum'Actions', 1) $ ";" $ matchStats);
}

function broadcastMatchEnd() {
    local string matchStats;

    matchStats= "event:" $ GetEnum(Enum'Events', 1) $ ";";
    matchStats$= "stat:result=" $ KFGameReplicationInfo(Level.Game.GameReplicationInfo).EndGameType $ ",";
    matchStats$= getStatValues(GSTGameReplicationInfo(Level.GRI).deathStats, 
            GSTGameReplicationInfo(Level.GRI).DeathStat.EnumCount, Enum'DeathStat');
    SendText(serverAddr, "action:" $ GetEnum(Enum'Actions', 1) $ ";" $ matchStats);
}    

function string getDateTime() {
    return "timestamp:" $ Level.Year$Level.Month$Level.Day$"_"$Level.Hour$":"$Level.Minute$":"$Level.Second $ ";";
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

    pri.addToHiddenStat(pri.HiddenStat.TIME_CONNECT, Level.GRI.ElapsedTime - pri.StartTime);

    baseMsg= "action:" $ GetEnum(Enum'Actions',0) $ ";playerid:" $ pri.playerIDHash $ ";" $ timeStamp;

    statValues[statValues.Length]= getStatValues(pri.playerStats, pri.PlayerStat.EnumCount, Enum'PlayerStat');
    statValues[statValues.Length]= getStatValues(pri.kfWeaponStats, pri.WeaponStat.EnumCount, Enum'WeaponStat');
    statValues[statValues.Length]= getStatValues(pri.killStats, pri.KillStat.EnumCount, Enum'KillStat');
    statValues[statValues.Length]= getStatValues(pri.hiddenStats, pri.HiddenStat.EnumCount, Enum'HiddenStat');
    for(index= 0; index < statValues.Length; index++) {
        if (statValues[index] != "") SendText(serverAddr, baseMsg $ "stat:" $ statValues[index]);
    }
}

