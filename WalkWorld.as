package
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.TiledImage;
	import net.flashpunk.masks.Hitbox;
	import net.flashpunk.World;
	import net.flashpunk.FP;
	
	
	public class WalkWorld extends World
	{
		private var score:int;

		public function WalkWorld(inscore:int = 0)
		{
			add(new Background);
			score = inscore;
			
			var staphonHead:Image = new Image (Assets.HEADS, new Rectangle(3*32, 0, 32, 32));
			var steveHead:Image = new Image   (Assets.HEADS, new Rectangle(0, 0, 32, 32));
			var meganHead:Image = new Image   (Assets.HEADS, new Rectangle(1*32, 1*32, 32, 32));
			var courtneyHead:Image = new Image(Assets.HEADS, new Rectangle(0, 1*32, 32, 32));
			var dennisHead:Image = new Image  (Assets.HEADS, new Rectangle(1*32, 0, 32, 32));
			var dianaHead:Image = new Image   (Assets.HEADS, new Rectangle(2*32, 0, 32, 32));
			var customerHead:Image = new Image(Assets.HEADS, new Rectangle(0, 0, 32, 32));
			var ssHead:Image = new Image      (Assets.HEADS, new Rectangle(0, 0, 32, 32));
			
			var staphon:Entity = new Entity(15 * 32, 2 * 32, staphonHead, new Hitbox(64,64,-32,-32));
			staphon.type = "staphon";
			add(staphon);
			
			var steve:Entity = new Entity(18 * 32, 2 * 32, steveHead, new Hitbox(64,64,-32,-32));
			steve.type = "steve";
			add(steve);
			
			var megan:Entity = new Entity(18 * 32, 6 * 32, meganHead, new Hitbox(64,64,-32,0));
			megan.type = "megan";
			add(megan);
			
			var courtney:Entity = new Entity(3 * 32, 14 * 32, courtneyHead, new Hitbox(64,80,0,5));
			courtney.type = "courtney";
			add(courtney);
			
			var dennis:Entity = new Entity(10 * 32, 8 * 32, dennisHead, new Hitbox(64,64,-32,-32));
			dennis.type = "dennis";
			add(dennis);
			
			var diana:Entity = new Entity(17 * 32, 15 * 32, dianaHead, new Hitbox(64,86,-32,-32));
			diana.type = "diana";
			add(diana);
			
			var customer:Entity = new Entity(2 * 32, 12 * 32, new Image(Assets.PLAYER), new Hitbox(80, 32, 0, 0));
			customer.type = "customer";
			add(customer);
			
			var ss:Entity = new Entity(3 * 32, 10 * 32, new Image(Assets.PLAYER), new Hitbox(80, 32, 0, 0));
			ss.type = "ss";
			add(ss);
			
			var minigame:Entity = new Entity(14 * 32, 6 * 32, null, new Hitbox(32, 32, 0, 0));
			minigame.type = "minigame";
			add(minigame);
			
			add(new Hero);
			
			add(new TalkBox);
			
		}
		

	}
}