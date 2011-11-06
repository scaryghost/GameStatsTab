class GSTMidGameStats extends MidGamePanel;

var automated GUISectionBackground i_BGPerks;
var automated GSTStatListBox    lb_StatSelect;
var automated moSlider sl_bgR, sl_bgG, sl_bgB, 
        sl_txtR, sl_txtG, sl_txtB, sl_alpha, sl_txtScale;

var() noexport bool bTeamGame;
var() noexport transient int bgR, bgG, bgB, txtR, txtG, txtB, alpha;
var() noexport float txtScale;

var string setProp, getProp;

function ShowPanel(bool bShow) {
    local GSTPlayerReplicationInfo pri;

    super.ShowPanel(bShow);

    if ( bShow ) {
        pri= GSTPlayerReplicationInfo(PlayerOwner().PlayerReplicationInfo);
        lb_StatSelect.statList.InitList(pri);
    }

    EnableComponent(sl_bgR);
    EnableComponent(sl_bgG);
    EnableComponent(sl_bgB);
    EnableComponent(sl_txtR);
    EnableComponent(sl_txtG);
    EnableComponent(sl_txtB);
    EnableComponent(sl_alpha);
    EnableComponent(sl_txtScale);
}

function InternalOnLoadINI(GUIComponent Sender, string s) {
    local PlayerController PC;

    PC= PlayerOwner();
    switch (Sender) {
        case sl_bgR:
            bgR= int(PC.ConsoleCommand(getProp$" bgR "));
            sl_bgR.SetComponentValue(bgR, true);
            break;
        case sl_bgG:
            bgG= int(PC.ConsoleCommand(getProp$" bgG "));
            sl_bgG.SetComponentValue(bgG, true);
            break;
        case sl_bgB:
            bgB= int(PC.ConsoleCommand(getProp$" bgB "));
            sl_bgB.SetComponentValue(bgB, true);
            break;
        case sl_txtR:
            txtR= int(PC.ConsoleCommand(getProp$" txtR "));
            sl_txtR.SetComponentValue(txtR, true);
            break;
        case sl_txtG:
            txtG= int(PC.ConsoleCommand(getProp$" txtG "));
            sl_txtG.SetComponentValue(txtG, true);
            break;
        case sl_txtB:
            txtB= int(PC.ConsoleCommand(getProp$" txtB "));
            sl_txtB.SetComponentValue(txtB, true);
            break;
        case sl_alpha:
            alpha= int(PC.ConsoleCommand(getProp$" alpha "));
            sl_alpha.SetComponentValue(alpha, true);
            break;
        case sl_txtScale:
            txtScale= float(PC.ConsoleCommand(getProp$" txtScale "));
            sl_txtScale.SetComponentValue(txtScale, true);
            break;
    }
}

function InternalOnChange(GUIComponent Sender) {
    local PlayerController PC;

    PC= PlayerOwner();
    switch (Sender) {
        case sl_bgR:
            bgR= sl_bgR.GetValue();
            PC.ConsoleCommand(setProp$" bgR "$bgR);
            break;
        case sl_bgG:
            bgG= sl_bgG.GetValue();
            PC.ConsoleCommand(setProp$" bgG "$bgG);
            break;
        case sl_bgB:
            bgB= sl_bgB.GetValue();
            PC.ConsoleCommand(setProp$" bgB "$bgB);
            break;
        case sl_txtR:
            txtR= sl_txtR.GetValue();
            PC.ConsoleCommand(setProp$" txtR "$txtR);
            break;
        case sl_txtG:
            txtG= sl_txtG.GetValue();
            PC.ConsoleCommand(setProp$" txtG "$txtG);
            break;
        case sl_txtB:
            txtB= sl_txtB.GetValue();
            PC.ConsoleCommand(setProp$" txtB "$txtB);
            break;
        case sl_alpha:
            alpha= sl_alpha.GetValue();
            PC.ConsoleCommand(setProp$" alpha "$alpha);
            break;
        case sl_txtScale:
            txtScale= sl_txtScale.GetValue();
            PC.ConsoleCommand(setProp$" txtScale "$txtScale);
            break;
    }
}

