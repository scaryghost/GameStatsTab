class GSTPlayerController extends KFPlayerController;

enum EStatKeys {
    TIME_ALIVE,
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
    MELEE_SWINGS,
    FRAGS_TOSSED,
    PIPES_SET,
    NUM_DECAPS,
    HEALING_RECIEVED,
    DAMAGE_TAKEN,
    SHIELD_LOST,
    FF_DAMAGE_DEALT,
    FLESHPOUNDS_RAGED,
    SCRAKES_RAGED,
    SCRAKES_STUNNED,
    SHOT_BY_HUSK
};

var array<float> statArray[24];
var array<string> descripArray[ArrayCount(statArray)];
var array<string> monsterIndexArray;

var float prevHealth, prevShield;

replication {
    reliable if (bNetOwner && Role == ROLE_Authority)
        statArray;
}

function addKill(KFMonster victim) {
    local int i;
   
    for(i= 0; i < monsterIndexArray.Length; i++) {
        if (InStr(string(victim),monsterIndexArray[i]) != -1) {
            statArray[i+1]+= 1;
            break;
        }
    }
}

function SetPawnClass(string inClass, string inCharacter) {
    PawnClass = Class'GameStatsTab.GSTHumanPawn';
    inCharacter = Class'KFGameType'.Static.GetValidCharacter(inCharacter);
    PawnSetupRecord = class'xUtil'.static.FindPlayerRecord(inCharacter);
    PlayerReplicationInfo.SetCharacterName(inCharacter);
}

function PawnDied(Pawn P) {
    super.PawnDied(P);

    statArray[EStatKeys.DAMAGE_TAKEN]+= prevHealth;
    statArray[EStatKeys.SHIELD_LOST]+= prevShield;
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
    monsterIndexArray(8)="ZombieFleshpound"
    monsterIndexArray(9)="ZombieBoss"

    descripArray(0)="Time alive"
    descripArray(1)="Crawler kills"
    descripArray(2)="Stalker kills"
    descripArray(3)="Clot kills"
    descripArray(4)="Gorefast kills"
    descripArray(5)="Bloat kills"
    descripArray(6)="Siren kills"
    descripArray(7)="Husk kills"
    descripArray(8)="Scrake kills"
    descripArray(9)="Fleshpound kills"
    descripArray(10)="Patriarch kills"
    descripArray(11)="Rounds fired"
    descripArray(12)="Melee swings"
    descripArray(13)="Frags tossed"
    descripArray(14)="Pipes set"
    descripArray(15)="Decapitations"
    descripArray(16)="Total healing recieved"
    descripArray(17)="Total damage taken"
    descripArray(18)="Total shield lost"
    descripArray(19)="Friendly fire damage"
    descripArray(20)="Fleshpounds raged"
    descripArray(21)="Scrakes raged"
    descripArray(22)="Scrakes stunned"
    descripArray(23)="Shot by husk"
}
