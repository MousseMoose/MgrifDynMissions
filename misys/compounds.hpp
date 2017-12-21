class CfgMisysCompounds {
	class Size33 {
		class CampAudacity {
			file = "misys\compounds\campAudacityModular.sqf";
			components[] ={{"Props","S5"},{"Props","S10"},{"Props","S5"},{"Props","S10"}};
		};
	};
	
};

class CfgMisysCompoundComponents {
	class Armory {
		class S5 {
			class AudacityArmory {
				file = "misys\components\braveryArmory.sqf";
			};
		};
		
		class S10 {
		};
	};
	
	class Medical {
		class S5 {
		};
		
		class S10 {
		};
	};
	
	class Props {
		class S5 {
			class Portapotties {
				file = "misys\components\s5portapotties.sqf";
			};
			
			class Tents {
				file = "misys\components\s5tents.sqf";
			};
		};
		
		class S10 {
			class Helipad {
				file = "misys\components\s10helipad.sqf";
			};
		};
	};
};