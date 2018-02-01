#define MISYS_META 		0
#define MISYS_WATCH 	1
#define MISYS_BUILDINGS 2
#define MISYS_PROPS 	3
#define MISYS_STATIC 	4
#define MISYS_COMPS 	5
#define MGRIF_CONFIGROOT missionconfigFile

params [
	["_pos",[]],
	["_dir",0],
	["_compPos",[]],
	["_compDir",0],
	["_faction","Fia"],
	["_strength",1],
	["_compObjs",[]]
];
//if(count (_compObjs select MISYS_BUILDINGS)>0) then {
	//hint str (_compObjs select MISYS_BUILDINGS) ;
//};

private ["_group","_unit"];




_buildingCount = 0;
_group = createGroup OPFOR;
{
	_pos = _pos vectorAdd [random 1, random 1,0];
	
	//at least one soldier per building because tents
	_unit = [
		_group,
		_pos vectorAdd [0.1*(_forEachIndex),0.1*_buildingCount,0],
		_faction
	] call mgrif_fnc_misys_createUnitRandom;
	
	{
		
		
		if(random 1 > 0.7) then {
			_unit = [
      			_group,
     			_pos vectorAdd [0.1*(1+_forEachIndex),0.1*_buildingCount,0],
                _faction
				] call mgrif_fnc_misys_createUnitRandom;
		};		
	} foreach (_x buildingPos -1); //foreach 
	_buildingCount = _buildingCount + 1;
	
} forEach (_compObjs select MISYS_BUILDINGS);





[_group]
	