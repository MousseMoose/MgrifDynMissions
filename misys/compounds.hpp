class CfgMisysCompounds {
	class S33 {
		class CampAudacity {
			file = "misys\compounds\campAudacityModular.sqf";
			components[] ={"S5","S10","S5","S10"};
		};
	};
	
};

class CfgMisysCompoundComponents {

	
	class Garage {
		function = "mgrif_fnc_misys_componentGarage";
		class S5 {
			class Car {
				file = "misys\components\s5GarageCar.sqf";
			};
		};
		
		class S10 {
			class Net {
				file = "misys\components\s10GarageNet.sqf";
			};
		};
	};
	
	class Props {
		function = "mgrif_fnc_misys_componentProps";
		class S5 {
			class Portapotties {
				file = "misys\components\s5portapotties.sqf";
			};	
		};
		
		class S10 {
			class HelipadProps {
				file = "misys\components\s10helipad.sqf";
			};
		};
		
		
	};
	
	class Garrison {
		function = "mgrif_fnc_misys_componentGarrison";
		class S5 {
			
			class Tents {
				file = "misys\components\s5tents.sqf";
			};
		};
		
		class S10 {
			
			class HQ {
				file = "misys\components\s10hq.sqf";
			};
		};
		
	};
	
	class Helipad {
		function = "mgrif_fnc_misys_componentHelipad";
		class S10 {
			class Helipad {
				file = "misys\components\s10helipad.sqf";
			};
		};
	};
};