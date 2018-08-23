#define MISYS_META 		0
#define MISYS_WATCH 	1
#define MISYS_BUILDINGS 2
#define MISYS_PROPS 	3
#define MISYS_STATIC 	4
#define MISYS_COMPS 	5
#define MISYS_SPECIAL 	5
#define MGRIF_CONFIGROOT missionConfigFile

#include "MacrosGarrison.hpp"

//Provided params
params [
	["_pos",[]],
	["_dir",0],
	["_compPos",[]],
	["_compDir",0],
	["_faction","Fia"],
	["_strength",1],
	["_compObjs",[]]
];



private _garrisonForces = MGRIF_MISYS_GARRISONTEMPLATE;
private _vehicles = [];
private _props = [];
[_garrisonForces,_vehicles,_props]