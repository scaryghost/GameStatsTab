class PlayerStatsPanel extends GSTMidGameStats;

function ShowPanel(bShow) {
    local GSTPlayerReplicationInfo pri;

    super.ShowPanel(bShow);
    if ( bShow ) {
        pri= GSTPlayerReplicationInfo(PlayerOwner().PlayerReplicationInfo);

        description[pri.PlayerStats.TIME_ALIVE]="Time alive";
        description[pri.PlayerStats.HEALING_RECIEVED]="Total healing received";
        description[pri.PlayerStats.DAMAGE_TAKEN]="Total damage taken";
        description[pri.PlayerStats.SHIELD_LOST]="Total shield lost";
        description[pri.PlayerStats.FF_DAMAGE_DEALT]="Friendly fire damage";
        description[pri.PlayerStats.SHOT_BY_HUSK]="Shot by husk";

        lb_StatSelect.statList.InitList(pri.playerStats, description, pri.StatGroup.PLAYER);
    }
}
