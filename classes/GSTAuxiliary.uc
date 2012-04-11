/**
 * Have it extend ReplicationInfo so this class will be compiled
 * before all other classes that need to use it
 */
class GSTAuxiliary extends Object;

var array<string> playerStatsDescrip;
var array<string> weaponStatsDescrip;
var array<string> zedStatsDescrip;
var bool isInit;

struct ReplacementPair {
    var class<Object> oldClass;
    var class<Object> newClass;
};

static function init(GSTPlayerReplicationInfo pri) {

    if (default.isInit) {
        return;
    }

    default.playerStatsDescrip[pri.PlayerStat.TIME_ALIVE]="Time alive";
    default.playerStatsDescrip[pri.PlayerStat.HEALING_RECIEVED]="Total healing received";
    default.playerStatsDescrip[pri.PlayerStat.DAMAGE_TAKEN]="Total damage taken";
    default.playerStatsDescrip[pri.PlayerStat.SHIELD_LOST]="Total shield lost";
    default.playerStatsDescrip[pri.PlayerStat.FF_DAMAGE_DEALT]="Friendly fire damage";
    default.playerStatsDescrip[pri.PlayerStat.SHOT_BY_HUSK]="Shot by husk";
    default.playerStatsDescrip[pri.PlayerStat.CASH_GIVEN]="Cash given";
    default.playerStatsDescrip[pri.PlayerStat.CASH_VANISHED]="Cash vanished";
    default.playerStatsDescrip[pri.PlayerStat.FORCED_SUICIDE]="Forced suicides";
    default.playerStatsDescrip[pri.PlayerStat.TIME_BERSERKER]="Time as berserker";
    default.playerStatsDescrip[pri.PlayerStat.TIME_COMMANDO]="Time as commando";
    default.playerStatsDescrip[pri.PlayerStat.TIME_DEMO]="Time as demolitions";
    default.playerStatsDescrip[pri.PlayerStat.TIME_FIREBUG]="Time as firebug";
    default.playerStatsDescrip[pri.PlayerStat.TIME_MEDIC]="Time as medic";
    default.playerStatsDescrip[pri.PlayerStat.TIME_SHARP]="Time as sharpshooter";
    default.playerStatsDescrip[pri.PlayerStat.TIME_SUPPORT]="Time as support specialist";

    default.weaponStatsDescrip[pri.WeaponStat.ROUNDS_FIRED]="Rounds fired";
    default.weaponStatsDescrip[pri.WeaponStat.MELEE_SWINGS]="Melee swings";
    default.weaponStatsDescrip[pri.WeaponStat.FRAGS_TOSSED]="Frags tossed";
    default.weaponStatsDescrip[pri.WeaponStat.PIPES_SET]="Pipes set";
    default.weaponStatsDescrip[pri.WeaponStat.UNITS_FUEL]="Units of fuel consumed";
    default.weaponStatsDescrip[pri.WeaponStat.SHELLS_FIRED]="Shells fired";
    default.weaponStatsDescrip[pri.WeaponStat.GRENADES_LAUNCHED]="Grenades launched";
    default.weaponStatsDescrip[pri.WeaponStat.ROCKETS_LAUNCHED]="Rockets launched";
    default.weaponStatsDescrip[pri.WeaponStat.BOLTS_FIRED]="Bolts fired";
    default.weaponStatsDescrip[pri.WeaponStat.BOLTS_RETRIEVED]="Bolts retrieved";
    default.weaponStatsDescrip[pri.WeaponStat.EXPLOSIVES_DISINTEGRATED]="Explosive disintegrated";

    default.zedStatsDescrip[pri.ZedStat.CRAWLER_KILLS]="Crawler kills";
    default.zedStatsDescrip[pri.ZedStat.STALKER_KILLS]="Stalker kills";
    default.zedStatsDescrip[pri.ZedStat.CLOT_KILLS]="Clot kills";
    default.zedStatsDescrip[pri.ZedStat.GOREFAST_KILLS]="Gorefast kills";
    default.zedStatsDescrip[pri.ZedStat.BLOAT_KILLS]="Bloat kills";
    default.zedStatsDescrip[pri.ZedStat.SIREN_KILLS]="Siren kills";
    default.zedStatsDescrip[pri.ZedStat.HUSK_KILLS]="Husk kills";
    default.zedStatsDescrip[pri.ZedStat.SCRAKE_KILLS]="Scrake kills";
    default.zedStatsDescrip[pri.ZedStat.FLESHPOUND_KILLS]="Fleshpound kills";
    default.zedStatsDescrip[pri.ZedStat.PATRIARCH_KILLS]="Patriarch kills";
    default.zedStatsDescrip[pri.ZedStat.FLESHPOUNDS_RAGED]="Enraged a fleshpound";
    default.zedStatsDescrip[pri.ZedStat.SCRAKES_RAGED]="Enraged a scrake";
    default.zedStatsDescrip[pri.ZedStat.SCRAKES_STUNNED]="Stunned a scrake";
    default.zedStatsDescrip[pri.ZedStat.BACKSTABS]="Backstabs";
    default.zedStatsDescrip[pri.ZedStat.NUM_DECAPS]="Decapitations";

    default.isInit= true;
}

static function int replaceClass(string className, array<ReplacementPair> replacementArray) {
    local int i, replaceIndex;

    replaceIndex= -1;
    for(i=0; replaceIndex == -1 && i < replacementArray.length; i++) {
        if (className ~= String(replacementArray[i].oldClass)) {
            replaceIndex = i;
        }
    }
    
    return replaceIndex;
}

/**
 *  Replaces the zombies in the given squadArray
 */
static function replaceSpecialSquad(out array<KFGameType.SpecialSquad> squadArray, 
        array<ReplacementPair> replacementArray) {
    local int i,j,k;
    local ReplacementPair pair;
    for(j=0; j<squadArray.Length; j++) {
        for(i=0;i<squadArray[j].ZedClass.Length; i++) {
            for(k=0; k<replacementArray.Length; k++) {
                pair= replacementArray[k];
                if(squadArray[j].ZedClass[i] ~= string(pair.oldClass)) {
                    squadArray[j].ZedClass[i]=  string(pair.newClass);
                }
            }
        }
    }
}

static function replaceStandardMonsterClasses(out array<KFGameType.MClassTypes> monsterClasses, 
        array<ReplacementPair> replacementArray) {
    local int i, k;
    local ReplacementPair pair;

    for( i=0; i<monsterClasses.Length; i++) {
        for(k=0; k<replacementArray.Length; k++) {
            pair= replacementArray[k];
            //Use ~= for case insensitive compare
            if (monsterClasses[i].MClassName ~= string(pair.oldClass)) {
                monsterClasses[i].MClassName= string(pair.newClass);
            }
        }
    }

}

static function string formatTime(int seconds) {
    local string timeStr;
    local int i;
    local array<int> timeValues;
    
    timeValues.Length= 3;
    timeValues[0]= seconds / 3600;
    timeValues[1]= seconds / 60;
    timeValues[2]= seconds % 60;
    for(i= 0; i < timeValues.Length; i++) {
        if (timeValues[i] < 10) {
            timeStr= timeStr$"0"$timeValues[i];
        } else {
            timeStr= timeStr$timeValues[i];
        }
        if (i < timeValues.Length-1) {
            timeStr= timeStr$":";
        }
    }

    return timeStr;
}
