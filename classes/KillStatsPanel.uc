class KillStatsPanel extends StatsPanelBase;

function fillDescription(GSTPlayerReplicationInfo pri) {
    descriptions.Length= pri.KillStat.EnumCount;
    descriptions[pri.KillStat.CRAWLER_KILLS].description="Crawler";
    descriptions[pri.KillStat.STALKER_KILLS].description="Stalker";
    descriptions[pri.KillStat.CLOT_KILLS].description="Clot";
    descriptions[pri.KillStat.GOREFAST_KILLS].description="Gorefast";
    descriptions[pri.KillStat.BLOAT_KILLS].description="Bloat";
    descriptions[pri.KillStat.SIREN_KILLS].description="Siren";
    descriptions[pri.KillStat.HUSK_KILLS].description="Husk";
    descriptions[pri.KillStat.SCRAKE_KILLS].description="Scrake";
    descriptions[pri.KillStat.FLESHPOUND_KILLS].description="Fleshpound";
    descriptions[pri.KillStat.BOSS_KILLS].description="Boss";
    descriptions[pri.KillStat.SELF_KILLS].description="Self";
    descriptions[pri.KillStat.TEAMMATE_KILLS].description="Teammate";
}

function ShowPanel(bool bShow) {
    super.ShowPanel(bShow);

    if ( bShow ) {
        lb_StatSelect.statListObj.InitList(pri.killStats, descriptions);
    }
}
