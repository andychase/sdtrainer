package
{
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Canvas;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.masks.Grid;

	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Key;
	import net.flashpunk.utils.Input;
	import net.flashpunk.FP;
	import com.adobe.serialization.json.JSON;
	
	public class Background extends Entity
	{
		private var hitgrid:Grid;
		public function Background()
		{
			var whiteback:Canvas = new Canvas(640, 640);
			whiteback.fill(new Rectangle(0, 0, 640, 640), 0xFFFFFF);
			addGraphic(whiteback);
			
			hitgrid = new Grid(640, 640, 32, 32);
			mask = hitgrid;
			type = "wall";
			
			loadMap();
		}
		
		override public function update():void 
		{

		}
		
		private function loadMap():void {
			var rawData:ByteArray = new Assets.MAP;
			var dataString:String = rawData.readUTFBytes(rawData.length);
			var jsonData:Object = JSON.decode(dataString);
			
			var _tiles:Tilemap;
			var layer:Object;
			var tile:int;
			var col:int;
			var row:int;
			col = 0;
			row = 0;
			for each (layer in jsonData.layers) {
				col = 0;
				row = 0;
				_tiles = new Tilemap(Assets.TILES, 640, 640, 32, 32);
				for each (tile in layer.data) {
					if (tile != 0 && tile != 51) _tiles.setTile( col, row, tile - 1);
					if (tile == 51) hitgrid.setTile(col, row);
					col += 1;
					if (col >= int(layer.width)) {
						col = 0;
						row += 1;
					}
				};
				addGraphic(_tiles);
			};
		}
		
 
	}
}