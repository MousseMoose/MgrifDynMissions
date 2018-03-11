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

private ["_buildings","_buil"];


_buildings = _compound select MISYS_BUILDINGS;
_mission setVariable [_taskName,_buildings];



if((count _buildings)>0) then {
_buil = selectRandom _buildings;
_buil setVariable ["mgrif_mission",_mission];
_buil setVariable ["mgrif_taskName",_taskname];

_buil addEventHandler ["Killed", {
	[_this select 0] spawn {
		_buil = _this select 0;
		[_buil getVariable "mgrif_taskName",nil,nil,nil,"SUCCEEDED",nil,true] call bis_fnc_setTask;
		deleteMarker (_buil getVariable "mgrif_taskName");
		//deleteVehicle _buil;
	};
	
}];

createMarker [_buil getVariable "mgrif_taskName", _pos];
[_taskName, true, ["", "Raze the Building", _buil getVariable "mgrif_taskName"], _buil, "AUTOASSIGNED",0,true] call BIS_fnc_setTask;


} else {
	[_pos,_faction,_compound,_mission,_taskName] spawn mgrif_fnc_misys_objectiveEliminate;
};


