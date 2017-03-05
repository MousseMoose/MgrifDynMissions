private _rnd = random 1;
_gear = 'common';
if(_rnd>0.8) then {_gear = 'uncommon'};
if(_rnd>0.95) then {_gear = 'rare'};
_gear