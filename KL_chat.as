package  {
	import flash.display.*;
	import flash.system.Capabilities;
	import flash.events.*;
	import fl.controls.ScrollBar;
	
	public class KL_chat {
		var mcChatScreen:chatscreen;
		var mcChatMsg:chatMsg;
		var chatLog:Array = new Array(["1", "Kimmo, voisitko hoitaa huomisen keikan?"], ["2", "Jos saan lisiä"], ["1", "Et saa"], ["3", "Halloojata halloo... "], ["3", "Kaatu kaliat uhrim päälle saako vero vähemmyksiä (työ tapa turma)???"], ["4", "Mitä h*lvettiä Pena???"], ["3", "Sinne meni periantai kaliat........................"],["3", "Elämä on vittujen elämä,,, ei per**kele !!!!,,,, joudun käymään kaupassa tyä päiväm jälkeen,,,,,,,,,"],["3", "suaattaapi olla että riipasem tänääm kovam kännim,,,,,,,,"],["3", "helvettiläöinem"] )
		public var returningToMenu:Boolean = false;
		public function showChat() {
			mcChatScreen = new chatscreen();
			mcChatScreen.x=100;
			mcChatScreen.y=100;
			mcChatScreen.button_return.addEventListener(MouseEvent.CLICK,returnToMain);
			mcChatScreen.button_enter.addEventListener(MouseEvent.CLICK,sendMessage);
			createChatField();
			mcChatScreen.scrollPane.source=mcChatScreen.chatField;
			mcChatScreen.scrollPane.setSize(mcChatScreen.chatField.width+15,537);
			
			return mcChatScreen;
		}
		public function updateProfiles(array:Array) {
			mcChatScreen.profile1.profile_middle.gotoAndStop(1);
			mcChatScreen.profile1.profilename.text = array[0];
			mcChatScreen.profile2.profile_middle.gotoAndStop(2);
			mcChatScreen.profile2.profilename.text = array[1];
			mcChatScreen.profile3.profile_middle.gotoAndStop(3);
			mcChatScreen.profile3.profilename.text = array[2];
			mcChatScreen.profile4.profile_middle.gotoAndStop(4);
			mcChatScreen.profile4.profilename.text = array[3];
			
		}
		function pushNewMsg(user:int, msg:String) {
			mcChatMsg = new chatMsg();
			mcChatMsg.x=0;
			mcChatMsg.y=mcChatScreen.chatField.height;
			mcChatMsg.profile_middle.gotoAndStop(user);
			mcChatMsg.chatText.text = msg;
			mcChatScreen.chatField.addChild(mcChatMsg);
			mcChatScreen.scrollPane.update();
			mcChatScreen.scrollPane.verticalScrollPosition=mcChatScreen.scrollPane.maxVerticalScrollPosition;
		}
		function createChatField() {
			for (var i=0;i<chatLog.length;i++) {
				mcChatMsg = new chatMsg();
				mcChatMsg.x=0;
				mcChatMsg.y=mcChatMsg.height*i;
				mcChatMsg.profile_middle.gotoAndStop(chatLog[i][0]);
				mcChatMsg.chatText.text = chatLog[i][1];
				mcChatScreen.chatField.addChild(mcChatMsg);
			}
		}
		function sendMessage(e:MouseEvent) {
			if (mcChatScreen.enteringText.text!="") {
				pushNewMsg(3,mcChatScreen.enteringText.text);
				mcChatScreen.enteringText.text="";
			}
		}
		function returnToMain(e:MouseEvent) {
			returningToMenu = true;
		}
	}
	
}
