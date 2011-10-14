class GSTInvasionLoginMenu extends SRInvasionLoginMenu;

// We want to get ride of this menu!
function bool NotifyLevelChange() { 
    bPersistent = false;
    return true;
}

function InitComponent(GUIController MyController, GUIComponent MyComponent) {
    Super(UT2K4PlayerLoginMenu).InitComponent(MyController, MyComponent);
    c_Main.RemoveTab(Panels[0].Caption);
    c_Main.ActivateTabByName(Panels[1].Caption, true);
}

defaultproperties {
    Panels(5)=(ClassName="GameStatsTab_ServerPerks.GSTMidGameStats",Caption="Game Stats",Hint="View stats about your current game")
}
