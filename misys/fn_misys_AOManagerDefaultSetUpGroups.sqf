params [
	["_garrisonForces",[]],
	["_AOManagerPoints",[]]
];

{
	
	_currentIndex = _forEachIndex;
	{
		_currentInfPoints = 0;
		_currentVehPoints = 0;
		{
			_groupCost = (count units _x);
			_vehicleCost = 0;
			_currentInfPoints = _currentInfPoints + _groupCost;
			
			//hint str [vehicle leader _x != leader _x,typename leader _x, _x, typeName _x];
			
			if(!isNull (leader _x) && vehicle leader _x != leader _x) then {
				_currentVehPoints = _currentVehPoints + 1;
				_vehicleCost = 1;
			};
			
			_x setVariable ["mgrif_misys_groupCost",[_groupCost,_vehicleCost]];
			_x setVariable ["mgrif_misys_groupVehicle",vehicle leader _x];

			
		} forEach ((_garrisonForces#_currentIndex)#_forEachIndex);
		
		_x pushback 0;//_currentInfPoints;
		_x pushback 0;//_currentVehPoints;
	} forEach _x;
	
} forEach _AOManagerPoints;