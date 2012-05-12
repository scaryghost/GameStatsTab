class StatsServerUDPLink extends UDPLink;

var int udpPort;
var IpAddr serverAddr;
var string authKey, actionAccum, actionWrite;

function PostBeginPlay() {
    udpPort= bindPort(class'GameStatsTabMut'.default.serverPort+1, true);
    if (udpPort > 0) Resolve(class'GameStatsTabMut'.default.serverAddress);
    authKey= "authKey:"$class'GameStatsTabMut'.default.authKey$";";
}

event Resolved(IpAddr addr) {
    serverAddr= addr;
    serverAddr.port= class'GameStatsTabMut'.default.serverPort;
}

function broadcastMatchStart() {
    local string matchStats;

    matchStats= "stat:map=" $ Left(string(Level), InStr(string(Level), ".")) $ ",";
    matchStats$= "difficulty=" $ Level.Game.GameDifficulty $ ",";
    matchStats$= "length=" $ KFGameType(Level.Game).KFGameLength;
    SendText(serverAddr, "action:matchbegin;" $ authKey $ matchStats);
}

function broadcastMatchEnd() {
    local string matchStats;

    matchStats= "stat:result=" $ KFGameReplicationInfo(Level.Game.GameReplicationInfo).EndGameType $ ",";
    matchStats$= getStatValues(GSTGameReplicationInfo(Level.GRI).deathStats, 
            GSTGameReplicationInfo(Level.GRI).DeathStat.EnumCount, Enum'DeathStat');
    SendText(serverAddr, "action:matchend;" $ authKey $ matchStats);
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

    baseMsg= "playerid:" $ pri.playerIDHash $ ";" $ authKey;

    statValues[statValues.Length]= getStatValues(pri.playerStats, pri.PlayerStat.EnumCount, Enum'PlayerStat');
    statValues[statValues.Length]= getStatValues(pri.kfWeaponStats, pri.WeaponStat.EnumCount, Enum'WeaponStat');
    statValues[statValues.Length]= getStatValues(pri.killStats, pri.KillStat.EnumCount, Enum'KillStat');
    statValues[statValues.Length]= getStatValues(pri.hiddenStats, pri.HiddenStat.EnumCount, Enum'HiddenStat');
    for(index= 0; index < statValues.Length; index++) {
        if (statValues[index] != "") SendText(serverAddr, actionAccum $ baseMsg $ "stat:" $ statValues[index]);
    }
}

defaultproperties {
    actionAccum="action:accum;"
    actionWrite="action:write;"
}

