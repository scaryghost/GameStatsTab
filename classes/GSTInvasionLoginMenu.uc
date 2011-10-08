class GSTInvasionLoginMenu extends KFInvasionLoginMenu;

function bool NotifyLevelChange() // We want to get ride of this menu!
{
	bPersistent = false;
	return true;
}
function InitComponent(GUIController MyController, GUIComponent MyComponent)
{
	Super(UT2K4PlayerLoginMenu).InitComponent(MyController, MyComponent);
	c_Main.RemoveTab(Panels[0].Caption);
	c_Main.ActivateTabByName(Panels[1].Caption, true);
}

defaultproperties
{
     Panels(1)=(ClassName="GameStatsTab.GSTMidGamePerks",Hint="Select your current Perk/view your progress")
}
