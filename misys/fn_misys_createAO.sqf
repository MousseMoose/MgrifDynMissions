#define MISYS_COMPOUND_SIZE_MAX 33
#define MISYS_COMPOUND_EXCLUSION_ZONE 200
#define MGRIF_FACTION_TRAIT_S(FAC,TRAIT) getText MGRIF_FACTION_TRAIT(FAC,TRAIT)
#define MGRIF_FACTION_TRAIT_N(FAC,TRAIT) getNumber MGRIF_FACTION_TRAIT(FAC,TRAIT)
#define MGRIF_FACTION_TRAIT_A(FAC,TRAIT) getArray MGRIF_FACTION_TRAIT(FAC,TRAIT)
#define MGRIF_FACTION_TRAIT(FAC,TRAIT) (MGRIF_CONFIGROOT >> "cfgMgrifFactions" >> FAC >> TRAIT)
#define MGRIF_CONFIGROOT missionconfigFile

#include "MacrosGarrison.hpp"

params[
	["_center",[0,0,0]],
	["_faction","FIA"],
	["_compoundCount",1],
	["_allowLocation",false]	
];

_locations = [_center,["NameCity","NameCityCapital","NameVillage"],2000,500] call mgrif_fnc_misys_nearestLocationsLimits;

_compounds = [];
_patrolPoints = [];
_blackList = [];

for "_i" from 1 to _compoundCount do {
	//generation
	_compoundPos = [0,0,0];
	if(_allowLocation && (count _locations) > 0 && (random 100) < -1) then {
		_location = selectRandom _locations;
		_compoundPos =  [_location] call mgrif_fnc_misys_locationPositionVaried;
		_patrolPoints pushBack ([_compoundPos,9,250,false] call mgrif_fnc_misys_safePosCompound);
		_locations deleteAt (_locations find _location);
		//_compoundPos pushback 0;
		_compounds pushBack [([_compoundPos,_faction,55] call mgrif_fnc_misys_createLocationCompound),_compoundPos];
	} else {
		//stub
		//_size = [_faction] call mgrif_misys_fnc_getRandomCompoundSize;
		_compoundPos = [_center, 0, 2000, MISYS_COMPOUND_SIZE_MAX , 0, 0.1, 0,_blackList,[]] call mgrif_fnc_misys_findSafePosReal;
		_compoundPos pushback 0;
		//p1 = str _compoundPos;
		if((count _compoundPos) > 0) then {
			_blackList pushback [_compoundPos,250];
			_patrolPoints pushBack ([_compoundPos,2,MISYS_COMPOUND_SIZE_MAX,false] call mgrif_fnc_misys_safePosCompound);
			_configSize = [(MGRIF_CONFIGROOT >> "CfgMisysCompounds")] call mgrif_fnc_misys_selectRandomConfig;
			_configCompound = [_configSize] call mgrif_fnc_misys_selectRandomConfig;
			_compoundComponents = getArray (_configCompound >> "components");
			_componentTypes = [];
			{
				_componentTypes pushBack (selectRandom getArray (MGRIF_CONFIGROOT >> "CfgMisysCompoundComponents" >> ("available" + _x)));
				
			} forEach _compoundComponents;
			_compound = [configName _configCompound,configName _configSize,_compoundPos, random 359,_faction,_componentTypes] call mgrif_fnc_misys_createCompound;
			_compounds pushBack [_compound,_compoundPos];
		};
	};
	createMarker [str _compoundPos, _compoundPos];
	(str _compoundPos) setMarkerType "flag_FIA";
};

//p2 = _patrolPoints;
{
	_mrk = createMarker [str  _x, _x ];
	_mrk setMarkerType "mil_dot";
} forEach _patrolPoints;

_allProvided = 
[
	[
		[],	//local patrols
		[], //AO Patrols
		[] // Special Groups
	],
	[], //loot vehicles
	[] //props
];

_allGarrisonForces = MGRIF_MISYS_GARRISONTEMPLATE;
{
	_garrisonForces = (_x#0)#2;
	{
			_current = _x;
			_currentIndex = _forEachIndex;
			{(((_allGarrisonForces)#_currentIndex)#_forEachIndex) append _x} forEach _current;
	} forEach _garrisonForces;
} forEach _compounds;



[_center,_faction,_compounds,_allGarrisonForces,_patrolPoints] spawn mgrif_fnc_misys_AOManagerDefault;

//TODO - link components/compounds

_compounds
