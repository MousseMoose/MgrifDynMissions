#define MISYS_META 		0
#define MISYS_WATCH 	1
#define MISYS_BUILDINGS 2
#define MISYS_PROPS 	3
#define MISYS_STATIC 	4
#define MISYS_COMPS 	5
#define MISYS_SPECIAL 	5
#define MGRIF_CONFIGROOT missionConfigFile


params [
	["_pos",[]],
	["_faction","Fia"],
	["_compound",[]],
	["_mission",objNull],
	["_taskName",objNull]
];


private ["_group"];
_officerPos = [_pos, 0, 15, 1, 0, 20, 0] call BIS_fnc_findSafePos;
_officerPos set [2,0];
_group = createGroup OPFOR;
_unit =  [
      			'officer',
      			_group,
     			_officerPos,
                _faction
                ] call mgrif_fnc_misys_createUnit;
_unit setVariable ["mgrif_taskName",_taskName];
_unit addEventHandler ["Killed", {
	[(_this select 0) getVariable "mgrif_taskName",nil,nil,nil,"SUCCEEDED",nil,true] call bis_fnc_setTask;
	deleteMarker (str (_this select 0));
}];

p3 = position _unit;
createMarker [str _unit, _pos];
[_taskName, true, ["", "Eliminate the Officer", str _unit], _unit, "AUTOASSIGNED",0,true] call BIS_fnc_setTask;
_group;