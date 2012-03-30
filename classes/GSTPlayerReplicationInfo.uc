class GSTPlayerReplicationInfo extends KFPlayerReplicationInfo;

enum StatGroup {
    PLAYER,
    WEAPON,
    ZED
};

enum PlayerStat {
    TIME_ALIVE, HEALING_RECIEVED, DAMAGE_TAKEN,
    SHIELD_LOST, FF_DAMAGE_DEALT, SHOT_BY_HUSK
};

enum WeaponStat {
    ROUNDS_FIRED,
    GRENADES_LAUNCHED, ROCKETS_LAUNCHED, BOLTS_FIRED,
    SHELLS_FIRED, UNITS_FUEL, MELEE_SWINGS,
    FRAGS_TOSSED, PIPES_SET
};

enum ZedStat {
    CRAWLER_KILLS, STALKER_KILLS,
    CLOT_KILLS, GOREFAST_KILLS, BLOAT_KILLS,
    SIREN_KILLS, HUSK_KILLS, SCRAKE_KILLS,
    FLESHPOUND_KILLS, PATRIARCH_KILLS,  BACKSTABS, 
    NUM_DECAPS,  FLESHPOUNDS_RAGED,
    SCRAKES_RAGED, SCRAKES_STUNNED
};

var array<float> playerStats[15];
var array<float> kfWeaponStats[15];
var array<float> zedStats[15];

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
