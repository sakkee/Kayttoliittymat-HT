package  {
	import flash.display.*;
	import flash.system.Capabilities;
	import flash.events.*;
	import flash.filters.*;
	import flash.utils.Timer;
	import flash.net.*;
	
	public class KL_login extends MovieClip {
		
		var mcLoginScreen:loginscreen;
		//Login screen stuff
		var password_Array:Array = new Array();
		var login_Buttons:Array = new Array();
		var user_Array:Array = new Array();
		var line_Array:Array = new Array();
		var glow:GlowFilter;
		var glow_red:GlowFilter;
		var timerPwExit:Timer = new Timer(750,1);
		var my_shape:Shape;
		var profileIndex:int=2;
		var xmlLoader:URLLoader = new URLLoader();
		var xmlData:XML = new XML();
		var userList:XMLList = new XMLList();
		public var pwFail:Boolean = false;
		public var passwordTrue:Boolean = false;
		public var isDown:Boolean = false;

		
		
		//Clear the password area and checks if the entered password is right
		public function clearPwArea(mcLogin:loginscreen) {
			for each(var myshape:Shape in line_Array) {
				mcLogin.removeChild(myshape);
			}
			for each (var passwordDot:password_dot in login_Buttons) {
				if (passwordDot.filters.length>0)passwordDot.filters=[]
			}
			password_Array.length=0;
			line_Array.length=0;
			return mcLogin;
		}
		function forcePwExit() {
			if (password_Array.length>0) {
				if (!pwFail) checkPassword();
				if (!passwordTrue) {
					pwFail=false;
					
					//Password was wrong, red glow. After the red glow (timer), clear the area
					for each(var passwordDot:password_dot in login_Buttons) {
						if (passwordDot.filters.length>0) passwordDot.filters = [glow_red];
					}
					for each(var myshape:Shape in line_Array) {
						mcLoginScreen.removeChild(myshape);
					}
					line_Array.length=0;
					timerPwExit.addEventListener(TimerEvent.TIMER_COMPLETE, clearPw)
					timerPwExit.start();
					function clearPw(event:TimerEvent) {
						for each(var passwordDot:password_dot in login_Buttons) {
							if (passwordDot.filters.length>0) passwordDot.filters = [];
						}
						password_Array.length=0;
					}
				}
			}
		}
		
		//Checks whether the moving mouse, which is down, hits any of the password buttons
	
		function checkPwCollision(e:MouseEvent):void {
			if(isDown) {
				for each(var passwordDot:password_dot in login_Buttons) {
					if (e.target == passwordDot) {
						//If no filters already applied, then add a glow filter
						//If the item isn't already in the array, then add it
						if(password_Array.indexOf(passwordDot)==-1) {
							//If the button locates next to the previously pressed button
							if(password_Array.length>0) {
								//Checks whether the found button is within +-1 range of the previous button
								if (Math.abs(password_Array[password_Array.length-1].positionJ-passwordDot.positionJ)<2 && Math.abs(password_Array[password_Array.length-1].positionI-passwordDot.positionI)<2) {
									if(passwordDot.filters.length==0) {
										passwordDot.filters = [glow];
										drawLine(password_Array[password_Array.length-1].x, password_Array[password_Array.length-1].y, passwordDot.x,passwordDot.y);
									}
									password_Array.push(passwordDot);
								}
								//If not, force exit
								else {
									pwFail=true;
									forcePwExit();
								}
							}
							//Password array is empty so no need to check for range
							else {
								password_Array.push(passwordDot);
								if(passwordDot.filters.length==0) passwordDot.filters = [glow];
							}
						}
					}
				}
			}
		}
		
		function checkPassword() {
			//Reads the password of the user
			var rightpw = xmlData.user.(@UID==profileIndex).userpassword.text();
			//Samples the right password to an array
			var pwCheck_Array:Array = new Array();
			var rightpw_Array = rightpw.split(";");
			for (var i=0;i<rightpw_Array.length;i++) {
				rightpw_Array[i] = rightpw_Array[i].split(",");
				for (var j=0;j<rightpw_Array[i].length;j++) {
					rightpw_Array[i][j] = int(rightpw_Array[i][j]);
				}
			}
			//Pushes the password given by the user to an array
			for each(var passwordDot:password_dot in password_Array) {
				pwCheck_Array.push(new Array(passwordDot.positionI, passwordDot.positionJ));
			}
			passwordTrue=true;
			//Check if array lengths don't match
			if(pwCheck_Array.length != rightpw_Array.length) {
				passwordTrue=false;
			}
			//Checks whether the password is right or wrong
			else {
				try {
					for (var k=0;k<rightpw_Array.length;k++) {
						for (var l=0;l<rightpw_Array[k].length;l++) {
							if (pwCheck_Array[k][l] != rightpw_Array[k][l]) {
								passwordTrue=false;
								break;
							}
						}
					}
				}
				catch(e) {passwordTrue=false;};
			}
		}
		//function used to draw lines between buttons
		function drawLine(startX:int, startY:int, destinationX:int, destinationY:int) {
			var my_shape:Shape = new Shape();
			mcLoginScreen.addChild(my_shape);
			my_shape.graphics.lineStyle(5,0x00AA00,1);
			my_shape.graphics.moveTo(startX,startY);
			my_shape.graphics.lineTo(destinationX,destinationY);
			line_Array.push(my_shape);
		}
		//Creats glow
		function glowReturn(color:int){
			var glow:GlowFilter = new GlowFilter();
			if (color==0) glow.color=0x00FF00;
			if (color==1) glow.color=0xFF0000;
			glow.alpha = 1;
			glow.blurX = 10;
			glow.blurY = 10;
			return glow;
		}
		//updates profilepics
		function profilePicUpdate() {
			if (profileIndex<1) profileIndex=mcLoginScreen.profile_middle.totalFrames;
			else if(profileIndex>mcLoginScreen.profile_middle.totalFrames) profileIndex=1;
			
			if (profileIndex>1) mcLoginScreen.profile_left.gotoAndStop(profileIndex-1);
			else mcLoginScreen.profile_left.gotoAndStop(mcLoginScreen.profile_middle.totalFrames);
			mcLoginScreen.profile_middle.gotoAndStop(profileIndex);
			
			if (profileIndex<mcLoginScreen.profile_middle.totalFrames) mcLoginScreen.profile_right.gotoAndStop(profileIndex+1);
			else mcLoginScreen.profile_right.gotoAndStop(1);
			mcLoginScreen.nametext.text = xmlData.user.(@UID==profileIndex).username.text();
		}
		function createUserArray() {
			userList = xmlData.user.username;
			for each (var xml:XML in userList) {
				user_Array.push(xml);
			}
		}
		function scrollRight(e:MouseEvent):void {
			profileIndex++;
			profilePicUpdate();
		}
		function scrollLeft(e:MouseEvent):void {
			profileIndex--;
			profilePicUpdate();
		}
		public function showLoginScreen() {
			mcLoginScreen = new loginscreen();
			mcLoginScreen.x=100;
			mcLoginScreen.y=100;
			mcLoginScreen.addEventListener(MouseEvent.MOUSE_MOVE, checkPwCollision);
			mcLoginScreen.profile_right.addEventListener(MouseEvent.CLICK,scrollRight);
			mcLoginScreen.profile_left.addEventListener(MouseEvent.CLICK,scrollLeft);
			xmlLoader.addEventListener(Event.COMPLETE,LoadXML);
			profilePicUpdate();
			xmlLoader.load(new URLRequest("passwordData.xml"));
			function LoadXML(e:Event):void {
				xmlData = new XML(e.target.data);
				profilePicUpdate();
				createUserArray();
			}
			var start_x = 362;
			var start_y = 380;
			var step_x = 150;
			var step_y = 100;
			for (var i:int=0; i<3; i++) {
				for (var j:int=0; j<4; j++) {
					var passwordDot:password_dot = new password_dot();
					passwordDot.x = start_x+i*step_x;
					passwordDot.y = start_y+j*step_y;
					mcLoginScreen.addChild(passwordDot);
					login_Buttons.push(passwordDot);
					login_Buttons[login_Buttons.length-1].positionJ = j;
					login_Buttons[login_Buttons.length-1].positionI = i;
				}
			}
			glow = glowReturn(0);
			glow_red = glowReturn(1);
			return mcLoginScreen;
		}
	}
	
}
