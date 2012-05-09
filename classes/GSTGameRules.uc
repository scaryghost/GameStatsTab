class GSTGameRules extends GameRules
    dependson(GSTPlayerReplicationInfo);

var array<string> zedNames;

function PostBeginPlay() {
    NextGameRules = Level.Game.GameRulesModifiers;
    Level.Game.GameRulesModifiers = Self;
}

function bool PreventDeath(Pawn Killed, Controller Killer, class<DamageType> damageType, vector HitLocation) {
    local GSTGameReplicationInfo.DeathStat deathIndex;

    if (!super.PreventDeath(Killed, Killer, damageType, HitLocation)) {
        if(damageType == class'Engine.Fell' || damageType == class'Gameplay.Burned') {
            deathIndex= ENV_DEATH;
            GSTGameReplicationInfo(Level.Game.GameReplicationInfo).deathStats[deathIndex]+= 1;
        }
        return false;
    }
    return true;
}

function ScoreKill(Controller Killer, Controller Killed) {
    local int index;
    local GSTPlayerReplicationInfo.KillStat statIndex;
    local GSTGameReplicationInfo.DeathStat deathIndex;
    local GSTPlayerReplicationInfo pri;

    Super.ScoreKill(Killer,Killed);
    
    if (KFMonsterController(Killer) != none && PlayerController(Killed) != none) {
        index= class'GSTAuxiliary'.static.binarySearch(GetItemName(string(Killer.pawn)), zedNames);
        if (index > -1) GSTGameReplicationInfo(Level.Game.GameReplicationInfo).deathStats[index]+= 1;
    } else if (PlayerController(Killer) != none) {
        pri= GSTPlayerReplicationInfo(Killer.PlayerReplicationInfo);
        if (Killed.PlayerReplicationInfo == none || 
            Killer.PlayerReplicationInfo.Team != Killed.PlayerReplicationInfo.Team) {
            index= class'GSTAuxiliary'.static.binarySearch(GetItemName(string(Killed.pawn)), zedNames);
        } else if (Killer == Killed) {
            deathIndex= SELF_DEATH;
            index= deathIndex;
            GSTGameReplicationInfo(Level.Game.GameReplicationInfo).deathStats[index]+= 1;
            statIndex= SELF_KILLS;
            index= statIndex;
        } else if (Killer.PlayerReplicationInfo.Team == Killed.PlayerReplicationInfo.Team) { 
            deathIndex= FF_DEATH;
            index= deathIndex;
            GSTGameReplicationInfo(Level.Game.GameReplicationInfo).deathStats[index]+= 1;
            statIndex= TEAMMATE_KILLS;
            index= statIndex;
        } else {
            index= -1;
        }
        if (index > -1 && pri != none) pri.addToKillStat(KillStat(index), 1);
    }
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
