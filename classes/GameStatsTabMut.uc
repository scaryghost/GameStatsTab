class GameStatsTabMut extends Mutator
    dependson(GSTAuxiliary);

var() config bool bDispStat;
var() config int dispInterval;
var string statTextColor, endGameBossClass, fallbackMonsterClass;
var byte currentStat;
var array<GSTAuxiliary.ReplacementPair> monsterReplacement, fireModeReplacement;
var class<GameRules> statsTabRules;
var class<PlayerController> statsTabController;
var class<PlayerReplicationInfo> statsTabReplicationInfo;

var class<GSTAuxiliary> auxiliaryRef;
var transient StatsServerUDPLink serverLink;

function PostBeginPlay() {
    local KFGameType gameType;
    local GSTPlayerReplicationInfo pri;

    gameType= KFGameType(Level.Game);
    if (gameType == none) {
        Destroy();
        return;
    }

    Spawn(statsTabRules);
    AddToPackageMap("GameStatsTab");

    gameType.PlayerControllerClass= statsTabController;
    gameType.PlayerControllerClassName= string(statsTabController);

    //Replace all instances of the old specimens with the new ones 
    auxiliaryRef.static.replaceStandardMonsterClasses(gameType.StandardMonsterClasses, 
            monsterReplacement);

    //Replace the special squad arrays
    auxiliaryRef.static.replaceSpecialSquad(gameType.ShortSpecialSquads, monsterReplacement);
    auxiliaryRef.static.replaceSpecialSquad(gameType.NormalSpecialSquads, monsterReplacement);
    auxiliaryRef.static.replaceSpecialSquad(gameType.LongSpecialSquads, monsterReplacement);
    auxiliaryRef.static.replaceSpecialSquad(gameType.FinalSquads, monsterReplacement);

    gameType.EndGameBossClass= endGameBossClass;
    gameType.FallbackMonsterClass= fallbackMonsterClass;

    statTextColor= chr(27)$chr(255)$chr(255)$chr(1);
/*
    if (bDispStat) {
        setTimer(dispInterval, true);
    }
*/

    serverLink= spawn(class'StatsSErverUDPLink');
}

/*
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
            msg= msg$auxiliaryRef.static.formatTime(pri.getStatValue(currentStat));
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
*/

function bool CheckReplacement(Actor Other, out byte bSuperRelevant) {
    local int index;
    local int i;
    local bool fireModeReplaced;

    if (KFWeapon(Other) != none) {
        fireModeReplaced= false;
        for(i= 0; i < ArrayCount(KFWeapon(Other).FireModeClass); i++) {
            index= auxiliaryRef.static.replaceClass(string(KFWeapon(Other).FireModeClass[i]),fireModeReplacement);
            if (index != -1) {
                KFWeapon(Other).FireModeClass[i]= class<WeaponFire>(fireModeReplacement[index].newClass);
                fireModeReplaced= true;
            }
        }
        if (fireModeReplaced) {
            return true;
        }
    } else if (PlayerController(Other) != none) {
        PlayerController(Other).PlayerReplicationInfoClass= statsTabReplicationInfo;
        return true;
    }

    return super.CheckReplacement(Other, bSuperRelevant);
}

