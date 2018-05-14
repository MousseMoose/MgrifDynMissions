#define MISYS_META 		0
#define MISYS_WATCH 	1
#define MISYS_BUILDINGS 2
#define MISYS_PROPS 	3
#define MISYS_STATIC 	4
#define MISYS_ENEMIES 	5
#define MISYS_VEHICLES 	6
#define MISYS_BASESKILL 0.25
#define MISYS_COMPOUNDSIZE_MAX 33
#define MGRIF_FACTION_TRAIT_S(FAC,TRAIT) getText MGRIF_FACTION_TRAIT(FAC,TRAIT)
#define MGRIF_FACTION_TRAIT_N(FAC,TRAIT) getNumber MGRIF_FACTION_TRAIT(FAC,TRAIT)
#define MGRIF_FACTION_TRAIT_A(FAC,TRAIT) getArray MGRIF_FACTION_TRAIT(FAC,TRAIT)
#define MGRIF_FACTION_TRAIT(FAC,TRAIT) (MGRIF_CONFIGROOT >> "cfgMgrifFactions" >> FAC >> TRAIT)
#define MGRIF_CONFIGROOT missionconfigFile



params [
	["_pos",[0,0,0]],
	["_faction","Fia"],
	["_compounds",[]],
	["_objectives",["Eliminate"]]
];

_missionGroup = createGroup sideLogic;
_mission = (createGroup sideLogic) createUnit ["LOGIC", _pos, [], 0, "NONE"];

private ["_positions","_compoundPos","_compounds","_compound","_taskNames", "_taskName","_provided"];
//create Compounds
_positions = [];
_taskNames = [];

{
	_compoundComposite = selectRandom _compounds;
	_compound = (_compoundComposite select 0) select 0;
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
	
	_positions pushBack _compoundPos;
} forEach _objectives;

[_positions, _taskNames, _mission]