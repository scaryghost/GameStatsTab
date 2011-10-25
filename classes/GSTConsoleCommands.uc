class GSTConsoleCommands extends Object
    abstract;

var array<string> commandNameList;

static function help(PlayerController sender) {
    local int i;
    sender.player.console.message("GameStatsTab commands: mutate [command] [parameters]", 5.0);
    sender.Player.Console.Message("commands:", 5.0);

    for(i= 0; i < default.commandNameList.Length; i++) {
        sender.Player.Console.Message(default.commandNameList[i], 5.0);
    }
}

static function listInfo(array<string> params, Controller cList, PlayerController sender) {
    local int index;
    local Controller c;
    local PlayerController pc;
    local GSTPlayerController gsPC;

    index= 0;
    switch (params[0]) {
        case "help":
            sender.Player.Console.Message("Usage: mutate list [players|stats|help]", 5.0);
            sender.Player.Console.Message("Displays the indices for the corresponding player names or stats", 5.0);
            break;
        case "players":
            for (c= cList; c != None; c= c.NextController) {
                pc= PlayerController(c);
                if (pc != None) {
                    sender.Player.Console.Message("["$index$"] "$pc.PlayerReplicationInfo.PlayerName, 5.0);
                    index++;
                }
            }
            break;
        case "stats":
            gsPC= GSTPlayerController(sender);
            for(index= 0; index < ArrayCount(gsPC.descripArray); index++) {
                sender.Player.Console.Message("["$index$"] "$gsPC.descripArray[index], 5.0);
            }
            break;
    }
}

static function getInfo(array<string> params, Controller cList, PlayerController sender) {
    local Controller c;
    local GSTPlayerController gsPC;
    local int playerIndex, statIndex;
    local int i,index;
    local array<string> strSplit;
    
    if (params[0] == "help") {
        sender.Player.Console.Message("Usage: mutate getstat player={index} stat={index}", 5.0);
        sender.Player.Console.Message("Retrieves the requested stat for the desired player.", 5.0);
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
        sender.Player.Console.Message("Usage: mutate getstat player={index} stat={index}", 5.0);
        return;
    }
    
    for (c= cList; c != None && index != playerIndex; c= c.NextController) {
        if (PlayerController(c) != None) {
            index++;
        }
    }
    gsPC= GSTPlayerController(C);
    sender.Player.Console.Message(gsPC.descripArray[statIndex]$": "$gsPC.getStatValue(statIndex), 5.0);
}

defaultproperties {
    commandNameList(0)="help"
    commandNameList(1)="list"
    commandNameList(2)="getstat"
}
