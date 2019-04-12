#define MGRIF_CONFIGROOT missionConfigFile
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
_wp = _group addWaypoint [ position leader _group,0];
_wp setWaypointType "CYCLE";
deleteWaypoint [_group,0];