function NotifyLogout(Controller Exiting) {
    local GSTPlayerReplicationInfo pri;
    local string baseMsg, statVals;
    local int i;

    pri= GSTPlayerReplicationInfo(Exiting.PlayerReplicationInfo);
    baseMsg= "action:write;playerid:";
    baseMsg= baseMsg $ pri.playerIDHash $ ";";

    statVals= "";
    for(i= 0; i < pri.PlayerStat.EnumCount; i++) {
        statVals$= GetEnum(Enum'GSTPlayerReplicationInfo.PlayerStat',i) $ "=" $ pri.playerStats[i];
        if (i < pri.PlayerStat.EnumCount - 1) {
            statVals$= ";";
        }
    }
    serverLink.SendText(serverLink.serverAddr, baseMsg $ statVals);

    statVals= "";
    for(i= 0; i < pri.WeaponStat.EnumCount; i++) {
        statVals$= GetEnum(Enum'GSTPlayerReplicationInfo.WeaponStat',i) $ "=" $ pri.kfWeaponStats[i];
        if (i < pri.WeaponStat.EnumCount - 1) {
            statVals$= ";";
        }
    }
    serverLink.SendText(serverLink.serverAddr, baseMsg $ statVals);

    statVals= "";
    for(i= 0; i < pri.ZedStat.EnumCount; i++) {
        statVals$= GetEnum(Enum'GSTPlayerReplicationInfo.ZedStat',i) $ "=" $ pri.zedStats[i];
        if (i < pri.ZedStat.EnumCount - 1) {
            statVals$= ";";
        }
    }
    serverLink.SendText(serverLink.serverAddr, baseMsg $ statVals);

    statVals= "";
    for(i= 0; i < pri.HiddenStat.EnumCount; i++) {
        statVals$= GetEnum(Enum'GSTPlayerReplicationInfo.HiddenStat',i) $ "=" $ pri.hiddenStats[i];
        if (i < pri.HiddenStat.EnumCount - 1) {
            statVals$= ";";
        }
    }
    serverLink.SendText(serverLink.serverAddr, baseMsg $ statVals);
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
    Description="Displays detailed statistics about your game.  Version 1.2.0"

    currentStat= 0
    auxiliaryRef= class'GameStatsTab.GSTAuxiliary';
    statsTabRules= class'GameStatsTab.GSTGameRules'
    statsTabController= class'GameStatsTab.GSTPlayerController'
    statsTabReplicationInfo= class'GameStatsTab.GSTPlayerReplicationInfo'

    endGameBossClass= "GameStatsTab.ZombieBoss"
    fallbackMonsterClass= "GameStatsTab.ZombieStalker"
    
    monsterReplacement(0)=(oldClass=class'KFChar.ZombieFleshPound',newClass=class'GameStatsTab.ZombieFleshpound')
    monsterReplacement(1)=(oldClass=class'KFChar.ZombieGorefast',newClass=class'GameStatsTab.ZombieGorefast')
    monsterReplacement(2)=(oldClass=class'KFChar.ZombieStalker',newClass=class'GameStatsTab.ZombieStalker')
    monsterReplacement(3)=(oldClass=class'KFChar.ZombieSiren',newClass=class'GameStatsTab.ZombieSiren')
    monsterReplacement(4)=(oldClass=class'KFChar.ZombieScrake',newClass=class'GameStatsTab.ZombieScrake')
    monsterReplacement(5)=(oldClass=class'KFChar.ZombieHusk',newClass=class'GameStatsTab.ZombieHusk')
    monsterReplacement(6)=(oldClass=class'KFChar.ZombieCrawler',newClass=class'GameStatsTab.ZombieCrawler')
    monsterReplacement(7)=(oldClass=class'KFChar.ZombieBloat',newClass=class'GameStatsTab.ZombieBloat')
    monsterReplacement(8)=(oldClass=class'KFChar.ZombieClot',newClass=class'GameStatsTab.ZombieClot')
    
    fireModeReplacement(0)=(oldClass=class'KFMod.M32Fire',newClass=class'GameStatsTab.M32Fire')
    fireModeReplacement(1)=(oldClass=class'KFMod.LAWFire',newClass=class'GameStatsTab.LAWFire')
    fireModeReplacement(2)=(oldClass=class'KFMod.CrossbowFire',newClass=class'GameStatsTab.CrossbowFire')
    fireModeReplacement(3)=(oldClass=class'KFMod.ShotgunFire',newClass=class'GameStatsTab.ShotgunFire')
    fireModeReplacement(4)=(oldClass=class'KFMod.AA12Fire',newClass=class'GameStatsTab.AA12Fire')
    fireModeReplacement(5)=(oldClass=class'KFMod.BoomStickFire',newClass=class'GameStatsTab.BoomStickFire')
    fireModeReplacement(6)=(oldClass=class'KFMod.BoomStickAltFire',newClass=class'GameStatsTab.BoomStickAltFire')
    fireModeReplacement(7)=(oldClass=class'KFMod.FlameBurstFire',newClass=class'GameStatsTab.FlameBurstFire')
    fireModeReplacement(8)=(oldClass=class'KFMod.M79Fire',newClass=class'GameStatsTab.M79Fire')
    fireModeReplacement(9)=(oldClass=class'KFMod.PipeBombFire',newClass=class'GameStatsTab.PipeBombFire')
    fireModeReplacement(10)=(oldClass=class'KFMod.WinchesterFire',newClass=class'GameStatsTab.WinchesterFire')
    fireModeReplacement(11)=(oldClass=class'KFMod.DualDeagleFire',newClass=class'GameStatsTab.DualDeagleFire')
    fireModeReplacement(12)=(oldClass=class'KFMod.DualiesFire',newClass=class'GameStatsTab.DualiesFire')
    fireModeReplacement(13)=(oldClass=class'KFMod.AK47Fire',newClass=class'GameStatsTab.AK47Fire')
    fireModeReplacement(14)=(oldClass=class'KFMod.BullpupFire',newClass=class'GameStatsTab.BullpupFire')
    fireModeReplacement(15)=(oldClass=class'KFMod.DeagleFire',newClass=class'GameStatsTab.DeagleFire')
    fireModeReplacement(16)=(oldClass=class'KFMod.M14EBRFire',newClass=class'GameStatsTab.M14EBRFire')
    fireModeReplacement(17)=(oldClass=class'KFMod.MAC10Fire',newClass=class'GameStatsTab.MAC10Fire')
    fireModeReplacement(18)=(oldClass=class'KFMod.MP7MFire',newClass=class'GameStatsTab.MP7MFire')
    fireModeReplacement(19)=(oldClass=class'KFMod.MachinePFire',newClass=class'GameStatsTab.MachinePFire')
    fireModeReplacement(20)=(oldClass=class'KFMod.SCARMK17Fire',newClass=class'GameStatsTab.SCARMK17Fire')
    fireModeReplacement(21)=(oldClass=class'KFMod.SingleFire',newClass=class'GameStatsTab.SingleFire')
    fireModeReplacement(22)=(oldClass=class'KFMod.FragFire',newClass=class'GameStatsTab.FragFire')
    fireModeReplacement(23)=(oldClass=class'KFMod.AxeFire',newClass=class'GameStatsTab.AxeFire')
    fireModeReplacement(24)=(oldClass=class'KFMod.AxeFireB',newClass=class'GameStatsTab.AxeFireB')
    fireModeReplacement(25)=(oldClass=class'KFMod.KatanaFire',newClass=class'GameStatsTab.KatanaFire')
    fireModeReplacement(26)=(oldClass=class'KFMod.KatanaFireB',newClass=class'GameStatsTab.KatanaFireB')
    fireModeReplacement(27)=(oldClass=class'KFMod.MacheteFire',newClass=class'GameStatsTab.MacheteFire')
    fireModeReplacement(28)=(oldClass=class'KFMod.MacheteFireB',newClass=class'GameStatsTab.MacheteFireB')
    fireModeReplacement(29)=(oldClass=class'KFMod.KnifeFire',newClass=class'GameStatsTab.KnifeFire')
    fireModeReplacement(30)=(oldClass=class'KFMod.KnifeFireB',newClass=class'GameStatsTab.KnifeFireB')
    fireModeReplacement(31)=(oldClass=class'KFMod.ChainsawFire',newClass=class'GameStatsTab.ChainsawFire')
    fireModeReplacement(32)=(oldClass=class'KFMod.ChainsawAltFire',newClass=class'GameStatsTab.ChainsawAltFire')
    fireModeReplacement(33)=(oldClass=class'KFMod.BenelliFire',newClass=class'GameStatsTab.BenelliFire')
    fireModeReplacement(34)=(oldClass=class'KFMod.ClaymoreSwordFire',newClass=class'GameStatsTab.ClaymoreSwordFire')
    fireModeReplacement(35)=(oldClass=class'KFMod.ClaymoreSwordFireB',newClass=class'GameStatsTab.ClaymoreSwordFireB')
    fireModeReplacement(36)=(oldClass=class'KFMod.HuskGunFire',newClass=class'GameStatsTab.HuskGunFire')
    fireModeReplacement(37)=(oldClass=class'KFMod.M203Fire',newClass=class'GameStatsTab.M203Fire')
    fireModeReplacement(38)=(oldClass=class'KFMod.M4203BulletFire',newClass=class'GameStatsTab.M4203BulletFire')
    fireModeReplacement(39)=(oldClass=class'KFMod.M4Fire',newClass=class'GameStatsTab.M4Fire')
    fireModeReplacement(40)=(oldClass=class'KFMod.MP5MFire',newClass=class'GameStatsTab.MP5MFire')
    fireModeReplacement(41)=(oldClass=class'KFMod.Magnum44Fire',newClass=class'GameStatsTab.Magnum44Fire')
    fireModeReplacement(42)=(oldClass=class'KFMod.Dual44MagnumFire',newClass=class'GameStatsTab.Dual44MagnumFire')
}
