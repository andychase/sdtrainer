package  
{
	import flash.display.MovieClip;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import flash.events.Event;
	import flash.display.DisplayObject;
	import net.flashpunk.World;
	/**
	 * ...
	 * @author DavidWilliams & Andrew Chase
	 */
	public class IntroWorld extends World
	{
		[Embed(source='assets/intro.swf')] private var splashScreen:Class; //embed your swf here
		private var splashMovie:MovieClip;
		
		public function IntroWorld() 
		{
			splashMovie = new splashScreen();
			splashMovie.scaleX = 640 / splashMovie.width; 
			splashMovie.scaleY = 640 / splashMovie.height;
			FP.stage.addChild(splashMovie);
			splashMovie.stage.addEventListener("DONE", CheckSplashEnded);
		}
		
		public function CheckSplashEnded(e:Event):void
		{
			splashMovie.removeEventListener(Event.ENTER_FRAME, CheckSplashEnded);
			FP.stage.removeChild(splashMovie);
			FP.world = new GameWorld; //world to change to when done.
		}
	}

}