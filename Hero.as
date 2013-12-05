package
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.masks.Grid;

	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Key;
	import net.flashpunk.utils.Input;
	import net.flashpunk.FP;

	public class Hero extends Entity
	{
		
		private var camera:Point;
		private var hitgrid:Grid;
		private var MOVESPEED:int = 10;

		public function Hero()
		{
			graphic = new Image(Assets.PLAYER);
			
			
			
			originY = -30;
			width = 16;
			height = 10;
			
			x = 14 * 32;
			y = 6 * 32;
			
		}
		
		override public function update():void 
		{
			//var dir:String = "";
			//if (Input.check(Key.Left) || FP.world.mouseX > ) dir = "left";
			
			if (Input.check(Key.LEFT) && !collide("wall", x-MOVESPEED, y)) {  x -= MOVESPEED;}
			if (Input.check(Key.RIGHT) && !collide("wall", x+MOVESPEED, y)) { x += MOVESPEED; }
			if (Input.check(Key.UP) && !collide("wall", x, y-MOVESPEED)) {   y -= MOVESPEED;  }
			if (Input.check(Key.DOWN) && !collide("wall", x, y + MOVESPEED)) { y += MOVESPEED;  }
			
			if  (Input.mouseDown) {
				if (FP.world.mouseX < x && !collide("wall", x-MOVESPEED, y)) {  x -= MOVESPEED;}
				if (FP.world.mouseX > x && !collide("wall", x+MOVESPEED, y)) { x += MOVESPEED; }
				if (FP.world.mouseY < y && !collide("wall", x, y-MOVESPEED)) {   y -= MOVESPEED;  }
				if (FP.world.mouseY > y && !collide("wall", x, y + MOVESPEED)) { y += MOVESPEED;  }
			}
			
			
			if (collide("staphon", x, y)) TalkBox.talkTo = "staphon";
			else if (collide("steve", x, y)) TalkBox.talkTo = "steve";
			else if (collide("megan", x, y)) TalkBox.talkTo = "megan";
			else if (collide("courtney", x, y)) TalkBox.talkTo = "courtney";
			else if (collide("dennis", x, y)) TalkBox.talkTo = "dennis";
			else if (collide("diana", x, y)) TalkBox.talkTo = "diana";
			else if (collide("customer", x, y)) TalkBox.talkTo = "customer";
			else if (collide("ss", x, y)) TalkBox.talkTo = "ss";
			else if (collide("minigame", x, y)) TalkBox.talkTo = "minigame";
			else TalkBox.talkTo = "";
			
			if (collide("minigame", x, y) && Input.check(Key.Q)) FP.world = new GameWorld;
		}
	}
}