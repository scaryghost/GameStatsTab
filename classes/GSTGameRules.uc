class GSTGameRules extends GameRules;

struct monsterIndexPair {
    var string monsterName;
    var GSTPlayerReplicationInfo.ZedStat statIndex;
};

var array<monsterIndexPair> monsterIndexArray;
var bool isArrayFilled;

function PostBeginPlay() {
    NextGameRules = Level.Game.GameRulesModifiers;
    Level.Game.GameRulesModifiers = Self;
}

function ScoreKill(Controller Killer, Controller Killed) {
    local GSTPlayerReplicationInfo pri;
    local int i;

    Super.ScoreKill(Killer,Killed);
    
    pri= GSTPlayerReplicationInfo(killer.PlayerReplicationInfo);
    if(pri != none) {
        if (!isArrayFilled) {
            fillMonsterIndexArray(pri);
        }
        for(i= 0; i < monsterIndexArray.Length; i++) {
            if (InStr(string(Killed.pawn),monsterIndexArray[i].monsterName) != -1) {
                pri.addToZedStat(monsterIndexArray[i].statIndex, 1);
                break;
            }
        }
    }

}

function fillMonsterIndexArray(GSTPlayerReplicationInfo pri) {
    monsterIndexArray.Length= 10;
    monsterIndexArray[0].monsterName="ZombieCrawler";
    monsterIndexArray[0].statIndex=pri.zedStat.CRAWLER_KILLS;
    monsterIndexArray[1].monsterName="ZombieStalker";
    monsterIndexArray[1].statIndex=pri.zedStat.STALKER_KILLS;
    monsterIndexArray[2].monsterName="ZombieClot";
    monsterIndexArray[2].statIndex=pri.zedStat.CLOT_KILLS;
    monsterIndexArray[3].monsterName="ZombieGorefast";
    monsterIndexArray[3].statIndex=pri.zedStat.GOREFAST_KILLS;
    monsterIndexArray[4].monsterName="ZombieBloat";
    monsterIndexArray[4].statIndex=pri.zedStat.BLOAT_KILLS;
    monsterIndexArray[5].monsterName="ZombieSiren";
    monsterIndexArray[5].statIndex=pri.zedStat.SIREN_KILLS;
    monsterIndexArray[6].monsterName="ZombieHusk";
    monsterIndexArray[6].statIndex=pri.zedStat.HUSK_KILLS;
    monsterIndexArray[7].monsterName="ZombieScrake";
    monsterIndexArray[7].statIndex=pri.zedStat.SCRAKE_KILLS;
    monsterIndexArray[8].monsterName="ZombieFleshpound";
    monsterIndexArray[8].statIndex=pri.zedStat.FLESHPOUND_KILLS;
    monsterIndexArray[9].monsterName="ZombieBoss";
    monsterIndexArray[9].statIndex=pri.zedStat.PATRIARCH_KILLS;

    isArrayFilled= true;
}

defaultproperties {
    isArrayFilled= false;
}
