class WeaponStatsPanel extends StatsPanelBase;

function fillDescription(GSTPlayerReplicationInfo pri) {
    descriptions.Length= pri.WeaponStat.EnumCount;
    descriptions[pri.WeaponStat.PISTOL_ROUNDS_FIRED].description="Pistol rounds fired";
    descriptions[pri.WeaponStat.RIFLE_ROUNDS_FIRED].description="Rifle rounds fired";
    descriptions[pri.WeaponStat.AUTOMATIC_ROUNDS_FIRED].description="Automatic rounds fired";
    descriptions[pri.WeaponStat.MELEE_SWINGS].description="Melee swings";
    descriptions[pri.WeaponStat.FRAGS_TOSSED].description="Frags tossed";
    descriptions[pri.WeaponStat.PIPES_SET].description="Pipes set";
    descriptions[pri.WeaponStat.UNITS_FUEL].description="Fuel consumed";
    descriptions[pri.WeaponStat.SHELLS_FIRED].description="Shells fired";
    descriptions[pri.WeaponStat.GRENADES_LAUNCHED].description="Grenades launched";
    descriptions[pri.WeaponStat.ROCKETS_LAUNCHED].description="Rockets launched";
    descriptions[pri.WeaponStat.BOLTS_FIRED].description="Bolts fired";
    descriptions[pri.WeaponStat.BOLTS_RETRIEVED].description="Bolts retrieved";
    descriptions[pri.WeaponStat.EXPLOSIVES_DISINTEGRATED].description="Explosives disintegrated";
    descriptions[pri.WeaponStat.HEAL_DARTS_FIRED].description="Heal darts fired";
    descriptions[pri.WeaponStat.HEAL_DARTS_LANDED].description="Heal darts landed";
}

function ShowPanel(bool bShow) {
    super.ShowPanel(bShow);

    if ( bShow ) {
        lb_StatSelect.statListObj.InitList(pri.kfWeaponStats, descriptions);
    }
}
