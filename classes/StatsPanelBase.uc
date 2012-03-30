class StatsPanelBase extends MidGamePanel;

var automated GSTStatListBox lb_StatSelect;
var array<string> description;

defaultproperties {
    Begin Object Class=GSTStatListBox Name=StatSelectList
        OnCreateComponent=StatSelectList.InternalOnCreateComponent
        WinTop=0.057760
        WinLeft=0.029240
        WinWidth=0.941520
        WinHeight=0.742836
    End Object
    lb_StatSelect=GSTStatListBox'GameStatsTab.StatsPanelBase.StatSelectList'
}
