#include "MacrosCompounds.hpp"
#include "MacrosGarrison.hpp"
#define MGRIF_CONFIGROOT missionconfigFile

//old faction system macros
#define MGRIF_TRAIT_S(FAC,TRAIT) getText MGRIF_FACTION_TRAIT(FAC,TRAIT)
#define MGRIF_FACTION_TRAIT_N(FAC,TRAIT) getNumber MGRIF_FACTION_TRAIT(FAC,TRAIT)
#define MGRIF_FACTION_TRAIT_A(FAC,TRAIT) getArray MGRIF_FACTION_TRAIT(FAC,TRAIT)
#define MGRIF_FACTION_TRAIT(FAC,TRAIT) (MGRIF_CONFIGROOT >> "cfgMgrifFactions" >> FAC >> TRAIT)


params [
	["_name",0],
	["_size",0],
	["_pos",0],
	["_dir",0],
	["_faction","FIA"],
	["_compTypes",[]],
	["_compNames", []],
	["_strength", 1],
	["_radius", 33],
	["_auxTypes",["Garrison","Motorpool"]],
	["_auxSizes",["S15","S20"]],
	["_auxNames", ["rand","rand"]]
];




private ["_file","_compound","_compSizes"];

//Load mission data
_file = getText(MGRIF_CONFIGROOT >> "CfgMisysCompounds" >> _size >> _name >> "file");
_compound = [_file,_pos,_dir] call mgrif_fnc_misys_createComposition;

_compSizes = getArray (MGRIF_CONFIGROOT >> "CfgMisysCompounds" >> _size >> _name >> "components");


if((count _compNames) == 0) then {
	_compNames = [];
	{_compNames pushback "rand"} foreach _compSizes;
};

if((count _auxNames) == 0) then {
	_auxNames = [];
	{_auxNames pushback "rand"} foreach _auxSizes;
};




_garrisonForces = MGRIF_MISYS_GARRISONTEMPLATE;
_vehicles = [];
_props = [];

_compPositions =  (_compound select MISYS_COMPS) apply {position _x};
_compTokens = (_compound select MISYS_COMPS);
_components = [];

