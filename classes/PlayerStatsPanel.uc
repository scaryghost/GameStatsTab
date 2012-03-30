class PlayerStatsPanel extends StatsPanelBase;

function ShowPanel(bool bShow) {
    local GSTPlayerReplicationInfo pri;

    super.ShowPanel(bShow);
    if ( bShow ) {
        pri= GSTPlayerReplicationInfo(PlayerOwner().PlayerReplicationInfo);

        description[pri.PlayerStat.TIME_ALIVE]="Time alive";
        description[pri.PlayerStat.HEALING_RECIEVED]="Total healing received";
        description[pri.PlayerStat.DAMAGE_TAKEN]="Total damage taken";
        description[pri.PlayerStat.SHIELD_LOST]="Total shield lost";
        description[pri.PlayerStat.FF_DAMAGE_DEALT]="Friendly fire damage";
        description[pri.PlayerStat.SHOT_BY_HUSK]="Shot by husk";

        lb_StatSelect.statList.InitList(pri.playerStats, description);
    }
}
