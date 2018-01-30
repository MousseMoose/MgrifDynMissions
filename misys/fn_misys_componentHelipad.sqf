#define MISYS_META 		0
#define MISYS_WATCH 	1
#define MISYS_BUILDINGS 2
#define MISYS_PROPS 	3
#define MISYS_STATIC 	4
#define MISYS_COMPS 	5
#define MGRIF_CONFIGROOT missionConfigFile


params [
	["_pos",[]],
	["_dir",0],
	["_compPos",[]],
	["_compDir",0],
	["_faction","Fia"],
	["_strength",1],
	["_compObjs",[]]
];

private ["_config","_veh"];

//TODO: create special component objs array in all components
_pad = (_compObjs select MISYS_PROPS) select 0;
_config = (MGRIF_CONFIGROOT >> "CfgMgrifFactions" >> _faction  >> "helicoptersTransport");
if((count _config)>0) then {
	//_vehClass =  configName ([MGRIF_CONFIGROOT >> "CfgMgrifFactions" >> _faction  >> "helicoptersTransport"] call mgrif_fnc_misys_selectRandomConfig);
	_veh = ["fia","helicoptersTransport","rand",(position _pad)] call mgrif_fnc_misys_createVehicle;
	//_veh =  _vehClass createVehicle (position _pad);
	_veh setDir (getDir _pad);
	
	
	[_veh]
	
} else {
	[]
};
