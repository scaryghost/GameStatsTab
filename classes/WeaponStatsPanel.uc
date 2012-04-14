class WeaponStatsPanel extends StatsPanelBase;

function ShowPanel(bool bShow) {
    local GSTPlayerReplicationInfo pri;

    super.ShowPanel(bShow);
    if ( bShow ) {
        pri= GSTPlayerReplicationInfo(PlayerOwner().PlayerReplicationInfo);
         if (descriptions.Length == 0) {
            descriptions.Length= pri.WeaponStat.EnumCount;
            descriptions[pri.WeaponStat.ROUNDS_FIRED].description="Rounds fired";
            descriptions[pri.WeaponStat.MELEE_SWINGS].description="Melee swings";
            descriptions[pri.WeaponStat.FRAGS_TOSSED].description="Frags tossed";
            descriptions[pri.WeaponStat.PIPES_SET].description="Pipes set";
            descriptions[pri.WeaponStat.UNITS_FUEL].description="Units of fuel consumed";
            descriptions[pri.WeaponStat.SHELLS_FIRED].description="Shells fired";
            descriptions[pri.WeaponStat.GRENADES_LAUNCHED].description="Grenades launched";
            descriptions[pri.WeaponStat.ROCKETS_LAUNCHED].description="Rockets launched";
            descriptions[pri.WeaponStat.BOLTS_FIRED].description="Bolts fired";
            descriptions[pri.WeaponStat.BOLTS_RETRIEVED].description="Bolts retrieved";
            descriptions[pri.WeaponStat.EXPLOSIVES_DISINTEGRATED].description="Explosive disintegrated";
        }       
        lb_StatSelect.statListObj.InitList(pri.kfWeaponStats, descriptions);
    }
}
