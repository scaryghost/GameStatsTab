class GSTPlayerController extends KFPlayerController;

exec function Fire(optional float F)
{
    local GSTStats gs;

    super.Fire(F);

    gs= class'GameSTatsTabMut'.static.findStats(getPlayerIDHash());
    gs.numShotsFired++;
    class'GameSTatsTabMut'.static.update(getPlayerIDHash(), gs);
}

