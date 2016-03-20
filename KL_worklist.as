package  {
	import flash.display.*;
	import flash.system.Capabilities;
	import flash.events.*;
	import flash.net.*;
	import fl.controls.ScrollBar;
	
	public class KL_worklist extends MovieClip {
		var mcWorkScreen:workscreen;
		var mcSpot:spotPlace;
		var mcPlace:placeHeader;
		public var goingToMain:Boolean=false;
		var work_Array:Array = new Array();
		var spotArray:Array = new Array();
		var tmpArray:Array = new Array();
		var spotTmpArray:Array=new Array();
		public var goingToSpot:Boolean=false;
		var xmlLoader:URLLoader = new URLLoader();
		var xmlData:XML = new XML();
		var WorkList:XMLList = new XMLList();
		var warkList:XMLList = new XMLList();
		
		public function showWorkList() {
			mcWorkScreen = new workscreen();
			mcWorkScreen.x=100;
			mcWorkScreen.y=100;
			mcWorkScreen.button_tomain.addEventListener(MouseEvent.CLICK,goToMain);
			xmlLoader.addEventListener(Event.COMPLETE,LoadXML);
			xmlLoader.load(new URLRequest("workData.xml"));
			function LoadXML(e:Event):void {
				xmlData = new XML(e.target.data);
				createWorkArray();
				mcWorkScreen.scrollPane.source=mcWorkScreen.placeField;
				mcWorkScreen.scrollPane.setSize(768,450);
			}
			
			return mcWorkScreen;
		}
		
		function goToMain(e:MouseEvent) {
			goingToMain=true;
		}
		public function refreshBoxes(Arr:Array) {
			for (var i:int=0;i<spotTmpArray.length;i++) {
				if(spotTmpArray[i].varaus.varaaja.text==Arr[2] && spotTmpArray[i].placeText.text == Arr[1]) {
					spotTmpArray[i].checkBox.gotoAndStop(Arr[3]);
				}
			}
		}
		function createWorkArray() {
			WorkList = xmlData.place;
			var i:int=0;
			for each (var place:XML in WorkList) {
				work_Array.push(new Array());
				work_Array[i].push(place.placeName);
				for each (var spot in place.spot) {
					work_Array[i].push(new Array(spot.spotName, spot.User, spot.State));
					spotArray.push(new Array(place.placeName,spot.spotName,spot.User,spot.State));
				}
				i++;
				
			}
			var m:int=0;
			var count:int=0;
			for (var j=0;j<work_Array.length;j++) {
				mcPlace = new placeHeader();
				mcPlace.x=0;
				mcPlace.y=m;
				mcPlace.placeText.text = work_Array[j][0];
				mcWorkScreen.placeField.addChild(mcPlace);
				m+=mcPlace.height;
				for (var k=1;k<work_Array[j].length;k++) {
					mcSpot = new spotPlace();
					mcSpot.x = 0;
					mcSpot.y=m;
					mcSpot.placeText.text = work_Array[j][k][0];
					mcSpot.button_spotPlace.addEventListener(MouseEvent.CLICK,goToSpot(count));
					if (work_Array[j][k][1]!="0") {
						mcSpot.varaus.varaaja.textColor=0x000000;
						mcSpot.varaus.varaaja.text=work_Array[j][k][1];
					}
					else {
						mcSpot.varaus.addEventListener(MouseEvent.CLICK,varaa(count));
					}
					mcSpot.checkBox.gotoAndStop(work_Array[j][k][2]);
					spotTmpArray.push(mcSpot);
					mcWorkScreen.placeField.addChild(mcSpot);
					m+=mcSpot.height;
					count++;
				}
			}
			
		}
		function goToSpot(Count:int) {
			return function(e:MouseEvent):void {
				tmpArray=spotArray[Count];
				goingToSpot=true;
			}
		}
		function varaa(Count:int) {
			return function(e:MouseEvent):void {
				if (e.target.text =="Pena Kauppinen") {
				e.target.textColor=0x339900;
				e.target.text="VARAA";
				spotArray[Count][2]=0;
				}
				else {
					e.target.textColor=0x000000;
					e.target.text="Pena Kauppinen";
					spotArray[Count][2]="Pena Kauppinen";
				}
			}
		}

	}
	
}
