class GSTPlayerReplicationInfo extends KFPlayerReplicationInfo;

enum StatGroup {
    PLAYER,
    WEAPON,
    ZED
};

enum PlayerStat {
    TIME_ALIVE, HEALING_RECIEVED, DAMAGE_TAKEN,
    SHIELD_LOST, FF_DAMAGE_DEALT, SHOT_BY_HUSK,
    CASH_GIVEN, CASH_VANISHED, FORCED_SUICIDE,
    TIME_BERSERKER, TIME_COMMANDO, TIME_DEMO, 
    TIME_FIREBUG, TIME_MEDIC, TIME_SHARP, 
    TIME_SUPPORT
};

enum WeaponStat {
    ROUNDS_FIRED, GRENADES_LAUNCHED, ROCKETS_LAUNCHED, 
    BOLTS_FIRED, BOLTS_RETRIEVED, SHELLS_FIRED, UNITS_FUEL, 
    MELEE_SWINGS, FRAGS_TOSSED, PIPES_SET, EXPLOSIVES_DISINTEGRATED
};

enum ZedStat {
    CRAWLER_KILLS, STALKER_KILLS,
    CLOT_KILLS, GOREFAST_KILLS, BLOAT_KILLS,
    SIREN_KILLS, HUSK_KILLS, SCRAKE_KILLS,
    FLESHPOUND_KILLS, PATRIARCH_KILLS,  BACKSTABS, 
    NUM_DECAPS,  FLESHPOUNDS_RAGED,
    SCRAKES_RAGED, SCRAKES_STUNNED
};

var protected array<float> playerStats[16];
var protected array<float> kfWeaponStats[16];
var protected array<float> zedStats[16];
var bool idHashSet;
var string playerIDHash;

replication {
    reliable if (bNetDirty && Role == ROLE_Authority)
        playerStats, kfWeaponStats, zedStats;
}

function Reset() {
    local int i;

    super.Reset();
    if (KFGameType(Level.Game) != none) {
        for(i= 0; i < ArrayCount(playerStats); i++) {
            playerStats[i]= 0;
        }
        for(i= 0; i < ArrayCount(kfWeaponStats); i++) {
            kfWeaponStats[i]= 0;
        }
        for(i= 0; i < ArrayCount(zedStats); i++) {
            zedStats[i]= 0;
        }
    }
}

function setPlayerIDHash() {
    if (!idHashSet) {
        playerIDHash= PlayerController(Owner).getPlayerIDHash();
        idHashSet= true;
    }
}

function addToPlayerStat(PlayerStat key, float delta) {
    setPlayerIDHash();
    playerStats[key]+= delta;
}

function addToWeaponStat(PlayerStat key, float delta) {
    setPlayerIDHash();
    kfWeaponStats[key]+= delta;
}

function addToZedStat(PlayerStat key, float delta) {
    setPlayerIDHash();
    zedStats[key]+= delta;
}
