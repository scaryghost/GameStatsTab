class GameStatsTabMut extends Mutator;

struct PlayerStats {
    var string idHash;
    var GSTStats stats;
};

var array<PlayerStats> playerArray;

function PostBeginPlay() {
    Spawn(class'GSTGameRules');
    AddToPackageMap();
    DeathMatch(Level.Game).LoginMenuClass = 
            string(Class'GSTInvasionLoginMenu');
}

static function int findPlayer(string hash) {
    local int i;
    for (i= 0; i < default.playerArray.Length; i++) {
        if (default.playerArray[i].idHash == hash) {
            return i;
        }
    }

    return -1;
}

defaultproperties {
    GroupName= "KFGameStatsTab"
    FriendlyName= "Detailed Stats Tab"
    Description= "Displays detailed statistics about your current game"
    LifeSpan=0.1
}