{
	_compToken = _compTokens#_forEachIndex;
	_component = [
		position _compToken,
		getDir _compToken,
		_compTypes#_forEachIndex,
		_compSizes#_forEachIndex,
		_compNames#_forEachIndex,
		_faction,
		_strength,
		false
	] call mgrif_fnc_misys_createCompoundComponent;
	_compNames set [_forEachIndex,_component#0];
	_components pushBack (_component#1);
} forEach _compTypes;



_realSizes = _auxSizes apply {call compile  ((_x splitString "S")#0)};
_auxNames = ["rand","rand"];
_auxPositions = [];
_auxillaries = [];
_auxPosCount = 0;
_toDelete = [];
{
	//TODO: verify auxPositions aren't default
	_auxPosition = [_pos, _radius + 7, _radius + (_realSizes#_forEachIndex) + 7, (_realSizes#_forEachIndex) + 2, 0, 0.5, 0,[],[]] call mgrif_fnc_misys_findSafePosReal;
	if(count _auxPosition<3) then {
		_auxPosition pushBack 0;
		_auxPositions pushBack _auxPosition;
		_auxillary = [
			_auxPosition,
			_auxPosition getDir _pos,
			_auxTypes#_forEachIndex,
			_auxSizes#_forEachIndex,
			_auxNames#_forEachIndex,
			_faction,
			_strength,
			true
		] call mgrif_fnc_misys_createCompoundComponent;
		_auxillaries pushBack (_auxillary#1);
		_auxPosCount = _auxPosCount+1;
	} else {
		_toDelete pushback _forEachIndex;
	};

} forEach _auxTypes;
[_auxTypes,_toDelete] call mgrif_fnc_misys_deleteIndices;
[_auxSizes,_toDelete] call mgrif_fnc_misys_deleteIndices;


_customs = [];

//initialise Compound

{
	_compToken = _compTokens#_forEachIndex;
	_compCustom = [_pos, _dir, position _compToken, getDir _compToken, _faction, _strength, _components#_forEachIndex,_compTypes + _auxTypes,_compSizes + _auxSizes] call call compile getText (MGRIF_CONFIGROOT >> "CfgMisysCompoundComponents" >> _x >> "function");
	_customs pushback _compCustom;
} forEach _compTypes;

//testtypes = [_compTypes,_compNames];

{
	_auxPosition = _auxPositions#_forEachIndex;
	_auxCustom = [_pos, _dir, _auxPosition,_auxPosition getDir _pos, _faction, _strength, _auxillaries#_forEachIndex,_compTypes + _auxTypes,_compSizes + _auxSizes] call call compile getText (MGRIF_CONFIGROOT >> "CfgMisysCompoundAuxillaries" >> _x >> "function");
	if (isNil "_auxCustom") then {
		CopyToClipboard str [_pos, _dir, _auxPosition,_auxPosition getDir _pos, _faction, _strength, _auxillaries#_forEachIndex,_compTypes + _auxTypes,_compSizes + _auxSizes];
		hint getText (MGRIF_CONFIGROOT >> "CfgMisysCompoundAuxillaries" >> _x >> "function");
	};
	_customs pushback _auxCustom;
} forEach _auxTypes;



{	
	_custom = _x;
	{
		private _current = _x;
		private _currentIndex = _forEachIndex;
		{(((_garrisonForces)#_currentIndex)#_forEachIndex) append _x} forEach _current;
	} forEach (_custom#0);
} forEach _customs;

//add component and auxillary objects to compound objects
{
	_current = _x;
	{
		(_compound select _forEachIndex) append _x;
	} forEach _current;
	
} foreach (_components + _auxillaries);

//AI
//------------------------------------------------------------------------------------------------------------
_buildingGroups = [];
{
	_buildingGroup = createGroup OPFOR;
	_bpos = (_x buildingPos -1);
	{
		if((random 1) >0.75) then {
			_unit = 	[
      			'rifleman',
      			_buildingGroup,
     			_x,
                _faction
                ] call mgrif_fnc_misys_createUnit;
        _unit setUnitPos "UP";
        doStop _unit;
		};
	} foreach _bpos;
	_buildingGroups pushBack _buildingGroup;
} foreach (_compound select MISYS_BUILDINGS); 


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
    } forEach _bpos;

    
    if(true) then { //random 1 >= 0.3
         _unit = 	[
      			'marksman',
      			_watchgroup,
     			_highest,
                _faction
                ] call mgrif_fnc_misys_createUnit;
       // [_unit] join _watchGroup; 
        _unit setDir random 359;
        _unit setPos _highest;
        _unit setUnitPos "UP";
        doStop _unit;
		_unit disableAI "PATH";
    };
    
    
   if(true) then { //_strength >0.75 && (random 1 > 0.5)
      _unit = 	[
      			'grenadier',
      			_watchgroup,
     			_bpos select (round random ((count _bpos)-1)),
                _faction
                ] call mgrif_fnc_misys_createUnit;
      //[_unit] join _watchGroup;
	  
      _unit setPos (_bpos select (round random ((count _bpos)-1)));
  	  _unit setDir random 359;
      _unit setUnitPos "UP";
      doStop _unit;
	  _unit disableAI "PATH";
   };
 
} foreach (_compound select MISYS_WATCH); 


//Spawn foot patrols
_patrolGroups = [];
_patrolCount = 2;
for "_i" from  1 to (round (_strength*(_patrolCount))) do {
    _patrolGroup = createGroup OPFOR;
    _patrolGroups pushBack _patrolGroup;
    _safePos = [_pos, _radius, _radius+10, 3, 0, 20, 0] call BIS_fnc_findSafePos;
    for "_i" from 1 to (_patrolCount) do {
      	 _unit = 	[
      			'rifleman',
      			_patrolGroup,
     			_safePos,
                _faction
                ] call mgrif_fnc_misys_createUnit;
                
    };
    //[_patrolgroup, _pos, 100] call BIS_fnc_taskPatrol;
};
{
	(MGRIF_MISYS_PATROLS(_garrisonForces)) pushback _x;
	[_x, _compoundPos, 100,[[_compoundPos,33]]] call BIS_fnc_taskPatrol;
} forEach _patrolGroups;

_groups = [[_watchGroup],_buildingGroups];

MGRIF_MISYS_WATCHS(_garrisonForces) pushBack _watchGroup;
MGRIF_MISYS_BUILDINGGUARDS(_garrisonForces) append _buildingGroups;


[_compound,_groups,_garrisonForces,_compTypes,_compSizes,_auxTypes,_auxSizes]












