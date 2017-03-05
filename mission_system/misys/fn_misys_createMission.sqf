#define MISYS_META 		0
#define MISYS_WATCH 	1
#define MISYS_BUILDINGS 2
#define MISYS_PROPS 	3
#define MISYS_STATIC 	4
#define MISYS_ENEMIES 	5
#define MISYS_VEHICLES 	6
#define MISYS_BASESKILL 0.25
#define MU_FACTION_TRAIT_S(FAC,TRAIT) getText MU_FACTION_TRAIT(FAC,TRAIT)
#define MU_FACTION_TRAIT_N(FAC,TRAIT) getNumber MU_FACTION_TRAIT(FAC,TRAIT)
#define MU_FACTION_TRAIT_A(FAC,TRAIT) getArray MU_FACTION_TRAIT(FAC,TRAIT)
#define MU_FACTION_TRAIT(FAC,TRAIT) (MU_CONFIGROOT >> "cfgMuFactions" >> FAC >> TRAIT)
#define MU_CONFIGROOT missionconfigFile


//Load Mission data
private ["_name","_pos","_dir","_params"];

_name 		= _this select 0;
_pos 		= _this select 1;
_dir		= _this select 2;
_faction	= _this select 3;
_type		= _this select 4;
_strength	= _this select 5;
_radius = 75; //TODO: read radius from file
//_condition 	= _this select 4;

_groups = [];
//Load mission data
_params = call compile preprocessfile format ["misys\missions\%1.sqf",_name];
_meta = _params select MISYS_META;
_watch 		= [];
if(count (_params select MISYS_WATCH) > 0) then {
	_watch 		= 		[_pos, _dir, _params select MISYS_WATCH] call bis_fnc_objectsMapper;
};
test1 = _watch;

_buildings  = [];
if(count (_params select MISYS_BUILDINGS) > 0) then {
	_buildings 	=		[_pos, _dir, _params select MISYS_BUILDINGS] call bis_fnc_objectsMapper;
};

_props 		= [];
if(count (_params select MISYS_PROPS) > 0) then {
    _props		= 		[_pos, _dir, _params select MISYS_PROPS] call bis_fnc_objectsMapper;
};

_static = [];
if(count (_params select MISYS_STATIC) > 0) then {
    _static 	= 		[_pos, _dir, _params select MISYS_STATIC] call bis_fnc_objectsMapper;
};


//Spawn sentries
_watchGroup = createGroup OPFOR;
{
    
    _bpos = (_x buildingPos -1);
    _highest = _bpos select 0;
    {
        if(_highest select 2 == _x select 2 && random 1 >=0.5) then {
            _highest = _x;
        };
        if((_highest select 2)< (_x select 2)) then {
           // hint format ["old height %1 , new height %2",_highest select 2, _x select 2];
            _highest = _x;
            
        };
    } foreach _bpos;

    
    if(random 1 >= 0.3) then {//"B_G_Soldier_GL_F"
       	//_unit = _watchGroup createUnit ["I_Soldier_lite_F",_highest,[],0,"NOTHING"];
         _unit = 	[
      			'soldier',
      			_watchgroup,
     			_highest,
                _faction
                ] call mu_fnc_misys_createUnit;
        [_unit] join _watchGroup;
        //_unit =  (units _watchGroup) select ((count units _watchGroup)-1);
        _unit setDir random 359;
        _unit setPos _highest;
        _unit setUnitPos "UP";
        doStop _unit;
    };
    
    
   if(_strength >0.75 && (random 1 > 0.5)) then {
      //"I_Soldier_lite_F" createUnit [_bpos select (round random ((count _bpos)-1)), _watchGroup];
      //_unit = _watchGroup createUnit ["I_Soldier_lite_F",_highest,[],0,"NOTHING"];
      _unit = 	[
      			'soldier',
      			_watchgroup,
     			_bpos select (round random ((count _bpos)-1)),
                _faction
                ] call mu_fnc_misys_createUnit;
      [_unit] join _watchGroup;
     // _unit =  (units _watchGroup) select ((count units _watchGroup)-1);
      _unit setPos (_bpos select (round random ((count _bpos)-1)));
  	  _unit setDir random 359;
      _unit setUnitPos "UP";
      doStop _unit;
   };
 
} foreach _watch;


//Spawn foot patrols
_patrolGroups = [];

_patrolCount = MU_FACTION_TRAIT_N("fia","patrolMaxCount");
for "_i" from  1 to (round (_strength*(_patrolCount))) do {
    _patrolGroup = createGroup OPFOR;
    _patrolGroups pushBack _patrolGroup;
    _safePos = [_pos, _radius, _radius+10, 3, 0, 20, 0] call BIS_fnc_findSafePos;
    for "_i" from 1 to (_patrolCount) do {
      	 _unit = 	[
      			'soldier',
      			_patrolGroup,
     			_safePos,
                _faction
                ] call mu_fnc_misys_createUnit;
                [_unit] join _patrolGroup;
                
    };
    [_patrolgroup, _pos, 100] call BIS_fnc_taskPatrol;
};














