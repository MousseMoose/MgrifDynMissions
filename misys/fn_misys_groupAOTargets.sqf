params [
	["_targets",[]],
	["_groupingDistance",100],
	["_weight",{1}]
];


//calculate localised target "groups" as players might not be in a logical group
_targetValues = [];
_currentIndex = 0;
_max = count _targets;

//group players within 100 meters, assign cummulative value
//Idea is to iterate over the array, removing targets that are close to the current 'center'. it's pretty rough, might replace with a better algorithm later
while{_currentIndex < _max} do {
	_currentTargets = + _targets;
	_currentCenter = _targets#_currentIndex;
	//remove current 
	_currentTargets deleteAt _currentIndex;
	
	_toDelete = [];
	_vehicles = [(vehicle _currentCenter)];
	
	{
		if ( _x distance _currentCenter < _groupingDistance ) then {
			_toDelete pushBack _forEachIndex;
			_vehicles pushbackUnique (vehicle _x);
		};
	} forEach _currentTargets;
	
	_targetValue = 0;
	{
		_targetValue = _targetValue + ([_x] call _weight);
	} forEach _vehicles;
	
	//deleteAt implicitly ordered ascending
	{
		_targets deleteAt (_x-_forEachIndex);
		
	} forEach _toDelete;
	_max = _max - (count _toDelete);
	_targetValues pushBack _targetValue;
	_currentIndex = _currentIndex + 1;
};

_targetValues;