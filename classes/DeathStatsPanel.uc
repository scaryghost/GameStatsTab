class DeathStatsPanel extends StatsPanelBase
    dependson(GSTGameReplicationInfo);

function fillDescription(GSTPlayerReplicationInfo pri) {
    descriptions.Length= GSTGameReplicationInfo(PlayerOwner().GameReplicationInfo).DeathStat.EnumCount;
    descriptions[GSTGameReplicationInfo(PlayerOwner().GameReplicationInfo).DeathStat.CRAWLER_DEATH].description="Crawler";
    descriptions[GSTGameReplicationInfo(PlayerOwner().GameReplicationInfo).DeathStat.STALKER_DEATH].description="Stalker";
    descriptions[GSTGameReplicationInfo(PlayerOwner().GameReplicationInfo).DeathStat.CLOT_DEATH].description="Clot";
    descriptions[GSTGameReplicationInfo(PlayerOwner().GameReplicationInfo).DeathStat.GOREFAST_DEATH].description="Gorefast";
    descriptions[GSTGameReplicationInfo(PlayerOwner().GameReplicationInfo).DeathStat.BLOAT_DEATH].description="Bloat";
    descriptions[GSTGameReplicationInfo(PlayerOwner().GameReplicationInfo).DeathStat.SIREN_DEATH].description="Siren";
    descriptions[GSTGameReplicationInfo(PlayerOwner().GameReplicationInfo).DeathStat.HUSK_DEATH].description="Husk";
    descriptions[GSTGameReplicationInfo(PlayerOwner().GameReplicationInfo).DeathStat.SCRAKE_DEATH].description="Scrake";
    descriptions[GSTGameReplicationInfo(PlayerOwner().GameReplicationInfo).DeathStat.FLESHPOUND_DEATH].description="Fleshpound";
    descriptions[GSTGameReplicationInfo(PlayerOwner().GameReplicationInfo).DeathStat.BOSS_DEATH].description="Boss";
    descriptions[GSTGameReplicationInfo(PlayerOwner().GameReplicationInfo).DeathStat.SELF_DEATH].description="Yourself";
    descriptions[GSTGameReplicationInfo(PlayerOwner().GameReplicationInfo).DeathStat.FF_DEATH].description="Friendly fire";
    descriptions[GSTGameReplicationInfo(PlayerOwner().GameReplicationInfo).DeathStat.ENV_DEATH].description="Environment";
}

function ShowPanel(bool bShow) {
    super.ShowPanel(bShow);

    if ( bShow ) {
        lb_StatSelect.statListObj.InitList(GSTGameReplicationInfo(PlayerOwner().GameReplicationInfo).deathStats, descriptions);
    }
}
