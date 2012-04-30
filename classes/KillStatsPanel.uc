class KillStatsPanel extends StatsPanelBase;

function fillDescription(GSTPlayerReplicationInfo pri) {
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
    descriptions[pri.KillStat.SELF_KILLS].description="Self kills";
    descriptions[pri.KillStat.TEAMMATE_KILLS].description="Teammate kills";
}

function ShowPanel(bool bShow) {
    super.ShowPanel(bShow);

    if ( bShow ) {
        lb_StatSelect.statListObj.InitList(pri.zedStats, descriptions);
    }
}
