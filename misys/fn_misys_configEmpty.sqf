#define MGRIF_CONFIGROOT missionConfigFile
params [
		["_config",""]
	];	

_ret = true;
if(!(isClass _config) || (count _config <=0)) then {
	_ret = false;
};

_ret