defaultproperties {
    setProp= "set GameStatsTab.GSTStatList"
    getProp= "get GameStatsTab.GSTStatList"
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

    Begin Object Class=moSlider Name=BackgroundRedSlider
        MaxValue=255
        MinValue=0
        SliderCaptionStyleName=""
        CaptionWidth=0.550000
        Caption="BG Red"
        OnCreateComponent=BackgroundRedSlider.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="0"
        Hint="Adjust the red value of the stat background color"
        WinTop=0.85
        WinLeft=0.012188
        WinWidth=0.461445
        TabOrder=2
        OnChange=GSTMidGameStats.InternalOnChange
        OnLoadINI=GSTMidGameStats.InternalOnLoadINI
    End Object
    sl_bgR=moSlider'GameStatsTab.GSTMidGameStats.BackgroundRedSlider'

    Begin Object Class=moSlider Name=BackgroundGreenSlider
        MaxValue=255
        MinValue=0
        SliderCaptionStyleName=""
        CaptionWidth=0.550000
        Caption="BG Green"
        OnCreateComponent=BackgroundRedSlider.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="0"
        Hint="Adjust the green value of the stat background color"
        WinTop=0.875
        WinLeft=0.012188
        WinWidth=0.461445
        TabOrder=2
        OnChange=GSTMidGameStats.InternalOnChange
        OnLoadINI=GSTMidGameStats.InternalOnLoadINI
    End Object
    sl_bgG=moSlider'GameStatsTab.GSTMidGameStats.BackgroundGreenSlider'

    Begin Object Class=moSlider Name=BackgroundBlueSlider
        MaxValue=255
        MinValue=0
        SliderCaptionStyleName=""
        CaptionWidth=0.550000
        Caption="BG Blue"
        OnCreateComponent=BackgroundRedSlider.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="0"
        Hint="Adjust the blue value of the stat background color"
        WinTop=0.90
        WinLeft=0.012188
        WinWidth=0.461445
        TabOrder=2
        OnChange=GSTMidGameStats.InternalOnChange
        OnLoadINI=GSTMidGameStats.InternalOnLoadINI
    End Object
    sl_bgB=moSlider'GameStatsTab.GSTMidGameStats.BackgroundBlueSlider'

    Begin Object Class=moSlider Name=TextRedSlider
        MaxValue=255
        MinValue=0
        SliderCaptionStyleName=""
        CaptionWidth=0.550000
        Caption="Text Red"
        OnCreateComponent=TextRedSlider.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="255"
        Hint="Adjust the red value of the stat text color"
        WinTop=0.85
        WinLeft=0.5
        WinWidth=0.461445
        TabOrder=2
        OnChange=GSTMidGameStats.InternalOnChange
        OnLoadINI=GSTMidGameStats.InternalOnLoadINI
    End Object
    sl_txtR=moSlider'GameStatsTab.GSTMidGameStats.TextRedSlider'

    Begin Object Class=moSlider Name=TextGreenSlider
        MaxValue=255
        MinValue=0
        SliderCaptionStyleName=""
        CaptionWidth=0.550000
        Caption="Text Green"
        OnCreateComponent=TextRedSlider.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="255"
        Hint="Adjust the green value of the stat text color"
        WinTop=0.875
        WinLeft=0.5
        WinWidth=0.461445
        TabOrder=2
        OnChange=GSTMidGameStats.InternalOnChange
        OnLoadINI=GSTMidGameStats.InternalOnLoadINI
    End Object
    sl_txtG=moSlider'GameStatsTab.GSTMidGameStats.TextGreenSlider'

    Begin Object Class=moSlider Name=TextBlueSlider
        MaxValue=255
        MinValue=0
        SliderCaptionStyleName=""
        CaptionWidth=0.550000
        Caption="Text Blue"
        OnCreateComponent=TextRedSlider.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="255"
        Hint="Adjust the blue value of the stat text color"
        WinTop=0.90
        WinLeft=0.5
        WinWidth=0.461445
        TabOrder=2
        OnChange=GSTMidGameStats.InternalOnChange
        OnLoadINI=GSTMidGameStats.InternalOnLoadINI
    End Object
    sl_txtB=moSlider'GameStatsTab.GSTMidGameStats.TextBlueSlider'

    Begin Object Class=moSlider Name=AlphaSlider
        MaxValue=255
        MinValue=0
        SliderCaptionStyleName=""
        CaptionWidth=0.550000
        Caption="Alpha"
        OnCreateComponent=TextRedSlider.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="255"
        Hint="Adjust alpha of the stat panel"
        WinTop=0.925
        WinLeft=0.012188
        WinWidth=0.461445
        TabOrder=2
        OnChange=GSTMidGameStats.InternalOnChange
        OnLoadINI=GSTMidGameStats.InternalOnLoadINI
    End Object
    sl_alpha=moSlider'GameStatsTab.GSTMidGameStats.AlphaSlider'

    Begin Object Class=moSlider Name=TextScale
        MaxValue=1
        MinValue=0
        SliderCaptionStyleName=""
        CaptionWidth=0.550000
        Caption="Text Scale"
        OnCreateComponent=TextRedSlider.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="1"
        Hint="Adjust text size of the stat panel"
        WinTop=0.925
        WinLeft=0.5
        WinWidth=0.461445
        TabOrder=2
        OnChange=GSTMidGameStats.InternalOnChange
        OnLoadINI=GSTMidGameStats.InternalOnLoadINI
    End Object
    sl_txtScale=moSlider'GameStatsTab.GSTMidGameStats.TextScale'
}
