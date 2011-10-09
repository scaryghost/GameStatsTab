class GSTMidGameStats extends MidGamePanel;

var automated GUISectionBackground i_BGPerks;
var automated GSTStatListBox    lb_StatSelect;

var() noexport bool bTeamGame;

function ShowPanel(bool bShow) {
    local GSTStats statsObj;

    super.ShowPanel(bShow);

    if ( bShow ) {
        statsObj= Class'GameStatsTab.GameStatsTabMut'.Static.findStats(PlayerOwner().getPlayerIDHash());
        lb_StatSelect.statList.InitList(statsObj);
        SetupGroups();
    }
}

function SetupGroups() {
    local int i;

    for ( i = 0; i < Controls.Length; i++ ) {
        if ( Controls[i] != i_BGPerks && Controls[i] != lb_StatSelect ) {
            RemoveComponent(Controls[i], True);
        }
    }

    RemapComponents();
}

defaultproperties {
    Begin Object Class=GUISectionBackground Name=BGPerks
        bFillClient=True
        Caption="Stats"
        WinTop=0.012063
        WinLeft=0.019240
        WinWidth=0.961520
        WinHeight=0.796032
        OnPreDraw=BGPerks.InternalPreDraw
    End Object
    i_BGPerks=GUISectionBackground'GameStatsTab.GSTMidGameStats.BGPerks'

    Begin Object Class=GSTStatListBox Name=StatSelectList
        OnCreateComponent=StatSelectList.InternalOnCreateComponent
        WinTop=0.057760
        WinLeft=0.029240
        WinWidth=0.941520
        WinHeight=0.742836
    End Object
    lb_StatSelect=GSTStatListBox'GameStatsTab.GSTMidGameStats.StatSelectList'
}
