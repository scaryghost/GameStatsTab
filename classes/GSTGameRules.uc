class GSTGameRules extends GameRules
    dependson(GSTPlayerReplicationInfo);

var array<string> zedNames;

function PostBeginPlay() {
    NextGameRules = Level.Game.GameRulesModifiers;
    Level.Game.GameRulesModifiers = Self;
}

function ScoreKill(Controller Killer, Controller Killed) {
    local GSTPlayerReplicationInfo.ZedStat index;
    local GSTPlayerReplicationInfo pri;

    Super.ScoreKill(Killer,Killed);
    
    pri= GSTPlayerReplicationInfo(killer.PlayerReplicationInfo);
    if(pri != none) {
        if (zedNames.Length == 0) {
            fillZedNamesArray(pri);
        }
        index= ZedStat(class'GSTAuxiliary'.static.binarySearch(GetItemName(string(Killed.pawn)), zedNames));
        if (index > -1) {
            log("GSTGameRules: "$index);
            pri.addToZedStat(index, 1);
        }
    }

}

function fillZedNamesArray(GSTPlayerReplicationInfo pri) {
    zedNames[pri.ZedStat.BLOAT_KILLS]= "ZombieBloat";
    zedNames[pri.ZedStat.BOSS_KILLS]= "ZombieBoss";
    zedNames[pri.ZedStat.CLOT_KILLS]= "ZombieClot";
    zedNames[pri.ZedStat.CRAWLER_KILLS]= "ZombieCrawler";
    zedNames[pri.ZedStat.FLESHPOUND_KILLS]= "ZombieFleshPound";
    zedNames[pri.ZedStat.GOREFAST_KILLS]= "ZombieGorefast";
    zedNames[pri.ZedStat.HUSK_KILLS]= "ZombieHusk";
    zedNames[pri.ZedStat.SCRAKE_KILLS]= "ZombieScrake";
    zedNames[pri.ZedStat.SIREN_KILLS]= "ZombieSiren";
    zedNames[pri.ZedStat.STALKER_KILLS]= "ZombieStalker";
}
