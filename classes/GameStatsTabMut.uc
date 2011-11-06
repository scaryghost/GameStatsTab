class GameStatsTabMut extends Mutator;

struct oldNewZombiePair {
    var string oldClass;
    var string newClass;
};

var() config bool bDispStat;
var() config int dispInterval;
var string statTextColor;
var byte currentStat;
var array<oldNewZombiePair> replacementArray;

function PostBeginPlay() {
    local KFGameType gameType;
    local int i,k;
    local oldNewZombiePair replacementValue;

    gameType= KFGameType(Level.Game);
    if (gameType == none) {
        Destroy();
        return;
    }

    Spawn(class'GameStatsTab.GSTGameRules');
    AddToPackageMap("GameStatsTab");
    DeathMatch(Level.Game).LoginMenuClass = 
            string(Class'GameStatsTab.GSTInvasionLoginMenu');

    gameType.PlayerControllerClass= class'GameStatsTab.GSTPlayerController';
    gameType.PlayerControllerClassName= "GameStatsTab.GSTPlayerController";

    //Replace all instances of the old specimens with the new ones 
    for( i=0; i<gameType.StandardMonsterClasses.Length; i++) {
        for(k=0; k<replacementArray.Length; k++) {
            replacementValue= replacementArray[k];
            //Use ~= for case insensitive compare
            if (gameType.StandardMonsterClasses[i].MClassName ~= replacementValue.oldClass) {
                gameType.StandardMonsterClasses[i].MClassName= replacementValue.newClass;
            }
        }
    }

    //Replace the special squad arrays
    replaceSpecialSquad(gameType.ShortSpecialSquads);
    replaceSpecialSquad(gameType.NormalSpecialSquads);
    replaceSpecialSquad(gameType.LongSpecialSquads);
    replaceSpecialSquad(gameType.FinalSquads);

    gameType.EndGameBossClass= "GameStatsTab.GSTZombieBoss";
    gameType.FallbackMonsterClass= "GameStatsTab.GSTZombieStalker";

    statTextColor= chr(27)$chr(255)$chr(255)$chr(1);

    if (bDispStat) {
        setTimer(dispInterval, true);
    }

}

function Timer() {
    local Controller C;
    local GSTPlayerController gsPC;
    local GSTPlayerReplicationInfo pri;
    local int numPlayers, randIndex, index;
    local string playerName, descrip, value;
   
    //Find out number of players 
    numPlayers= 0;
    for(C= Level.ControllerList; C != none; C= C.NextController) {
        if (GSTPlayerController(C) != none) {
            numPlayers++;
        }
    }
    
    //randomly select a player
    randIndex= Rand(numPlayers);
    index= 0;
    for(C= Level.ControllerList; C != none; C= C.NextController) {
        if (GSTPlayerController(C) != none) {
            if (randIndex == index) {
                gsPC= GSTPlayerController(C);
                pri= GSTPlayerReplicationInfo(gsPC.PlayerReplicationInfo);
                break;
            } else {
                index++;
            }
        }
    }

    for(C= Level.ControllerList; C != none; C= C.NextController) {
        if (GSTPlayerController(C) != none) {
            playerName= pri.PlayerName;
            descrip= pri.descripArray[currentStat];
            if (currentStat == pri.EStatKeys.TIME_ALIVE) {
                value= formatTime(pri.getStatValue(currentStat));
            } else {
                value= string(int(pri.getStatValue(currentStat)));
            }
            GSTPlayerController(C).ClientMessage(statTextColor$playerName$" - "$descrip$": "$value);
        }
    }
    //Get next stat
    do {
        currentStat= (currentStat+1) % ArrayCount(pri.descripArray);

    } until (currentStat != pri.EStatKeys.ROUNDS_FIRED && 
        currentStat != pri.EStatKeys.GRENADES_LAUNCHED && currentStat != pri.EStatKeys.ROCKETS_LAUNCHED &&
        currentStat != pri.EStatKeys.BOLTS_FIRED &&  currentStat != pri.EStatKeys.SHELLS_FIRED && 
        currentStat != pri.EStatKeys.UNITS_FUEL && currentStat != pri.EStatKeys.MELEE_SWINGS);

}

static function FillPlayInfo(PlayInfo PlayInfo) {
    Super.FillPlayInfo(PlayInfo);
    PlayInfo.AddSetting("GameStatsTab", "bDispStat", "Display Stats", 0, 0, "Check");
    PlayInfo.AddSetting("GameStatsTab", "dispInterval", "Display Interval", 0, 0, "Text");
}

static event string GetDescriptionText(string property) {
    switch(property) {
        case "bDispStat":
            return "Display a random stat from a random player";
        case "dispInterval":
            return "Interval (sec) between polls";
        default:
            return Super.GetDescriptionText(property);
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

/**
 *  Replaces the zombies in the given squadArray
 */
function replaceSpecialSquad(out array<KFGameType.SpecialSquad> squadArray) {
    local int i,j,k;
    local oldNewZombiePair replacementValue;
    for(j=0; j<squadArray.Length; j++) {
        for(i=0;i<squadArray[j].ZedClass.Length; i++) {
            for(k=0; k<replacementArray.Length; k++) {
                replacementValue= replacementArray[k];
                if(squadArray[j].ZedClass[i] ~= replacementValue.oldClass) {
                    squadArray[j].ZedClass[i]=  replacementValue.newClass;
                }
            }
        }
    }
}

defaultproperties {
    GroupName="KFGameStatsTab"
    FriendlyName="Game Stats Tab"
    Description="Displays detailed statistics about your game.  Version 1.1.0"

    currentStat= 0

    replacementArray(0)=(oldClass="KFChar.ZombieFleshPound",newClass="GameStatsTab.GSTZombieFleshpound")
    replacementArray(1)=(oldClass="KFChar.ZombieGorefast",newClass="GameStatsTab.GSTZombieGorefast")
    replacementArray(2)=(oldClass="KFChar.ZombieStalker",newClass="GameStatsTab.GSTZombieStalker")
    replacementArray(3)=(oldClass="KFChar.ZombieSiren",newClass="GameStatsTab.GSTZombieSiren")
    replacementArray(4)=(oldClass="KFChar.ZombieScrake",newClass="GameStatsTab.GSTZombieScrake")
    replacementArray(5)=(oldClass="KFChar.ZombieHusk",newClass="GameStatsTab.GSTZombieHusk")
    replacementArray(6)=(oldClass="KFChar.ZombieCrawler",newClass="GameStatsTab.GSTZombieCrawler")
    replacementArray(7)=(oldClass="KFChar.ZombieBloat",newClass="GameStatsTab.GSTZombieBloat")
    replacementArray(8)=(oldClass="KFChar.ZombieClot",newClass="GameStatsTab.GSTZombieClot")
}
