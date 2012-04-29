class GSTGameRules extends GameRules
    dependson(GSTPlayerReplicationInfo);

var array<string> zedNames;

function PostBeginPlay() {
    local GSTPlayerReplicationInfo.KillStat index;

    NextGameRules = Level.Game.GameRulesModifiers;
    Level.Game.GameRulesModifiers = Self;
    
    index= BLOAT_KILLS;
    zedNames[index]= "ZombieBloat";
    index= BOSS_KILLS;
    zedNames[index]= "ZombieBoss";
    index= CLOT_KILLS;
    zedNames[index]= "ZombieClot";
    index= CRAWLER_KILLS;
    zedNames[index]= "ZombieCrawler";
    index= FLESHPOUND_KILLS;
    zedNames[index]= "ZombieFleshPound";
    index= GOREFAST_KILLS;
    zedNames[index]= "ZombieGorefast";
    index= HUSK_KILLS;
    zedNames[index]= "ZombieHusk";
    index= SCRAKE_KILLS;
    zedNames[index]= "ZombieScrake";
    index= SIREN_KILLS;
    zedNames[index]= "ZombieSiren";
    index= STALKER_KILLS;
    zedNames[index]= "ZombieStalker";
}

function ScoreKill(Controller Killer, Controller Killed) {
    local int index;
    local GSTPlayerReplicationInfo pri;

    Super.ScoreKill(Killer,Killed);
    
    pri= GSTPlayerReplicationInfo(killer.PlayerReplicationInfo);
    if(pri != none) {
        index= class'GSTAuxiliary'.static.binarySearch(GetItemName(string(Killed.pawn)), zedNames);
        if (index > -1) pri.addToKillStat(KillStat(index), 1);
    }

}
