class GSTPlayerController extends KFPlayerController;

function SetPawnClass(string inClass, string inCharacter) {
    PawnClass = Class'GameStatsTab.GSTHumanPawn';
    inCharacter = Class'KFGameType'.Static.GetValidCharacter(inCharacter);
    PawnSetupRecord = class'xUtil'.static.FindPlayerRecord(inCharacter);
    PlayerReplicationInfo.SetCharacterName(inCharacter);
}

exec function suicide() {
    local GSTPlayerReplicationInfo pri;

    super.suicide();
    pri= GSTPlayerReplicationInfo(PlayerReplicationInfo);
    pri.playerStats[pri.PlayerStat.FORCED_SUICIDE]+= 1;
}

exec function InGameStats() {
    ClientOpenMenu("GameStatsTab.StatsMenu");
}
