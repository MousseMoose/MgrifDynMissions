#define MGRIF_CONFIGROOT missionConfigFile



params ["_count",
		"_pos",
		"_faction"];

private ["_group"];

if((count _pos)==2) then { _pos = [_pos#0,_pos#1,0];}; //game crashes if _pos only has 2 entries for some reason

_group = createGroup OPFOR;
for "_i" from 1 to _count do {
	_unit = 	[
			_group,
			_pos vectorAdd [random 0.25, random 0.25, 0],
			_faction
			] call mgrif_fnc_misys_createUnitRandom;
};
_group


