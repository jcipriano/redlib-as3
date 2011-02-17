package org.redblind.display 
{	import flash.display.Sprite;	
	import flash.display.Bitmap;	
	import flash.display.BitmapData;
	
	/**	 * @author jcipriano	 */	public class BitmapDisplay extends Sprite 
	{
		protected var _bmd:BitmapData;
		protected var _bm:Bitmap;

		public function BitmapDisplay(bmd:BitmapData=null):void
		{
			if(bmd){
				_bmd = bmd;
				_bm = new Bitmap(_bmd);
				addChild(_bm);
			}
		}
		
		public function update(bmd:BitmapData):void
		{
			_bmd = bmd;
			if(_bm){
				removeChild(_bm);
				_bm = null;
			}
			_bm = new Bitmap(_bmd);
			addChild(_bm);
		}
		
		public function get bitmapData():BitmapData
		{
			return _bm.bitmapData;
		}
	}}