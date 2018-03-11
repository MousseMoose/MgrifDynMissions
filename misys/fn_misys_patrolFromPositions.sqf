#define MUCONFIGROOT missionConfigFile
params [
		["_group",grpNull],
		["_positions",[]]
	];	

private ["_count"];
_count = count _positions;
_group setBehaviour "SAFE";
_group setFormation "COLUMN";

{
	_wp = _group addWaypoint [_x,3];
	if(_forEachIndex == _count) then {
		_wp setWaypointType "CYCLE";
	};
} foreach _positions;
