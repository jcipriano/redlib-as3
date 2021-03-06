﻿package org.redblind.bitmapdata {	import flash.geom.Rectangle;			import com.gskinner.geom.ColorMatrix;			import flash.display.BitmapData;		import flash.display.DisplayObject;		import flash.geom.Point;		/**	 * @author jcipriano	 */	public class ColorIsolator	{		public var source:DisplayObject;				private var _color:Number;		private var _tolerance:Number;		private var _rgbMin:Number;		private var _rgbMax:Number;		private var _bmd:BitmapData;		private var _rect:Rectangle;		private const _pt:Point = new Point();				public function ColorIsolator(src:DisplayObject=null,clr:Number=0xF000000,tol:Number=20):void		{			source = src;			tolerance = tol;			color = clr;		}				public function process(bmd:BitmapData = null):BitmapData		{			if(bmd){				_bmd = bmd;			}else{				_bmd = new BitmapData(source.width,source.height,true);				_bmd.draw(source);			}			reduceDepth();						var rmin:Number = (_rgbMin >> 16) & 0xff;			var gmin:Number = (_rgbMin >> 8) & 0xff;			var bmin:Number = _rgbMin  & 0xff;						var rmax:Number = (_rgbMax >> 16) & 0xff;			var gmax:Number = (_rgbMax >> 8) & 0xff;			var bmax:Number = _rgbMax  & 0xff;						var tmp:Number;						if (rmin>rmax){				tmp = rmin;				rmin = rmax;				rmax = tmp;			}						if (gmin>gmax){				tmp = gmin;				gmin = gmax;				gmax = tmp;			}						if (bmin>bmax){				tmp = bmin;				bmin = bmax;				bmax = tmp;			}					_bmd.threshold(_bmd, _bmd.rect, _pt, "<", rmin<<16,0,0x00FF0000,true);			_bmd.threshold(_bmd, _bmd.rect, _pt, "<", gmin<<8,0,0x0000FF00,true);			_bmd.threshold(_bmd, _bmd.rect, _pt, "<", bmin,0,0x000000FF,true);						_bmd.threshold(_bmd, _bmd.rect, _pt, ">", rmax<<16,0,0x00FF0000,true);			_bmd.threshold(_bmd, _bmd.rect, _pt, ">", gmax<<8,0,0x0000FF00,true);			_bmd.threshold(_bmd, _bmd.rect, _pt, ">", bmax,0,0x000000FF,true);						_rect = _bmd.getColorBoundsRect(0xFFFFFFFF, _color, false);						return _bmd;		}				public function reduceDepth(c:int=128):void		{			var Ra:Array = new Array(256);			var Ga:Array = new Array(256);			var Ba:Array = new Array(256);		 			var n:Number = 256/(c/3);		 			for (var i:int = 0; i < 256; i++)			{				Ba[i] = Math.floor(i / n) * n;				Ga[i] = Ba[i] << 8;				Ra[i] = Ga[i] << 8;			}		 			_bmd.paletteMap( _bmd, _bmd.rect, _pt, Ra, Ga, Ba );		}				public function get rect():Rectangle { return _rect; }				public function get bitmapData():BitmapData { return _bmd; }		public function get colorMin():Number { return _rgbMin; }				public function get colorMax():Number { return _rgbMax; }				public function set color(c:Number):void		{			_color = c;						var rMin:Number = Math.min(255,Math.max(0,((_color >> 16) & 0xff) - _tolerance ));			var gMin:Number = Math.min(255,Math.max(0,((_color >> 8) & 0xff) - _tolerance ));			var bMin:Number = Math.min(255,Math.max(0,(_color & 0xff) - _tolerance ));			_rgbMin = rMin<<16 | gMin<<8 | bMin;						var rMax:Number = Math.min(255,Math.max(0,((_color >> 16) & 0xff) + _tolerance ));			var gMax:Number = Math.min(255,Math.max(0,((_color >> 8) & 0xff ) + _tolerance ));			var bMax:Number = Math.min(255,Math.max(0, (_color & 0xff) + _tolerance ));			_rgbMax = rMax<<16 | gMax<<8 | bMax;		}				public function get color():Number { return _color; }				public function set tolerance(t:Number):void		{			_tolerance = t;			color = _color;		}				public function get tolerance():Number { return _tolerance; }	}}