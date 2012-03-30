class GSTPlayerController extends KFPlayerController;

var float prevHealth, prevShield;

function SetPawnClass(string inClass, string inCharacter) {
    PawnClass = Class'GameStatsTab.GSTHumanPawn';
    inCharacter = Class'KFGameType'.Static.GetValidCharacter(inCharacter);
    PawnSetupRecord = class'xUtil'.static.FindPlayerRecord(inCharacter);
    PlayerReplicationInfo.SetCharacterName(inCharacter);
}

function PawnDied(Pawn P) {
    local GSTPlayerReplicationInfo pri;

    super.PawnDied(P);

    pri= GSTPlayerReplicationInfo(PlayerReplicationInfo);
    pri.playerStats[pri.PlayerStat.DAMAGE_TAKEN]+= prevHealth;
    pri.playerStats[pri.PlayerStat.SHIELD_LOST]+= prevShield;
}

exec function InGameStats() {
    ClientOpenMenu("GameSTatsTab.StatsMenu");
}
