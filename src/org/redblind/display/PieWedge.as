package org.redblind.display
{
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.LineScaleMode;
	
	public class PieWedge extends Sprite
	{
		private var radians:Number;
		private var shape:Shape;
		private var angle:Number;
		
		public function PieWedge():void
		{
			trace('>PieWedge');
			radians = Math.PI/180;
			shape = new Shape();
			drawShape(100,10,0xFF0000);
		}
		
		public function drawShape(radius:Number,angle:Number,color:Number=0x000000,lineThickness:Number=0,lineColor:Number=0x000000):void
		{
			if(lineThickness>0)
				shape.graphics.lineStyle(1,color,1,true,LineScaleMode.NONE);
				
			shape.graphics.beginFill(color);
			
			shape.graphics.moveTo(0,0);
			shape.graphics.lineTo(radius,0);
			
			var nSeg:Number = Math.floor(angle/30);
			var pSeg:Number = angle - nSeg*30;
			
			var a:Number = 0.268;
			for (var i=0; i < nSeg; i++) {
				 var endx = radius*Math.cos((i+1)*30*radians);
				 var endy = radius*Math.sin((i+1)*30*radians);
				 var ax = endx+radius*a*Math.cos(((i+1)*30-90)*radians);
				 var ay = endy+radius*a*Math.sin(((i+1)*30-90)*radians);
				 shape.graphics.curveTo(ax, ay, endx, endy);
			}
			
			if (pSeg > 0) {
				a = Math.tan(pSeg/2 * radians);
				endx = radius*Math.cos((i*30+pSeg)*radians);
				endy = radius*Math.sin((i*30+pSeg)*radians);
				ax = endx+radius*a*Math.cos((i*30 + pSeg-90)*radians);
				ay = endy+radius*a*Math.sin((i*30 + pSeg-90)*radians);
				shape.graphics.curveTo(ax, ay, endx, endy);
			}
			shape.graphics.lineTo(0, 0);
			addChild(shape);
			shape.cacheAsBitmap = true;
		}
	}
}