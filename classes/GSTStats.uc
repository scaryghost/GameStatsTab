class GSTStats extends Object;

var array<int> numSpecimenKilled;
var int numRoundsFired;
var float totalDamageTaken;
var float totalShieldLost;
var float ffDamage;
var float totalHealAmtRecieved;
var int numSecondsAlive; 
var int numFragsTossed;


function addKill(KFMonster victim) {
    local int index;
    if (ZombieCrawler(victim) != none) {
        index= 0;
    } else if (ZombieStalker(victim) != none) {
        index= 1;
    } else if (ZombieClot(victim) != none) {
        index= 2;
    } else if (ZombieGorefast(victim) != none) {
        index= 3;
    } else if (ZombieBloat(victim) != none) {
        index= 4;
    } else if (ZombieSiren(victim) != none) {
        index= 5;
    } else if (ZombieHusk(victim) != none) {
        index= 6;
    } else if (ZombieScrake(victim) != none) {
        index= 7;
    } else if (ZombieFleshPound(victim) != none) {
        index= 8;
    } else if (ZombieBoss(victim) != none) {
        index= 9;
    } else {
        //attacking custom specimen not derived from base monsters
        return;
    }

    numSpecimenKilled[index]++;
}

defaultproperties {
    numSpecimenKilled(0)=0  //crawlers
    numSpecimenKilled(1)=0  //stalkers
    numSpecimenKilled(2)=0  //clots
    numSpecimenKilled(3)=0  //gorefasts
    numSpecimenKilled(4)=0  //bloats
    numSpecimenKilled(5)=0  //sirens
    numSpecimenKilled(6)=0  //husks
    numSpecimenKilled(7)=0  //scrakes
    numSpecimenKilled(8)=0  //fleshpound
    numSpecimenKilled(9)=0  //patriarch
    numRoundsFired= 0
    totalDamageTaken= 0
    totalShieldLost= 0
    numFragsTossed= 0
    ffDamage= 0;
    totalHealAmtRecieved= 0;
}
