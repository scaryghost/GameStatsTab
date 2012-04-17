class PlayerStatsPanel extends StatsPanelBase;

function ShowPanel(bool bShow) {
    local GSTPlayerReplicationInfo pri;

    super.ShowPanel(bShow);
    if ( bShow ) {
        pri= GSTPlayerReplicationInfo(PlayerOwner().PlayerReplicationInfo);
        if (descriptions.Length == 0) {
            descriptions.Length= pri.PlayerStat.EnumCount;
            descriptions[pri.PlayerStat.TIME_ALIVE].description="Time alive";
            descriptions[pri.PlayerStat.TIME_ALIVE].format= lb_StatSelect.statListObj.DescripFormat.TIME;
            descriptions[pri.PlayerStat.HEALING_RECIEVED].description="Total healing received";
            descriptions[pri.PlayerStat.DAMAGE_TAKEN].description="Total damage taken";
            descriptions[pri.PlayerStat.SHIELD_LOST].description="Total shield lost";
            descriptions[pri.PlayerStat.FF_DAMAGE_DEALT].description="Friendly fire damage";
            descriptions[pri.PlayerStat.SHOT_BY_HUSK].description="Shot by husk";
            descriptions[pri.PlayerStat.CASH_GIVEN].description="Cash given";
            descriptions[pri.PlayerStat.CASH_GIVEN].format= lb_StatSelect.statListObj.DescripFormat.DOSH;
            descriptions[pri.PlayerStat.CASH_VANISHED].description="Cash vanished";
            descriptions[pri.PlayerStat.CASH_VANISHED].format= lb_StatSelect.statListObj.DescripFormat.DOSH;
            descriptions[pri.PlayerStat.FORCED_SUICIDE].description="Forced suicides";
            descriptions[pri.PlayerStat.DAMAGE_DEALT].description="Damage dealt";
        }
        lb_StatSelect.statListObj.InitList(pri.playerStats,descriptions);
    }
}
