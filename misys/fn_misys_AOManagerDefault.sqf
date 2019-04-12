//AI Commander - Default
#define MGRIF_MISYS_AO_SIZE 2000
#define MGRIF_MISYS_DETECTION_THRESHOLD 0.4
#define MGRIF_MISYS_AOMANAGERTICKRATE 5

#define MGRIF_MISYS_COMPOUNDPOS(arr) ((arr) select 1)
#define MGRIF_MISYS_COMPOUNDOBJECTS(arr) (((arr) select 0) select 0)



#include "MacrosCompounds.hpp"
#include "MacrosGarrison.hpp"
#include "MacrosTasks.hpp"

params [
	["_center",[0,0,0]],
	["_faction","FIA"],
	["_compounds",[]],
	["_garrisonForces",MGRIF_MISYS_GARRISONTEMPLATE],
	["_patrolPoints",[]]
];

mgrif_var_misys_AOManagerPoints = MGRIF_MISYS_GARRISONTEMPLATE;



//Set up group costs and vehicle points in group variables
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
	
} forEach mgrif_var_misys_AOManagerPoints;





//spawn officer
_officerPos = [0,0,0];
_compound = selectRandom _compounds;
if(count (MGRIF_MISYS_COMPOUNDOBJECTS(_compound)#MISYS_BUILDINGS) > 0) then {
	_building = selectRandom (MGRIF_MISYS_COMPOUNDOBJECTS(_compound)#MISYS_BUILDINGS);
	_buildingPos = selectRandom (_building buildingPos -1);
	_officerPos = _buildingPos;
} else {
	_officerPos = MGRIF_MISYS_COMPOUNDPOS(_compound);
};


_officer =	[
      			'officer',
      			createGroup opfor,
     			_officerPos,
                _faction
                ] call mgrif_fnc_misys_createUnit;
				


//set up patrols
{
	
	_ptPointsTemp = _patrolPoints call bis_fnc_arrayShuffle;
	[_x,_ptPointsTemp] call mgrif_fnc_misys_patrolFromPositions;
	
	//workaround to fix bug that has mounted patrols not move until interacted with
	if(vehicle leader _x != leader _x) then {doGetOut units _x};
	_x setVariable ["mgrif_misys_currentTask",MGRIF_MISYS_TASK_LRPATROL];
} forEach MGRIF_MISYS_MOTORISEDARMED(_garrisonForces);

deletedGroups = [];


addedGroups = [];

while {alive _officer} do {
	// Check for empty groups and refund points
	//TODO: Maybe decouple reinforcement calculation?
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
					deletedGroups pushBack["Refunding Points",_x,_x getVariable "mgrif_misys_groupCost"];
				};
				
			} forEach ((_garrisonForces#_currentIndex)#_forEachIndex);
			
			_deleteOffset = 0;
			_currentSubIndex = _forEachIndex;
			{
				//diag_log str ["Trying to delete",_deleteOffset,"Count",count ((_garrisonForces#_currentIndex)#_currentSubIndex)];
				 ((_garrisonForces#_currentIndex)#_currentSubIndex) deleteAt (_x - _deleteOffset);
				 
				 _deleteOffset = _deleteOffset + 1;
			} forEach _toDelete;
			
			_x set [0,_currentInfPoints];
			_x set [1,_currentVehPoints];
		} forEach _x;
		
	} forEach mgrif_var_misys_AOManagerPoints;
	//refund end
	
	
	//create Reinforcements
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
					p1 = _compoundPos;
					_spawnPos = [_compoundPos,3,33,false,[]] call mgrif_fnc_misys_safePosCompound;
					if(count _spawnPos <3) then {
						_spawnPos pushBack 0;
						_rgroup = [_squadSize,_spawnPos,_faction] call mgrif_fnc_misys_createInfantryGroup;
						
						MGRIF_MISYS_SQUADS(_garrisonForces) pushBack _rgroup;
						addedGroups pushBack [_squadSize,"ADDED",_rgroup];
						hint "Added group";
					};

					
				};
				
			};
			
			_x set [0,_currentInfPoints-_squadsize];
			_x set [1,_currentVehPoints];
		} forEach _x;
	} forEach mgrif_var_misys_AOManagerPoints;
	
	
	

	if(_officer getVariable ["mgrif_var_misys_canCommunicate",true]) then {
		
		_availableTroops = MGRIF_MISYS_SQUADS(_garrisonForces) + MGRIF_MISYS_MOTORISEDARMED(_garrisonForces);
		//p1 = _availableTroops;
		
		
		//calculate known targets within AO
		_targets = [_center,MGRIF_MISYS_AO_SIZE,MGRIF_MISYS_DETECTION_THRESHOLD] call mgrif_fnc_misys_knownAOTargets;
		//diag_log ("targets " + str _targets);
		_targetValues = [_targets,100] call mgrif_fnc_misys_groupAOTargets;
		//diag_log ("targetValues " + str _targetValues);
		

		
		
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
					//hint "yes";
				};
				
				
			} forEach _availableTroops;//(_provided#0#1);
			
			
			if(_available) then {
				(group _closeUnit) move (position _target);
			};
		} forEach _targets;
		
		
		
		
	};
	uisleep MGRIF_MISYS_AOMANAGERTICKRATE;
};