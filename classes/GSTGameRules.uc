class GSTGameRules extends GameRules;

struct monsterIndexPair {
    var string monsterName;
    var byte statIndex;
};

var GSTPlayerController gsPC;
var array<monsterIndexPair> monsterIndexArray;
var bool isArrayFilled;

function PostBeginPlay() {
    NextGameRules = Level.Game.GameRulesModifiers;
    Level.Game.GameRulesModifiers = Self;
}

function ScoreKill(Controller Killer, Controller Killed) {
    local int i;

    Super.ScoreKill(Killer,Killed);
    
    gsPC= GSTPlayerController(killer);
    if(gsPC != none) {
        if (!isArrayFilled) {
            fillMonsterIndexArray();
        }
        for(i= 0; i < monsterIndexArray.Length; i++) {
            if (InStr(string(Killed.pawn),monsterIndexArray[i].monsterName) != -1) {
                gsPC.incrementStat(monsterIndexArray[i].statIndex, 1);
                break;
            }
        }
    }

}

function fillMonsterIndexArray() {
    monsterIndexArray.Length= 10;
    monsterIndexArray[0].monsterName="ZombieCrawler";
    monsterIndexArray[0].statIndex=gsPC.EStatKeys.CRAWLER_KILLS;
    monsterIndexArray[1].monsterName="ZombieStalker";
    monsterIndexArray[1].statIndex=gsPC.EStatKeys.STALKER_KILLS;
    monsterIndexArray[2].monsterName="ZombieClot";
    monsterIndexArray[2].statIndex=gsPC.EStatKeys.CLOT_KILLS;
    monsterIndexArray[3].monsterName="ZombieGorefast";
    monsterIndexArray[3].statIndex=gsPC.EStatKeys.GOREFAST_KILLS;
    monsterIndexArray[4].monsterName="ZombieBloat";
    monsterIndexArray[4].statIndex=gsPC.EStatKeys.BLOAT_KILLS;
    monsterIndexArray[5].monsterName="ZombieSiren";
    monsterIndexArray[5].statIndex=gsPC.EStatKeys.SIREN_KILLS;
    monsterIndexArray[6].monsterName="ZombieHusk";
    monsterIndexArray[6].statIndex=gsPC.EStatKeys.HUSK_KILLS;
    monsterIndexArray[7].monsterName="ZombieScrake";
    monsterIndexArray[7].statIndex=gsPC.EStatKeys.SCRAKE_KILLS;
    monsterIndexArray[8].monsterName="ZombieFleshpound";
    monsterIndexArray[8].statIndex=gsPC.EStatKeys.FLESHPOUND_KILLS;
    monsterIndexArray[9].monsterName="ZombieBoss";
    monsterIndexArray[9].statIndex=gsPC.EStatKeys.PATRIARCH_KILLS;

    isArrayFilled= true;
}

defaultproperties {
    isArrayFilled= false;
}
