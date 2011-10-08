class GSTMidGamePerks extends KFTab_MidGamePerks;

var	automated GSTStatListBox    lb_StatSelect;

function ShowPanel(bool bShow)
{
	local GSTStats L;

	super.ShowPanel(bShow);

	if ( bShow )
	{
//		L = Class'ClientPerkRepLink'.Static.FindStats(PlayerOwner());
		if ( L!=None )
			lb_StatSelect.statList.InitList(L);
		InitGRI();
	}
}

function SetupGroups()
{
    local int i;
    local PlayerController PC;

    PC = PlayerOwner();

    if ( bTeamGame )
    {
        //RemoveComponent(lb_FFA, True);
        //RemoveComponent(sb_FFA, true);

        if ( PC.GameReplicationInfo != None && PC.GameReplicationInfo.bNoTeamChanges )
        {
            RemoveComponent(b_Team,true);
        }

        //lb_FFA = None;
    }
	else if ( bFFAGame )
	{
		RemoveComponent(b_Team, true);
	}
	else
	{
		for ( i = 0; i < Controls.Length; i++ )
		{
			if ( Controls[i] != i_BGPerks && Controls[i] != lb_StatSelect )
			{
				RemoveComponent(Controls[i], True);
			}
		}
	}

    if ( PC.Level.NetMode != NM_Client )
    {
        RemoveComponent(b_Favs);
        RemoveComponent(b_Browser);
    }
    else if ( CurrentServerIsInFavorites() )
    {
        DisableComponent(b_Favs);
    }

    if ( PC.Level.NetMode == NM_StandAlone )
    {
        RemoveComponent(b_MapVote, True);
        RemoveComponent(b_MatchSetup, True);
        RemoveComponent(b_KickVote, True);
    }
    else if ( PC.VoteReplicationInfo != None )
    {
        if ( !PC.VoteReplicationInfo.MapVoteEnabled() )
        {
            RemoveComponent(b_MapVote,True);
        }

        if ( !PC.VoteReplicationInfo.KickVoteEnabled() )
        {
            RemoveComponent(b_KickVote);
        }

        if ( !PC.VoteReplicationInfo.MatchSetupEnabled() )
        {
            RemoveComponent(b_MatchSetup);
        }
    }
    else
    {
        RemoveComponent(b_MapVote);
        RemoveComponent(b_KickVote);
        RemoveComponent(b_MatchSetup);
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
     i_BGPerks=GUISectionBackground'GameStatsTab.GSTMidGamePerks.BGPerks'

     Begin Object Class=GSTStatListBox Name=StatSelectList
         OnCreateComponent=StatSelectList.InternalOnCreateComponent
         WinTop=0.057760
         WinLeft=0.029240
         WinWidth=0.941520
         WinHeight=0.742836
     End Object
     lb_StatSelect=GSTStatListBox'GameStatsTab.GSTMidGamePerks.StatSelectList'

    lb_PerkSelect= None;

    i_BGPerkEffects= None;
    lb_PerkEffects= None;

    i_BGPerkNextLevel= None;
    lb_PerkProgress= None;

}
