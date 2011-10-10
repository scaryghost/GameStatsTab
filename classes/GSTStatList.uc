class GSTStatList extends GUIVertList;

// Display
var texture InfoBackground;

// State
var localized array<string> statName;
var array<int>  statValue;

function bool PreDraw(Canvas Canvas) {
    return false;
}

function InitList( GSTStats statsObject ) {
    local int i;
    // Update the ItemCount and select the first item
    itemCount= statsObject.EStatKeys.EnumCount;
    SetIndex(0);

    statValue.Length= itemCount;
    for(i= 0; i < statsObject.statArray.Length; i++) {
        statName[i]= statsObject.statArray[i].descrip;
        statValue[i]= statsObject.statArray[i].statValue;
    }

    if ( bNotify ) {
        CheckLinkedObjects(Self);
    }

    if ( MyScrollBar != none ) {
        MyScrollBar.AlignThumb();
    }
}

function string formatTime(int seconds) {
    local string timeStr;
    local int i;
    local array<int> timeValues;
    
    timeValues.Length= 3;
    timeValues[0]= seconds / 60;
    timeValues[1]= seconds / 3600;
    timeValues[2]= seconds % 60;
    for(i= 0; i < timeValues.Length; i++) {
        if (timeValues[i] < 10) {
            timeStr= timeStr$"0"$timeValues[i];
        } else {
            timeStr= timeStr$timeValues[i];
        }
        if (i < timeValues.Length-1) {
            timeStr= timeStr$":";
        }
    }

    return timeStr;
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
    Canvas.Font = class'ROHUD'.Static.GetSmallerMenuFont(Canvas);
    Canvas.SetDrawColor(class'GameStatsTabMut'.default.bgR, 
            class'GameStatsTabMut'.default.bgG, class'GameStatsTabMut'.default.bgB, 
            class'GameStatsTabMut'.default.alpha);

    // Draw Item Background
    Canvas.SetPos(TempX, TempY);
    Canvas.DrawTileStretched(InfoBackground, Width, Height);

    // Select Text Color
    Canvas.SetDrawColor(class'GameStatsTabMut'.default.txtR, 
            class'GameStatsTabMut'.default.txtG, class'GameStatsTabMut'.default.txtB, 
            class'GameStatsTabMut'.default.alpha);

    // Draw the Perk's Level Name
    Canvas.TextSize(statName[CurIndex],TempWidth,TempHeight);
    TempX += Width*0.1f;
    TempY += (Height-TempHeight)*0.5f;
    Canvas.SetPos(TempX, TempY);
    Canvas.DrawText(statName[CurIndex]);

    // Draw the Perk's Level
    if (curIndex == statValue.Length-1) {
        S= formatTime(statValue[CurIndex]);
    } else {
        S = string(statValue[CurIndex]);
    }
    Canvas.TextSize(S,TempWidth,TempHeight);
    Canvas.SetPos(X + Width*0.88f - TempWidth, TempY);
    Canvas.DrawText(S);
}

function float PerkHeight(Canvas c) {
    return (MenuOwner.ActualHeight() / 14.0) - 1.0;
}

defaultproperties {
     InfoBackground=Texture'KF_InterfaceArt_tex.Menu.Item_box_bar'
     GetItemHeight=GSTStatList.PerkHeight
     OnDrawItem=GSTStatList.DrawStat
     FontScale=FNS_Medium
     OnPreDraw=GSTStatList.PreDraw
}
