class GSTPlayerReplicationInfo extends KFPlayerReplicationInfo;

enum PlayerStat {
    TIME_ALIVE, CASH_SPENT, WELDING, 
    HEALS_RECEIVED, SELF_HEALS, TEAMMATES_HEALED,
    DAMAGE_TAKEN, SHIELD_LOST, BACKSTABS, 
    NUM_DECAPS, SHOT_BY_HUSK, HUSKS_STUNNED, 
    SCRAKES_RAGED, SCRAKES_STUNNED, FLESHPOUNDS_RAGED
};

enum WeaponStat {
    PISTOL_ROUNDS_FIRED, RIFLE_ROUNDS_FIRED, AUTOMATIC_ROUNDS_FIRED,
    SHELLS_FIRED, MELEE_SWINGS, BOLTS_FIRED, 
    BOLTS_RETRIEVED, GRENADES_LAUNCHED, ROCKETS_LAUNCHED,
    FRAGS_TOSSED, PIPES_SET, EXPLOSIVES_DISINTEGRATED,
    HEAL_DARTS_LANDED, HEAL_DARTS_FIRED, UNITS_FUEL
};

enum KillStat {
    BLOAT_KILLS, BOSS_KILLS, CLOT_KILLS,
    CRAWLER_KILLS, FLESHPOUND_KILLS, GOREFAST_KILLS,
    HUSK_KILLS, SCRAKE_KILLS, SIREN_KILLS,
    STALKER_KILLS, SELF_KILLS, TEAMMATE_KILLS
};

enum HiddenStat {
    TIME_BERSERKER, TIME_COMMANDO, TIME_DEMO, 
    TIME_FIREBUG, TIME_MEDIC, TIME_SHARP, 
    TIME_SUPPORT, DAMAGE_DEALT, FORCED_SUICIDE,
    TIME_CONNECT
};

var array<float> playerStats[15];
var array<float> kfWeaponStats[15];
var array<float> killStats[15];
var array<float> hiddenStats[15];
var string playerIDHash;

replication {
    reliable if (bNetDirty && Role == ROLE_Authority)
        playerStats, kfWeaponStats, killStats;
}

function Timer() {
    super.Timer();
    playerIDHash= PlayerController(Owner).getPlayerIDHash();
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
        for(i= 0; i < ArrayCount(killStats); i++) {
            killStats[i]= 0;
        }
        for(i= 0; i < ArrayCount(hiddenStats); i++) {
            hiddenStats[i]= 0;
        }
    }
}

function addToPlayerStat(PlayerStat key, float delta) {
    playerStats[key]+= delta;
}

function addToWeaponStat(WeaponStat key, float delta) {
    kfWeaponStats[key]+= delta;
}

function addToKillStat(KillStat key, float delta) {
    killStats[key]+= delta;
}

function addToHiddenStat(HiddenStat key, float delta) {
    hiddenStats[key]+= delta;
}
