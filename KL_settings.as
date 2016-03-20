package  {
	import flash.display.*;
	import flash.system.Capabilities;
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.media.SoundChannel;
	import flash.media.Sound;
	import fl.controls.List;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.media.SoundTransform;
	
	public class KL_settings extends MovieClip {
		public var isDown:Boolean = false;
		public var locked:Boolean = false;
		public var settingsOpened=false;
		public var settingsClosed=true;
		public var previousState:int = 1;
		public var vibration:Boolean = true;
		public var volumeSetting:int = 50;
		public var songName:String = "havusaurus.mp3";
		var mySound:Sound;
		var myChannel:SoundChannel = new SoundChannel();
		var myTransform = new SoundTransform();
		var songList:Array = new Array();
		var mcSettings:settingsSlider = new settingsSlider();
		var mcSettingsScreen:settingsscreen = new settingsscreen();
		var mcSettis:MovieClip = new MovieClip();
		var bitmapData:BitmapData;
		var bitmap:Bitmap;
		var list:List=new List();
		var xmlLoader:URLLoader = new URLLoader();
		var xmlData:XML = new XML();
		
		public function addSlider() {
			mcSettings.x=100;
			mcSettings.y=100;
			mcSettings.addEventListener(MouseEvent.MOUSE_MOVE, dragSlider);
			return mcSettings;
		}
		public function addSettingsScreen() {
			mcSettis.x=100;
			mcSettis.y=100;
			return mcSettis;
		}
		public function addSettingsMenu() {
			mcSettingsScreen.x=100;
			mcSettingsScreen.y=100;
			mcSettingsScreen.vibrating.addEventListener(MouseEvent.CLICK,vibratingChange);
			mcSettingsScreen.slider.addEventListener(MouseEvent.MOUSE_MOVE, changeVolume);
			xmlLoader.addEventListener(Event.COMPLETE,LoadXML);
			xmlLoader.load(new URLRequest("songData.xml"));
			function LoadXML(e:Event):void {
				xmlData = new XML(e.target.data);
				buildList();
			}
			mcSettingsScreen.soundClick.addEventListener(MouseEvent.CLICK,openList);
			return mcSettingsScreen;
		}
		function buildList() {
			list.setSize(mcSettingsScreen.soundClick.width, mcSettingsScreen.soundClick.height);
			list.move(mcSettingsScreen.soundClick.x,mcSettingsScreen.soundClick.y);
			var songListXML:XMLList = xmlData.song.songname;
			for each(var songElement:XML in songListXML) {
				songList.push(songElement);
			}
			songName = songList[0];
			mcSettingsScreen.soundName.text = songName;
			for (var i=0;i<songList.length;i++) {
				list.addItem({label: songList[i]});
			}
			list.rowHeight =40;
			list.addEventListener(Event.CHANGE,itemClick);
		}
		function itemClick(e:Event) {
			songName = e.target.selectedItem.label;
			mcSettingsScreen.soundName.text = songName;
			mySound = new Sound(new URLRequest(songName));
			myChannel.stop();
			myChannel = mySound.play();
			myChannel.soundTransform = myTransform;
			mcSettingsScreen.removeChild(list);
		}
		function openList(e:MouseEvent) {
			mcSettingsScreen.addChild(list);
		}
		function changeVolume(e:MouseEvent) {
			if (isDown) {
				if (e.stageX<mcSettingsScreen.slider.x+100) {
					mcSettingsScreen.slider.volumeSlider.width=0;
					volumeSetting = 0;
				}
				else if (e.stageX>=mcSettingsScreen.slider.x+mcSettingsScreen.slider.width+93) {
					mcSettingsScreen.slider.volumeSlider.width=397;
					volumeSetting=100;
				}
				else {
					mcSettingsScreen.slider.volumeSlider.width = (e.stageX-mcSettingsScreen.slider.x-100)/3*4;
					volumeSetting=(mcSettingsScreen.slider.volumeSlider.width/mcSettingsScreen.slider.width)*100;
				}
				myTransform.volume=volumeSetting/100;
				myChannel.soundTransform = myTransform;
			}
		}
		function vibratingChange(e:MouseEvent) {
			if (!vibration) {
				mcSettingsScreen.vibrating1.gotoAndStop(1);
				vibration=true;
			}
			else {
				mcSettingsScreen.vibrating1.gotoAndStop(2);
				vibration=false;
			}
		}
		function dragSlider(e:MouseEvent) {
			if (isDown) {
				locked=false;
				if (e.stageY<mcSettings.height/2+100) { mcSettings.y = 100;}
				else if (e.stageY>868-50) {mcSettings.y = 868-100;}
				else {mcSettings.y=e.stageY-50; mcSettis.visible=true}
				drawBitmap();
				settingsClosed=false;
			}
			else {
				if (mcSettings.y > 600) {mcSettings.y = 868-100; locked=true;}
				else {mcSettings.y=100; locked=false; settingsClosed=true; mcSettis.visible=false}
				drawBitmap();
			}
		}
		function drawBitmap() {
			var bmdCanvas:BitmapData = new BitmapData(1024,668,true,0);
			bitmapData = new BitmapData(1024,668);
			bitmapData.draw(mcSettingsScreen);
			bmdCanvas.copyPixels(bitmapData,new Rectangle(0,0,1024,mcSettings.y),new Point(0,0),null,null,true);
			bitmap = new Bitmap(bmdCanvas);
			mcSettis.addChildAt(bitmap,0);
			while(mcSettis.numChildren>1) {
				(mcSettis.getChildAt(1) as Bitmap).bitmapData.dispose();
				mcSettis.removeChildAt(1);
			}
		}

	}
	
}
