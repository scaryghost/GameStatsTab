class GameStatsTabMut extends Mutator;

var() config bool bDispStat;
var() config int dispInterval;
var string statTextColor, gstLoginMenuClass, endGameBossClass, fallbackMonsterClass;
var byte currentStat;
var array<GSTAuxiliary.ReplacementPair> monsterReplacement, fireModeReplacement;
var bool replaceLoginMenu;
var class<GameRules> statsTabRules;
var class<PlayerController> statsTabController;
var class<PlayerReplicationInfo> statsTabReplicationInfo;

var class<GSTAuxiliary> auxiliaryRef;

function PostBeginPlay() {
    local KFGameType gameType;

    gameType= KFGameType(Level.Game);
    if (gameType == none) {
        Destroy();
        return;
    }

    Spawn(statsTabRules);
    AddToPackageMap("GameStatsTab_ServerPerks");
    DeathMatch(Level.Game).LoginMenuClass= gstLoginMenuClass;

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

    setTimer(0.1, false);
}

/**
 * Need the timer to overwrite ServerPerk's login menu.
 * ServerPerks is loaded after GameStatsTab since it 
 * alphabetically is after GameStatsTab
 */
function Timer() {
    local array<GSTPlayerController> players;
    local Controller C;
    local UnrealPlayer up;
    local string loginMenuClass;
    local GSTPlayerReplicationInfo pri;
    local string msg;
    local int i;

    if (!replaceLoginMenu) {
        loginMenuClass= string(class'GameStatsTab_ServerPerks.GSTInvasionLoginMenu');
        DeathMatch(Level.Game).LoginMenuClass= loginMenuClass;

        /**
         * Need this part for local hosts
         */            
        for(C= Level.ControllerList; C != none; C= C.NextController) {
            up= UnrealPlayer(c);
            if (up != none) {
                up.ClientReceiveLoginMenu(loginMenuClass, DeathMatch(Level.Game).bAlwaysShowLoginMenu);
            }
        }

        replaceLoginMenu= true;
        if (bDispStat) {
            setTimer(dispInterval, true);
        }
        return;
    }
   
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
    FriendlyName="Game Stats Tab - ServerPerks"
    Description="Displays detailed statistics about your game.  This version is compatible with ServerPerks.  Version 1.1.0"

    auxiliaryRef= class'GameStatsTab_ServerPerks.GSTAuxiliary';
    gstLoginMenuClass="GameStatsTab_ServerPerks.GSTInvasionLoginMenu"
    statsTabRules= class'GameStatsTab_ServerPerks.GSTGameRules'
    statsTabController= class'GameStatsTab_ServerPerks.GSTPlayerController'
    statsTabReplicationInfo= class'GameStatsTab_ServerPerks.GSTPlayerReplicationInfo'

    endGameBossClass= "GameStatsTab_ServerPerks.GSTZombieBoss"
    fallbackMonsterClass= "GameStatsTab_ServerPerks.GSTZombieStalker"
    
    currentStat= 0

    monsterReplacement(0)=(oldClass=class'KFChar.ZombieFleshPound',newClass=class'GameStatsTab_ServerPerks.GSTZombieFleshpound')
    monsterReplacement(1)=(oldClass=class'KFChar.ZombieGorefast',newClass=class'GameStatsTab_ServerPerks.GSTZombieGorefast')
    monsterReplacement(2)=(oldClass=class'KFChar.ZombieStalker',newClass=class'GameStatsTab_ServerPerks.GSTZombieStalker')
    monsterReplacement(3)=(oldClass=class'KFChar.ZombieSiren',newClass=class'GameStatsTab_ServerPerks.GSTZombieSiren')
    monsterReplacement(4)=(oldClass=class'KFChar.ZombieScrake',newClass=class'GameStatsTab_ServerPerks.GSTZombieScrake')
    monsterReplacement(5)=(oldClass=class'KFChar.ZombieHusk',newClass=class'GameStatsTab_ServerPerks.GSTZombieHusk')
    monsterReplacement(6)=(oldClass=class'KFChar.ZombieCrawler',newClass=class'GameStatsTab_ServerPerks.GSTZombieCrawler')
    monsterReplacement(7)=(oldClass=class'KFChar.ZombieBloat',newClass=class'GameStatsTab_ServerPerks.GSTZombieBloat')
    monsterReplacement(8)=(oldClass=class'KFChar.ZombieClot',newClass=class'GameStatsTab_ServerPerks.GSTZombieClot')

    fireModeReplacement(0)=(oldClass=class'KFMod.M32Fire',newClass=class'GameStatsTab_ServerPerks.GSTM32Fire')
    fireModeReplacement(1)=(oldClass=class'KFMod.LAWFire',newClass=class'GameStatsTab_ServerPerks.GSTLAWFire')
    fireModeReplacement(2)=(oldClass=class'KFMod.CrossbowFire',newClass=class'GameStatsTab_ServerPerks.GSTCrossbowFire')
    fireModeReplacement(3)=(oldClass=class'KFMod.ShotgunFire',newClass=class'GameStatsTab_ServerPerks.GSTShotgunFire')
    fireModeReplacement(4)=(oldClass=class'KFMod.AA12Fire',newClass=class'GameStatsTab_ServerPerks.GSTAA12Fire')
    fireModeReplacement(5)=(oldClass=class'KFMod.BoomStickFire',newClass=class'GameStatsTab_ServerPerks.GSTBoomStickFire')
    fireModeReplacement(6)=(oldClass=class'KFMod.BoomStickAltFire',newClass=class'GameStatsTab_ServerPerks.GSTBoomStickAltFire')
    fireModeReplacement(7)=(oldClass=class'KFMod.FlameBurstFire',newClass=class'GameStatsTab_ServerPerks.GSTFlameBurstFire')
    fireModeReplacement(8)=(oldClass=class'KFMod.M79Fire',newClass=class'GameStatsTab_ServerPerks.GSTM79Fire')
    fireModeReplacement(9)=(oldClass=class'KFMod.PipeBombFire',newClass=class'GameStatsTab_ServerPerks.GSTPipeBombFire')
    fireModeReplacement(10)=(oldClass=class'KFMod.WinchesterFire',newClass=class'GameStatsTab_ServerPerks.GSTWinchesterFire')
    fireModeReplacement(11)=(oldClass=class'KFMod.DualDeagleFire',newClass=class'GameStatsTab_ServerPerks.GSTDualDeagleFire')
    fireModeReplacement(12)=(oldClass=class'KFMod.DualiesFire',newClass=class'GameStatsTab_ServerPerks.GSTDualiesFire')
    fireModeReplacement(13)=(oldClass=class'KFMod.AK47Fire',newClass=class'GameStatsTab_ServerPerks.GSTAK47Fire')
    fireModeReplacement(14)=(oldClass=class'KFMod.BullpupFire',newClass=class'GameStatsTab_ServerPerks.GSTBullpupFire')
    fireModeReplacement(15)=(oldClass=class'KFMod.DeagleFire',newClass=class'GameStatsTab_ServerPerks.GSTDeagleFire')
    fireModeReplacement(16)=(oldClass=class'KFMod.M14EBRFire',newClass=class'GameStatsTab_ServerPerks.GSTM14EBRFire')
    fireModeReplacement(17)=(oldClass=class'KFMod.MAC10Fire',newClass=class'GameStatsTab_ServerPerks.GSTMAC10Fire')
    fireModeReplacement(18)=(oldClass=class'KFMod.MP7MFire',newClass=class'GameStatsTab_ServerPerks.GSTMP7MFire')
    fireModeReplacement(19)=(oldClass=class'KFMod.MachinePFire',newClass=class'GameStatsTab_ServerPerks.GSTMachinePFire')
    fireModeReplacement(20)=(oldClass=class'KFMod.SCARMK17Fire',newClass=class'GameStatsTab_ServerPerks.GSTSCARMK17Fire')
    fireModeReplacement(21)=(oldClass=class'KFMod.SingleFire',newClass=class'GameStatsTab_ServerPerks.GSTSingleFire')
    fireModeReplacement(22)=(oldClass=class'KFMod.FragFire',newClass=class'GameStatsTab_ServerPerks.GSTFragFire')
    fireModeReplacement(23)=(oldClass=class'KFMod.AxeFire',newClass=class'GameStatsTab_ServerPerks.GSTAxeFire')
    fireModeReplacement(24)=(oldClass=class'KFMod.AxeFireB',newClass=class'GameStatsTab_ServerPerks.GSTAxeFireB')
    fireModeReplacement(25)=(oldClass=class'KFMod.KatanaFire',newClass=class'GameStatsTab_ServerPerks.GSTKatanaFire')
    fireModeReplacement(26)=(oldClass=class'KFMod.KatanaFireB',newClass=class'GameStatsTab_ServerPerks.GSTKatanaFireB')
    fireModeReplacement(27)=(oldClass=class'KFMod.MacheteFire',newClass=class'GameStatsTab_ServerPerks.GSTMacheteFire')
    fireModeReplacement(28)=(oldClass=class'KFMod.MacheteFireB',newClass=class'GameStatsTab_ServerPerks.GSTMacheteFireB')
    fireModeReplacement(29)=(oldClass=class'KFMod.KnifeFire',newClass=class'GameStatsTab_ServerPerks.GSTKnifeFire')
    fireModeReplacement(30)=(oldClass=class'KFMod.KnifeFireB',newClass=class'GameStatsTab_ServerPerks.GSTKnifeFireB')
    fireModeReplacement(31)=(oldClass=class'KFMod.ChainsawFire',newClass=class'GameStatsTab_ServerPerks.GSTChainsawFire')
    fireModeReplacement(32)=(oldClass=class'KFMod.ChainsawAltFire',newClass=class'GameStatsTab_ServerPerks.GSTChainsawAltFire')
    fireModeReplacement(33)=(oldClass=class'KFMod.BenelliFire',newClass=class'GameStatsTab_ServerPerks.GSTBenelliFire')
    fireModeReplacement(34)=(oldClass=class'KFMod.ClaymoreSwordFire',newClass=class'GameStatsTab_ServerPerks.GSTClaymoreSwordFire')
    fireModeReplacement(35)=(oldClass=class'KFMod.ClaymoreSwordFireB',newClass=class'GameStatsTab_ServerPerks.GSTClaymoreSwordFireB')
    fireModeReplacement(36)=(oldClass=class'KFMod.HuskGunFire',newClass=class'GameStatsTab_ServerPerks.GSTHuskGunFire')
    fireModeReplacement(37)=(oldClass=class'KFMod.M203Fire',newClass=class'GameStatsTab_ServerPerks.GSTM203Fire')
    fireModeReplacement(38)=(oldClass=class'KFMod.M4203BulletFire',newClass=class'GameStatsTab_ServerPerks.GSTM4203BulletFire')
    fireModeReplacement(39)=(oldClass=class'KFMod.M4Fire',newClass=class'GameStatsTab_ServerPerks.GSTM4Fire')
    fireModeReplacement(40)=(oldClass=class'KFMod.MP5MFire',newClass=class'GameStatsTab_ServerPerks.GSTMP5MFire')
    fireModeReplacement(41)=(oldClass=class'KFMod.Magnum44Fire',newClass=class'GameStatsTab_ServerPerks.GSTMagnum44Fire')
    fireModeReplacement(42)=(oldClass=class'KFMod.Dual44MagnumFire',newClass=class'GameStatsTab_ServerPerks.GSTDual44MagnumFire')
>>>>>>> milestone_1_2
}
