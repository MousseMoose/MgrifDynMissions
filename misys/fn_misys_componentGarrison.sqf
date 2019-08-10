#define MISYS_META 		0
#define MISYS_WATCH 	1
#define MISYS_BUILDINGS 2
#define MISYS_PROPS 	3
#define MISYS_STATIC 	4
#define MISYS_COMPS 	5
#define MGRIF_CONFIGROOT missionconfigFile

#include "MacrosGarrison.hpp"

params [
	["_pos",[]],
	["_dir",0],
	["_compPos",[]],
	["_compDir",0],
	["_faction","Fia"],
	["_strength",1],
	["_compObjs",[]],
	["_compNames",[]]
];

private ["_group","_unit"];








/*
_buildingCount = 0;
_group = createGroup OPFOR;
{
	
	_pos = _pos vectorAdd [random 1, random 1,0];
	
	_unit = [
		_group,
		_pos vectorAdd [0.1*(_forEachIndex),0.1*_buildingCount,0],
		_faction
	] call mgrif_fnc_misys_createUnitRandom;
	
	{
		
		
		if(random 1 > 0.7) then {
			_unit = [
      			_group,
     			_pos vectorAdd [0.1*(1+_forEachIndex),0.1*_buildingCount,0],
                _faction
				] call mgrif_fnc_misys_createUnitRandom;
		};		
	} foreach (_x buildingPos -1); //foreach 
	_buildingCount = _buildingCount + 1;
	
} forEach (_compObjs select MISYS_BUILDINGS);
*/

_bposCount = 0;
{
	_bposCount = _bposCount + count (_x buildingPos -1);
} forEach (_compObjs select MISYS_BUILDINGS);
_bposCount = _bposCount * ((random 0.5) + 0.5);

_lrPatrolPos = [_pos,2,33,false] call mgrif_fnc_misys_safePosCompound;
_lrPatrolPos set [2,0];
_lrPatrolGrp = [_bposCount,_lrPatrolPos, _faction] call mgrif_fnc_misys_createInfantryGroup;

private _garrisonForces = MGRIF_MISYS_GARRISONTEMPLATE;
MGRIF_MISYS_SQUADS(_garrisonForces) pushback _lrPatrolGrp;

private _vehicles = [];
private _props = [];
[_garrisonForces,_vehicles,_props]