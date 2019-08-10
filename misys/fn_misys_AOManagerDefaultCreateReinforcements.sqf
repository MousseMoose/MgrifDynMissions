#define MGRIF_MISYS_AO_SIZE 2000
#define MGRIF_MISYS_DETECTION_THRESHOLD 0.4
#define MGRIF_MISYS_AOMANAGERTICKRATE 5

#define MGRIF_MISYS_COMPOUNDPOS(arr) ((arr) select 1)
#define MGRIF_MISYS_COMPOUNDOBJECTS(arr) (((arr) select 0) select 0)

#include "MacrosCompounds.hpp"
#include "MacrosGarrison.hpp"
#include "MacrosTasks.hpp"


params [
	["_garrisonForces",[]], 
	["_AOManagerPoints",[]],
	["_defaultSpawnPoints",[]],
	["_compounds",[]],
	["_faction","FIA"]
];


{
	_currentIndex = _forEachIndex;
	{
		_currentInfPoints = _x#0;
		_currentVehPoints = _x#1;
		
		((_garrisonForces#_currentIndex)#_forEachIndex);
		_squadsize = 0;
		if(_currentInfPoints >=4) then {
			if (_currentInfPoints >=8) then {_squadsize = 8;} else {_squadSize = _currentInfPoints};
			_eligibileCompounds = [];
			{
				_currentCompound = _x;
				_nearbyPlayersCount = {(MGRIF_MISYS_COMPOUNDPOS(_currentCompound) distance _x) < 350} count allPlayers;
				if(_nearbyPlayersCount==0) then {_eligibileCompounds pushBack _forEachIndex};
			} forEach _compounds;
			
			if (count _eligibileCompounds > 0) then {
				_compIndex = selectRandom _eligibileCompounds;
				_compoundPos = MGRIF_MISYS_COMPOUNDPOS(_compounds#_compIndex);
				_spawnPos = [_compoundPos,3,33,false,[]] call mgrif_fnc_misys_safePosCompound;
				if(count _spawnPos <3) then {
					_spawnPos pushBack 0;
					_rgroup = [_squadSize,_spawnPos,_faction] call mgrif_fnc_misys_createInfantryGroup;
					_rgroup setVariable ["mgrif_misys_groupCost",[_squadSize,0]];
					_rgroup setVariable ["mgrif_misys_groupVehicle",vehicle leader _rgroup];
					
					MGRIF_MISYS_SQUADS(_garrisonForces) pushBack _rgroup;
					addedGroups pushBack [_squadSize,_rgroup];
				} else {
					diag_log "Cannot spawn reinforcements due to space problems!";
				};

				
			};
			
		};
		
		_x set [0,_currentInfPoints-_squadsize];
		_x set [1,_currentVehPoints];
	} forEach _x;
} forEach mgrif_var_misys_AOManagerPoints;