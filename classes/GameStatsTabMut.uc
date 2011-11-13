class GameStatsTabMut extends Mutator;

var() config bool bDispStat;
var() config int dispInterval;
var string statTextColor;
var byte currentStat;
var class<GSTAuxiliary> auxRef;
var array<GSTAuxiliary.ReplacementPair> monsterReplacement, fireModeReplacement;

function PostBeginPlay() {
    local KFGameType gameType;

    gameType= KFGameType(Level.Game);
    if (gameType == none) {
        Destroy();
        return;
    }

    Spawn(class'GameStatsTab.GSTGameRules');
    AddToPackageMap("GameStatsTab");
    DeathMatch(Level.Game).LoginMenuClass = 
            string(Class'GameStatsTab.GSTInvasionLoginMenu');

    gameType.PlayerControllerClass= class'GameStatsTab.GSTPlayerController';
    gameType.PlayerControllerClassName= "GameStatsTab.GSTPlayerController";

    auxRef= class'GameStatsTab.GSTAuxiliary';
    //Replace all instances of the old specimens with the new ones 
    auxRef.static.replaceStandardMonsterClasses(gameType.StandardMonsterClasses, 
            monsterReplacement);

    //Replace the special squad arrays
    auxRef.static.replaceSpecialSquad(gameType.ShortSpecialSquads, monsterReplacement);
    auxRef.static.replaceSpecialSquad(gameType.NormalSpecialSquads, monsterReplacement);
    auxRef.static.replaceSpecialSquad(gameType.LongSpecialSquads, monsterReplacement);
    auxRef.static.replaceSpecialSquad(gameType.FinalSquads, monsterReplacement);

    gameType.EndGameBossClass= "GameStatsTab.GSTZombieBoss";
    gameType.FallbackMonsterClass= "GameStatsTab.GSTZombieStalker";

    statTextColor= chr(27)$chr(255)$chr(255)$chr(1);

    if (bDispStat) {
        setTimer(dispInterval, true);
    }

}

function Timer() {
    local array<GSTPlayerController> players;
    local Controller C;
    local GSTPlayerReplicationInfo pri;
    local string msg;
    local int i;
   
    //Find out number of players 
    for(C= Level.ControllerList; C != none; C= C.NextController) {
        if (GSTPlayerController(C) != none) {
            players[players.Length]= GSTPlayerController(C);
        }
    }
    
    if (players.Length > 0) {
        //randomly select a player
        pri= GSTPlayerReplicationInfo(players[Rand(players.Length)].PlayerReplicationInfo);

        //Retrieve and display stat
        msg= pri.PlayerName$" - ";
        msg= msg$pri.descripArray[currentStat]$" - ";
        if (currentStat == pri.EStatKeys.TIME_ALIVE) {
            msg= msg$auxRef.static.formatTime(pri.getStatValue(currentStat));
        } else {
            msg= msg$string(int(pri.getStatValue(currentStat)));
        }
        for(i= 0; i < players.Length; i++) {
            players[i].ClientMessage(statTextColor$msg);
        }
        //Get next stat
        currentStat= (currentStat+1) % pri.EStatKeys.EnumCount;
    }

}

function bool CheckReplacement(Actor Other, out byte bSuperRelevant) {
    local int index;
    local int i;
    local bool fireModeReplaced;

    if (KFWeapon(Other) != none) {
        fireModeReplaced= false;
        for(i= 0; i < ArrayCount(KFWeapon(Other).FireModeClass); i++) {
            index= auxRef.static.replaceClass(string(KFWeapon(Other).FireModeClass[i]),fireModeReplacement);
            if (index != -1) {
                KFWeapon(Other).FireModeClass[i]= class<WeaponFire>(fireModeReplacement[index].newClass);
                fireModeReplaced= true;
            }
        }
        if (fireModeReplaced) {
            return true;
        }
    } else if (PlayerController(Other) != none) {
        PlayerController(Other).PlayerReplicationInfoClass=Class'GameStatsTab.GSTPlayerReplicationInfo';
        return true;
    }

    return super.CheckReplacement(Other, bSuperRelevant);
}

static function FillPlayInfo(PlayInfo PlayInfo) {
    Super.FillPlayInfo(PlayInfo);
    PlayInfo.AddSetting("GameStatsTab", "bDispStat", "Display Stats", 0, 0, "Check");
    PlayInfo.AddSetting("GameStatsTab", "dispInterval", "Display Interval", 0, 0, "Text");
}

static event string GetDescriptionText(string property) {
    switch(property) {
        case "bDispStat":
            return "Display a random stat from a random player";
        case "dispInterval":
            return "Interval (sec) between polls";
        default:
            return Super.GetDescriptionText(property);
    }
}

