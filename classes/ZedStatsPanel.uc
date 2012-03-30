class ZedStatsPanel extends GSTMidGameStats;

function ShowPanel(bShow) {
    local GSTPlayerReplicationInfo pri;

    super.ShowPanel(bShow);
    if ( bShow ) {
        pri= GSTPlayerReplicationInfo(PlayerOwner().PlayerReplicationInfo);

        description[pri.ZedStats.CRAWLER_KILLS]="Crawler kills";
        description[pri.ZedStats.STALKER_KILLS]="Stalker kills";
        description[pri.ZedStats.CLOT_KILLS]="Clot kills";
        description[pri.ZedStats.GOREFAST_KILLS]="Gorefast kills";
        description[pri.ZedStats.BLOAT_KILLS]="Bloat kills";
        description[pri.ZedStats.SIREN_KILLS]="Siren kills";
        description[pri.ZedStats.HUSK_KILLS]="Husk kills";
        description[pri.ZedStats.SCRAKE_KILLS]="Scrake kills";
        description[pri.ZedStats.FLESHPOUND_KILLS]="Fleshpound kills";
        description[pri.ZedStats.PATRIARCH_KILLS]="Patriarch kills";
        description[pri.ZedStats.FLESHPOUNDS_RAGED]="Enraged a fleshpound";
        description[pri.ZedStats.SCRAKES_RAGED]="Enraged a scrake";
        description[pri.ZedStats.SCRAKES_STUNNED]="Stunned a scrake";
        description[pri.ZedStats.BACKSTABS]="Backstabs";

        lb_StatSelect.statList.InitList(pri.zedStats, description, pri.StatGroup.ZED);
    }
}
