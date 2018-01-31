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
	["_compound",[]]
];

private ["_group"];

_group = createGroup OPFOR;
_unit =  [
      			'officer',
      			_group,
     			_pos,
                _faction
                ] call mgrif_fnc_misys_createUnit;
_unit addEventHandler ["Killed", {
	[(str (_this select 0)),nil,nil,nil,"SUCCEEDED",nil,true] call bis_fnc_setTask;
	deleteMarker (str (_this select 0));
}];

createMarker [str _unit, _pos];
[(str _unit), true, ["", "Eliminate the Officer", str _unit], _unit, "AUTOASSIGNED",0,true] call BIS_fnc_setTask;
_group;