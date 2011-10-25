class GSTConsoleCommands extends Object;

static function listInfo(array<string> params, Controller cList, PlayerController sender) {
    local int index;
    local Controller c;
    local PlayerController pc;
    local GSTPlayerController gsPC;

    index= 0;
    switch (params[0]) {
        case  "help":
            sender.Player.Console.Message("Usage: mutator list [players|stats]", 5.0);
            sender.Player.Console.Message("Displays the indices for the corresponding player names or stats", 5.0);
            break;
        case "players":
            for (c= cList; c != None; c= c.NextController) {
                pc= PlayerController(c);
                if (pc != None) {
                    sender.Player.Console.Message("["$index$"] "$pc.PlayerReplicationInfo.PlayerName, 5.0);
                }
                index++;
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
    local int playerIndex, statIndex;
    local int i;
    
    if (params[0] == "help") {
        sender.Player.Console.Message("Usage: mutator getstat player={index} stat={index}", 5.0);
        sender.Player.Console.Message("Retreives the requested stat for the desired player.", 5.0);
        return;
    }

    for(i= 0; i < params.Length; i++) {
        
    }
    
        
}
