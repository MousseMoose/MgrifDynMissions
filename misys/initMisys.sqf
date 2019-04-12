#define MGRIF_CONFIGROOT missionConfigFile

_componentsForSize = {
	params[
		["_compConfig","CfgMisysCompoundComponents"],
		["_isAux",false]
	];
	{
		private _name = configName _x;
		private _sizes = ("true" configClasses _x) apply {configName _x};
		private _varName = "mgrif_var_misys_compAvailable";
		if(_isAux) then {
			_varName = "mgrif_var_misys_auxAvailable";
		};
		{
			if(isNil (_varName+_x)) then {
				missionNamespace setVariable [_varName + _x,[_name]];
			} else {
				(missionNamespace getVariable (_varName+_x)) pushBack _name;
			};
		} forEach _sizes;
		
		
		missionNamespace setVariable ["mgrif_var_misys_sizesComp" + _name,_sizes];
	
	} forEach ("true" configClasses (MGRIF_CONFIGROOT >> _compConfig));
};

private _compConfig = "CfgMisysCompoundComponents";
[_compConfig] call _componentsForSize;


_compConfig = "CfgMisysCompoundAuxillaries";
[_compConfig,true] call _componentsForSize;
