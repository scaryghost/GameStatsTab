/**
 * Have it extend ReplicationInfo so this class will be compiled
 * before all other classes that need to use it
 */
class GSTAuxiliary extends ReplicationInfo;

struct ReplacementPair {
    var class<Object> oldClass;
    var class<Object> newClass;
};

static function int replaceClass(string className, array<ReplacementPair> replacementArray) {
    local int i, replaceIndex;

    replaceIndex= -1;
    for(i=0; replaceIndex == -1 && i < replacementArray.length; i++) {
        if (className ~= String(replacementArray[i].oldClass)) {
            replaceIndex = i;
        }
    }
    
    return replaceIndex;
}

/**
 *  Replaces the zombies in the given squadArray
 */
static function replaceSpecialSquad(out array<KFGameType.SpecialSquad> squadArray, 
        array<ReplacementPair> replacementArray) {
    local int i,j,k;
    local ReplacementPair pair;
    for(j=0; j<squadArray.Length; j++) {
        for(i=0;i<squadArray[j].ZedClass.Length; i++) {
            for(k=0; k<replacementArray.Length; k++) {
                pair= replacementArray[k];
                if(squadArray[j].ZedClass[i] ~= string(pair.oldClass)) {
                    squadArray[j].ZedClass[i]=  string(pair.newClass);
                }
            }
        }
    }
}

static function replaceStandardMonsterClasses(out array<KFGameType.MClassTypes> monsterClasses, 
        array<ReplacementPair> replacementArray) {
    local int i, k;
    local ReplacementPair pair;

    for( i=0; i<monsterClasses.Length; i++) {
        for(k=0; k<replacementArray.Length; k++) {
            pair= replacementArray[k];
            //Use ~= for case insensitive compare
            if (monsterClasses[i].MClassName ~= string(pair.oldClass)) {
                monsterClasses[i].MClassName= string(pair.newClass);
            }
        }
    }

}

static function string formatTime(int seconds) {
    local string timeStr;
    local int i;
    local array<int> timeValues;
    
    timeValues.Length= 3;
    timeValues[0]= seconds / 3600;
    timeValues[1]= seconds / 60;
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

