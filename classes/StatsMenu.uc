class StatsMenu extends KFInvasionLoginMenu;

function InitComponent(GUIController MyController, GUIComponent MyComponent) {
    super(UT2K4PlayerLoginMenu).InitComponent(MyController, MyComponent);
}

function SetTitle() {
    WindowName= default.WindowName;
}

defaultproperties {
    Panels(0)=(ClassName="GameStatsTab.PlayerStatsPanel",Caption="Player",Hint="Damage taken, time alive, etc.")
    Panels(1)=(ClassName="GameStatsTab.WeaponStatsPanel",Caption="Weapon",Hint="Rounds fired, shells fired, etc.")
    Panels(2)=(ClassName="GameStatsTab.ZedStatsPanel",Caption="Zed",Hint="Clot kills, backstabs, etc.")
    Panels(3)=(ClassName="GameStatsTab.PanelSettings",Caption="Settings",Hint="Adjust settings for the stat panels")
    WindowName="Game Statistics"
}