defaultproperties {
    GroupName="KFGameStatsTab"
    FriendlyName="Game Stats Tab"
    Description="Displays detailed statistics about your game.  Version 1.1.0"

    currentStat= 0

    monsterReplacement(0)=(oldClass=class'KFChar.ZombieFleshPound',newClass=class'GameStatsTab.GSTZombieFleshpound')
    monsterReplacement(1)=(oldClass=class'KFChar.ZombieGorefast',newClass=class'GameStatsTab.GSTZombieGorefast')
    monsterReplacement(2)=(oldClass=class'KFChar.ZombieStalker',newClass=class'GameStatsTab.GSTZombieStalker')
    monsterReplacement(3)=(oldClass=class'KFChar.ZombieSiren',newClass=class'GameStatsTab.GSTZombieSiren')
    monsterReplacement(4)=(oldClass=class'KFChar.ZombieScrake',newClass=class'GameStatsTab.GSTZombieScrake')
    monsterReplacement(5)=(oldClass=class'KFChar.ZombieHusk',newClass=class'GameStatsTab.GSTZombieHusk')
    monsterReplacement(6)=(oldClass=class'KFChar.ZombieCrawler',newClass=class'GameStatsTab.GSTZombieCrawler')
    monsterReplacement(7)=(oldClass=class'KFChar.ZombieBloat',newClass=class'GameStatsTab.GSTZombieBloat')
    monsterReplacement(8)=(oldClass=class'KFChar.ZombieClot',newClass=class'GameStatsTab.GSTZombieClot')
    
    fireModeReplacement(0)=(oldClass=class'KFMod.M32Fire',newClass=class'GameStatsTab.GSTM32Fire')
    fireModeReplacement(1)=(oldClass=class'KFMod.LAWFire',newClass=class'GameStatsTab.GSTLAWFire')
    fireModeReplacement(2)=(oldClass=class'KFMod.CrossbowFire',newClass=class'GameStatsTab.GSTCrossbowFire')
    fireModeReplacement(3)=(oldClass=class'KFMod.ShotgunFire',newClass=class'GameStatsTab.GSTShotgunFire')
    fireModeReplacement(4)=(oldClass=class'KFMod.AA12Fire',newClass=class'GameStatsTab.GSTAA12Fire')
    fireModeReplacement(5)=(oldClass=class'KFMod.BoomStickFire',newClass=class'GameStatsTab.GSTBoomStickFire')
    fireModeReplacement(6)=(oldClass=class'KFMod.BoomStickAltFire',newClass=class'GameStatsTab.GSTBoomStickAltFire')
    fireModeReplacement(7)=(oldClass=class'KFMod.FlameBurstFire',newClass=class'GameStatsTab.GSTFlameBurstFire')
    fireModeReplacement(8)=(oldClass=class'KFMod.M79Fire',newClass=class'GameStatsTab.GSTM79Fire')
    fireModeReplacement(9)=(oldClass=class'KFMod.PipeBombFire',newClass=class'GameStatsTab.GSTPipeBombFire')
    fireModeReplacement(10)=(oldClass=class'KFMod.WinchesterFire',newClass=class'GameStatsTab.GSTWinchesterFire')
    fireModeReplacement(11)=(oldClass=class'KFMod.DualDeagleFire',newClass=class'GameStatsTab.GSTDualDeagleFire')
    fireModeReplacement(12)=(oldClass=class'KFMod.DualiesFire',newClass=class'GameStatsTab.GSTDualiesFire')
    fireModeReplacement(13)=(oldClass=class'KFMod.AK47Fire',newClass=class'GameStatsTab.GSTAK47Fire')
    fireModeReplacement(14)=(oldClass=class'KFMod.BullpupFire',newClass=class'GameStatsTab.GSTBullpupFire')
    fireModeReplacement(15)=(oldClass=class'KFMod.DeagleFire',newClass=class'GameStatsTab.GSTDeagleFire')
    fireModeReplacement(16)=(oldClass=class'KFMod.M14EBRFire',newClass=class'GameStatsTab.GSTM14EBRFire')
    fireModeReplacement(17)=(oldClass=class'KFMod.MAC10Fire',newClass=class'GameStatsTab.GSTMAC10Fire')
    fireModeReplacement(18)=(oldClass=class'KFMod.MP7MFire',newClass=class'GameStatsTab.GSTMP7MFire')
    fireModeReplacement(19)=(oldClass=class'KFMod.MachinePFire',newClass=class'GameStatsTab.GSTMachinePFire')
    fireModeReplacement(20)=(oldClass=class'KFMod.SCARMK17Fire',newClass=class'GameStatsTab.GSTSCARMK17Fire')
    fireModeReplacement(21)=(oldClass=class'KFMod.SingleFire',newClass=class'GameStatsTab.GSTSingleFire')
    fireModeReplacement(22)=(oldClass=class'KFMod.FragFire',newClass=class'GameStatsTab.GSTFragFire')
    fireModeReplacement(23)=(oldClass=class'KFMod.AxeFire',newClass=class'GameStatsTab.GSTAxeFire')
    fireModeReplacement(24)=(oldClass=class'KFMod.AxeFireB',newClass=class'GameStatsTab.GSTAxeFireB')
    fireModeReplacement(25)=(oldClass=class'KFMod.KatanaFire',newClass=class'GameStatsTab.GSTKatanaFire')
    fireModeReplacement(26)=(oldClass=class'KFMod.KatanaFireB',newClass=class'GameStatsTab.GSTKatanaFireB')
    fireModeReplacement(27)=(oldClass=class'KFMod.MacheteFire',newClass=class'GameStatsTab.GSTMacheteFire')
    fireModeReplacement(28)=(oldClass=class'KFMod.MacheteFireB',newClass=class'GameStatsTab.GSTMacheteFireB')
    fireModeReplacement(29)=(oldClass=class'KFMod.KnifeFire',newClass=class'GameStatsTab.GSTKnifeFire')
    fireModeReplacement(30)=(oldClass=class'KFMod.KnifeFireB',newClass=class'GameStatsTab.GSTKnifeFireB')
    fireModeReplacement(31)=(oldClass=class'KFMod.ChainsawFire',newClass=class'GameStatsTab.GSTChainsawFire')
    fireModeReplacement(32)=(oldClass=class'KFMod.ChainsawAltFire',newClass=class'GameStatsTab.GSTChainsawAltFire')
}
