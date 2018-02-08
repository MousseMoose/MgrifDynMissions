#define MUCONFIGROOT missionConfigFile
params [
		["_pos",""],
		["_classes",[]],
		["_maxDist",0],
		["_minDist",0]	
	];
	
private ["_locations","_distance","_ret"];	
_locations = nearestLocations [_pos, _classes, _maxDist];
_ret = [];
{
	_distance = (_x distance _pos);
	if((_distance >= _minDist) && (_distance <= _maxDist )) then {
		_ret pushBack _x;
	};
} forEach _locations;

_ret

