class GameStatsTabMut extends Mutator
    config(GameStatsTabMut)
    dependson(GSTAuxiliary);

var() config bool accumulateStats;
var() config int serverPort;
var() config string serverAddress, serverPwd, localHostSteamId;
var KFGameType gameType;
var string endGameBossClass, fallbackMonsterClass;
var array<GSTAuxiliary.ReplacementPair> monsterReplacement, fireModeReplacement;
var class<GameRules> statsTabRules;
var class<PlayerController> statsTabController;
var class<PlayerReplicationInfo> statsTabReplicationInfo;
var class<GameReplicationInfo> statsTabGameReplicationInfo;
var class<GSTAuxiliary> auxiliaryRef;
var class<StatsServerUDPLink> statsUDPLink;
var transient StatsServerUDPLink serverLink;

function PostBeginPlay() {
    gameType= KFGameType(Level.Game);
    if (gameType == none) {
        Destroy();
        return;
    }

    Spawn(statsTabRules);
    AddToPackageMap("GameStatsTab");

    gameType.PlayerControllerClass= statsTabController;
    gameType.PlayerControllerClassName= string(statsTabController);
    gameType.GameReplicationInfoClass= statsTabGameReplicationInfo;

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

    if (accumulateStats) {
        serverLink= spawn(statsUDPLink);
        SetTimer(1,true);
    }
}

