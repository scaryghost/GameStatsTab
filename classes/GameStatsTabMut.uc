class GameStatsTabMut extends Mutator;

struct oldNewZombiePair {
    var string oldClass;
    var string newClass;
};

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

    Spawn(class'GSTGameRules');
    AddToPackageMap("GameStatsTab");
    DeathMatch(Level.Game).LoginMenuClass = 
            string(Class'GSTInvasionLoginMenu');

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

    gameType.FallbackMonsterClass= "GameStatsTab.GSTZombieStalker";
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
    Description="Displays detailed statistics about your current game.  Version 1.0.0"

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
