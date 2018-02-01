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

private ["_buildings"];


_buildings = _compound select MISYS_BUILDINGS;
_mission setVariable [_taskName,_buildings];



if((count _buildings)>0) then {
	{
		_x setVariable ["mgrif_mission",_mission];
		_x setVariable ["mgrif_taskName",_taskname];
		
		_x addEventHandler ["Killed", {
			[_this select 0] spawn {
				sleep random 1;
				_buil = _this select 0;
				_mission =  (_this select 0) getVariable "mgrif_mission";
				_done = true;
				
				{
					if(alive _x) then {_done = false;};
				} foreach (_mission getVariable (_buil getVariable "mgrif_taskName"));
				
				if(_done) then {
					[_buil getVariable "mgrif_taskName",nil,nil,nil,"SUCCEEDED",nil,true] call bis_fnc_setTask;
				};
				
			};
			
		}];
} forEach _buildings;
//hint str _taskName;
_buil = _buildings select 0;
//hint str (_buil getVariable "mgrif_taskName");
createMarker [_buil getVariable "mgrif_taskName", _pos];
[_taskName, true, ["420 raze it", "Raze the Compound", _buil getVariable "mgrif_taskName"], _buil, "AUTOASSIGNED",0,true] call BIS_fnc_setTask;


};


