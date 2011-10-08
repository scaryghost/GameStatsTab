class GSTGameRules extends GameRules;

function PostBeginPlay()
{
	NextGameRules = Level.Game.GameRulesModifiers;
	Level.Game.GameRulesModifiers = Self;
}

function ScoreKill(Controller Killer, Controller Killed)
{
    local int index;
    local GSTStats gs;

    Super.ScoreKill(Killer,Killed);
    log("GSTGameType: Killed!");
    index= class'GameStatsTabMut'.static.findPlayer(KFPlayerController(Killer).getPlayerIDHash());
    log("GSTGameType: Index= "$index);
    if (index != -1) {
        class'GameStatsTabMut'.default.playerArray[index].stats.addKill(KFMonster(Killed.Pawn));
    } else {
        gs= new class'GSTStats';
        gs.addKill(KFMonster(Killed.pawn));
        log("GSTGameType: stats= "$gs);
        class'GameStatsTabMut'.default.playerArray.insert(class'GameStatsTabMut'.default.playerArray.Length, 1);
        class'GameStatsTabMut'.default.playerArray[class'GameStatsTabMut'.default.playerArray.Length-1].idHash=
                KFPlayerController(Killer).getPlayerIDHash();
        class'GameStatsTabMut'.default.playerArray[class'GameStatsTabMut'.default.playerArray.Length-1].stats= gs;
    }

}
