//AI Commander - Default
#define MGRIF_MISYS_AO_SIZE 2000
#define MGRIF_MISYS_DETECTION_THRESHOLD 0.4

#define MGRIF_MISYS_COMPOUNDPOS(arr) ((arr) select 1)
#define MGRIF_MISYS_COMPOUNDOBJECTS(arr) (((arr) select 0) select 0)

#include "MacrosCompounds.hpp"
#include "MacrosGarrison.hpp"

params [
	["_center",[0,0,0]],
	["_faction","FIA"],
	["_compounds",[]],
	["_garrisonForces",MGRIF_MISYS_GARRISONTEMPLATE]
];

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
				


while {alive _officer} do {
	if(_officer getVariable ["mgrif_var_misys_canCommunicate",true]) then {
		//TODO: remove empty provided groups
		
		//
		_availableTroops = MGRIF_MISYS_SQUADS(_garrisonForces) + MGRIF_MISYS_MOTORISEDARMED(_garrisonForces);
		p1 = _availableTroops;
		
		
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
					hint "yes";
				};
				
				
			} forEach _availableTroops;//(_provided#0#1);
			
			
			if(_available) then {
				//p3 = _closeUnit;
				(group _closeUnit) move (position _target);
			};
		} forEach _targets;
		
		
		
		
	};
	uisleep 30;
};