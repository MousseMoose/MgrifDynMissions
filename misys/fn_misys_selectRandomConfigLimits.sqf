#define MGRIF_CONFIGROOT missionConfigFile
params [
		["_config",""],
		["_limits",[0, (count (_this select 0))-1]]
	];	
(_config select (_limits select 0) + (random ((_limis select 1) - (_limits select 1))))
