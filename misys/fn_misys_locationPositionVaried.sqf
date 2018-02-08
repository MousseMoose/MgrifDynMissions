#define MISYS_META 		0
#define MISYS_WATCH 	1
#define MISYS_BUILDINGS 2
#define MISYS_PROPS 	3
#define MISYS_STATIC 	4
#define MISYS_COMPS 	5
#define MGRIF_CONFIGROOT missionconfigFile

params [
	["_location", locationNull]
];

private ["_pos","_houses","_center"];

_compound = [];

_pos =  locationPosition _location;
_pos set [2,0];
_houses = _pos nearObjects ["House_F", 100];
_center = selectRandom _houses;

(position _center)













