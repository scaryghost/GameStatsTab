class GSTStats extends Object;

enum EStatKeys {
    CRAWLER_KILLS,
    STALKER_KILLS,
    CLOT_KILLS,
    GOREFAST_KILLS,
    BLOAT_KILLS,
    SIREN_KILLS,
    HUSK_KILLS,
    SCRAKE_KILLS,
    FLESHPOUND_KILLS,
    PATRIARCH_KILLS,
    ROUNDS_FIRED,
    FRAGS_TOSSED,
    HEALING_RECIEVED,
    DAMAGE_TAKEN,
    SHIELD_LOST,
    FF_DAMAGE_DEALT,
    TIME_ALIVE
};

struct StatDescripValuePair {
    var string descrip;
    var int statValue;
};

var array<StatDescripValuePair> statArray;
var array<string> monsterIndexArray;

function addKill(KFMonster victim) {
    local int i;
   
    for(i= 0; i < monsterIndexArray.Length; i++) {
        if (InStr(string(victim),monsterIndexArray[i]) != -1) {
            statArray[i].statValue++;
            break;
        }
    }
}

defaultproperties {
    monsterIndexArray(0)="ZombieCrawler"
    monsterIndexArray(1)="ZombieStalker"
    monsterIndexArray(2)="ZombieClot"
    monsterIndexArray(3)="ZombieGorefast"
    monsterIndexArray(4)="ZombieBloat"
    monsterIndexArray(5)="ZombieSiren"
    monsterIndexArray(6)="ZombieHusk"
    monsterIndexArray(7)="ZombieScrake"
    monsterIndexArray(8)="ZombieFleshPound"
    monsterIndexArray(9)="ZombieBoss"
    
    statArray(0)=(descrip="Crawler kills",statValue=0)
    statArray(1)=(descrip="Stalker kills",statValue=0)
    statArray(2)=(descrip="Clot kills",statValue=0)
    statArray(3)=(descrip="Gorefast kills",statValue=0)
    statArray(4)=(descrip="Bloat kills",statValue=0)
    statArray(5)=(descrip="Siren kills",statValue=0)
    statArray(6)=(descrip="Husk kills",statValue=0)
    statArray(7)=(descrip="Scrake kills",statValue=0)
    statArray(8)=(descrip="Fleshpound kills",statValue=0)
    statArray(9)=(descrip="Patriarch kills",statValue=0)
    statArray(10)=(descrip="Rounds fired",statValue=0)
    statArray(11)=(descrip="Frags tossed",statValue=0)
    statArray(12)=(descrip="Total healing recieved",statValue=0)
    statArray(13)=(descrip="Total damage taken",statValue=0)
    statArray(14)=(descrip="Total shield lost",statValue=0)
    statArray(15)=(descrip="Friendly fire damage",statValue=0)
    statArray(16)=(descrip="Time alive",statValue=0)
}
