class GSTPlayerController extends KFPlayerController;

enum EStatKeys {
    TIME_ALIVE,
    CRAWLER_KILLS,
    STALKER_KILLS,
    CLOT_KILLS,
    GOREFAST_KILLS,
    BLOAT_KILLS,
    SIREN_KILLS,
    HUSK_KILLS,
    SCRAKE_KILLS,
    FLESHPOUND_KILLS,
    PATRIARCH_KILLS,
    ROUNDS_FIRED,
    GRENADES_LAUNCHED,
    ROCKETS_LAUNCHED,
    BOLTS_FIRED,
    SHELLS_FIRED,
    UNITS_FUEL,
    MELEE_SWINGS,
    BACKSTABS,
    FRAGS_TOSSED,
    PIPES_SET,
    NUM_DECAPS,
    HEALING_RECIEVED,
    DAMAGE_TAKEN,
    SHIELD_LOST,
    FF_DAMAGE_DEALT,
    FLESHPOUNDS_RAGED,
    SCRAKES_RAGED,
    SCRAKES_STUNNED,
    SHOT_BY_HUSK
};

var protected array<float> statArray[30];
var array<string> descripArray[ArrayCount(statArray)];
var float prevHealth, prevShield;

var array<string> consolecommands;
var string consoleTextColor, statTextColor;

replication {
    reliable if (bNetOwner && Role == ROLE_Authority)
        statArray;
}

simulated function PostBeginPlay() {
    super.PostBeginPlay();

    /**
     * Should be handled in the defaultproperties but the compiler
     * thinks all enum values are 0 at compile time and flags an error
     */
    descripArray[EStatKeys.TIME_ALIVE]="Time alive";
    descripArray[EStatKeys.CRAWLER_KILLS]="Crawler kills";
    descripArray[EStatKeys.STALKER_KILLS]="Stalker kills";
    descripArray[EStatKeys.CLOT_KILLS]="Clot kills";
    descripArray[EStatKeys.GOREFAST_KILLS]="Gorefast kills";
    descripArray[EStatKeys.BLOAT_KILLS]="Bloat kills";
    descripArray[EStatKeys.SIREN_KILLS]="Siren kills";
    descripArray[EStatKeys.HUSK_KILLS]="Husk kills";
    descripArray[EStatKeys.SCRAKE_KILLS]="Scrake kills";
    descripArray[EStatKeys.FLESHPOUND_KILLS]="Fleshpound kills";
    descripArray[EStatKeys.PATRIARCH_KILLS]="Patriarch kills";
    descripArray[EStatKeys.ROUNDS_FIRED]="Rounds fired";
    descripArray[EStatKeys.MELEE_SWINGS]="Melee swings";
    descripArray[EStatKeys.FRAGS_TOSSED]="Frags tossed";
    descripArray[EStatKeys.PIPES_SET]="Pipes set";
    descripArray[EStatKeys.NUM_DECAPS]="Decapitations";
    descripArray[EStatKeys.HEALING_RECIEVED]="Total healing received";
    descripArray[EStatKeys.DAMAGE_TAKEN]="Total damage taken";
    descripArray[EStatKeys.SHIELD_LOST]="Total shield lost";
    descripArray[EStatKeys.FF_DAMAGE_DEALT]="Friendly fire damage";
    descripArray[EStatKeys.FLESHPOUNDS_RAGED]="Enraged a fleshpound";
    descripArray[EStatKeys.SCRAKES_RAGED]="Enraged a scrake";
    descripArray[EStatKeys.SCRAKES_STUNNED]="Stunned a scrake";
    descripArray[EStatKeys.SHOT_BY_HUSK]="Shot by husk";
    descripArray[EStatKeys.UNITS_FUEL]="Units of fuel consumed";
    descripArray[EStatKeys.SHELLS_FIRED]="Shells fired";
    descripArray[EStatKeys.GRENADES_LAUNCHED]="Grenades launched";
    descripArray[EStatKeys.ROCKETS_LAUNCHED]="Rockets launched";
    descripArray[EStatKeys.BACKSTABS]="Backstabs";
    descripArray[EStatKeys.BOLTS_FIRED]="Bolts fired";

    consoleTextColor= chr(27)$chr(1)$chr(255)$chr(1);
    statTextColor= chr(27)$chr(255)$chr(255)$chr(1);
}

function incrementStat(byte statKey, float value) {
    statArray[statKey]+= value;
}

function float getStatValue(byte statKey) {
    return statArray[statKey];
}

function SetPawnClass(string inClass, string inCharacter) {
    PawnClass = Class'GameStatsTab.GSTHumanPawn';
    inCharacter = Class'KFGameType'.Static.GetValidCharacter(inCharacter);
    PawnSetupRecord = class'xUtil'.static.FindPlayerRecord(inCharacter);
    PlayerReplicationInfo.SetCharacterName(inCharacter);
}

