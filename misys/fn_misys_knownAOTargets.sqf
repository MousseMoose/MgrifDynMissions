params [
	["_center",[]],
	["_size",2000],
	["_threshold",0]
];

_targets = [];

{
	if((_x distance _center ) < _size && (OPFOR knowsAbout _x) > _threshold) then {
		_targets pushBack _x;	
	};
} forEach allPlayers;

_targets