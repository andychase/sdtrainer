package  
{
	import com.adobe.utils.IntUtil;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.tweens.motion.LinearMotion;
	import net.flashpunk.tweens.motion.Motion;
	/**
	 * ...
	 * @author Andy Chase
	 */
	public class TalkBox extends Entity
	{
		public static var talkTo:String;
		
		private var currentlyTalkingTo:String;
		private var textObj:Text;
		private var hide:Boolean;
		
		public function TalkBox() 
		{
			x = 100;
			y = -150;
			addGraphic(new Image(Assets.CHAT));
			
			var textOptions:Object = new Object();
			textOptions.color = 0x000;
			textOptions.width = 360;
			textOptions.size = 20;
			textOptions.wordWrap = true;
			
			textObj = new Text("", 20, 20, textOptions);
			
			hide = true;
			
			addGraphic(textObj);
		}
		
		override public function update():void {
			check();
			if (!hide) moveTowards(100, 0, 30);
			if (hide) moveTowards(100, -150, 30);
		}
		
		private function activate(stringToSay:String):void {
			textObj.text = stringToSay;
			hide = false;
		}
		
		private function deactivate():void {
			hide = true;
			
		}
		
		private function check():void {
			var talkTo:String = TalkBox.talkTo;
			if (talkTo!=currentlyTalkingTo) {
				if (talkTo == "") deactivate();
				else activate(randomPick(Assets.chatWords[talkTo]));
				currentlyTalkingTo = talkTo;
			}
			
		}
		
		private function randomPick(inArray:Array):String {
			var number:int = Math.floor(Math.random()*(inArray.length));
			return inArray[number];
		}
		
		
		
	}

}