class GSTConsoleCommands extends Object
    abstract;

var array<string> commandNameList;
var string consoleTextColor;
var bool isInitialized;

static function init() {
    if (!default.isInitialized) {
        default.consoleTextColor= chr(27)$chr(1)$chr(255)$chr(1);
        default.isInitialized= true;
    }
}

static function help(PlayerController sender) {
    local int i;
    sender.player.console.message(default.consoleTextColor$"GameStatsTab commands: mutate [command] [parameters]", 5.0);
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
        case "help":
            messageLines[messageLines.Length]= "Usage: mutate list [players|stats|help]";
            messageLines[messageLines.Length]= "Displays the indices for the corresponding player names or stats";
            break;
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
    }

    for(index= 0; index < messageLines.Length; index++) {
        sender.Player.Console.Message(default.consoleTextColor$messageLines[index], 5.0);
    }
}

static function getInfo(array<string> params, Controller cList, PlayerController sender) {
    local Controller c;
    local GSTPlayerController gsPC;
    local int playerIndex, statIndex;
    local int i,index;
    local array<string> strSplit;
    local string playerName;
    
    if (params[0] == "help") {
        sender.Player.Console.Message(default.consoleTextColor$"Usage: mutate getstat player={index} stat={index}", 5.0);
        sender.Player.Console.Message(default.consoleTextColor$"Retrieves the requested stat for the desired player.", 5.0);
        return;
    }

    playerIndex= -1;
    statIndex= -1;
    for(i= 0; i < params.Length; i++) {
        Split(params[i],"=",strSplit);
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
        sender.Player.Console.Message(default.consoleTextColor$"Usage: mutate getstat player={index} stat={index}", 5.0);
        return;
    }
    
    for (c= cList; c != None && index != playerIndex; c= c.NextController) {
        if (PlayerController(c) != None) {
            index++;
        }
    }
    playerName= PlayerController(c).PlayerReplicationInfo.PlayerName;
    gsPC= GSTPlayerController(C);
    sender.Player.Console.Message(default.consoleTextColor$playerName$" - "$gsPC.descripArray[statIndex]$": "$int(gsPC.getStatValue(statIndex)), 5.0);
}

defaultproperties {
    commandNameList(0)="help"
    commandNameList(1)="list"
    commandNameList(2)="getstat"

    consoleTextColor= ""
    isInitialized= false;
}
