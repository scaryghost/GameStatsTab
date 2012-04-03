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
        description[pri.PlayerStat.CASH_GIVEN]="Cash given";
        description[pri.PlayerStat.CASH_VANISHED]="Cash vanished";
        description[pri.PlayerStat.TIME_BERSERKER]="Time as berserker";
        description[pri.PlayerStat.TIME_COMMANDO]="Time as commando";
        description[pri.PlayerStat.TIME_DEMO]="Time as demolitions";
        description[pri.PlayerStat.TIME_FIREBUG]="Time as firebug";
        description[pri.PlayerStat.TIME_MEDIC]="Time as medic";
        description[pri.PlayerStat.TIME_SHARP]="Time as sharpshooter";
        description[pri.PlayerStat.TIME_SUPPORT]="Time as support specialist";

        lb_StatSelect.statList.InitList(pri.playerStats, description);
    }
}
