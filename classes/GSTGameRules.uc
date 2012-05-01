class GSTGameRules extends GameRules
    dependson(GSTPlayerReplicationInfo);

var array<string> zedNames;

function PostBeginPlay() {
    NextGameRules = Level.Game.GameRulesModifiers;
    Level.Game.GameRulesModifiers = Self;
}

function bool PreventDeath(Pawn Killed, Controller Killer, class<DamageType> damageType, vector HitLocation) {
    local GSTGameReplicationInfo.DeathStat deathIndex;

    if (damageType == class'Engine.Fell' || damageType == class'Gameplay.Burned') {
        deathIndex= ENV_DEATH;
        GSTGameReplicationInfo(Level.Game.GameReplicationInfo).deathStats[deathIndex]+= 1;
    }
    return super.PreventDeath(Killed, Killer, damageType, HitLocation);
}

function ScoreKill(Controller Killer, Controller Killed) {
    local int index;
    local GSTPlayerReplicationInfo.KillStat statIndex;
    local GSTGameReplicationInfo.DeathStat deathIndex;
    local GSTPlayerReplicationInfo pri;

    Super.ScoreKill(Killer,Killed);
    
    pri= GSTPlayerReplicationInfo(killer.PlayerReplicationInfo);
    if(PlayerController(Killer) != none && pri != none) {
        if (Killer == Killed) {
            statIndex= SELF_KILLS;
            index= statIndex;
        } else if (Killer.PlayerReplicationInfo.Team == Killed.PlayerReplicationInfo.Team) { 
            statIndex= TEAMMATE_KILLS;
            index= statIndex;
        } else {
            index= class'GSTAuxiliary'.static.binarySearch(GetItemName(string(Killed.pawn)), zedNames);
        }
        if (index > -1) pri.addToKillStat(KillStat(index), 1);
    } else if (AIController(Killer) != none) {
        /** TODO: self deaths is bugged, need to move to first if statement block */
        if (Killer == Killed) {
            deathIndex= SELF_DEATH;
            index= deathIndex;
        } else if (Killer.PlayerReplicationInfo.Team == Killed.PlayerReplicationInfo.Team) {
            deathIndex= FF_DEATH;
            index= deathIndex;
        } else {
            index= class'GSTAuxiliary'.static.binarySearch(GetItemName(string(Killer.pawn)), zedNames);
        }
        if (index > -1) GSTGameReplicationInfo(Level.Game.GameReplicationInfo).deathStats[index]+= 1;
        PlayerController(Killed).ClientMessage("Killed by: "$zedNames[index]);
    }
    PlayerController(Killed).ClientMessage("Killed by: "$Killer);
}

defaultproperties {
    zedNames(0)="ZombieBloat";
    zedNames(1)="ZombieBoss";
    zedNames(2)="ZombieClot";
    zedNames(3)="ZombieCrawler";
    zedNames(4)="ZombieFleshPound";
    zedNames(5)="ZombieGorefast";
    zedNames(6)="ZombieHusk";
    zedNames(7)="ZombieScrake";
    zedNames(8)="ZombieSiren";
    zedNames(9)="ZombieStalker";
}
