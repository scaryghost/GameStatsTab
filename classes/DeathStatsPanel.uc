class DeathStatsPanel extends StatsPanelBase
    dependson(GSTGameReplicationInfo);

function fillDescription(GSTPlayerReplicationInfo pri) {
    descriptions.Length= GSTGameReplicationInfo(PlayerOwner().GameReplicationInfo).DeathStat.EnumCount;
    descriptions[GSTGameReplicationInfo(PlayerOwner().GameReplicationInfo).DeathStat.CRAWLER_DEATH].description="Killed by crawler";
    descriptions[GSTGameReplicationInfo(PlayerOwner().GameReplicationInfo).DeathStat.STALKER_DEATH].description="Killed by stalker";
    descriptions[GSTGameReplicationInfo(PlayerOwner().GameReplicationInfo).DeathStat.CLOT_DEATH].description="Killed by clot";
    descriptions[GSTGameReplicationInfo(PlayerOwner().GameReplicationInfo).DeathStat.GOREFAST_DEATH].description="Killed by gorefast";
    descriptions[GSTGameReplicationInfo(PlayerOwner().GameReplicationInfo).DeathStat.BLOAT_DEATH].description="Killed by bloat";
    descriptions[GSTGameReplicationInfo(PlayerOwner().GameReplicationInfo).DeathStat.SIREN_DEATH].description="Killed by siren";
    descriptions[GSTGameReplicationInfo(PlayerOwner().GameReplicationInfo).DeathStat.HUSK_DEATH].description="Killed by husk";
    descriptions[GSTGameReplicationInfo(PlayerOwner().GameReplicationInfo).DeathStat.SCRAKE_DEATH].description="Killed by scrake";
    descriptions[GSTGameReplicationInfo(PlayerOwner().GameReplicationInfo).DeathStat.FLESHPOUND_DEATH].description="Killed by Fleshpound";
    descriptions[GSTGameReplicationInfo(PlayerOwner().GameReplicationInfo).DeathStat.BOSS_DEATH].description="Killed by boss";
    descriptions[GSTGameReplicationInfo(PlayerOwner().GameReplicationInfo).DeathStat.SELF_DEATH].description="Killed by yourself";
    descriptions[GSTGameReplicationInfo(PlayerOwner().GameReplicationInfo).DeathStat.FF_DEATH].description="Killed by teammate";
    descriptions[GSTGameReplicationInfo(PlayerOwner().GameReplicationInfo).DeathStat.ENV_DEATH].description="Killed by environment";
}

function ShowPanel(bool bShow) {
    super.ShowPanel(bShow);

    if ( bShow ) {
        lb_StatSelect.statListObj.InitList(GSTGameReplicationInfo(PlayerOwner().GameReplicationInfo).deathStats, descriptions);
    }
}
