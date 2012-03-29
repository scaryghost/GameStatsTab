class StatsPanel extends KFInvasionLoginMenu;

function InitComponent(GUIController MyController, GUIComponent MyComponent) {
    super(UT2K4PlayerLoginMenu).InitComponent(MyController, MyComponent);
}

defaultproperties {
    Panels(0)=(ClassName="GameStatsTab.GSTMidGameStats",Caption="Game Stats",Hint="View stats about your current game")
    WindowName="Game Statistics"
}
