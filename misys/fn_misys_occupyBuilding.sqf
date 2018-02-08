#define MGRIF_CONFIGROOT missionconfigFile

params [
	["_building",[]],
	["_faction","Fia"],
	["_chance",0.25]
];



_buildingGroup = createGroup OPFOR;
_bpos = (_x buildingPos -1);
{
	if((random 1) < _chance) then {
		_unit = 	[
			_buildingGroup,
			_x,
			_faction
			] call mgrif_fnc_misys_createUnitRandom;
	_unit setUnitPos "UP";
	_unit setDir random 359;
	doStop _unit;
	
	};
} foreach _bpos;

_buildingGroup;
















