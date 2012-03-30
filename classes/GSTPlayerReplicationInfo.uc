class GSTPlayerReplicationInfo extends KFPlayerReplicationInfo;

enum PlayerStats {
    TIME_ALIVE, HEALING_RECIEVED, DAMAGE_TAKEN,
    SHIELD_LOST, FF_DAMAGE_DEALT, SHOT_BY_HUSK
};

enum WeaponStats {
    ROUNDS_FIRED,
    GRENADES_LAUNCHED, ROCKETS_LAUNCHED, BOLTS_FIRED,
    SHELLS_FIRED, UNITS_FUEL, MELEE_SWINGS,
    FRAGS_TOSSED, PIPES_SET
};

enum ZedStats {
    CRAWLER_KILLS, STALKER_KILLS,
    CLOT_KILLS, GOREFAST_KILLS, BLOAT_KILLS,
    SIREN_KILLS, HUSK_KILLS, SCRAKE_KILLS,
    FLESHPOUND_KILLS, PATRIARCH_KILLS,  BACKSTABS, 
    NUM_DECAPS,  FLESHPOUNDS_RAGED,
    SCRAKES_RAGED, SCRAKES_STUNNED
};

var protected array<float> playerStats[6];
var protected array<float> weaponStats[9];
var protected array<float> zedStats[15];

replication {
    reliable if (bNetDirty && Role == ROLE_Authority)
        playerStats, weaponStats, zedStats;
}

function Reset() {
    local int i;

    super.Reset();
    if (KFGameType(Level.Game) != none) {
        for(i= 0; i < ArrayCount(playerStats); i++) {
            playerStats[i]= 0;
        }
        for(i= 0; i < ArrayCount(weaponStats); i++) {
            weaponStats[i]= 0;
        }
        for(i= 0; i < ArrayCount(zedStats); i++) {
            zedStats[i]= 0;
        }
    }
}
