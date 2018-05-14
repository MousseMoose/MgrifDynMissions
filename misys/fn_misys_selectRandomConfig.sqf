#define MUCONFIGROOT missionConfigFile
params [
		["_config",""]
	];	
//_config select (random ((count (_this select 0))-1));
_config select floor ((random (count (_this select 0))));