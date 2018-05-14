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
	["_pos",[]],
	["_faction","Fia"],
	["_objCount",1]
];

private ["_objectives"];

_objectives = [];
for "_i" from 1 to _objCount do {
	_objectives pushBack (configName ([MGRIF_CONFIGROOT >> "CfgMisysObjectives"] call mgrif_fnc_misys_selectRandomConfig ));
};
//hint str _objectives;
_compounds =[_pos,_faction,_objCount,true] call mgrif_fnc_misys_createAO;
_mission = [_pos,_faction,_compounds,_objectives] call mgrif_fnc_misys_createMission;
//if(true) exitWith{};
_positions =  _mission select 0;
_tnames = _mission select 1;



[_tnames] spawn {
	_missionInProgress = true;
	_tnames = _this select 0;
	while{_missionInProgress} do {
		_missionDone = true;
		{
		 
		 if(!([_x] call BIS_fnc_taskCompleted)) then {
			_missionDone = false;
		 };
		} forEach _tnames;
		
		if(_missionDone) then {
			//does _missionInProgess = !_missionDone; have the same effect?
			_missionInProgress = false;
		};
		
		sleep 2;
	};
	"EveryoneWon" call BIS_fnc_endMissionServer;	
};
