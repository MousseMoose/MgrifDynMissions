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

private ["_buildings","_buildingPos"];


_buildings = [];
{
	if((count (_x buildingPos -1)) > 0 ) then { _buildings pushBack _x };
} forEach (_compound select MISYS_BUILDINGS);



_intelligence = objNull;
_intelligencePos = [];

if((count _buildings)>0) then {
	_buil = selectRandom _buildings;
	_buildingPos = _buil buildingPos -1;
	_intelligencePos = selectRandom _buildingPos;
	
} else {
	_watch = _compound select MISYS_WATCH;
	if((count _watch)>0) then {
		_buil = selectRandom _watch;
		_intelligencePos = selectRandom (_buil buildingPos -1);
	} else {
		_intelligencePos = [_pos, 0, 7, 1, 0, 0.5, 0] call bis_fnc_findSafePos;
		_intelligencePos pushBack 0.1;
	};
};

_intelligence = createVehicle ["Land_Tablet_02_F", (_intelligencePos vectorAdd [0,0,0.1]), [], 0, "CAN_COLLIDE"];

_intelligence setVariable ["mgrif_taskname",_taskname,true];

private "_target";
_target = -2;
if ((isMultiplayer && !isDedicated) || (!isMultiplayer)) then {
	_target = 0;
};

[_intelligence,["Collect Intel",{
		_tn = (_this select 0) getVariable "mgrif_taskname";
		[_tn,nil,nil,nil,"SUCCEEDED",nil,true] call bis_fnc_setTask;
		player playAction "putdown";
		deleteVehicle (_this select 0);
	}]] remoteExec ["addAction",_target,_intelligence];


createMarker [_taskName, _pos];
[_taskName, true, ["The enemy compound contains valuable intel. You must secure it.", "Steal Intelligence", _taskName], _intelligence, "AUTOASSIGNED",0,true] call BIS_fnc_setTask;


