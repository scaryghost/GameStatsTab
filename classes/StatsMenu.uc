class StatsMenu extends KFInvasionLoginMenu;

function InitComponent(GUIController MyController, GUIComponent MyComponent) {
    super(UT2K4PlayerLoginMenu).InitComponent(MyController, MyComponent);
}

function SetTitle() {
    WindowName= default.WindowName;
}

defaultproperties {
    Begin Object Class=GUITabControl Name=StatsMenuTC
        bDockPanels=True
        BackgroundStyleName="TabBackground"
        WinTop=0.026336
        WinLeft=0.012500
        WinWidth=0.974999
        WinHeight=0.055000
        bScaleToParent=True
        bAcceptsInput=True
        OnActivate=LoginMenuTC.InternalOnActivate
    End Object
    c_Main=GUITabControl'GameStatsTab.StatsMenu.StatsMenuTC'

    WinHeight=0.8125
    Panels(0)=(ClassName="GameStatsTab.PlayerStatsPanel",Caption="Player",Hint="Player related stats")
    Panels(1)=(ClassName="GameStatsTab.WeaponStatsPanel",Caption="Weapon",Hint="Stats about weapon usage")
    Panels(2)=(ClassName="GameStatsTab.KillStatsPanel",Caption="Kills",Hint="Breakdown of the kill count")
    Panels(3)=(ClassName="GameStatsTab.GameStatsPanel",Caption="Game",Hint="Death count and game info")
    Panels(4)=(ClassName="GameStatsTab.PanelSettings",Caption="Settings",Hint="Adjust settings for the stat panels")
    WindowName="Game Statistics"
}
