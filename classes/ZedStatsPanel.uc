class ZedStatsPanel extends GSTMidGameStats;

function ShowPanel(bShow) {
    local GSTPlayerReplicationInfo pri;

    super.ShowPanel(bShow);
    if ( bShow ) {
        pri= GSTPlayerReplicationInfo(PlayerOwner().PlayerReplicationInfo);

        description[pri.ZedStat.CRAWLER_KILLS]="Crawler kills";
        description[pri.ZedStat.STALKER_KILLS]="Stalker kills";
        description[pri.ZedStat.CLOT_KILLS]="Clot kills";
        description[pri.ZedStat.GOREFAST_KILLS]="Gorefast kills";
        description[pri.ZedStat.BLOAT_KILLS]="Bloat kills";
        description[pri.ZedStat.SIREN_KILLS]="Siren kills";
        description[pri.ZedStat.HUSK_KILLS]="Husk kills";
        description[pri.ZedStat.SCRAKE_KILLS]="Scrake kills";
        description[pri.ZedStat.FLESHPOUND_KILLS]="Fleshpound kills";
        description[pri.ZedStat.PATRIARCH_KILLS]="Patriarch kills";
        description[pri.ZedStat.FLESHPOUNDS_RAGED]="Enraged a fleshpound";
        description[pri.ZedStat.SCRAKES_RAGED]="Enraged a scrake";
        description[pri.ZedStat.SCRAKES_STUNNED]="Stunned a scrake";
        description[pri.ZedStat.BACKSTABS]="Backstabs";

        lb_StatSelect.statList.InitList(pri.zedStats, description);
    }
}
