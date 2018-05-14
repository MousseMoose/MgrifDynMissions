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
} foreach _positions;
_waypoints = (waypoints _group);
_wp = _waypoints select ((count _waypoints) -1);
_wp setWaypointType "CYCLE";
