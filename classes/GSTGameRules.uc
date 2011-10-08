class GSTGameRules extends GameRules;

function PostBeginPlay()
{
	NextGameRules = Level.Game.GameRulesModifiers;
	Level.Game.GameRulesModifiers = Self;
}

function ScoreKill(Controller Killer, Controller Killed)
{
    local GSTStats gs;

    Super.ScoreKill(Killer,Killed);
    
    gs= class'GameStatsTabMut'.static.findStats(KFPlayerController(killer).getPlayerIDHash());
    gs.addKill(KFMonster(Killed.pawn));
    class'GameStatsTabMut'.static.update(KFPlayerController(killer).getPlayerIDHash(), gs);

}
