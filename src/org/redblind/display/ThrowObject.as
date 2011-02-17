package org.redblind.display
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;	

	public class ThrowObject extends Sprite
	{
		// hold time
		public var holdTime:Number;
		public var hold:Boolean;
		private var startTime:Number;
		
		// environmental variable
		public var _bounce:Number = -0.01;
		public var gravity:Number = 0;  
		public var resistance:Number = 0.02;  
		public var bounds:Object;
		public var objBounds:Object;
		
		// velocity variables
		private var prevX:Number;
		private var prevY:Number; 
		private var vx:Number;
		private var vy:Number;
		
		// drag flags
		private var _dragX:Boolean;
		private var _dragY:Boolean;
		
		var offsetX:Number;
		var offsetY:Number;
		
		public function ThrowObject():void
		{  	
			vx = 0;  // x velocity
			vy = 0;  // y velocity
			//drawShape();
		}

		/**
		 * enables drag
		 */
		public function enableDrag(dragX:Boolean=true,dragY:Boolean=true):void
		{
			_dragX = dragX;
			_dragY = dragY;
			addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);  
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		/**
		 * sdraw shape for testing
		 */
		public function drawShape(r:Number=50):void
		{ 
			graphics.beginFill(0xCC0000);  
			graphics.drawCircle(0, 0, r);  
			graphics.endFill();
		}

		/**
		 * bounce getter
		 */
		public function set bounce(v:Number):void
		{
			_bounce = v*-1;
		}

		/**
		 * bounce setter
		 */
		public function get bounce():Number
		{
			return _bounce;
		}

		/**
		 * apply rudimentry physics
		 */
		private function onEnterFrame(event:Event):void  
		{  
			//apply gravity above 0
			if(gravity > 0)
			{
				vy += gravity;
			}
			//else apply resistence
			else if(Math.abs(vy) < 0.15)
			{
				vy = 0;
			}
			else
			{
				vy *= 1-resistance;
			}
			
			// apply resistence
			if(Math.abs(vx) < 0.15)
			{
				vx = 0;
			}
			else
			{
				vx *= 1-resistance;
			}
			
			// assign new coords
			if(_dragX) this.x += vx;  
			if(_dragY) this.y += vy;
			// if bounds defined, enforce them
			if(bounds)
			{
				if(this.x > bounds.right && _dragX) // right bound  
				{  
					this.x = bounds.right;  
					vx *= _bounce;
				}
				else if(this.x < bounds.left && _dragX) //left bound  
				{ 
					this.x = bounds.left;  
					vx *= _bounce;  
				}
				if(this.y > bounds.bottom && _dragY) // bottom bound  
				{  
					this.y = bounds.bottom;  
					vy *= _bounce;  
				}  
				else if(this.y < bounds.top && _dragY) // top bound  
				{  
					this.y = bounds.top;  
					vy *= _bounce;  
				}
			}
		}    
		
		/**
		 * initiate drag
		 */
		private function handleMouseDown(e:MouseEvent):void  
		{  
        	startTime = new Date().getTime();        	
			prevX = this.x;
			prevY = this.y;
    		offsetX = (e.currentTarget as DisplayObject).mouseX;
        	offsetY = (e.currentTarget as DisplayObject).mouseY;
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			addEventListener(Event.ENTER_FRAME, trackVelocity);
			addEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
			addEventListener(MouseEvent.MOUSE_OUT, handleMouseUp);
        	addEventListener(MouseEvent.MOUSE_MOVE, handleDrag);
		}  
		
		public function killThrow():void
		{
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
			removeEventListener(MouseEvent.MOUSE_OUT, handleMouseUp);
        	removeEventListener(MouseEvent.MOUSE_MOVE, handleDrag);
		}
		
		/**
		 * stop drag and calc mouse hold time
		 */
		private function handleMouseUp(event:MouseEvent):void  
		{  
        	removeEventListener(MouseEvent.MOUSE_MOVE, handleDrag);
			removeEventListener(MouseEvent.MOUSE_OUT, handleMouseUp);
        	holdTime = new Date().getTime() - startTime;
        	hold = holdTime > 150 ? true : false; 
			removeEventListener(MouseEvent.MOUSE_UP,handleMouseUp);  
			removeEventListener(Event.ENTER_FRAME,trackVelocity);
			addEventListener(Event.ENTER_FRAME,onEnterFrame);  
		}  
		
		/**
		 * constant track of velocity
		 */
		private function trackVelocity(event:Event):void  
		{  
			vx = this.x - prevX;  
			vy = this.y - prevY;  
			prevX = this.x;  
			prevY = this.y;  
		}
		
		/**
		 * do drag on mouse move
		 */
		function handleDrag(e:MouseEvent):void
		{
       		if(_dragX)
       		{
            	var tempX:int=parent.mouseX-offsetX;
            	x=tempX;
            }
            if(_dragY)
            {
            	var tempY:int=parent.mouseY-offsetY;
            	y = tempY;
            }    
			e.updateAfterEvent();
		}
	}  
}
