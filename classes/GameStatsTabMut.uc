class GameStatsTabMut extends Mutator;

struct PlayerStats {
    var string idHash;
    var GSTStats stats;
};

var array<PlayerStats> playerArray;

function PostBeginPlay() {
    DeathMatch(Level.Game).LoginMenuClass = 
            string(Class'GSTInvasionLoginMenu');
}

function MutatorTakeDamage( out int ActualDamage, Pawn Victim, 
        Pawn InstigatedBy, out Vector HitLocation, out Vector Momentum, 
        name DamageType) {
    local KFHumanPawn KFHP;
    local KFMonster KFM;
    local string hash;
    local PlayerStats tempStats;
    local int index;

    KFHP= KFHumanPawn(InstigatedBy);
    KFM= KFMonster(Victim);
	if (KFHP != none && KFM != none && KFM.Health <= 0) {
        hash= KFHP.KFPC.getPlayerIDHash();
        index= findPlayer(hash);
        if ( index == -1 ) {
            tempStats.idHash= hash;
            tempStats.stats.addKill(KFM);
            default.playerArray.insert(default.playerArray.Length, 1);
            default.playerArray[default.playerArray.Length-1]= tempStats;
        } else {
            default.playerArray[index].stats.addKill(KFM);
        }
        
	}
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
}
