class PlayerStatsPanel extends StatsPanelBase;

function ShowPanel(bool bShow) {
    local GSTPlayerReplicationInfo pri;

    super.ShowPanel(bShow);
    if ( bShow ) {
        pri= GSTPlayerReplicationInfo(PlayerOwner().PlayerReplicationInfo);
        lb_StatSelect.statList.InitList(pri.playerStats, 
            class'GameStatsTab.GSTAuxiliary'.default.playerStatsDescrip);
    }
}
