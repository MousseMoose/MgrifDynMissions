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
//p3 = _mission;

private ["_positions","_compoundPos","_compounds","_compound","_taskNames", "_taskName"];
_positions = [];
_blackList = [];

//create Compounds
_locations = [_pos,["NameCity","NameCityCapital","NameVillage"],2000,500] call mgrif_fnc_misys_nearestLocationsLimits;
_compounds = [];

//for "_i" from 1 to (round random count _objectives) do 
{
	_compoundPos = [];
	//_compound = [];
	if(random 1 < 1 && (count _locations >0)) then {
		_locationIndex = round random ((count _locations)-1);
		_location = _locations select _locationIndex;
		_locations deleteAt _locationIndex;
		
		_compoundPos =  [_location] call mgrif_fnc_misys_locationPositionVaried;
		_compounds pushBack [([_compoundPos,_faction,55] call mgrif_fnc_misys_createLocationCompound),_compoundPos];
		
		
		
	} else {
		_compoundPos = [_pos, 500, 2000, 33, 0, 0.06, 0,_blackList] call BIS_fnc_findSafePos;
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
		_compounds pushBack [_compound,_compoundPos];
		
		
		
	};
	
	createMarker [str _compoundPos, _compoundPos];
	(str _compoundPos) setMarkerType "flag_FIA";
} forEach _objectives;

_taskNames = [];
{
	//test1 = _compounds;
	
	_compoundComposite = selectRandom _compounds;
	_compound = _compoundComposite select 0;
	_compoundPos = _compoundComposite select 1;
	
	
	_objective = "";
	if(_x == "Rand") then {
		_objective =  getText(([(MGRIF_CONFIGROOT >> "CfgMisysObjectives")] call mgrif_fnc_misys_selectRandomConfig) >> "function");
	} else {
		_objective =  getText(MGRIF_CONFIGROOT >> "CfgMisysObjectives" >> _x >> "function");
	};
	_taskName = (str _mission) + (str _forEachIndex);
	_taskNames pushBack _taskName;
	[_compoundPos, _faction,_compound,_mission,_taskName] call call compile _objective;
	
    //createMarker [str _compoundPos, _compoundPos];
	//(str _compoundPos) setMarkerType "flag_FIA";
	_positions pushBack _compoundPos;
} forEach _objectives;

[_positions,_taskNames];