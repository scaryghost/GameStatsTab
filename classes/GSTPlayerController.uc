class GSTPlayerController extends KFPlayerController;

var bool forcedSuicideAttempt;

function SetPawnClass(string inClass, string inCharacter) {
    PawnClass = Class'GameStatsTab.GSTHumanPawn';
    inCharacter = Class'KFGameType'.Static.GetValidCharacter(inCharacter);
    PawnSetupRecord = class'xUtil'.static.FindPlayerRecord(inCharacter);
    PlayerReplicationInfo.SetCharacterName(inCharacter);
}

exec function suicide() {
    /** TODO: Don't count forced suicide unless it actually worked */
    forcedSuicideAttempt= true;
    super.suicide();
    forcedSuicideAttempt= false;
}

exec function InGameStats() {
    ClientOpenMenu("GameStatsTab.StatsMenu");
}
