#define MISYS_META 		0
#define MISYS_WATCH 	1
#define MISYS_BUILDINGS 2
#define MISYS_PROPS 	3
#define MISYS_STATIC 	4
#define MISYS_COMPS 	5
#define MGRIF_CONFIGROOT missionconfigFile

#define MGRIF_FACTION_TRAIT_S(FAC,TRAIT) getText MGRIF_FACTION_TRAIT(FAC,TRAIT)
#define MGRIF_FACTION_TRAIT_N(FAC,TRAIT) getNumber MGRIF_FACTION_TRAIT(FAC,TRAIT)
#define MGRIF_FACTION_TRAIT_A(FAC,TRAIT) getArray MGRIF_FACTION_TRAIT(FAC,TRAIT)
#define MGRIF_FACTION_TRAIT(FAC,TRAIT) (MGRIF_CONFIGROOT >> "cfgMgrifFactions" >> FAC >> TRAIT)


params [
	["_name",0],
	["_size",0],
	["_pos",0],
	["_dir",0]
];




//Load mission data
_file = getText(MGRIF_CONFIGROOT >> "CfgMisysCompounds" >> _size >> _name >> "file");
_compound = [_file,_pos,_dir] call mgrif_fnc_misys_createComposition;

_components = getArray (MGRIF_CONFIGROOT >> "CfgMisysCompounds" >> _size >> _name >> "components");
if(count (_components) > 0) then {
	{
		//select a random component of given Size and Type
		_comp = (MGRIF_CONFIGROOT >> "CfgMisysCompoundComponents" >> (_x select 0) >> (_x select 1));
		//select a random component of given size and type
		_compFile = getText ((_comp select random ((count _comp)-1)) >> "file");
		diag_log str _compound;
		diag_log format ["Parameter 1 %1",_compFile];
		diag_log format ["Parameter 2 %1",position ((_compound select MISYS_COMPS) select _forEachIndex)];
		diag_log format ["Parameter 3 %1",getDir ((_compound select MISYS_COMPS) select _forEachIndex)];
		_compObjs = [
						_compFile,
						position ((_compound select MISYS_COMPS) select _forEachIndex),
						getDir ((_compound select MISYS_COMPS) select _forEachIndex)
					] call mgrif_fnc_misys_createComposition;
		{
			//(_compound select _forEachIndex) append _x;
		} foreach _compObjs;
	} foreach _components;
	
	{deleteVehicle _x} foreach (_compound select MISYS_COMPS);
};

//AI
//------------------------------------------------------------------------------------------------------------
//hardcode stuff for now
_faction = "FIA";
_strength = 1;
_radius = 33;


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
                ] call mgrif_fnc_misys_createUnit;
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
                ] call mgrif_fnc_misys_createUnit;
      [_unit] join _watchGroup;
	  
     // _unit =  (units _watchGroup) select ((count units _watchGroup)-1);
      _unit setPos (_bpos select (round random ((count _bpos)-1)));
  	  _unit setDir random 359;
      _unit setUnitPos "UP";
      doStop _unit;
	  _unit disableAI "PATH";
   };
 
} foreach (_compound select MISYS_WATCH); //watch


//Spawn foot patrols
_patrolGroups = [];

_patrolCount = MGRIF_FACTION_TRAIT_N(_faction,"patrolMaxCount");
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
                ] call mgrif_fnc_misys_createUnit;
                [_unit] join _patrolGroup;
                
    };
    [_patrolgroup, _pos, 100] call BIS_fnc_taskPatrol;
};












