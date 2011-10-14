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

    Spawn(class'GameStatsTab_ServerPerks.GSTGameRules');
    AddToPackageMap("GameStatsTab_ServerPerks");
    DeathMatch(Level.Game).LoginMenuClass = 
            string(Class'GameStatsTab_ServerPerks.GSTInvasionLoginMenu');

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

    gameType.FallbackMonsterClass= "GameStatsTab_ServerPerks.GSTZombieStalker";
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
    GroupName="KFSRGameStats"
    FriendlyName="ServerPerks.GameStatsTab"
    Description="Displays detailed statistics about your game.  This version is compatible with ServerPerks.  Version 1.0.0"

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
