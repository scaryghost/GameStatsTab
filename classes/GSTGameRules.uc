class GSTGameRules extends GameRules
    dependson(GSTPlayerReplicationInfo);

var array<string> zedNames;

function PostBeginPlay() {
    NextGameRules = Level.Game.GameRulesModifiers;
    Level.Game.GameRulesModifiers = Self;
}

function ScoreKill(Controller Killer, Controller Killed) {
    local GSTPlayerReplicationInfo.KillStat index;
    local GSTPlayerReplicationInfo pri;

    Super.ScoreKill(Killer,Killed);
    
    pri= GSTPlayerReplicationInfo(killer.PlayerReplicationInfo);
    if(pri != none) {
        if (zedNames.Length == 0) {
            fillZedNamesArray(pri);
        }
        index= KillStat(class'GSTAuxiliary'.static.binarySearch(GetItemName(string(Killed.pawn)), zedNames));
        if (index > -1) {
            log("GSTGameRules: "$index);
            pri.addToKillStat(index, 1);
        }
    }

}

function fillZedNamesArray(GSTPlayerReplicationInfo pri) {
    zedNames[pri.KillStat.BLOAT_KILLS]= "ZombieBloat";
    zedNames[pri.KillStat.BOSS_KILLS]= "ZombieBoss";
    zedNames[pri.KillStat.CLOT_KILLS]= "ZombieClot";
    zedNames[pri.KillStat.CRAWLER_KILLS]= "ZombieCrawler";
    zedNames[pri.KillStat.FLESHPOUND_KILLS]= "ZombieFleshPound";
    zedNames[pri.KillStat.GOREFAST_KILLS]= "ZombieGorefast";
    zedNames[pri.KillStat.HUSK_KILLS]= "ZombieHusk";
    zedNames[pri.KillStat.SCRAKE_KILLS]= "ZombieScrake";
    zedNames[pri.KillStat.SIREN_KILLS]= "ZombieSiren";
    zedNames[pri.KillStat.STALKER_KILLS]= "ZombieStalker";
}
