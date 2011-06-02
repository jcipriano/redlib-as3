package org.redblind.display 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	
	public class BitmapCreator
	{
		public static function createBitmap(mc:MovieClip):Bitmap{
			var bitmapData:BitmapData = new BitmapData(mc.width,mc.height,true,0x00FFFFFF);
			bitmapData.draw(mc);
			var bitmap:Bitmap = new Bitmap(bitmapData);
			
			bitmap.x = mc.x;
			bitmap.y = mc.y;
			
			var parentMC:MovieClip = mc.parent as MovieClip;
			parentMC.removeChild(mc);
			parentMC.addChild(bitmap);
			
			return bitmap;
		}
	}
}