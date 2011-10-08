class GSTStatListBox extends GUIListBoxBase;

var GSTStatList statList;

function InitComponent(GUIController MyController, GUIComponent MyOwner) {
    DefaultListClass = string(Class'GameStatsTab.GSTStatList');
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
}
