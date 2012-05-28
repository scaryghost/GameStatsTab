class StatsServerUDPLink extends UDPLink;

var int udpPort;
var IpAddr serverAddr;
var string timeStamp, matchData;

function PostBeginPlay() {
    udpPort= bindPort(class'GameStatsTabMut'.default.serverPort+1, true);
    if (udpPort > 0) Resolve(class'GameStatsTabMut'.default.serverAddress);
}

event Resolved(IpAddr addr) {
    serverAddr= addr;
    serverAddr.port= class'GameStatsTabMut'.default.serverPort;
}

function MatchStarting() {
    timeStamp= "timestamp:"$Level.Year$Level.Month$Level.Day$"_"$Level.Hour$":"$Level.Minute$":"$Level.Second $ ";";

    matchData= "stat:map=" $ Left(string(Level), InStr(string(Level), ".")) $ ",";
    matchData$= "difficulty=" $ int(Level.Game.GameDifficulty) $ ",";
    matchData$= "length=" $ KFGameType(Level.Game).KFGameLength $ ",";
}

function broadcastMatchResults() {
    local string results;

    results$= "elapsedtime=" $ Level.GRI.ElapsedTime $ ",";
    results$= "result=" $ KFGameReplicationInfo(Level.GRI).EndGameType $ ",";
    results$= "wave=" $ KFGameType(Level.Game).WaveNum+1 $ ",";
    results$= getStatValues(GSTGameReplicationInfo(Level.GRI).deathStats, 
            GSTGameReplicationInfo(Level.GRI).DeathStat.EnumCount, Enum'DeathStat');
    SendText(serverAddr, timestamp $ matchData $ results);
}    

function string getStatValues(array<float> stats[15], int numStats, Object statEnum) {
    local string statVals;
    local int i;
    local bool addComma;

    for(i= 0; i < numStats; i++) {
        if (stats[i] != 0) {
            if (addComma) statVals$= ",";
            statVals$= GetEnum(statEnum,i) $ "=" $ int(round(stats[i]));
            addComma= true;
        }
    }
    return statVals;
}

function saveStats(GSTPlayerReplicationInfo pri) {
    local string baseMsg;
    local array<string> statMsgs;
    local int index;

    pri.addToHiddenStat(pri.HiddenStat.TIME_CONNECT, Level.GRI.ElapsedTime - pri.StartTime);
    baseMsg= "playerid:" $ pri.playerIDHash $ ";";

    statMsgs[statMsgs.Length]= timeStamp $ "seq:0;stat:" $ getStatValues(pri.playerStats, pri.PlayerStat.EnumCount, Enum'PlayerStat');
    statMsgs[statMsgs.Length]= "seq:1;stat:" $ getStatValues(pri.kfWeaponStats, pri.WeaponStat.EnumCount, Enum'WeaponStat');
    statMsgs[statMsgs.Length]= "seq:2;stat:" $ getStatValues(pri.killStats, pri.KillStat.EnumCount, Enum'KillStat');
    statMsgs[statMsgs.Length]= "seq:3;stat:" $ getStatValues(pri.hiddenStats, pri.HiddenStat.EnumCount, Enum'HiddenStat');
    statMsgs[statMsgs.Length]= "seq:4;" $ matchData $ "result=" $ KFGameReplicationInfo(Level.GRI).EndGameType $ ",wave=" $ KFGameType(Level.Game).WaveNum+1 $ ";_close";
    for(index= 0; index < statMsgs.Length; index++) {
        SendText(serverAddr, baseMsg $ statMsgs[index]);
    }
}

