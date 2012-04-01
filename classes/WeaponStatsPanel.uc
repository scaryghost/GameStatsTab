class WeaponStatsPanel extends StatsPanelBase;

function ShowPanel(bool bShow) {
    local GSTPlayerReplicationInfo pri;

    super.ShowPanel(bShow);
    if ( bShow ) {
        pri= GSTPlayerReplicationInfo(PlayerOwner().PlayerReplicationInfo);

        description[pri.WeaponStat.ROUNDS_FIRED]="Rounds fired";
        description[pri.WeaponStat.MELEE_SWINGS]="Melee swings";
        description[pri.WeaponStat.FRAGS_TOSSED]="Frags tossed";
        description[pri.WeaponStat.PIPES_SET]="Pipes set";
        description[pri.WeaponStat.UNITS_FUEL]="Units of fuel consumed";
        description[pri.WeaponStat.SHELLS_FIRED]="Shells fired";
        description[pri.WeaponStat.GRENADES_LAUNCHED]="Grenades launched";
        description[pri.WeaponStat.ROCKETS_LAUNCHED]="Rockets launched";
        description[pri.WeaponStat.BOLTS_FIRED]="Bolts fired";
        description[pri.WeaponStat.BOLTS_RETRIEVED]="Bolts retrieved";

        lb_StatSelect.statList.InitList(pri.kfWeaponStats, description);
    }
}
