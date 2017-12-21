#define MISYS_META 		0
#define MISYS_WATCH 	1
#define MISYS_BUILDINGS 2
#define MISYS_PROPS 	3
#define MISYS_STATIC 	4
#define MISYS_COMPS 	5
#define MGRIF_CONFIGROOT missionconfigFile

//TODO: better defaults, macro?
params [
	["_file",0],
	["_pos",0],
	["_dir",0]
];

//Load composition
_params = call compile preprocessfile _file;
_meta = _params select MISYS_META;

//spawn objects
_watch 		= [];
if(count (_params select MISYS_WATCH) > 0) then {
	_watch 		= 		[_pos, _dir, _params select MISYS_WATCH] call bis_fnc_objectsMapper;
};

_buildings  = [];
if(count (_params select MISYS_BUILDINGS) > 0) then {
	_buildings 	=		[_pos, _dir, _params select MISYS_BUILDINGS] call bis_fnc_objectsMapper;
};

_props 		= [];
if(count (_params select MISYS_PROPS) > 0) then {
    _props		= 		[_pos, _dir, _params select MISYS_PROPS] call bis_fnc_objectsMapper;
};

_statics 		= [];
//if(count (_params select MISYS_STATIC) > 0) then {
//    _statics		= 		[_pos, _dir, _params select MISYS_STATIC] call bis_fnc_objectsMapper;
//};

_comps 		= [];
if(count (_params select MISYS_COMPS) > 0) then {
    _comps		= 		[_pos, _dir, _params select MISYS_COMPS] call bis_fnc_objectsMapper;
};



//return
[_meta,_watch,_buildings,_props,_statics,_comps]












