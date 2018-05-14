//AI Commander - Default
#define MGRIF_MISYS_AO_SIZE 2000
#define MGRIF_MISYS_DETECTION_THRESHOLD 0.4
params [
	["_center",[0,0,0]],
	["_faction","FIA"],
	["_compounds",[]],
	["_provided",[]]
];
_officer =	[
      			'officer',
      			createGroup opfor,
     			_center,
                _faction
                ] call mgrif_fnc_misys_createUnit;
_officer setCaptive true;
_officer disableAI "ALL";
while {alive _officer} do {
	if(_officer getVariable ["mgrif_var_misys_canCommunicate",true]) then {
		_targets = [];
		//TODO: remove empty provided groups
		
		
		//calculate known targets within AO
		{
			if((_x distance _center ) < MGRIF_MISYS_AO_SIZE && (OPFOR knowsAbout _x) > MGRIF_MISYS_DETECTION_THRESHOLD) then {
				_targets pushBack _x;
				hint str _x;
				
			};
		} forEach allPlayers;
		
		
		//calculate localised target "groups" as players might not be in a logical group
		_targetValues = [];
		_currentIndex = 0;
		_max = count _targets;

		//group players within 100 meters, assign cummulative value
		while{_currentIndex < _max} do {
			_currentTargets = + _targets; 
			_currentTargets deleteAt _currentIndex;
			_currentTarget = _targets#_currentIndex;
			_toDelete = [];
			//_targetValue = [_currentTarget] call mgrif_fnc_misys_targetValue;
			
			{
				if ( _x distance _currentTarget < 100 ) then {
					//_targetValue = _targetValue + [_x] call mgrif_fnc_misys_targetValue;
					_toDelete pushBack _forEachIndex;
				};
			} forEach _currentTargets;
			
			{
				_targets deleteAt (_x+1);
				
			} forEach _toDelete;
			//_targetValues pushBack _targetValue;
			_max = _max - (count _toDelete);
			_currentIndex = _currentIndex + 1;
		};
		
		
		{
			//find closest group to send
			
			_closest = 100000;
			_closeUnit = objNull;
			_target = _x;
			_available = false;
			{
				_dist = (leader _x) distance _target;
				if (_dist < _closest) then {
					_closest = _dist;
					_closeUnit = (leader _x);
					_available = true;
					hint "yes";
				};
				
				
			} forEach (_provided#0#1);
			
			
			if(_available) then {
				//p3 = _closeUnit;
				(group _closeUnit) move (position _target);
			};
		} forEach _targets;
		
		
		
		
	};
	uisleep 60;
};