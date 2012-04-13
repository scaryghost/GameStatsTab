class PlayerStatsPanel extends StatsPanelBase;

function ShowPanel(bool bShow) {
    local GSTPlayerReplicationInfo pri;

    super.ShowPanel(bShow);
    if ( bShow ) {
        pri= GSTPlayerReplicationInfo(PlayerOwner().PlayerReplicationInfo);
        if (description.Length == 0) {
            description[pri.PlayerStat.TIME_ALIVE]="Time alive";
            description[pri.PlayerStat.HEALING_RECIEVED]="Total healing received";
            description[pri.PlayerStat.DAMAGE_TAKEN]="Total damage taken";
            description[pri.PlayerStat.SHIELD_LOST]="Total shield lost";
            description[pri.PlayerStat.FF_DAMAGE_DEALT]="Friendly fire damage";
            description[pri.PlayerStat.SHOT_BY_HUSK]="Shot by husk";
            description[pri.PlayerStat.CASH_GIVEN]="Cash given";
            description[pri.PlayerStat.CASH_VANISHED]="Cash vanished";
            description[pri.PlayerStat.FORCED_SUICIDE]="Forced suicides";
        }
        lb_StatSelect.statListObj.InitList(pri.playerStats,description);
    }
}
