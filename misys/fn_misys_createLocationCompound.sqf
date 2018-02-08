#define MISYS_META 		0
#define MISYS_WATCH 	1
#define MISYS_BUILDINGS 2
#define MISYS_PROPS 	3
#define MISYS_STATIC 	4
#define MISYS_COMPS 	5
#define MGRIF_CONFIGROOT missionconfigFile

params [
	["_pos", []],
	["_faction", "Fia"],
	["_size",50]
];

private ["_center","_veh","_unit","_dir","_groups","_group","_count"];
_compound = [];

/*_pos =  locationPosition _location;
_pos set [2,0];
_houses = _pos nearObjects ["House_F", 100];
_center = selectRandom _houses;*/

_houses = _pos nearObjects ["House_F", _size];



//Get all Roads connected to "outside"
//please look away
_roads = _pos nearRoads _size;
_threshold = []; 
{ 
 _roadsConnected = ( roadsConnectedTo _x); 
 _isThreshold = false;
 _thresholdDir = 0;
 _currentRoad = _x;
 { 
  if(!(_x in _roads)) then { 
  
  //todo: edgecase T-Crossing
  //todo: minimum distance to one another?
   _isThreshold = true;
   _thresholdDir = _currentRoad getDir _x;
   //todo: break
  }; 
 } forEach _roadsConnected; 
  
 if(_isThreshold) then { 
  _threshold pushback [_currentRoad,_thresholdDir-37]; 
 }; 
} forEach _roads;
//you may look again


{
	createMarker [(str (_x select 0)), position (_x select 0)];
	(str (_x select 0)) setmarkerType "KIA";
} foreach _threshold;






//Roadblocks
{
	//todo: add to compound!
	_rbpos = position (_x select 0);
	_dir = (_x select 1);
	/*_dirInv = _dir + 180;
	_dirCenter = _pos getDir _rbPos;
	if(abs(_dirInv-_dirCenter)>abs(_dir-_dirCenter)) then {
		_dir = _dirInv;
	};*/
	
	
	_file = getText(([(missionConfigFile >> "CfgMisysRoadblocks")] call mgrif_fnc_misys_selectRandomConfig) >> "file");
	//hint str [_file,_rbpos,_dir];
	_rb = [_file,_rbpos,_dir] call mgrif_fnc_misys_createComposition;
	//test1 = _rb;
	_static = _rb select MISYS_STATIC;
	//p3 = _static;
	_group = createGroup OPFOR;
	
	{
		_unit = [_group,position _x,_faction] call mgrif_fnc_misys_createUnitRandom;
		_unit setDir _dir;
		doStop _unit;
	} foreach (_static select 0);
	
	{
		//turrets
		//_veh = [_faction,"carsTurret",(position _x)] call mgrif_fnc_misys_createVehicle;
	} foreach (_static select 1);
	
	{
		_veh = [_faction,"carsTurret",(position _x)] call mgrif_fnc_misys_createVehicle;
		_veh setDir (getDir _x);
		{
			_unit = ["crew", _group, position _veh, _faction] call mgrif_fnc_misys_createUnit;
			_unit moveInTurret [_veh, _x];
 		} forEach (allTurrets _veh);
	} foreach (_static select 2);
	
	{{deleteVehicle _x;} foreach _x;} foreach _static;
	
} forEach _threshold;


_groups = [];
{
	_groups pushBack ([_x,_faction] call mgrif_fnc_misys_occupyBuilding);
} forEach _houses;


{
	_patrolPos = [position (selectRandom _roads), 0, 5, 1, 0, 20, 0] call BIS_fnc_findSafePos;
	_patrolPos set [2,0];
	//hint str _patrolPos;
	_group =  ([_x,	
				_patrolPos,
				_faction] call mgrif_fnc_misys_createInfantryGroup);
	_group setBehaviour "SAFE";
	_group setFormation "COLUMN";
	_groups pushback _group;
} foreach [5,5];

{
	_group = _x;
	_count = count _threshold;
	{
		//hint str [position (_x select 0),3];
		_wp = _group addWaypoint [position (_x select 0),3];
		if(_forEachIndex == _count) then {
			_wp setWaypointType "CYCLE";
		};
	} foreach _threshold;
	reverse _threshold;

} forEach _groups;


_compound = [
	[name location,_size],
	[],
	_houses,
	[],
	[],
	_threshold
];

_compound












