class GSTGameReplicationInfo extends KFGameReplicationInfo;

enum DeathStat {
    BLOAT_DEATH, BOSS_DEATH, CLOT_DEATH,
    CRAWLER_DEATH, FLESHPOUND_DEATH, GOREFAST_DEATH,
    HUSK_DEATH, SCRAKE_DEATH, SIREN_DEATH,
    STALKER_DEATH, ENV_DEATH, SELF_DEATH,
    FF_DEATH
};

var array<float> deathStats[15];
var array<GSTPlayerReplicationInfo> players;
var array<GSTPlayerReplicationInfo> spectators;

replication {
    reliable if (bNetDirty && Role == ROLE_Authority)
        deathStats;
}
