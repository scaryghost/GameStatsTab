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

exec function gamestatstab(string params) {
    local array<string> paramArray;
    local string func;

    Split(params, " ", paramArray);
    func= paramArray[0];
    paramArray.Remove(0,1);
    switch(func) {
        case consolecommands[1]:
            listInfo(paramArray);
            break;
        case consolecommands[2]:
            getStat(paramArray);
            break;
        case consolecommands[0]:
        default:
            gsthelp();
            break;
    }
}

function gsthelp() {
    local int i;

    Player.console.message(consoleTextColor$"GameStatsTab console commands:", 5.0);
    Player.console.message(consoleTextColor$"Format: gamestatstab [command] [parameters]", 5.0);
    for(i= 0; i < consolecommands.Length; i++) {
        Player.Console.Message(consoleTextColor$consolecommands[i], 5.0);
    }
}

function listInfo(array<string> paramArray) {
    local int index;
    local GSTPlayerController gsPC;
    local string msgBase;
    local array<string> messageLines;

    index= 0;
    switch (paramArray[0]) {
        case "player":
            messageLines[messageLines.Length]= "Index       Player Name";
            messageLines[messageLines.Length]= "-----------------------";
            foreach AllActors(class'GSTPlayerController', gsPC) {
                if (index < 10) {
                    msgBase= "["$index$"]          ";
                } else {
                    msgBase= "["$index$"]         ";
                }
                messageLines[messageLines.Length]= msgBase$gsPC.PlayerReplicationInfo.PlayerName;
                index++;
            }
            break;
        case "stat":
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
            messageLines[messageLines.Length]= "Usage: gamestatstab list [player|stat|help]";
            messageLines[messageLines.Length]= "Displays the indices for the corresponding player names or stats";
            break;
    }

    for(index= 0; index < messageLines.Length; index++) {
        Player.Console.Message(consoleTextColor$messageLines[index], 5.0);
    }

}

static function string formatTime(int seconds) {
    local string timeStr;
    local int i;
    local array<int> timeValues;
    
    timeValues.Length= 3;
    timeValues[0]= seconds / 3600;
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

function getstat(array<string> paramArray) {
    local GSTPlayerController gsPC;
    local int playerIndex, statIndex, index;
    local array<string> strSplit;
    local string playerName, statMsg;
    
    playerIndex= -1;
    statIndex= -1;
    for(index= 0; index < paramArray.Length; index++) {
        Split(paramArray[index],"=",strSplit);
        switch(strSplit[0]) {
            case "player":
                playerIndex= int(strSplit[1]);
                break;
            case "stat":
                statIndex= int(strSplit[1]);
                break;
            case "help":
                Player.Console.Message(consoleTextColor$"Usage: gstgetstat player={index} stat={index}", 5.0);
                Player.Console.Message(consoleTextColor$"Retrieves the requested stat for the desired player.", 5.0);
                return;
        }
    }

    if (playerIndex == -1 || statIndex == -1) {
        Player.Console.Message(consoleTextColor$"Usage: gstgetstat player={index} stat={index}", 5.0);
        return;
    }

    index= 0;
    foreach AllActors(class'GSTPlayerController', gsPC) {
        if (index == playerIndex)
            break;
        index++;
    }
    playerName= gsPC.PlayerReplicationInfo.PlayerName;
    statMsg= statTextColor$playerName$" - "$gsPC.descripArray[statIndex]$": ";
    if (statIndex == gsPC.EStatKeys.TIME_ALIVE) {
        statMsg= statMsg$formatTime(gsPC.getStatValue(statIndex));
    } else {
        statMsg= statMsg$int(gsPC.getStatValue(statIndex));
    }
    Player.Console.Message(statMsg, 5.0);
}

defaultproperties {
    consolecommands(0)="help"
    consolecommands(1)="list"
    consolecommands(2)="getstat"
}
