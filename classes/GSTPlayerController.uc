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
    GRENADES_LAUNCHED,
    ROCKETS_LAUNCHED,
    BOLTS_FIRED,
    SHELLS_FIRED,
    UNITS_FUEL,
    MELEE_SWINGS,
    BACKSTABS,
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

var protected array<float> statArray[30];
var array<string> descripArray[ArrayCount(statArray)];
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
    descripArray[EStatKeys.UNITS_FUEL]="Units of fuel consumed";
    descripArray[EStatKeys.SHELLS_FIRED]="Shells fired";
    descripArray[EStatKeys.GRENADES_LAUNCHED]="Grenades launched";
    descripArray[EStatKeys.ROCKETS_LAUNCHED]="Rockets launched";
    descripArray[EStatKeys.BACKSTABS]="Backstabs";
    descripArray[EStatKeys.BOLTS_FIRED]="Bolts fired";
}

function incrementStat(byte statKey, float value) {
    statArray[statKey]+= value;
}

function float getStatValue(byte statKey) {
    return statArray[statKey];
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
