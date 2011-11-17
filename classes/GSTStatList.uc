class GSTStatList extends GUIVertList
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

function InitList(GSTPlayerReplicationInfo pri) {
    local int i;
    // Update the ItemCount and select the first item
    itemCount= pri.EStatKeys.EnumCount;
    SetIndex(0);

    statValue.Length= itemCount;
    for(i= 0; i < itemCount; i++) {
        statName[i]= pri.descripArray[i];
        statValue[i]= pri.getStatValue(i);
    }
    timeIndex= pri.EStatKeys.TIME_ALIVE;

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
    GetItemHeight=GSTStatList.PerkHeight
    OnDrawItem=GSTStatList.DrawStat
    FontScale=FNS_Medium
    OnPreDraw=GSTStatList.PreDraw
}
