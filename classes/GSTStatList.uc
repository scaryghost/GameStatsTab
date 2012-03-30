class GSTStatList extends GUIVertList
    config;

// Display
var texture InfoBackground;

// State
var localized array<string> statName;
var array<int>  statValue;
var int timeIndex;

var array<string> playerStatDescrip;
var array<string> weaponStatDescrip;
var array<string> zedStatDescrip;

var() config int bgR, bgG, bgB;
var() config int txtR, txtG, txtB;
var() config int alpha;
var() config float txtScale;

simulated function PostBeginPlay() {
    local class<GSTPlayerReplicationInfo> pri;

    playerStatDescrip.Length= pri.PlayerStats.EnumCount;
    weaponSTatDescrip.Length= pri.WeaponStats.EnumCount;
    zedStatDescrip.Length= pri.ZedStats.EnumCount;

    playerStatDescrip[pri.PlayerStats.TIME_ALIVE]="Time alive";
    playerStatDescrip[pri.PlayerStats.HEALING_RECIEVED]="Total healing received";
    playerStatDescrip[pri.PlayerStats.DAMAGE_TAKEN]="Total damage taken";
    playerStatDescrip[pri.PlayerStats.SHIELD_LOST]="Total shield lost";
    playerStatDescrip[pri.PlayerStats.FF_DAMAGE_DEALT]="Friendly fire damage";
    playerStatDescrip[pri.PlayerStats.SHOT_BY_HUSK]="Shot by husk";


    weaponStatDescrip[pri.WeaponStats.CRAWLER_KILLS]="Crawler kills";
    weaponStatDescrip[pri.WeaponStats.STALKER_KILLS]="Stalker kills";
    weaponStatDescrip[pri.WeaponStats.CLOT_KILLS]="Clot kills";
    weaponStatDescrip[pri.WeaponStats.GOREFAST_KILLS]="Gorefast kills";
    weaponStatDescrip[pri.WeaponStats.BLOAT_KILLS]="Bloat kills";
    weaponStatDescrip[pri.WeaponStats.SIREN_KILLS]="Siren kills";
    weaponStatDescrip[pri.WeaponStats.HUSK_KILLS]="Husk kills";
    weaponStatDescrip[pri.WeaponStats.SCRAKE_KILLS]="Scrake kills";
    weaponStatDescrip[pri.WeaponStats.FLESHPOUND_KILLS]="Fleshpound kills";
    weaponStatDescrip[pri.WeaponStats.PATRIARCH_KILLS]="Patriarch kills";
    weaponStatDescrip[pri.WeaponStats.FLESHPOUNDS_RAGED]="Enraged a fleshpound";
    weaponStatDescrip[pri.WeaponStats.SCRAKES_RAGED]="Enraged a scrake";
    weaponStatDescrip[pri.WeaponStats.SCRAKES_STUNNED]="Stunned a scrake";
    weaponStatDescrip[pri.WeaponStats.BACKSTABS]="Backstabs";

    zedStatDescrip[pri.ZedStats.ROUNDS_FIRED]="Rounds fired";
    zedStatDescrip[pri.ZedStats.MELEE_SWINGS]="Melee swings";
    zedStatDescrip[pri.ZedStats.FRAGS_TOSSED]="Frags tossed";
    zedStatDescrip[pri.ZedStats.PIPES_SET]="Pipes set";
    zedStatDescrip[pri.ZedStats.NUM_DECAPS]="Decapitations";
    zedStatDescrip[pri.ZedStats.UNITS_FUEL]="Units of fuel consumed";
    zedStatDescrip[pri.ZedStats.SHELLS_FIRED]="Shells fired";
    zedStatDescrip[pri.ZedStats.GRENADES_LAUNCHED]="Grenades launched";
    zedStatDescrip[pri.ZedStats.ROCKETS_LAUNCHED]="Rockets launched";
    zedStatDescrip[pri.ZedStats.BOLTS_FIRED]="Bolts fired";

}

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
