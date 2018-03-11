#define MISYS_META 		0
#define MISYS_WATCH 	1
#define MISYS_BUILDINGS 2
#define MISYS_PROPS 	3
#define MISYS_STATIC 	4
#define MISYS_COMPS 	5
#define MISYS_SPECIAL 	5
#define MGRIF_CONFIGROOT missionConfigFile

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


//returns an array with spawned groups and objects
// [Groups, loot vehicles, props]
// groups: [Local Compound Patrols, AO Patrols,Special groups]
// loot vehicles: array of claimable vehicles
[
	[
		[],		//local patrols
		[], //AO Patrols
		[] // Special Groups
	],
	[], //loot vehicles
	[] //props
]