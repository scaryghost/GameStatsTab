class ZedStatsPanel extends StatsPanelBase;

function ShowPanel(bool bShow) {
    local GSTPlayerReplicationInfo pri;

    super.ShowPanel(bShow);
    if ( bShow ) {
        pri= GSTPlayerReplicationInfo(PlayerOwner().PlayerReplicationInfo);
        if (descriptions.Length == 0) {
            descriptions.Length= pri.ZedStat.EnumCount;
            descriptions[pri.ZedStat.CRAWLER_KILLS].description="Crawler kills";
            descriptions[pri.ZedStat.STALKER_KILLS].description="Stalker kills";
            descriptions[pri.ZedStat.CLOT_KILLS].description="Clot kills";
            descriptions[pri.ZedStat.GOREFAST_KILLS].description="Gorefast kills";
            descriptions[pri.ZedStat.BLOAT_KILLS].description="Bloat kills";
            descriptions[pri.ZedStat.SIREN_KILLS].description="Siren kills";
            descriptions[pri.ZedStat.HUSK_KILLS].description="Husk kills";
            descriptions[pri.ZedStat.SCRAKE_KILLS].description="Scrake kills";
            descriptions[pri.ZedStat.FLESHPOUND_KILLS].description="Fleshpound kills";
            descriptions[pri.ZedStat.BOSS_KILLS].description="Boss kills";
        }
        lb_StatSelect.statListObj.InitList(pri.zedStats, descriptions);
    }
}
