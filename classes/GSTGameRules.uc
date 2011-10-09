class GSTGameRules extends GameRules;

function PostBeginPlay() {
    NextGameRules = Level.Game.GameRulesModifiers;
    Level.Game.GameRulesModifiers = Self;
}

function ScoreKill(Controller Killer, Controller Killed) {
    local GSTStats gs;
    local KFPlayerController kfpc;

    Super.ScoreKill(Killer,Killed);
    
    kfpc= KFPlayerController(killer);
    if(kfpc != none) {
        gs= class'GameStatsTabMut'.static.findStats(kfpc.getPlayerIDHash());
        gs.addKill(KFMonster(Killed.pawn));
    }

}
