class KillStatsPanel extends StatsPanelBase;

function ShowPanel(bool bShow) {
    local GSTPlayerReplicationInfo pri;

    super.ShowPanel(bShow);
    if ( bShow ) {
        pri= GSTPlayerReplicationInfo(PlayerOwner().PlayerReplicationInfo);
        if (descriptions.Length == 0) {
            descriptions.Length= pri.KillStat.EnumCount;
            descriptions[pri.KillStat.CRAWLER_KILLS].description="Crawler kills";
            descriptions[pri.KillStat.STALKER_KILLS].description="Stalker kills";
            descriptions[pri.KillStat.CLOT_KILLS].description="Clot kills";
            descriptions[pri.KillStat.GOREFAST_KILLS].description="Gorefast kills";
            descriptions[pri.KillStat.BLOAT_KILLS].description="Bloat kills";
            descriptions[pri.KillStat.SIREN_KILLS].description="Siren kills";
            descriptions[pri.KillStat.HUSK_KILLS].description="Husk kills";
            descriptions[pri.KillStat.SCRAKE_KILLS].description="Scrake kills";
            descriptions[pri.KillStat.FLESHPOUND_KILLS].description="Fleshpound kills";
            descriptions[pri.KillStat.BOSS_KILLS].description="Boss kills";
        }
        lb_StatSelect.statListObj.InitList(pri.zedStats, descriptions);
    }
}
