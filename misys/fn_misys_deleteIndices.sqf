params [
		["_arr",[]],
		["_toDelete",[]]
		
	];	

private _deleteOffset = 0;
{

	_arr deleteAt (_x - _deleteOffset);
	_deleteOffset = _deleteOffset + 1;
} forEach _toDelete;