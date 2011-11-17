class GSTStatListBox extends GUIListBoxBase;

var GSTStatList statList;

function InitComponent(GUIController MyController, GUIComponent MyOwner) {
    Super.InitComponent(MyController,MyOwner);
    statList = GSTStatList(AddComponent(DefaultListClass));
    if (statList == None) {
        Warn(Class$".InitComponent - Could not create default list ["$DefaultListClass$"]");
        return;
    }
    InitBaseList(statList);
}

function int GetIndex() {
    return statList.Index;
}

defaultproperties {
    DefaultListClass="GameStatsTab.GSTStatList"
}
