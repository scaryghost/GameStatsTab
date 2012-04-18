class GSTPlayerController extends KFPlayerController;

var string statsPanelClassName;
var bool forcedSuicideAttempt;

function SetPawnClass(string inClass, string inCharacter) {
    super.SetPawnClass(inClass, inCharacter);
    PawnClass = Class'GameStatsTab.GSTHumanPawn';
}

exec function suicide() {
    forcedSuicideAttempt= true;
    super.suicide();
    forcedSuicideAttempt= false;
}

exec function InGameStats() {
    ClientOpenMenu(statsPanelClassName);
}

defaultproperties {
    statsPanelClassName= "GameStatsTab.StatsMenu"
}
