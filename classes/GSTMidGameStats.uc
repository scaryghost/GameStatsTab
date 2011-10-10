class GSTMidGameStats extends MidGamePanel;

var automated GUISectionBackground i_BGPerks;
var automated GSTStatListBox    lb_StatSelect;
var automated moSlider sl_bgR, sl_bgG, sl_bgB, sl_txtR, sl_txtG, sl_txtB, sl_alpha;

var() noexport bool bTeamGame;
var() noexport transient int bgR, bgG, bgB, txtR, txtG, txtB, alpha;

function ShowPanel(bool bShow) {
    local GSTPlayerController gsPC;

    super.ShowPanel(bShow);

    if ( bShow ) {
        gsPC= GSTPlayerController(PlayerOwner());
        lb_StatSelect.statList.InitList(gsPC.descripArray, gsPC.statArray);
    }

    EnableComponent(sl_bgR);
    EnableComponent(sl_bgG);
    EnableComponent(sl_bgB);
    EnableComponent(sl_txtR);
    EnableComponent(sl_txtG);
    EnableComponent(sl_txtB);
    EnableComponent(sl_alpha);
}

function InternalOnLoadINI(GUIComponent Sender, string s) {
    local PlayerController PC;

    PC= PlayerOwner();
    switch (Sender) {
        case sl_bgR:
            bgR= int(PC.ConsoleCommand("get GameStatsTab.GameStatsTabMut bgR "));
            sl_bgR.SetComponentValue(bgR, true);
            break;
        case sl_bgG:
            bgG= int(PC.ConsoleCommand("get GameStatsTab.GameStatsTabMut bgG "));
            sl_bgG.SetComponentValue(bgG, true);
            break;
        case sl_bgB:
            bgB= int(PC.ConsoleCommand("get GameStatsTab.GameStatsTabMut bgB "));
            sl_bgB.SetComponentValue(bgB, true);
            break;
        case sl_txtR:
            txtR= int(PC.ConsoleCommand("get GameStatsTab.GameStatsTabMut txtR "));
            sl_txtR.SetComponentValue(txtR, true);
            break;
        case sl_txtG:
            txtG= int(PC.ConsoleCommand("get GameStatsTab.GameStatsTabMut txtG "));
            sl_txtG.SetComponentValue(txtG, true);
            break;
        case sl_txtB:
            txtB= int(PC.ConsoleCommand("get GameStatsTab.GameStatsTabMut txtB "));
            sl_txtB.SetComponentValue(txtB, true);
            break;
        case sl_alpha:
            alpha= int(PC.ConsoleCommand("get GameStatsTab.GameStatsTabMut alpha "));
            sl_alpha.SetComponentValue(alpha, true);
            break;
    }
}

function InternalOnChange(GUIComponent Sender) {
    local PlayerController PC;

    PC= PlayerOwner();
    switch (Sender) {
        case sl_bgR:
            bgR= sl_bgR.GetValue();
            class'GameStatsTabMut'.default.bgR= bgR;
            PC.ConsoleCommand("set GameStatsTab.GameStatsTabMut bgR "$bgR);
            break;
        case sl_bgG:
            bgG= sl_bgG.GetValue();
            class'GameStatsTabMut'.default.bgG= bgG;
            PC.ConsoleCommand("set GameStatsTab.GameStatsTabMut bgG "$bgG);
            break;
        case sl_bgB:
            bgB= sl_bgB.GetValue();
            class'GameStatsTabMut'.default.bgB= bgB;
            PC.ConsoleCommand("set GameStatsTab.GameStatsTabMut bgB "$bgB);
            break;
        case sl_txtR:
            txtR= sl_txtR.GetValue();
            class'GameStatsTabMut'.default.txtR= txtR;
            PC.ConsoleCommand("set GameStatsTab.GameStatsTabMut txtR "$txtR);
            break;
        case sl_txtG:
            txtG= sl_txtG.GetValue();
            class'GameStatsTabMut'.default.txtG= txtG;
            PC.ConsoleCommand("set GameStatsTab.GameStatsTabMut txtG "$txtG);
            break;
        case sl_txtB:
            txtB= sl_txtB.GetValue();
            class'GameStatsTabMut'.default.txtB= txtB;
            PC.ConsoleCommand("set GameStatsTab.GameStatsTabMut txtB "$txtB);
            break;
        case sl_alpha:
            alpha= sl_alpha.GetValue();
            class'GameStatsTabMut'.default.alpha= alpha;
            PC.ConsoleCommand("set GameStatsTab.GameStatsTabMut alpha "$alpha);
            break;
    }
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

    Begin Object Class=moSlider Name=BackgroundRedSlider
        MaxValue=255
        MinValue=0
        SliderCaptionStyleName=""
        CaptionWidth=0.550000
        Caption="BG Red"
        OnCreateComponent=BackgroundRedSlider.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="255"
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
        IniDefault="255"
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
        IniDefault="255"
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
        WinTop=0.95
        WinLeft=0.25
        WinWidth=0.461445
        TabOrder=2
        OnChange=GSTMidGameStats.InternalOnChange
        OnLoadINI=GSTMidGameStats.InternalOnLoadINI
    End Object
    sl_alpha=moSlider'GameStatsTab.GSTMidGameStats.AlphaSlider'
}
