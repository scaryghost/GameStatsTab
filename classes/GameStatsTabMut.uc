class GameStatsTabMut extends Mutator;

struct propertyDescTuple {
    var string property;
    var string longDescription;
    var string shortDescription;
};

struct PlayerStats {
    var string idHash;
    var GSTStats stats;
};

var() config int bgR, bgG, bgB;
var() config int txtR, txtG, txtB;
var() config int alpha;

var array<PlayerStats> playerArray;

function PostBeginPlay() {
    local KFGameType kfgt;

    kfgt= KFGameType(Level.Game);
    if (kfgt == none) {
        Destroy();
        return;
    }

    Spawn(class'GSTGameRules');
    AddToPackageMap();
    DeathMatch(Level.Game).LoginMenuClass = 
            string(Class'GSTInvasionLoginMenu');

    kfgt.PlayerControllerClass= class'GameStatsTab.GSTPlayerController';
    kfgt.PlayerControllerClassName= "GameStatsTab.GSTPlayerController";
}

static function int findIndex(string hash) {
    local int i;
    for (i= 0; i < default.playerArray.Length; i++) {
        if (default.playerArray[i].idHash == hash) {
            return i;
        }
    }
    return -1;
}

static function GSTStats findStats(string hash) {
    local int i;
    local GSTStats gs;

    i= findIndex(hash);
    if (i != -1) {
        return default.playerArray[i].stats;
    }
    gs= new class'GSTStats';
    update(hash, gs);
    return gs;
}

static function update(string hash, GSTStats newStats) {
    local int i;
    i= findIndex(hash);

    if (i == -1) {
        default.playerArray.insert(default.playerArray.Length, 1);
        default.playerArray[default.playerArray.Length-1].idHash= hash;
        default.playerArray[default.playerArray.Length-1].stats= newStats;
    } else {
        default.playerArray[i].stats= newStats;
    }
}

defaultproperties {
    GroupName= "KFGameStatsTab"
    FriendlyName= "Detailed Stats Tab"
    Description= "Displays detailed statistics about your current game"

    LifeSpan=0.1
}
