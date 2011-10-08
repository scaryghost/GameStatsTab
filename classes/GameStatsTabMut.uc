class GameStatsTabMut extends Mutator;

struct PlayerStats {
    string idHash;
    GSTStats stats;
};

var array<PlayerStats> playerArray;

function PostBeginPlay() {
    DeathMatch(Level.Game).LoginMenuClass = 
            string(Class'GSTInvasionLoginMenu');
}

function MutatorTakeDamage( out int ActualDamage, Pawn Victim, 
        Pawn InstigatedBy, out Vector HitLocation, out Vector Momentum, 
        name DamageType) {
    local KFHumanPawn KFHP(InstigatedBy);
    local string hash;
    local PlayerStats tempStats;
    local int index;

	if (KFHP != none && KFMonster(Victim) != none &&
            KFMonster(Victime).Health <= 0) {
        hash= KFHP.KFPC.getPlayerIDHash();
        index= findPlayer(hash);
        if ( index == -1 ) {
            tempStats.idHash= hash;
            tempStats.stats.addKill(Victim);
            playerArray.insert(playerArray.Length, tempStats);
        } else {
            playerArray[index].stats.addKill(Victim);
        }
        
	}
	if ( NextDamageMutator != None )
		NextDamageMutator.MutatorTakeDamage( ActualDamage, Victim, InstigatedBy, 
                HitLocation, Momentum, DamageType );
}

static int function findPlayer(string hash) {
    local int i;
    for (i= 0; i < playerArray.Length; i++) {
        if (playerArray[i].idHash == hash) {
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
