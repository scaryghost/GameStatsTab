class GSTConsoleCommands extends Object
    abstract;

var array<string> commandNameList;
var string consoleTextColor, statTextColor;
var bool isInitialized;

static function init() {
    if (!default.isInitialized) {
        default.consoleTextColor= chr(27)$chr(1)$chr(255)$chr(1);
        default.statTextColor= chr(27)$chr(255)$chr(255)$chr(1);
        default.isInitialized= true;
    }
}

static function string formatTime(int seconds) {
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


static function help(PlayerController sender) {
    local int i;
    sender.player.console.message(default.consoleTextColor$"GameStatsTab commands: mutate GameStatsTab [command] [parameters]", 5.0);
    sender.Player.Console.Message(default.consoleTextColor$"commands:", 5.0);

    for(i= 0; i < default.commandNameList.Length; i++) {
        sender.Player.Console.Message(default.consoleTextColor$default.commandNameList[i], 5.0);
    }
}

static function listInfo(array<string> params, Controller cList, PlayerController sender) {
    local int index;
    local Controller c;
    local PlayerController pc;
    local GSTPlayerController gsPC;
    local string msgBase;
    local array<string> messageLines;

    index= 0;
    switch (params[0]) {
        case "players":
            messageLines[messageLines.Length]= "Index       Player Name";
            messageLines[messageLines.Length]= "-----------------------";
            for (c= cList; c != None; c= c.NextController) {
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
            gsPC= GSTPlayerController(sender);
            messageLines[messageLines.Length]= "Index       Stat Name";
            messageLines[messageLines.Length]= "-----------------------";
            for(index= 0; index < ArrayCount(gsPC.descripArray); index++) {
                if (index < 10) {
                    msgBase= "["$index$"]          ";
                } else {
                    msgBase= "["$index$"]        ";
                }
                messageLines[messageLines.Length]= msgBase$gsPC.descripArray[index];
            }
            break;
        
        case "help":
        default:
            messageLines[messageLines.Length]= "Usage: mutate GameStatsTab list [players|stats|help]";
            messageLines[messageLines.Length]= "Displays the indices for the corresponding player names or stats";
            break;
    }

    for(index= 0; index < messageLines.Length; index++) {
        sender.Player.Console.Message(default.consoleTextColor$messageLines[index], 5.0);
    }
}

static function getStat(array<string> params, Controller cList, PlayerController sender) {
    local Controller c;
    local GSTPlayerController gsPC;
    local int playerIndex, statIndex;
    local int index;
    local array<string> strSplit;
    local string playerName, statMsg;
    
    if (params[0] == "help") {
        sender.Player.Console.Message(default.consoleTextColor$"Usage: mutate GameStatsTab getstat player={index} stat={index}", 5.0);
        sender.Player.Console.Message(default.consoleTextColor$"Retrieves the requested stat for the desired player.", 5.0);
        return;
    }

    playerIndex= -1;
    statIndex= -1;
    for(index= 0; index < params.Length; index++) {
        Split(params[index],"=",strSplit);
        switch(strSplit[0]) {
            case "player":
                playerIndex= int(strSplit[1]);
                break;
            case "stat":
                statIndex= int(strSplit[1]);
                break;
        }
    }

    if (playerIndex == -1 || statIndex == -1) {
        sender.Player.Console.Message(default.consoleTextColor$"Usage: mutate GameStatsTab getstat player={index} stat={index}", 5.0);
        return;
    }

    //Added this to search for the first PlayerController in the list
    index= 0;
    for (c= cList; c != None && PlayerController(c) == None; c= c.NextController);
    for (c= c; c != None && index != playerIndex; c= c.NextController) {
        if (PlayerController(c) != None) {
            index++;
        }
    }
    playerName= PlayerController(c).PlayerReplicationInfo.PlayerName;
    gsPC= GSTPlayerController(c);
    statMsg= default.statTextColor$playerName$" - "$gsPC.descripArray[statIndex]$": ";
    if (statIndex == gsPC.EStatKeys.TIME_ALIVE) {
        statMsg= statMsg$formatTime(gsPC.getStatValue(statIndex));
    } else {
        statMsg= statMsg$int(gsPC.getStatValue(statIndex));
    }
    sender.Player.Console.Message(statMsg, 5.0);
}

defaultproperties {
    commandNameList(0)="help"
    commandNameList(1)="list"
    commandNameList(2)="getstat"

    consoleTextColor= ""
    isInitialized= false;
}
