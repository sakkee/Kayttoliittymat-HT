package  {
	import flash.display.*;
	import flash.system.Capabilities;
	import flash.events.*;
	
	public class KL_mainmenu extends MovieClip {
		var mcMainScreen:mainscreen;
		public var loggingout:Boolean = false;
		public var goingToChat:Boolean = false;
		public var goingToWork:Boolean = false;
		public var goingToCamera:Boolean = false;
		public function showMainMenu() {
			mcMainScreen = new mainscreen();
			mcMainScreen.x=100;
			mcMainScreen.y=100;
			mcMainScreen.workApp.addEventListener(MouseEvent.CLICK,openWorkList);
			mcMainScreen.exitApp.addEventListener(MouseEvent.CLICK,logout);
			mcMainScreen.chatApp.addEventListener(MouseEvent.CLICK,goToChat);
			mcMainScreen.cameraApp.addEventListener(MouseEvent.CLICK,goToCamera);
			return mcMainScreen;
		}
		function openWorkList(e:MouseEvent) {
			goingToWork=true;
		}
		function goToChat(e:MouseEvent) {
			goingToChat=true;
		}
		function logout(event:MouseEvent) {
			loggingout=true;
		}
		function goToCamera(e:MouseEvent) {
			goingToCamera=true;
		}
	}
	
}
