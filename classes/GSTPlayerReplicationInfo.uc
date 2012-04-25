class GSTPlayerReplicationInfo extends KFPlayerReplicationInfo;

enum PlayerStat {
    TIME_ALIVE, HEALING_RECIEVED, DAMAGE_TAKEN,
    SHIELD_LOST, FF_DAMAGE_DEALT, CASH_SPENT, 
    FORCED_SUICIDE, BACKSTABS, NUM_DECAPS, 
    FLESHPOUNDS_RAGED, SCRAKES_RAGED, SCRAKES_STUNNED, SHOT_BY_HUSK
};

enum WeaponStat {
    ROUNDS_FIRED, GRENADES_LAUNCHED, ROCKETS_LAUNCHED, 
    BOLTS_FIRED, BOLTS_RETRIEVED, SHELLS_FIRED, UNITS_FUEL, 
    MELEE_SWINGS, FRAGS_TOSSED, PIPES_SET, EXPLOSIVES_DISINTEGRATED
};

enum KillStat {
    BLOAT_KILLS, BOSS_KILLS, CLOT_KILLS,
    CRAWLER_KILLS, FLESHPOUND_KILLS, GOREFAST_KILLS,
    HUSK_KILLS, SCRAKE_KILLS, SIREN_KILLS,
    STALKER_KILLS
};

enum HiddenStat {
    TIME_BERSERKER, TIME_COMMANDO, TIME_DEMO, 
    TIME_FIREBUG, TIME_MEDIC, TIME_SHARP, 
    TIME_SUPPORT, DAMAGE_DEALT
};

var array<float> playerStats[15];
var array<float> kfWeaponStats[15];
var array<float> zedStats[15];
var array<float> hiddenStats[15];
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
        for(i= 0; i < ArrayCount(hiddenStats); i++) {
            hiddenStats[i]= 0;
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

function addToWeaponStat(WeaponStat key, float delta) {
    setPlayerIDHash();
    kfWeaponStats[key]+= delta;
}

function addToKillStat(KillStat key, float delta) {
    setPlayerIDHash();
    zedStats[key]+= delta;
}

function addToHiddenStat(HiddenStat key, float delta) {
    setPlayerIDHash();
    hiddenStats[key]+= delta;
}
