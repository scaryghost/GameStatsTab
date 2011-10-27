class GameStatsTabMut extends Mutator;

struct oldNewZombiePair {
    var string oldClass;
    var string newClass;
};

var array<oldNewZombiePair> replacementArray;
var class<GSTConsoleCommands> ccClassRef;

function PostBeginPlay() {
    local KFGameType gameType;
    local int i,k;
    local oldNewZombiePair replacementValue;

    gameType= KFGameType(Level.Game);
    if (gameType == none) {
        Destroy();
        return;
    }

    Spawn(class'GameStatsTab_ServerPerks.GSTGameRules');
    AddToPackageMap("GameStatsTab_ServerPerks");

    gameType.PlayerControllerClass= class'GameStatsTab_ServerPerks.GSTPlayerController';
    gameType.PlayerControllerClassName= "GameStatsTab_ServerPerks.GSTPlayerController";

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

    gameType.EndGameBossClass= "GameStatsTab_ServerPerks.GSTZombieBoss";
    gameType.FallbackMonsterClass= "GameStatsTab_ServerPerks.GSTZombieStalker";

    ccClassRef= class'GameStatsTab_ServerPerks.GSTConsoleCommands';
    ccClassRef.static.init();


    setTimer(0.1, false);
}

/**
 * Need the timer to overwrite ServerPerk's login menu.
 * ServerPerks is loaded after GameStatsTab since it 
 * alphabetically is after GameStatsTab
 */
function Timer() {
    local UnrealPlayer up;
    local Controller c;
    local string loginMenuClass;

    loginMenuClass= string(class'GameStatsTab_ServerPerks.GSTInvasionLoginMenu');
    DeathMatch(Level.Game).LoginMenuClass= loginMenuClass;

    /**
     * Need this part for local hosts
     */            
    for(c= Level.ControllerList; c != none; c= c.NextController) {
        up= UnrealPlayer(c);
        if (up != none) {
            up.ClientReceiveLoginMenu(loginMenuClass, DeathMatch(Level.Game).bAlwaysShowLoginMenu);
        }
    }
}

function Mutate(string command, PlayerController sender) {
    local array<string> params;
    local string func, mutateClass;

    Split(command, " ", params);
    mutateClass= params[0];
    func= params[1];
    params.Remove(0,2);
    if (mutateClass == "GameStatsTab") {
        switch(func) {
            case ccClassRef.default.commandNameList[1]:
                ccClassRef.static.listInfo(params, Level.ControllerList, sender);
                break;
            case ccClassRef.default.commandNameList[2]:
                ccClassRef.static.getStat(params, Level.ControllerList, sender);
                break;
            case ccClassRef.default.commandNameList[0]:
            default:
                ccClassRef.static.help(sender);
                break;
        }
    } else {
        super.Mutate(command, sender);
    }
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
    FriendlyName="GameStatsTab - ServerPerks"
    Description="Displays detailed statistics about your game.  This version is compatible with ServerPerks.  Version 1.1.0"

    replacementArray(0)=(oldClass="KFChar.ZombieFleshPound",newClass="GameStatsTab_ServerPerks.GSTZombieFleshpound")
    replacementArray(1)=(oldClass="KFChar.ZombieGorefast",newClass="GameStatsTab_ServerPerks.GSTZombieGorefast")
    replacementArray(2)=(oldClass="KFChar.ZombieStalker",newClass="GameStatsTab_ServerPerks.GSTZombieStalker")
    replacementArray(3)=(oldClass="KFChar.ZombieSiren",newClass="GameStatsTab_ServerPerks.GSTZombieSiren")
    replacementArray(4)=(oldClass="KFChar.ZombieScrake",newClass="GameStatsTab_ServerPerks.GSTZombieScrake")
    replacementArray(5)=(oldClass="KFChar.ZombieHusk",newClass="GameStatsTab_ServerPerks.GSTZombieHusk")
    replacementArray(6)=(oldClass="KFChar.ZombieCrawler",newClass="GameStatsTab_ServerPerks.GSTZombieCrawler")
    replacementArray(7)=(oldClass="KFChar.ZombieBloat",newClass="GameStatsTab_ServerPerks.GSTZombieBloat")
    replacementArray(8)=(oldClass="KFChar.ZombieClot",newClass="GameStatsTab_ServerPerks.GSTZombieClot")
}