function PawnDied(Pawn P) {
    super.PawnDied(P);

    statArray[EStatKeys.DAMAGE_TAKEN]+= prevHealth;
    statArray[EStatKeys.SHIELD_LOST]+= prevShield;
}

exec function gsthelp() {
    local int i;

    Player.console.message(consoleTextColor$"GameStatsTab console commands:", 5.0);
    for(i= 0; i < consolecommands.Length; i++) {
        Player.Console.Message(consoleTextColor$consolecommands[i], 5.0);
    }
}

exec function gstlist(string key) {
    local int index;
    local Controller c;
    local PlayerController pc;
    local string msgBase;
    local array<string> messageLines;

    index= 0;
    switch (key) {
        case "players":
            messageLines[messageLines.Length]= "Index       Player Name";
            messageLines[messageLines.Length]= "-----------------------";
            for (c= Level.ControllerList; c != None; c= c.NextController) {
                pc= PlayerController(c);
                if (pc != None) {
                    if (index < 10) {
                        msgBase= "["$index$"]          ";
                    } else {
                        msgBase= "["$index$"]         ";
                    }
                    messageLines[messageLines.Length]= msgBase$pc.PlayerReplicationInfo.PlayerName;
                    index++;
                }
            }
            break;
        case "stats":
            messageLines[messageLines.Length]= "Index       Stat Name";
            messageLines[messageLines.Length]= "-----------------------";
            for(index= 0; index < ArrayCount(descripArray); index++) {
                if (index < 10) {
                    msgBase= "["$index$"]          ";
                } else {
                    msgBase= "["$index$"]        ";
                }
                messageLines[messageLines.Length]= msgBase$descripArray[index];
            }
            break;
        
        case "help":
        default:
            messageLines[messageLines.Length]= "Usage: gstlist [players|stats|help]";
            messageLines[messageLines.Length]= "Displays the indices for the corresponding player names or stats";
            break;
    }

    for(index= 0; index < messageLines.Length; index++) {
        Player.Console.Message(consoleTextColor$messageLines[index], 5.0);
    }

}

function string formatTime(int seconds) {
    local string timeStr;
    local int i;
    local array<int> timeValues;
    
    timeValues.Length= 3;
    timeValues[0]= seconds / 3660;
    timeValues[1]= seconds / 60;
    timeValues[2]= seconds % 60;
    for(i= 0; i < timeValues.Length; i++) {
        if (timeValues[i] < 10) {
            timeStr= timeStr$"0"$timeValues[i];
        } else {
            timeStr= timeStr$timeValues[i];
        }
        if (i < timeValues.Length-1) {
            timeStr= timeStr$":";
        }
    }

    return timeStr;
}

exec function gstgetstat(string playerStr, string statStr) {
    local Controller c;
    local GSTPlayerController gsPC;
    local int playerIndex, statIndex;
    local int index;
    local array<string> strSplit;
    local string playerName, statMsg;
    
    if (playerStr == "help" || statStr == "help") {
        Player.Console.Message(consoleTextColor$"Usage: gstgetstat player={index} stat={index}", 5.0);
        Player.Console.Message(consoleTextColor$"Retrieves the requested stat for the desired player.", 5.0);
        return;
    }

    playerIndex= -1;
    statIndex= -1;
    Split(playerStr,"=",strSplit);
    playerIndex= int(strSplit[1]);
    Split(statStr,"=",strSplit);
    statIndex= int(strSplit[1]);

    if (playerIndex == -1 || statIndex == -1) {
        Player.Console.Message(consoleTextColor$"Usage: gstgetstat player={index} stat={index}", 5.0);
        return;
    }

    //Added this to search for the first PlayerController in the list
    index= 0;
    for (c= Level.ControllerList; c != None && PlayerController(c) == None; c= c.NextController);
    for (c= c; c != None && index != playerIndex; c= c.NextController) {
        if (PlayerController(c) != None) {
            index++;
        }
    }
    playerName= PlayerController(c).PlayerReplicationInfo.PlayerName;
    gsPC= GSTPlayerController(c);
    statMsg= statTextColor$playerName$" - "$gsPC.descripArray[statIndex]$": ";
    if (statIndex == gsPC.EStatKeys.TIME_ALIVE) {
        statMsg= statMsg$formatTime(gsPC.getStatValue(statIndex));
    } else {
        statMsg= statMsg$int(gsPC.getStatValue(statIndex));
    }
    Player.Console.Message(statMsg, 5.0);
}

defaultproperties {
    consolecommands(0)="gsthelp"
    consolecommands(1)="gstlist"
    consolecommands(2)="gstgetstat"
}
