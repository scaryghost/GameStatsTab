class GameStatsTabMut extends Mutator;

var() config bool bDispStat;
var() config int dispInterval;
var string statTextColor;
var byte currentStat;
var class<GSTAuxiliary> auxRef;
var array<GSTAuxiliary.ReplacementPair> monsterReplacement, fireModeReplacement;

function PostBeginPlay() {
    local KFGameType gameType;

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

    auxRef= class'GameStatsTab.GSTAuxiliary';
    //Replace all instances of the old specimens with the new ones 
    auxRef.static.replaceStandardMonsterClasses(gameType.StandardMonsterClasses, 
            monsterReplacement);

    //Replace the special squad arrays
    auxRef.static.replaceSpecialSquad(gameType.ShortSpecialSquads, monsterReplacement);
    auxRef.static.replaceSpecialSquad(gameType.NormalSpecialSquads, monsterReplacement);
    auxRef.static.replaceSpecialSquad(gameType.LongSpecialSquads, monsterReplacement);
    auxRef.static.replaceSpecialSquad(gameType.FinalSquads, monsterReplacement);

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

    if (pri != none) {
        //Retrieve and display stat
        for(C= Level.ControllerList; C != none; C= C.NextController) {
            if (GSTPlayerController(C) != none) {
                playerName= pri.PlayerName;
                descrip= pri.descripArray[currentStat];
                if (currentStat == pri.EStatKeys.TIME_ALIVE) {
                    value= auxRef.static.formatTime(pri.getStatValue(currentStat));
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

}

function bool CheckReplacement(Actor Other, out byte bSuperRelevant) {
    local int index;

    if (KFWeapon(Other) != none) {
        index= auxRef.static.replaceClass(string(KFWeapon(Other).FireModeClass[0]),fireModeReplacement);
        if (index != -1) {
            KFWeapon(Other).FireModeClass[0]= class<WeaponFire>(fireModeReplacement[index].newClass);
            return true;
        }
    }

    return super.CheckReplacement(Other, bSuperRelevant);
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

defaultproperties {
    GroupName="KFGameStatsTab"
    FriendlyName="Game Stats Tab"
    Description="Displays detailed statistics about your game.  Version 1.1.0"

    currentStat= 0

    monsterReplacement(0)=(oldClass=class'KFChar.ZombieFleshPound',newClass=class'GameStatsTab.GSTZombieFleshpound')
    monsterReplacement(1)=(oldClass=class'KFChar.ZombieGorefast',newClass=class'GameStatsTab.GSTZombieGorefast')
    monsterReplacement(2)=(oldClass=class'KFChar.ZombieStalker',newClass=class'GameStatsTab.GSTZombieStalker')
    monsterReplacement(3)=(oldClass=class'KFChar.ZombieSiren',newClass=class'GameStatsTab.GSTZombieSiren')
    monsterReplacement(4)=(oldClass=class'KFChar.ZombieScrake',newClass=class'GameStatsTab.GSTZombieScrake')
    monsterReplacement(5)=(oldClass=class'KFChar.ZombieHusk',newClass=class'GameStatsTab.GSTZombieHusk')
    monsterReplacement(6)=(oldClass=class'KFChar.ZombieCrawler',newClass=class'GameStatsTab.GSTZombieCrawler')
    monsterReplacement(7)=(oldClass=class'KFChar.ZombieBloat',newClass=class'GameStatsTab.GSTZombieBloat')
    monsterReplacement(8)=(oldClass=class'KFChar.ZombieClot',newClass=class'GameStatsTab.GSTZombieClot')
    
    fireModeReplacement(0)=(oldClass=class'KFMod.M32Fire',newClass=class'GameStatsTab.GSTM32Fire')
    fireModeReplacement(1)=(oldClass=class'KFMod.LAWFire',newClass=class'GameStatsTab.GSTLAWFire')
    fireModeReplacement(2)=(oldClass=class'KFMod.CrossbowFire',newClass=class'GameStatsTab.GSTCrossbowFire')
}
