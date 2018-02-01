class CfgMisysCompounds {
	class S33 {
		class CampAudacity {
			file = "misys\compounds\S33Audacity.sqf";
			components[] ={"S5","S10","S5","S10"};
		};
		
		class CampBravery {
			file = "misys\compounds\S33Bravery.sqf";
			components[] ={"S7p5","S10","S7p5","S7p5","S10","S7p5"};
		};
	};
	
};

class CfgMisysCompoundComponents {
	
	availableS5[] = {"Garage","Props","Garrison"};
	availableS7p5[] = {"Garage","Props","Garrison"};
	availableS10[] = {"Garage","Props","Garrison","Helipad","Medical"};
	
	
	
	
	class Garage {
		function = "mgrif_fnc_misys_componentGarage";
		class S5 {
			class Car {
				file = "misys\components\s5GarageCar.sqf";
			};
		};
		
		class S7p5 {
			class NetBarrels {
				file = "misys\components\s7p5GarageNetBarrels.sqf";
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
		
		class S7p5 {
			class Storage {
				file = "misys\components\s7p5PropsStorage.sqf";
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
		
		class S7p5 {
			class Cargo2 {
				file = "misys\components\s7p5Cargo2.sqf";
			};
		};
		
		class S10 {
			
			class HQ {
				file = "misys\components\s10hq.sqf";
			};
		};
		
	};
	
	class Medical {
		function = "mgrif_fnc_misys_componentMedical";
		class S10 {
			class Damaged {
				file = "misys\components\s10MedicalDamaged.sqf";
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