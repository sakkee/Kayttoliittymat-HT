package  {
	import flash.display.*;
	import flash.events.MouseEvent;

	public class KL_spot extends MovieClip {
		var mcSpotScreen:spotscreen;
		public var goingToWork:Boolean=false;
		public var tmpArr:Array = new Array();
		
		public function openSpot() {
			mcSpotScreen = new spotscreen();
			mcSpotScreen.x=100;
			mcSpotScreen.y=100;
			mcSpotScreen.button_towork.addEventListener(MouseEvent.CLICK, goToWork);
			mcSpotScreen.osa1.addEventListener(MouseEvent.CLICK,osa1Change);
			mcSpotScreen.osa2.addEventListener(MouseEvent.CLICK,osa2Change);
			mcSpotScreen.osa3.addEventListener(MouseEvent.CLICK,osa3Change);
			
			return mcSpotScreen;
		}
		function goToWork(e:MouseEvent) {
			goingToWork=true;
		}
		function osa1Change(e:MouseEvent) {
			
			if (tmpArr[2]=="Pena Kauppinen") {
				if (tmpArr[3]=="1") {
					mcSpotScreen.osa1.gotoAndStop(1);
					tmpArr[3]="2";
				}
				else if (tmpArr[3]=="2"){
					mcSpotScreen.osa1.gotoAndStop(2);
					tmpArr[3]="1";
				}
				
			}
		}
		function osa2Change(e:MouseEvent) {
			if (tmpArr[2]=="Pena Kauppinen") {
				if (tmpArr[3]=="2") {
					mcSpotScreen.osa2.gotoAndStop(1);
					tmpArr[3]="3"
				}
				else if (tmpArr[3]=="3"){
					mcSpotScreen.osa2.gotoAndStop(2);
					tmpArr[3]="2";
				}
				
			}
		}
		function osa3Change(e:MouseEvent) {
			if (tmpArr[2]=="Pena Kauppinen") {
				if (tmpArr[3]=="3") {mcSpotScreen.osa3.gotoAndStop(1);tmpArr[3]="4"}
				else if (tmpArr[3]=="4"){
					mcSpotScreen.osa3.gotoAndStop(2);
					tmpArr[3]="3";
				}
				
			}
		}
		public function placeAll(Arr:Array) {
			tmpArr=Arr;
			if (Arr[2]!="0") mcSpotScreen.headerText.text=Arr[0]+": "+Arr[1]+": "+Arr[2];
			else mcSpotScreen.headerText.text=Arr[0]+": "+Arr[1]+": VARAA";
			if(Arr[3]=="1") {
				mcSpotScreen.osa1.gotoAndStop(2);
				mcSpotScreen.osa2.gotoAndStop(2);
				mcSpotScreen.osa3.gotoAndStop(2);
			}
			else if (Arr[3]=="2") {
				mcSpotScreen.osa1.gotoAndStop(1);
				mcSpotScreen.osa2.gotoAndStop(2);
				mcSpotScreen.osa3.gotoAndStop(2);
			}
			else if (Arr[3]=="3"){
				mcSpotScreen.osa1.gotoAndStop(1);
				mcSpotScreen.osa2.gotoAndStop(1);
				mcSpotScreen.osa3.gotoAndStop(2);
			}
			else {
				mcSpotScreen.osa1.gotoAndStop(1);
				mcSpotScreen.osa2.gotoAndStop(1);
				mcSpotScreen.osa3.gotoAndStop(1);
			}
		}

	}
	
}
