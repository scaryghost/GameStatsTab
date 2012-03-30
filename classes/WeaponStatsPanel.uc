class PlayerStatsPanel extends GSTMidGameStats;

function ShowPanel(bShow) {
    local GSTPlayerReplicationInfo pri;

    super.ShowPanel(bShow);
    if ( bShow ) {
        pri= GSTPlayerReplicationInfo(PlayerOwner().PlayerReplicationInfo);

        description[pri.WeaponStats.ROUNDS_FIRED]="Rounds fired";
        description[pri.WeaponStats.MELEE_SWINGS]="Melee swings";
        description[pri.WeaponStats.FRAGS_TOSSED]="Frags tossed";
        description[pri.WeaponStats.PIPES_SET]="Pipes set";
        description[pri.WeaponStats.NUM_DECAPS]="Decapitations";
        description[pri.WeaponStats.UNITS_FUEL]="Units of fuel consumed";
        description[pri.WeaponStats.SHELLS_FIRED]="Shells fired";
        description[pri.WeaponStats.GRENADES_LAUNCHED]="Grenades launched";
        description[pri.WeaponStats.ROCKETS_LAUNCHED]="Rockets launched";
        description[pri.WeaponStats.BOLTS_FIRED]="Bolts fired";

        lb_StatSelect.statList.InitList(pri.weaponStats, description, pri.StatGroup.WEAPON);
    }
}
