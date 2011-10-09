class GSTStatList extends GUIVertList;

// Display
var	texture	InfoBackground;

// State
var	localized array<string>			StatName;
var	array<int>					StatProgress;

function bool PreDraw(Canvas Canvas) {
	return false;
}

function InitList( GSTStats statsObject ) {
	// Update the ItemCount and select the first item
	SetIndex(0);

	StatProgress[0] = statsObject.numSpecimenKilled[0];
	StatProgress[1] = statsObject.numSpecimenKilled[1];
	StatProgress[2] = statsObject.numSpecimenKilled[2];
	StatProgress[3] = statsObject.numSpecimenKilled[3];
	StatProgress[4] = statsObject.numSpecimenKilled[4];
    StatProgress[5] = statsObject.numSpecimenKilled[5];
	StatProgress[6] = statsObject.numSpecimenKilled[6];
	StatProgress[7] = statsObject.numSpecimenKilled[7];
	StatProgress[8] = statsObject.numSpecimenKilled[8];
	StatProgress[9] = statsObject.numSpecimenKilled[9];
	StatProgress[10] = statsObject.numShotsFired;
	StatProgress[11] = statsObject.numShotsHit;

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
	Canvas.SetDrawColor(class'GameStatsTabMut'.default.bgR, 
            class'GameStatsTabMut'.default.bgG, class'GameStatsTabMut'.default.bgB, 
            class'GameStatsTabMut'.default.bgA);

	// Draw Item Background
	Canvas.SetPos(TempX, TempY);
	Canvas.DrawTileStretched(InfoBackground, Width, Height);

	// Select Text Color
	Canvas.SetDrawColor(class'GameStatsTabMut'.default.txtR, 
            class'GameStatsTabMut'.default.txtG, class'GameStatsTabMut'.default.txtB, 
            class'GameStatsTabMut'.default.txtA);

	// Draw the Perk's Level Name
	Canvas.TextSize(StatName[CurIndex],TempWidth,TempHeight);
	TempX += Width*0.1f;
	TempY += (Height-TempHeight)*0.5f;
	Canvas.SetPos(TempX, TempY);
	Canvas.DrawText(StatName[CurIndex]$":");

	// Draw the Perk's Level
	S = string(StatProgress[CurIndex]);
	Canvas.TextSize(S,TempWidth,TempHeight);
	Canvas.SetPos(X + Width*0.88f - TempWidth, TempY);
	Canvas.DrawText(S);
}

function float PerkHeight(Canvas c) {
	return (MenuOwner.ActualHeight() / 14.0) - 1.0;
}

defaultproperties
{
     InfoBackground=Texture'KF_InterfaceArt_tex.Menu.Item_box_bar'
     StatName(0)="Crawlers killed"
     StatName(1)="Stalkers killed"
     StatName(2)="Clots killed"
     StatName(3)="Gorefasts killed"
     StatName(4)="Bloats killed"
     StatName(5)="Sirens killed"
     StatName(6)="Husks killed"
     StatName(7)="Scrakes killed"
     StatName(8)="Fleshpounds killed"
     StatName(9)="Patriarchs killed"
     StatName(10)="Number of shots fired"
     StatName(11)="Number of shots hit"
     GetItemHeight=GSTStatList.PerkHeight
     ItemCount=12
     OnDrawItem=GSTStatList.DrawStat
     FontScale=FNS_Medium
     OnPreDraw=GSTStatList.PreDraw
}
