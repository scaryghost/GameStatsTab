class GSTGameRules extends GameRules;

function PostBeginPlay() {
    NextGameRules = Level.Game.GameRulesModifiers;
    Level.Game.GameRulesModifiers = Self;
}

function ScoreKill(Controller Killer, Controller Killed) {
    local GSTPlayerController gameStatsTabPC;

    Super.ScoreKill(Killer,Killed);
    
    gameStatsTabPC= GSTPlayerController(killer);
    if(gameStatsTabPC != none) {
        gameStatsTabPC.addKillCount(KFMonster(Killed.pawn));
    }

}
