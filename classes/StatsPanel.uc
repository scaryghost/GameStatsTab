class StatsPanel extends KFInvasionLoginMenu;

function InitComponent(GUIController MyController, GUIComponent MyComponent) {
    Panels.Remove(3,Panels.Length-1);
    super(UT2K4PlayerLoginMenu).InitComponent(MyController, MyComponent);
}

defaultproperties {
    Panels(0)=(ClassName="GameStatsTab.PlayerStatsPanel",Caption="Player Stats",Hint="Damage taken, time alive, etc.")
    Panels(1)=(ClassName="GameStatsTab.WeaponStatsPanel",Caption="Weapon Stats",Hint="Rounds fired, shells fired, etc.")
    Panels(2)=(ClassName="GameStatsTab.ZedStatsPanel",Caption="ZED Stats",Hint="Clot kills, backstabs, etc.")
    WindowName="Game Statistics"
}
