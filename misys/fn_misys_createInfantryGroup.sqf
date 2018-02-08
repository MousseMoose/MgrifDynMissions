#define MUCONFIGROOT missionConfigFile



params ["_count",
		"_pos",
		"_faction"];

private ["_group"];
_group = createGroup OPFOR;
for "_i" from 1 to _count do {
	_unit = 	[
			_group,
			_pos vectorAdd [random 0.25, random 0.25, 0],
			_faction
			] call mgrif_fnc_misys_createUnitRandom;
};
_group


