#define MUCONFIGROOT missionConfigFile
params [
		["_config",""]
	];	
_config select ((count (_this select 0))-1);