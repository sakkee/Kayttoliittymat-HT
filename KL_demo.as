package  {
	import flash.display.*;
	import flash.system.Capabilities;
	import flash.events.*;
	import flash.filters.*;
	import flash.utils.Timer;
	import flash.net.*;
	import flash.media.SoundChannel;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.media.SoundTransform;

	public class KL_demo extends MovieClip {
		
		//Password list, NOTE THIS IS NOT A SAFE WAY TO HANDLE THE PASSWORDS
		
		//AppStates are to determine the screen which is opened
		var APPSTATE_LOGIN = 0;
		var APPSTATE_MAIN = 1;
		var APPSTATE_SETTINGS = 2;
		var APPSTATE_CAMERA = 3;
		var APPSTATE_CHAT = 4;
		var APPSTATE_WORK = 5;
		var APPSTATE_SPOT = 6;
		var appState:int = APPSTATE_LOGIN;
		var mainTick:Timer = new Timer(10,0);
		var login:KL_login = new KL_login();
		var mainmenu:KL_mainmenu = new KL_mainmenu();
		var settings:KL_settings = new KL_settings();
		var camera:KL_camera = new KL_camera();
		var chat:KL_chat = new KL_chat();
		var work:KL_worklist = new KL_worklist();
		var spot:KL_spot = new KL_spot();
		// Determine the screens and their movieclips
		var userArray:Array = new Array();
		var tmpArray:Array=new Array();
		var mcMainScreen:mainscreen;
		var mcLoginScreen:loginscreen;
		var mcSettings:settingsSlider;
		var mcSettingsScreen:settingsscreen;
		var mcChatScreen:chatscreen;
		var mcWorkScreen:workscreen;
		var mcSpotScreen:spotscreen;
		var mcCameraScreen:camerascreen;
		var mcSettis:MovieClip;
		
		var songName:String = "havusaurus.mp3";
		var volumeSetting:int = 50;
		var mySound:Sound;
		var myChannel:SoundChannel = new SoundChannel();
		var myTransform = new SoundTransform();
		
		var settingsOnTop:MovieClip = new MovieClip();
		var otherOnBot:MovieClip = new MovieClip();
		//Mouse variable, to check whether mouse is down or not
		
		
		public function KL_demo() {
			mainTick.addEventListener(TimerEvent.TIMER,main_tick);
			mainTick.start();
			mcLoginScreen = login.showLoginScreen();
			mcMainScreen = mainmenu.showMainMenu();
			mcSettings = settings.addSlider();
			mcSettis = settings.addSettingsScreen();
			mcSettingsScreen = settings.addSettingsMenu();
			mcChatScreen = chat.showChat();
			mcWorkScreen = work.showWorkList();
			mcSpotScreen = spot.openSpot();
			mcCameraScreen=camera.openCamera();
			addChild(otherOnBot);
			addChild(settingsOnTop);
			otherOnBot.addChild(mcLoginScreen);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			function onMouseDown(evt:MouseEvent):void {
				if (appState==APPSTATE_LOGIN)login.isDown=true;
				else settings.isDown=true; //;
			}
			function onMouseUp(evt:MouseEvent):void {
				if (appState==APPSTATE_LOGIN) {
					login.isDown=false;
					login.forcePwExit();
				}
				else settings.isDown=false;
			}
		}
		
		function main_tick(event:TimerEvent) {
			if (appState != APPSTATE_SETTINGS)  {
				settings.previousState = appState;
				if (settings.locked) {
					appState=APPSTATE_SETTINGS
				}
			}
			switch (appState) {
				case APPSTATE_LOGIN:
					if (login.passwordTrue) passwordRight();
					break;
				case APPSTATE_MAIN:
					if (mainmenu.loggingout) logout();
					else if (mainmenu.goingToChat) chatOpen();
					else if (mainmenu.goingToWork) workOpen();
					else if(mainmenu.goingToCamera) cameraOpen();
					break;
				case APPSTATE_SETTINGS:
					if (!settings.locked && settings.settingsOpened==true) {appState=settings.previousState;settingsOnTop.removeChild(mcSettingsScreen);settings.settingsOpened=false;songName = settings.songName;volumeSetting=settings.volumeSetting}
					else if (settings.locked && settings.settingsOpened==false && !settings.settingsClosed) {settingsOnTop.addChild(mcSettingsScreen);settings.settingsOpened=true;}
					break;
				case APPSTATE_CHAT:
					if (chat.returningToMenu) chatClose();
					break;
				case APPSTATE_WORK:
					if (work.goingToMain) workClose();
					else if (work.goingToSpot) openSpot();
					break;
				case APPSTATE_SPOT:
					if(spot.goingToWork) spotClose();
					break;
				case APPSTATE_CAMERA:
					if(camera.returnToMain) cameraClose();
					break;
			}
			
		}
		function cameraClose() {
			otherOnBot.removeChild(mcCameraScreen);
			camera.returnToMain=false;
			appState=APPSTATE_MAIN;
			otherOnBot.addChild(mcMainScreen);
		}
		function cameraOpen(){
			otherOnBot.removeChild(mcMainScreen);
			mainmenu.goingToCamera=false;
			appState=APPSTATE_CAMERA;
			otherOnBot.addChild(mcCameraScreen);
		}
		function spotClose() {
			tmpArray = spot.tmpArr;
			otherOnBot.removeChild(mcSpotScreen);
			spot.goingToWork=false;
			appState=APPSTATE_WORK;
			work.refreshBoxes(tmpArray);
			otherOnBot.addChild(mcWorkScreen);
		}
		function openSpot(){
			otherOnBot.removeChild(mcWorkScreen);
			work.goingToSpot=false;
			appState=APPSTATE_SPOT;
			spot.placeAll(work.tmpArray);
			otherOnBot.addChild(mcSpotScreen);
		}
		function workOpen() {
			otherOnBot.removeChild(mcMainScreen);
			mainmenu.goingToWork=false;
			appState=APPSTATE_WORK;
			otherOnBot.addChild(mcWorkScreen);
		}
		function workClose() {
			otherOnBot.removeChild(mcWorkScreen);
			work.goingToMain=false;
			appState=APPSTATE_MAIN;
			otherOnBot.addChild(mcMainScreen);
		}
		function chatOpen() {
			otherOnBot.removeChild(mcMainScreen);
			mainmenu.goingToChat=false;
			appState = APPSTATE_CHAT;
			chat.updateProfiles(userArray);
			otherOnBot.addChild(mcChatScreen);
		}
		function chatClose() {
			otherOnBot.removeChild(mcChatScreen);
			chat.returningToMenu=false;
			appState = APPSTATE_MAIN;
			otherOnBot.addChild(mcMainScreen);
		}
		function passwordRight() {
			otherOnBot.removeChild(mcLoginScreen);
			login.passwordTrue=false;
			login.pwFail=false;
			appState=APPSTATE_MAIN;
			mcLoginScreen = login.clearPwArea(mcLoginScreen);
			userArray = login.user_Array;
			otherOnBot.addChild(mcMainScreen);
			
			settingsOnTop.addChild(mcSettis);
			settingsOnTop.addChild(mcSettings);
		}
		
		
		function logout() {
			otherOnBot.removeChild(mcMainScreen);
			settingsOnTop.removeChild(mcSettis);
			settingsOnTop.removeChild(mcSettings);
			appState = APPSTATE_LOGIN;
			mainmenu.loggingout=false;
			otherOnBot.addChild(mcLoginScreen);
		}
		

	}
	
}
