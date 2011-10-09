class GSTPlayerController extends KFPlayerController;

function SetPawnClass(string inClass, string inCharacter) {
    PawnClass = Class'GameStatsTab.GSTHumanPawn';
    inCharacter = Class'KFGameType'.Static.GetValidCharacter(inCharacter);
    PawnSetupRecord = class'xUtil'.static.FindPlayerRecord(inCharacter);
    PlayerReplicationInfo.SetCharacterName(inCharacter);
}

exec function Fire(optional float F)
{
    local GSTStats gs;

    super.Fire(F);

    gs= class'GameSTatsTabMut'.static.findStats(getPlayerIDHash());
    gs.statArray[gs.EStatKeys.ROUNDS_FIRED].statValue++;
}

