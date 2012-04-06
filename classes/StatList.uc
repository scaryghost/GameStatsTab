class StatList extends GUIVertList
    config;

// Display
var texture InfoBackground;

// State
var localized array<string> statName;
var array<int>  statValue;
var int timeIndex;

var() config int bgR, bgG, bgB;
var() config int txtR, txtG, txtB;
var() config int alpha;
var() config float txtScale;

function bool PreDraw(Canvas Canvas) {
    return false;
}

function InitList(array<float> stats[16], array<string> descriptions) {
    local int i;
    // Update the ItemCount and select the first item
    itemCount= descriptions.Length;
    SetIndex(0);

    statValue.Length= itemCount;
    for(i= 0; i < itemCount; i++) {
        statName[i]= descriptions[i];
        statValue[i]= stats[i];
    }

    if ( bNotify ) {
        CheckLinkedObjects(Self);
    }

    if ( MyScrollBar != none ) {
        MyScrollBar.AlignThumb();
    }
}

function DrawStat(Canvas Canvas, int CurIndex, float X, float Y, 
        float Width, float Height, bool bSelected, bool bPending) {
    local float TempX, TempY;
    local float TempWidth, TempHeight;
    local string S;

    // Offset for the Background
    TempX = X;
    TempY = Y;

    // Initialize the Canvas
    Canvas.Style = 1;
    Canvas.Font = class'ROHUD'.Static.GetSmallMenuFont(Canvas);
    Canvas.FontScaleX= Canvas.default.FontScaleX * txtScale;
    Canvas.FontScaleY= Canvas.default.FontScaleY * txtScale;
    Canvas.SetDrawColor(bgR, bgG, bgB, alpha);

    // Draw Item Background
    Canvas.SetPos(TempX, TempY);
    Canvas.DrawTileStretched(InfoBackground, Width, Height);

    // Select Text Color
    Canvas.SetDrawColor(txtR, txtG, txtB, alpha);

    // Write stat name
    Canvas.TextSize(statName[CurIndex],TempWidth,TempHeight);
    TempX += Width*0.1f;
    TempY += (Height-TempHeight)*0.5f;
    Canvas.SetPos(TempX, TempY);
    Canvas.DrawText(statName[CurIndex]);

    // Write stat value
    if (curIndex == timeIndex) {
        S= class'GameStatsTab.GSTAuxiliary'.static.formatTime(statValue[CurIndex]);
    } else {
        S = string(statValue[CurIndex]);
    }
    Canvas.TextSize(S,TempWidth,TempHeight);
    Canvas.SetPos(X + Width*0.88f - TempWidth, TempY);
    Canvas.DrawText(S);
}

function float PerkHeight(Canvas c) {
    return ((MenuOwner.ActualHeight() / 14.0) - 1.0) * txtScale;
}

defaultproperties {
    InfoBackground=Texture'KF_InterfaceArt_tex.Menu.Item_box_bar'
    GetItemHeight=StatList.PerkHeight
    OnDrawItem=StatList.DrawStat
    FontScale=FNS_Medium
    OnPreDraw=StatList.PreDraw
    timeIndex=-1

    bgR=255
    bgG=255
    bgB=255
    txtR=0
    txtG=0
    txtB=0
    alpha=255
    txtScale=1.000
}