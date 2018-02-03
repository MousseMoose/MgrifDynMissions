#define MISYS_META 		0
#define MISYS_WATCH 	1
#define MISYS_BUILDINGS 2
#define MISYS_PROPS 	3
#define MISYS_STATIC 	4
#define MISYS_ENEMIES 	5
#define MISYS_VEHICLES 	6
#define MISYS_BASESKILL 0.25
#define MGRIF_FACTION_TRAIT_S(FAC,TRAIT) getText MGRIF_FACTION_TRAIT(FAC,TRAIT)
#define MGRIF_FACTION_TRAIT_N(FAC,TRAIT) getNumber MGRIF_FACTION_TRAIT(FAC,TRAIT)
#define MGRIF_FACTION_TRAIT_A(FAC,TRAIT) getArray MGRIF_FACTION_TRAIT(FAC,TRAIT)
#define MGRIF_FACTION_TRAIT(FAC,TRAIT) (MGRIF_CONFIGROOT >> "cfgMgrifFactions" >> FAC >> TRAIT)
#define MGRIF_CONFIGROOT missionconfigFile



params [
	["_pos",[0,0,0]],
	["_faction","Fia"],
	["_objectives",["Eliminate"]]
];

_missionGroup = createGroup sideLogic;
_mission = (createGroup sideLogic) createUnit ["LOGIC", _pos, [], 0, "NONE"];
p3 = _mission;

private ["_positions"];
_positions = [];
_blackList = [];

{

	_compoundPos = [_pos, 500, 1500, 33, 0, 0.06, 0,_blackList] call BIS_fnc_findSafePos;
	// make array 3 dimensional
	_compoundPos pushback 0;
	_blackList pushback [_compoundPos,250];
	
	_configSize = [(MGRIF_CONFIGROOT >> "CfgMisysCompounds")] call mgrif_fnc_misys_selectRandomConfig;
	_configCompound = [_configSize] call mgrif_fnc_misys_selectRandomConfig;
	
	_compoundComponents = getArray (_configCompound >> "components");
	_componentTypes = [];
	{
		_componentTypes pushBack (selectRandom getArray (MGRIF_CONFIGROOT >> "CfgMisysCompoundComponents" >> ("available" + _x)));
		
	} forEach _compoundComponents;
	_compound = [configName _configCompound,configName _configSize,_compoundPos, random 359,_componentTypes] call mgrif_fnc_misys_createCompound;
	
	_objective = "";
	if(_x == "Rand") then {
		_objective =  getText(([(MGRIF_CONFIGROOT >> "CfgMisysObjectives")] call mgrif_fnc_misys_selectRandomConfig) >> "function");
	} else {
		_objective =  getText(MGRIF_CONFIGROOT >> "CfgMisysObjectives" >> _x >> "function");
	};

	[_compoundPos, _faction,_compound,_mission,(str _mission) + (str _forEachIndex)] call call compile _objective;
	
    createMarker [str _compoundPos, _compoundPos];
	(str _compoundPos) setMarkerType "flag_FIA";
	_positions pushBack _compoundPos;
} forEach _objectives;

_positions