params [
	["_garrisonForces",[]],
	["_AOManagerPoints",[]]
];

{
	_currentIndex = _forEachIndex;
	{
		_currentInfPoints = _x#0;
		_currentVehPoints = _x#1;
		_toDelete = [];
		{
			if(count units _x == 0) then {
				//hint str ["Refunding Points",_x,_x getVariable "mgrif_misys_groupCost"];
				_toDelete pushBack _forEachIndex;
				_currentInfPoints = _currentInfPoints + ((_x getVariable "mgrif_misys_groupCost")#0);
				_currentVehPoints = _currentVehPoints + ((_x getVariable "mgrif_misys_groupCost")#1);
				deletedGroups pushBack[_x,_x getVariable "mgrif_misys_groupCost"];
			};
			
		} forEach ((_garrisonForces#_currentIndex)#_forEachIndex);
		
		

		[((_garrisonForces#_currentIndex)#_forEachIndex),_toDelete] call mgrif_fnc_misys_deleteIndices;
		
		_x set [0,_currentInfPoints];
		_x set [1,_currentVehPoints];
	} forEach _x;
	
} forEach _AOManagerPoints;
