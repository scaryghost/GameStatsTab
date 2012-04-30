class PlayerStatsPanel extends StatsPanelBase;

function fillDescription(GSTPlayerReplicationInfo pri) {
    descriptions.Length= pri.PlayerStat.EnumCount;
    descriptions[pri.PlayerStat.TIME_ALIVE].description="Time alive";
    descriptions[pri.PlayerStat.TIME_ALIVE].format= lb_StatSelect.statListObj.DescripFormat.TIME;
    descriptions[pri.PlayerStat.DAMAGE_TAKEN].description="Damage taken";
    descriptions[pri.PlayerStat.SHIELD_LOST].description="Armor lost";
    descriptions[pri.PlayerStat.SHOT_BY_HUSK].description="Shot by husk";
    descriptions[pri.PlayerStat.CASH_SPENT].description="Cash spent";
    descriptions[pri.PlayerStat.CASH_SPENT].format= lb_StatSelect.statListObj.DescripFormat.DOSH;
    descriptions[pri.PlayerStat.FLESHPOUNDS_RAGED].description="Fleshpounds enraged";
    descriptions[pri.PlayerStat.SCRAKES_RAGED].description="Scrakes enraged";
    descriptions[pri.PlayerStat.SCRAKES_STUNNED].description="Scrakes stunned";
    descriptions[pri.PlayerStat.BACKSTABS].description="Backstabs";
    descriptions[pri.PlayerStat.NUM_DECAPS].description="Decapitations";
    descriptions[pri.PlayerStat.HUSKS_STUNNED].description="Husks stunned";
    descriptions[pri.PlayerStat.WELDING].description="Welding";
    descriptions[pri.PlayerStat.SELF_HEALS].description="Self heals";
    descriptions[pri.PlayerStat.TEAMMATES_HEALED].description="Teammates healed";
    descriptions[pri.PlayerStat.HEALS_RECEIVED].description="Heals received";
}

function ShowPanel(bool bShow) {
    super.ShowPanel(bShow);

    if ( bShow ) {
        lb_StatSelect.statListObj.InitList(pri.playerStats,descriptions);
    }
}
