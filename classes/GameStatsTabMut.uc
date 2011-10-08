class GameStatsTabMut extends Mutator;

function PostBeginPlay() {
    DeathMatch(Level.Game).LoginMenuClass = string(Class'GSTInvasionLoginMenu');
}

defaultproperties {
    GroupName= "KFGameStatsTab"
    FriendlNAme= "Detailed Stats Tab"
    Description= "Displays detailed statistics about your current game"
}