function Timer() {
    if (KFGameReplicationInfo(Level.Game.GameReplicationInfo).EndGameType != 0 &&
        (gameType.WaveNum != gameType.InitialWave || gameType.bWaveInProgress)) {
        serverLink.broadcastMatchResults();
        if (accumulateStats && Level.NetMode != NM_DedicatedServer) {
            serverLink.saveStats(GSTPlayerReplicationInfo(Level.GetLocalPlayerController().PlayerReplicationInfo));
        }
        SetTimer(0,false);
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

function NotifyLogout(Controller Exiting) {
    if (accumulateStats && Level.Game.GameReplicationInfo.bMatchHasBegun && 
        (gameType.WaveNum != gameType.InitialWave || gameType.bWaveInProgress) &&
        Exiting != Level.GetLocalPlayerController()) {
        serverLink.saveStats(GSTPlayerReplicationInfo(Exiting.PlayerReplicationInfo));
    }
}

static function FillPlayInfo(PlayInfo PlayInfo) {
    Super.FillPlayInfo(PlayInfo);
    PlayInfo.AddSetting("GameStatsTab", "accumulateStats", "Accumulate Statistics", 0, 0, "Check");
    PlayInfo.AddSetting("GameStatsTab", "localHostSteamId", "Local Host Steam ID", 0, 0, "Text", "16");
    PlayInfo.AddSetting("GameStatsTab", "serverAddress", "Remote Server Address", 0, 0, "Text", "128");
    PlayInfo.AddSetting("GameStatsTab", "serverPort", "Remote Server Port", 0, 0, "Text");
    PlayInfo.AddSetting("GameStatsTab", "serverPwd", "Remote Server Password", 0, 0, "Text", "128");
}

static event string GetDescriptionText(string property) {
    switch(property) {
        case "accumulateStats":
            return "Check if the mutator should save the stats to a remote server";
        case "localHostSteamId":
            return "16 digit steam id of the game's local host.  Used for solo or listen server games by the host.";
        case "serverAddress":
            return "Address of tracking server";
        case "serverPort":
            return "Port number of tracking server";
        case "serverPwd":
            return "Password of tracking server";
        default:
            return Super.GetDescriptionText(property);
    }
}

defaultproperties {
    GroupName="KFGameStatsTab"
    FriendlyName="Game Stats Tab v2.0"
    Description="Displays detailed statistics about your game.  Version 2.0"

    auxiliaryRef= class'GameStatsTab.GSTAuxiliary';
    statsTabRules= class'GameStatsTab.GSTGameRules'
    statsTabController= class'GameStatsTab.GSTPlayerController'
    statsTabReplicationInfo= class'GameStatsTab.GSTPlayerReplicationInfo'
    statsTabGameReplicationInfo= class'GameStatsTab.GSTGameReplicationInfo'
    statsUDPLink= class'StatsServerUDPLink'

    endGameBossClass= "GameStatsTab.ZombieBoss"
    fallbackMonsterClass= "GameStatsTab.ZombieStalker"
    
    monsterReplacement(0)=(oldClass=class'KFChar.ZombieBloat',newClass=class'GameStatsTab.ZombieBloat')
    monsterReplacement(1)=(oldClass=class'KFChar.ZombieClot',newClass=class'GameStatsTab.ZombieClot')
    monsterReplacement(2)=(oldClass=class'KFChar.ZombieCrawler',newClass=class'GameStatsTab.ZombieCrawler')
    monsterReplacement(3)=(oldClass=class'KFChar.ZombieFleshPound',newClass=class'GameStatsTab.ZombieFleshpound')
    monsterReplacement(4)=(oldClass=class'KFChar.ZombieGorefast',newClass=class'GameStatsTab.ZombieGorefast')
    monsterReplacement(5)=(oldClass=class'KFChar.ZombieHusk',newClass=class'GameStatsTab.ZombieHusk')
    monsterReplacement(6)=(oldClass=class'KFChar.ZombieScrake',newClass=class'GameStatsTab.ZombieScrake')
    monsterReplacement(7)=(oldClass=class'KFChar.ZombieSiren',newClass=class'GameStatsTab.ZombieSiren')
    monsterReplacement(8)=(oldClass=class'KFChar.ZombieStalker',newClass=class'GameStatsTab.ZombieStalker')
    
    fireModeReplacement(0)=(oldClass=class'KFMod.AA12Fire',newClass=class'GameStatsTab.AA12Fire')
    fireModeReplacement(1)=(oldClass=class'KFMod.AK47Fire',newClass=class'GameStatsTab.AK47Fire')
    fireModeReplacement(2)=(oldClass=class'KFMod.AxeFire',newClass=class'GameStatsTab.AxeFire')
    fireModeReplacement(3)=(oldClass=class'KFMod.AxeFireB',newClass=class'GameStatsTab.AxeFireB')
    fireModeReplacement(4)=(oldClass=class'KFMod.BenelliFire',newClass=class'GameStatsTab.BenelliFire')
    fireModeReplacement(5)=(oldClass=class'KFMod.BoomStickAltFire',newClass=class'GameStatsTab.BoomStickAltFire')
    fireModeReplacement(6)=(oldClass=class'KFMod.BoomStickFire',newClass=class'GameStatsTab.BoomStickFire')
    fireModeReplacement(7)=(oldClass=class'KFMod.BullpupFire',newClass=class'GameStatsTab.BullpupFire')
    fireModeReplacement(8)=(oldClass=class'KFMod.ChainsawAltFire',newClass=class'GameStatsTab.ChainsawAltFire')
    fireModeReplacement(9)=(oldClass=class'KFMod.ChainsawFire',newClass=class'GameStatsTab.ChainsawFire')
    fireModeReplacement(10)=(oldClass=class'KFMod.ClaymoreSwordFire',newClass=class'GameStatsTab.ClaymoreSwordFire')
    fireModeReplacement(11)=(oldClass=class'KFMod.ClaymoreSwordFireB',newClass=class'GameStatsTab.ClaymoreSwordFireB')
    fireModeReplacement(12)=(oldClass=class'KFMod.CrossbowFire',newClass=class'GameStatsTab.CrossbowFire')
    fireModeReplacement(13)=(oldClass=class'KFMod.DeagleFire',newClass=class'GameStatsTab.DeagleFire')
    fireModeReplacement(14)=(oldClass=class'KFMod.Dual44MagnumFire',newClass=class'GameStatsTab.Dual44MagnumFire')
    fireModeReplacement(15)=(oldClass=class'KFMod.DualDeagleFire',newClass=class'GameStatsTab.DualDeagleFire')
    fireModeReplacement(16)=(oldClass=class'KFMod.DualiesFire',newClass=class'GameStatsTab.DualiesFire')
    fireModeReplacement(17)=(oldClass=class'KFMod.FlameBurstFire',newClass=class'GameStatsTab.FlameBurstFire')
    fireModeReplacement(18)=(oldClass=class'KFMod.FragFire',newClass=class'GameStatsTab.FragFire')
    fireModeReplacement(19)=(oldClass=class'KFMod.HuskGunFire',newClass=class'GameStatsTab.HuskGunFire')
    fireModeReplacement(20)=(oldClass=class'KFMod.KatanaFire',newClass=class'GameStatsTab.KatanaFire')
    fireModeReplacement(21)=(oldClass=class'KFMod.KatanaFireB',newClass=class'GameStatsTab.KatanaFireB')
    fireModeReplacement(22)=(oldClass=class'KFMod.KnifeFire',newClass=class'GameStatsTab.KnifeFire')
    fireModeReplacement(23)=(oldClass=class'KFMod.KnifeFireB',newClass=class'GameStatsTab.KnifeFireB')
    fireModeReplacement(24)=(oldClass=class'KFMod.LAWFire',newClass=class'GameStatsTab.LAWFire')
    fireModeReplacement(25)=(oldClass=class'KFMod.M14EBRFire',newClass=class'GameStatsTab.M14EBRFire')
    fireModeReplacement(26)=(oldClass=class'KFMod.M203Fire',newClass=class'GameStatsTab.M203Fire')
    fireModeReplacement(27)=(oldClass=class'KFMod.M32Fire',newClass=class'GameStatsTab.M32Fire')
    fireModeReplacement(28)=(oldClass=class'KFMod.M4203BulletFire',newClass=class'GameStatsTab.M4203BulletFire')
    fireModeReplacement(29)=(oldClass=class'KFMod.M4Fire',newClass=class'GameStatsTab.M4Fire')
    fireModeReplacement(30)=(oldClass=class'KFMod.M79Fire',newClass=class'GameStatsTab.M79Fire')
    fireModeReplacement(31)=(oldClass=class'KFMod.MAC10Fire',newClass=class'GameStatsTab.MAC10Fire')
    fireModeReplacement(32)=(oldClass=class'KFMod.MacheteFire',newClass=class'GameStatsTab.MacheteFire')
    fireModeReplacement(33)=(oldClass=class'KFMod.MacheteFireB',newClass=class'GameStatsTab.MacheteFireB')
    fireModeReplacement(34)=(oldClass=class'KFMod.MachinePFire',newClass=class'GameStatsTab.MachinePFire')
    fireModeReplacement(35)=(oldClass=class'KFMod.Magnum44Fire',newClass=class'GameStatsTab.Magnum44Fire')
    fireModeReplacement(36)=(oldClass=class'KFMod.MP5MAltFire',newClass=class'GameStatsTab.MP5MAltFire')
    fireModeReplacement(37)=(oldClass=class'KFMod.MP5MFire',newClass=class'GameStatsTab.MP5MFire')
    fireModeReplacement(38)=(oldClass=class'KFMod.MP7MAltFire',newClass=class'GameStatsTab.MP7MAltFire')
    fireModeReplacement(39)=(oldClass=class'KFMod.MP7MFire',newClass=class'GameStatsTab.MP7MFire')
    fireModeReplacement(40)=(oldClass=class'KFMod.PipeBombFire',newClass=class'GameStatsTab.PipeBombFire')
    fireModeReplacement(41)=(oldClass=class'KFMod.SCARMK17Fire',newClass=class'GameStatsTab.SCARMK17Fire')
    fireModeReplacement(42)=(oldClass=class'KFMod.ShotgunFire',newClass=class'GameStatsTab.ShotgunFire')
    fireModeReplacement(43)=(oldClass=class'KFMod.SingleFire',newClass=class'GameStatsTab.SingleFire')
    fireModeReplacement(44)=(oldClass=class'KFMod.SyringeAltFire',newClass=class'GameStatsTab.SyringeAltFire')
    fireModeReplacement(45)=(oldClass=class'KFMod.SyringeFire',newClass=class'GameStatsTab.SyringeFire')
    fireModeReplacement(46)=(oldClass=class'KFMod.UnWeldFire',newClass=class'GameStatsTab.UnWeldFire')
    fireModeReplacement(47)=(oldClass=class'KFMod.WeldFire',newClass=class'GameStatsTab.WeldFire')
    fireModeReplacement(48)=(oldClass=class'KFMod.WinchesterFire',newClass=class'GameStatsTab.WinchesterFire')
}
