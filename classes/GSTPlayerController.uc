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

simulated function PostBeginPlay() {
    super.PostBeginPlay();

    /**
     * Should be handled in the defaultproperties but the compiler
     * thinks all enum values are 0 at compile time and flags an error
     */
    descripArray[EStatKeys.TIME_ALIVE]="Time alive";
    descripArray[EStatKeys.CRAWLER_KILLS]="Crawler kills";
    descripArray[EStatKeys.STALKER_KILLS]="Stalker kills";
    descripArray[EStatKeys.CLOT_KILLS]="Clot kills";
    descripArray[EStatKeys.GOREFAST_KILLS]="Gorefast kills";
    descripArray[EStatKeys.BLOAT_KILLS]="Bloat kills";
    descripArray[EStatKeys.SIREN_KILLS]="Siren kills";
    descripArray[EStatKeys.HUSK_KILLS]="Husk kills";
    descripArray[EStatKeys.SCRAKE_KILLS]="Scrake kills";
    descripArray[EStatKeys.FLESHPOUND_KILLS]="Fleshpound kills";
    descripArray[EStatKeys.PATRIARCH_KILLS]="Patriarch kills";
    descripArray[EStatKeys.ROUNDS_FIRED]="Rounds fired";
    descripArray[EStatKeys.MELEE_SWINGS]="Melee swings";
    descripArray[EStatKeys.FRAGS_TOSSED]="Frags tossed";
    descripArray[EStatKeys.PIPES_SET]="Pipes set";
    descripArray[EStatKeys.NUM_DECAPS]="Decapitations";
    descripArray[EStatKeys.HEALING_RECIEVED]="Total healing received";
    descripArray[EStatKeys.DAMAGE_TAKEN]="Total damage taken";
    descripArray[EStatKeys.SHIELD_LOST]="Total shield lost";
    descripArray[EStatKeys.FF_DAMAGE_DEALT]="Friendly fire damage";
    descripArray[EStatKeys.FLESHPOUNDS_RAGED]="Enraged a fleshpound";
    descripArray[EStatKeys.SCRAKES_RAGED]="Enraged a scrake";
    descripArray[EStatKeys.SCRAKES_STUNNED]="Stunned a scrake";
    descripArray[EStatKeys.SHOT_BY_HUSK]="Shot by husk";
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

}
