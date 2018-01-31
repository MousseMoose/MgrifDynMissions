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

private ["_positions"];
_positions = [];

{
	_compoundPos = [_pos, 500, 1500, 33, 0, 0.06, 0] call BIS_fnc_findSafePos;
	//player setPos _compoundPos;
	// make array 3 dimensional
	_compoundPos pushback 0;
	_compound = ["CampAudacity","S33",_compoundPos, random 359,["Garage","Helipad","Props","Garrison"], ["rand","rand","rand","rand"]] call mgrif_fnc_misys_createCompound;
	[_compoundPos, _faction] call mgrif_fnc_misys_objectiveEliminate;
    createMarker [str _compoundPos, _compoundPos];
	(str _compoundPos) setMarkerType "flag_FIA";
	_positions pushBack _compoundPos;
} forEach _objectives;

_positions