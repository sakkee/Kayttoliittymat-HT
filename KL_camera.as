package  {
	import flash.events.*;
	import flash.display.*;
	public class KL_camera {
		var mcCameraScreen:camerascreen;
		public var returnToMain:Boolean = false;
		public function openCamera() {
			mcCameraScreen = new camerascreen();
			mcCameraScreen.x=100;
			mcCameraScreen.y=100;
			mcCameraScreen.button_tomain.addEventListener(MouseEvent.CLICK,goToMain);
			return mcCameraScreen;
		}
		function goToMain(e:MouseEvent) {
			returnToMain=true;
		}

	}
	
}
