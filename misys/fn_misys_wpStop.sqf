params [
	["_group",grpNull]
];

{deleteWaypoint _x} forEach waypoints _group;
_holdWP = _group addWaypoint [position leader _group,10];
_holdWP setWaypointType "HOLD";
_group setCurrentWaypoint [_group,1];
