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


//

//Set up group costs and vehicle points in group variables
[_garrisonForces,mgrif_var_misys_AOManagerPoints] call mgrif_fnc_misys_AOManagerDefaultSetUpGroups;


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

//calculate out of zone reinforcement points defaults

_averagePosition = [0,0,0];
{_averagePosition = _averagePosition vectorAdd (_x#1)} forEach _compounds;
_averagePosition =  _averagePosition apply {_x / count _compounds};
_offset = MGRIF_MISYS_AO_SIZE*1.5 / sqrt 2;

_reinforcementPointsDefaultLand = [
	_averagePosition vectorAdd [_offset,_offset,0],
	_averagePosition vectorAdd [-_offset,_offset,0],
	_averagePosition vectorAdd [-_offset,-_offset,0],
	_averagePosition vectorAdd [_offset,-_offset,0]
];
_reinforcementPointsDefaultWater = [];
_toDelete = [];
 { if(surfaceIsWater _x) then {_toDelete pushBack _forEachIndex; _reinforcementPointsDefaultWater pushBack _x}} forEach _reinforcementPointsDefaultLand;
[_reinforcementPointsDefaultLand,_toDelete] call mgrif_fnc_misys_deleteIndices;
{_mrk = createMarker [str  _x, _x]; _mrk setMarkerType "mil_arrow";} forEach _reinforcementPointsDefaultLand;
{_mrk = createMarker [str  _x, _x]; _mrk setMarkerType "mil_arrow2";} forEach _reinforcementPointsDefaultWater;

addedGroups = [];

while {true} do {
	// Check for empty groups and refund points
	[_garrisonForces,mgrif_var_misys_AOManagerPoints] call mgrif_fnc_misys_AOManagerDefaultRefundPoints;
	
	//create Reinforcements
	[_garrisonForces,mgrif_var_misys_AOManagerPoints,_reinforcementPointsDefaultLand,_compounds,_faction] call mgrif_fnc_misys_AOManagerDefaultCreateReinforcements;
		
	if(_officer getVariable ["mgrif_var_misys_canCommunicate",true]) then {
		
		_availableTroops = MGRIF_MISYS_SQUADS(_garrisonForces) + MGRIF_MISYS_MOTORISEDARMED(_garrisonForces);
		
		
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