#define MUCONFIGROOT missionConfigFile


/*_class = _this select 0;
_group = _this select 1;
_pos = _this select 2;
_faction = _this select 3;*/
params ["_class","_group","_pos","_faction"];



//_config = MUCONFIGROOT >> 'cfgMuFactions' >> _faction >> 'gear' >> _gear;

_unit = _group createUnit [getText ( MUCONFIGROOT >> 'cfgMuFactions' >> _faction >> 'unit') ,_pos,[],0,"NOTHING"];

removeAllWeapons _unit;
removeAllItems _unit;
removeAllAssignedItems _unit;
removeUniform _unit;
removeVest _unit;
removeBackpack _unit;
removeHeadgear _unit;
removeGoggles _unit;

//use scope visibility to make helper function to add gear
_getEntry = {
    selectRandom ([_faction,[] call  mu_fnc_misys_determineRarity, _this select 0] call mu_fnc_misys_getGearArr)
    };
    
_unit addUniform (["uniforms"] call _getEntry);
_unit addVest (["vests"] call _getEntry);


if(random 1 >0.6 ) then {
    _backpack =  (["backpacks"] call _getEntry);
    if(!isNil "_backpack") then {
        _unit addBackpack _backpack;
        };
};

_wep = ["weaponsPrim"] call _getEntry;
//if (isNil "_wep") then {hint format["(MUCONFIGROOT >> 'cfgMuFactions' >> %1 >> 'gear' >>%2 >> %3)",_faction,[] call  mu_fnc_misys_determineRarity, "weaponsPrim"]};
for "_i" from 3 to (3 + (round random 3)) do {
 _unit addMagazine selectRandom (getArray (configFile >> "cfgWeapons" >> _wep >> 'magazines'));
};

//TODO: attachments

_muzzles = getArray (configFile >> 'cfgWeapons' >> _wep >> 'muzzles');
if(count _muzzles  >1) then {
    {
        if (_forEachIndex>0) then {
        _unit addMagazine selectRandom getArray(configFile >> "cfgWeapons" >> _wep >> _x >> 'magazines');
        };
    } foreach _muzzles;
};
_unit addWeapon _wep;

if(random 1>0.75) then {
    _wep = ["weaponsSide"] call _getEntry;
    if(isNil "_wep") then {
        _unit addMagazine (selectRandom (getArray (configFile >> "cfgWeapons" >> _wep >> 'magazines')));
   		_unit addWeapon _wep;
    };
};

//Add items, minimum and possible extras
_itemCount = ([_faction,[] call  mu_fnc_misys_determineRarity, 'itemCount'] call mu_fnc_misys_getGearArr);
for "_i" from 1 to ((_itemCount select 0) + (round random (_itemCount select 1))) do {
    _unit addItem (["items"] call _getEntry);
};

//add standard gear
_unit linkItem "itemRadio";
_unit linkItem "itemMap";

//Add gear/linked items. Slightly worse odds for adding gear items due to duplicates
_gearCount = ([_faction,[] call  mu_fnc_misys_determineRarity, 'gearCount'] call mu_fnc_misys_getGearArr);
for "_i" from 1 to ((_gearCount select 0) + (round random (_gearCount select 1))) do {
    _unit linkItem (["gear"] call _getEntry);
};

_unit




