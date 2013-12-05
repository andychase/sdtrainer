package  
{
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import net.flashpunk.Entity;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Key;
	import net.flashpunk.utils.Input;
	import net.flashpunk.graphics.Canvas;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Andy Chase
	 */
	
	public class GameMenuEntity extends Entity
	{
		[Embed(source = 'assets/cutscenes.swf', symbol = "Introduction")]  private var IntroClip:Class;
		[Embed(source = 'assets/cutscenes.swf', symbol = "Concentrate")]   private var ConClip:Class;
		[Embed(source = 'assets/cutscenes.swf', symbol = "Scenery")]       private var SceneClip:Class;
		[Embed(source = 'assets/cutscenes.swf', symbol = "PhoneCall")]     private var PhoneCallClip:Class;
		[Embed(source = 'assets/cutscenes.swf', symbol = "Character")]     private var CharClip:Class;
		[Embed(source = 'assets/cutscenes.swf', symbol = "Action")]  	   private var ActionClip:Class;
		[Embed(source = 'assets/cutscenes.swf', symbol = "HangUp")]    	   private var HangUp:Class;
		[Embed(source = 'assets/cutscenes.swf', symbol = "Uhohs")]    	   private var Uhohs:Class;
		
		private var conClip:MovieClip;
		private var charClip:MovieClip;
		
		private var phoneCallTimer:Timer;
		private var letterPressed:String;
		
		private var activeClip:MovieClip;
		private var functionWhenDone:Function;
		
		private var topleftText:Text;
		private var topleftEmphTextStyle:Object;
		private var bottomText:Text;
		private var bottomrightText:Text;
		
		public var score:int=0; // Public for tweening
		public var storyTime:int = 0; // Public for tweening
		private var timeToDoStory:int;
		private var menu:String = "\nQ] Password Reset\nW] Work Order\nE] Simple Question\nR] Sales Call";
		
		//Special vars for different modes
		private var characterIntroLabels:Array;
		private var randomCharacterLabel:int;
		private var storyMode:Boolean;
		private var introMode:Boolean;
		private var personStory:PersonStory;
		private var storyTimer:Timer = new Timer(100);
		
		public function GameMenuEntity() 
		{
			// Setup Settings
			width = 640;
			height = 640;
			
			// Set up text sections styles
			var topleftTextStyle:Object = new Object();
			topleftTextStyle.color = 0x000;
			topleftTextStyle.width = 250;
			topleftTextStyle.wordWrap = true;
			topleftTextStyle.size = 16;
			
			
			topleftEmphTextStyle = new Object();
			topleftEmphTextStyle.color = 0xEEE;
			topleftEmphTextStyle.size = 16;
			
			// Set up text sections
			topleftText = new Text("", 20, 20, topleftTextStyle);
			topleftText.richText = "";
			topleftText.setStyle("e", topleftEmphTextStyle);
			addGraphic(topleftText);
			
			bottomText = new Text("", halfWidth - 200, height - 100, topleftTextStyle);
			bottomText.setStyle("e", topleftEmphTextStyle);
			addGraphic(bottomText);
			
			bottomrightText = new Text("Score: "+score+menu, width - 200, height - 150, topleftTextStyle);
			addGraphic(bottomrightText);
			bottomrightText.visible = false;
			
			// Set up person story generator
			personStory = new PersonStory();
			
			// Start the game...
			intro();
		}
		
		override public function update():void {
			if (Input.pressed(Key.Q)) letterPressed = "Q";
			if (Input.pressed(Key.W)) letterPressed = "W";
			if (Input.pressed(Key.E)) letterPressed = "E";
			if (Input.pressed(Key.R)) letterPressed = "R";
			bottomrightText.text = "Score: " + score;
			if (storyMode) {
				bottomrightText.text = "Score: " + score + menu;
			}
			if (introMode && letterPressed == "Q") {
				letterPressed = "";
				activeClip.gotoAndStop(activeClip.currentFrame+1);
			}
		}
		
		// Flow of the game:
		// Intro animation
		private function intro():void {
			showClip(IntroClip, introDone);
			activeClip.addEventListener(Event.ENTER_FRAME, introCaptions);
			introMode = true;
			activeClip.stop();
		}
		public function introCaptions(e:Event):void {
			activeClip.stop();
			if (activeClip.currentLabel == "1") {
				bottomText.text = "This is your beautiful desk."
			}
			if (activeClip.currentLabel == "2") {
				bottomText.text = "This is your beautiful phone. Answer it when it rings."
			}
			if (activeClip.currentLabel == "3") {
				bottomText.text = "This is a beautiful customer. Make it happy."
			}
			if (activeClip.currentLabel == "4") {
				bottomText.text = "These are the only 4 things you can do. Choose wisely."
			}
			if (activeClip.currentLabel == "5") {
				bottomText.richText = "The words in <e>blue</e> are important."
			}
			if (activeClip.currentLabel == "6") {
				bottomText.text = "Good luck!"
			}
		}
		public function introDone():void {
			introMode = false;
			activeClip.removeEventListener(Event.ENTER_FRAME, introCaptions);
			bottomText.text = "";
			scenery();
		}
		// Cut scene of peacefull things (random delay)...Phone call!
		private function scenery():void {
			bottomText.text = "";
			bottomrightText.visible = false;
			
			activeClip = new SceneClip();
			addClip(activeClip);
			activeClip.gotoAndPlay(FP.rand(activeClip.totalFrames));
			var sceneryTimer:Timer = new Timer(FP.rand(3000) + 200, 1);
			sceneryTimer.start();
			sceneryTimer.addEventListener(TimerEvent.TIMER_COMPLETE, sceneryCallback);
		}
		private function sceneryCallback(e:Event):void {
			removeClip(activeClip);
			phoneCall();
		}
		// Phone call! Q to pick up W to leave
		private function phoneCall():void {
			bottomrightText.visible = false;
			letterPressed = "";
			
			bottomText.text = "Phone call!\n Q] Answer\n W] Leave & Explore";
			phoneCallTimer = new Timer(100, FP.rand(30) + 4);
			phoneCallTimer.start();
			phoneCallTimer.addEventListener(TimerEvent.TIMER_COMPLETE, didntPickUpInTimeListener);
			phoneCallTimer.addEventListener(TimerEvent.TIMER, phoneCallTickListener);
			
			showClip(PhoneCallClip, charIntro);
			activeClip.gotoAndStop(1);
		}
		public function phoneCallTickListener(e:Event):void {
			if (letterPressed == "Q") {
				phoneCallTimer.stop();
				activeClip.gotoAndPlay(3);
				bottomText.text = "Got it!";
			}
			if (letterPressed == "W") {
				activeClip.removeEventListener(Event.ENTER_FRAME, callbackListener);
				phoneCallTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, didntPickUpInTimeListener);
				removeClip(activeClip);
				FP.world = new WalkWorld(score);
			}
		}
		public function didntPickUpInTimeListener(e:Event):void {
			removeClip(activeClip);
			activeClip.removeEventListener(Event.ENTER_FRAME, callbackListener);
			phoneCallTimer.stop();
			bottomrightText.visible = true;
			consequence("didn't pick up phone in time");
		}
		// Caller introduction
		private function charIntro():void {
			bottomText.text = "A wild caller has appeared!";
			charClip = new CharClip();
			addClip(charClip);

			characterIntroLabels     = charClip.currentLabels;
			randomCharacterLabel     = FP.rand(characterIntroLabels.length);
			var labelToPlay:String   = characterIntroLabels[randomCharacterLabel].name;
			charClip.gotoAndPlay(labelToPlay);
			
			var lastframe:int = 0;
			
			var charClipCallBack:Function = function checkCharIntroOver(e:Event):void {
				if (charClip.currentLabel != labelToPlay) {
					charClip.removeEventListener(Event.ENTER_FRAME, charClipCallBack);
					charClip.gotoAndStop(lastframe);
					concentrate();
				}
				lastframe = charClip.currentFrame;
			}
			
			charClip.addEventListener(Event.ENTER_FRAME, charClipCallBack);
		}
		// CONCENTRATE
		private function concentrate():void {
			conClip = new ConClip();
			addClip(conClip);
			var concentrateTimer:Timer = new Timer(100, FP.rand(40)+7);
			concentrateTimer.start();
			concentrateTimer.addEventListener(TimerEvent.TIMER_COMPLETE, endConcentrateListener);
		}
		public function endConcentrateListener(e:Event):void {
			removeClip(conClip);
			story();
		}
		// Story+"What do you do?"+Options + Seconds counter
		private function story():void {
			letterPressed = "";
			bottomrightText.visible = true;
			bottomText.text = "";
			
			storyMode = true;
			personStory.NewStory();
			topleftText.richText = personStory.richText;
			storyTime = 0;
			if (score<1300) timeToDoStory = (((-1/300)*score)+5)
			else timeToDoStory = .2 * FP.rand(4); // This value is in seconds
			storyTimer = new Timer(40, 25*timeToDoStory)
			storyTimer.addEventListener(TimerEvent.TIMER, storyTick);
			storyTimer.addEventListener(TimerEvent.TIMER_COMPLETE, storyTimedOut);
			storyTimer.start();
		}
		public function storyTick(e:Event):void {
			storyTime += 40;
			bottomText.text = "Time: " + ((timeToDoStory*25*40) - storyTime) / 1000;
			if (letterPressed == "Q" || letterPressed == "W" || letterPressed == "E" || letterPressed == "R" ) {
				storyTimer.stop();
				personStory.userChoice = letterPressed;
				action(letterPressed);
			}
		}
		public function storyTimedOut(e:Event):void {
			consequence("too slow picking a response");
		}
		// Cut scene of action
		public function action(choice:String):void {
			switch (choice) {
				case "Q": showClipLabel(ActionClip, "Password", actionDone); break;
				case "W": showClipLabel(ActionClip, "WO", actionDone); break;
				case "E": showClipLabel(ActionClip, "SimpleQ", actionDone); break;
				case "R": showClipLabel(ActionClip, "Sales", actionDone); break;
				default: actionDone(); break;
			}
		}
		public function actionDone():void {
			if (personStory.WasRight()) {
				consequence("was right");
			} else {
				switch (personStory.userChoice) {
				case "Q": consequence("was wrong--password"); break;
				case "W": consequence("was wrong--work order"); break;
				case "E": consequence("was wrong--simple q"); break;
				case "R": consequence("was wrong--sales call"); break;
				default: consequence(); break;
				}
			}
		}
		// Consequences to actions cutscene - points & special events
		private function consequence(reason:String = ""):void {
			removeClip(charClip);
			removeClip(activeClip);
			bottomText.text = "";
			topleftText.text = "";
			storyMode = false;
			
			var scoreTween:VarTween = new VarTween(function ():void {bottomrightText.color = 0x000});
			//Based on what happen, pick consequence
			if (reason == "was right") {
				var responses:Array = ["That's right!", "Yep!", "Good Job!", "COOL!"];
				bottomText.text = responses[FP.rand(responses.length - 1)];
				bottomrightText.color = 0xEEE;
				scoreTween.tween(this, "score", score + 100, 1);
				showClip(HangUp, scenery);
			}
			if (reason == "was wrong--password") {
				bottomText.text = "They didn't need that!! You hath awakend the wrath of STEVE!!";
				bottomrightText.color = 0xff0000;
				scoreTween.tween(this, "score", score - FP.rand(100) - 200, 1);
				showClipLabel(Uhohs, "Steve", scenery);
			}
			if (reason == "was wrong--work order") {
				if (FP.rand(2) == 1) reason = "was wrong--gotawaywithit";
				else {
					bottomText.text = "RE-ASSIGNED TO YOU!! You hath awakend the wrath of STEVE!!";
					bottomrightText.color = 0xff0000;
					scoreTween.tween(this, "score", score - FP.rand(100) - 200, 1);
					showClipLabel(Uhohs, "Steve", scenery);
				}
			}
			if (reason == "was wrong--gotawaywithit") {
				bottomText.text = "Not a work order, but you got away with it!"
				showClip(HangUp, scenery);
			}
			if (reason == "was wrong--simple q") {
				bottomText.text = "THEY'RE NOT STUPID!! You hath awakend the wrath of STEVE!!";
				bottomrightText.color = 0xff0000;
				scoreTween.tween(this, "score", score - FP.rand(100) - 200, 1);
				showClipLabel(Uhohs, "Steve", scenery);
			}
			if (reason == "was wrong--sales call") {
				bottomText.text = "NOT A SALES CALL!! You hath awakend the wrath of STEVE!!";
				bottomrightText.color = 0xff0000;
				scoreTween.tween(this, "score", score - FP.rand(100) - 200, 1);
				showClipLabel(Uhohs, "Steve", scenery);
			}
			if (reason == "too slow picking a response") {
				bottomText.text = "TOO SLOW!! You hath awakend the wrath of STEVE!!";
				bottomrightText.color = 0xff0000;
				scoreTween.tween(this, "score", score - FP.rand(100) - 200, 1);
				showClipLabel(Uhohs, "Steve", scenery);
			}
			if (reason == "didn't pick up phone in time") {
				bottomText.text = "You missed the call. Brenton got it.";
				bottomrightText.color = 0xff0000;
				scoreTween.tween(this, "score", score - FP.rand(600), 1);
				showClipLabel(Uhohs, "Brenton", scenery);
			}
			new ScoreUploader(score);
			addTween(scoreTween, true);
		}
		private function consequenceCallback():void {
			scenery();
		}
		
		// Call back functions
		private function showClip(Clip:Class, callback:Function):void {
			activeClip = new Clip();
			activeClip.gotoAndPlay(1);
			functionWhenDone = callback;
			addClip(activeClip);
			activeClip.addEventListener(Event.ENTER_FRAME, callbackListener);
		}
		public function callbackListener(e:Event):void {
			if (activeClip.currentFrame == activeClip.totalFrames) {
				activeClip.removeEventListener(Event.ENTER_FRAME, callbackListener);
				if (removeClip(activeClip)) functionWhenDone();
			}
		}
		
		private function showClipLabel(Clip:Class, label:String, callback:Function ):void {
			activeClip = new Clip();
			addClip(activeClip);
			activeClip.gotoAndPlay(label); 
			
			var temp:Function = function (e:Event):void {
				if (activeClip.currentLabel != label) {
					activeClip.removeEventListener(Event.ENTER_FRAME, temp);
					if (removeClip(activeClip)) callback();
				}
			}
			activeClip.addEventListener(Event.ENTER_FRAME, temp);	
		}
		
		private function addClip(clip:MovieClip):void {
			if(visible) FP.stage.addChild(clip);
		}
		
		private function removeClip(clip:MovieClip):Boolean {
			try {
				FP.stage.removeChild(clip);
			} catch (e:Error) {
				trace("Error");
				return false;
			}
			return true;
		}
		
	
	
	
	}
	

}