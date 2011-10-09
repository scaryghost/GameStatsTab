class GameStatsTabMut extends Mutator;

struct propertyDescTuple {
    var string property;
    var string longDescription;
    var string shortDescription;
};

var config int bgR, bgG, bgB, bgA;
var config int txtR, txtG, txtB, txtA;
var array<propertyDescTuple> propDescripArray;

function PostBeginPlay() {
    DeathMatch(Level.Game).LoginMenuClass = string(Class'GSTInvasionLoginMenu');
}

static function FillPlayInfo(PlayInfo PlayInfo) {
    local string mutConfigGroup;
    local int i;

    Super.FillPlayInfo(PlayInfo);
   
    mutConfigGroup= "GameStatsTab Config"; 
    for(i= 0; i<default.propDescripArray.Length;i++) {
        PlayInfo.AddSetting(mutConfigGroup, default.propDescripArray[i].property, 
        default.propDescripArray[i].shortDescription, 0, 1, "Text","1;0:255");
    }
}

static event string GetDescriptionText(string property) {
    local int i;

    for(i=0;i<default.propDescripArray.Length;i++) {
        if(default.propDescripArray[i].property == property) {
            return default.propDescripArray[i].longDescription;
        }
    }

    return Super.GetDescriptionText(property);
}

defaultproperties {
    GroupName= "KFGameStatsTab"
    FriendlyName= "Detailed Stats Tab"
    Description= "Displays detailed statistics about your current game"

    propDescripArray(0)=(property="bgR",longDescription="Set red value for stat field background color",shortDescription="Background RGB.R")
    propDescripArray(1)=(property="bgG",longDescription="Set green value for stat field background color",shortDescription="Background RGB.G")
    propDescripArray(2)=(property="bgB",longDescription="Set blue value for stat field background color",shortDescription="Background RGB.B")
    propDescripArray(3)=(property="bgA",longDescription="Set alpha value for stat field background color",shortDescription="Background RGB.A")
    propDescripArray(4)=(property="txtR",longDescription="Set red value for stat text color",shortDescription="Text RGB.R")
    propDescripArray(5)=(property="txtG",longDescription="Set green value for stat text color",shortDescription="Text RGB.G")
    propDescripArray(6)=(property="txtB",longDescription="Set blue value for stat text color",shortDescription="Text RGB.B")
    propDescripArray(7)=(property="txtA",longDescription="Set alpha value for stat text color",shortDescription="Text RGB.A")
}
