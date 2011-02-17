package org.redblind.pv3d
{
	import flash.display.DisplayObject;			import org.papervision3d.core.math.Number3D;		import org.papervision3d.core.geom.renderables.Triangle3D;
	import org.papervision3d.core.geom.renderables.Vertex3D;
	import org.papervision3d.core.geom.TriangleMesh3D;
	import org.papervision3d.core.math.NumberUV;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.objects.DisplayObject3D;
	
	/**
	 * Ribbon3D extends Papervision3D's DisplayObject3D.
	 * It creates the ability to render 3D ribbons or tape.
	 * Based on the work of Justin Clarke Windle (blog.soulwire.co.uk).
	 * Changed the way positioning and drawing is handled.
	 * Setting position or rotation properties is relative to the whole ribbon.
	 * Added a rotation property to add the ability to "twist" the ribbon.
	 * By Jonathan Cipriano (www.redblind.com/blog).
	 */
	public class Ribbon3D extends DisplayObject3D
	{
		private var length:Number;
		private var planes:Array;
		private var v1:Vertex3D;
		private var v2:Vertex3D;
		private var v3:Vertex3D;
		private var v4:Vertex3D;
		
		/**
		 * The x coordinate of the draw target.
		 */
		public var targetX:Number;
		
		/**
		 * The y coordinate of the draw target.
		 */
		public var targetY:Number;
		
		/**
		 * The z coordinate of the draw target.
		 */
		public var targetZ:Number;
		
		/**
		 * The width of the ribbon.
		 */
		public var width:Number;
		
		/**
		 * The rotation or twist angle of the ribbon.
		 */
		public var rotation:Number;
		
		public var materialRef:DisplayObject;

		/**
		 * Constructor for Ribbon3D instances.
		 * @param 	m 	The material to apply.
		 * @param 	w 	The width of the ribbon.
		 * @param 	r 	The rotation angle of ribbon.
		 * @param 	ms 	The max number of plane segments of the ribbon.
		 * @param 	tp 	The starting point of the rendered ribbon relative to the position of the Ribbon3D instance.
		 */
		public function Ribbon3D(m:MaterialObject3D=null,w:Number=20,r:Number=0,ms:int=100,tp:Number3D=undefined) 
		{
			super();
			planes = new Array();
			material = m;
			length = ms;
			width = w;
			rotation = r;
			targetPosition = tp ? tp : new Number3D(0,0,0);
			
			v1 = new Vertex3D(targetX+Math.sin(toRadians(rotation))*(width/2), targetY+Math.cos(toRadians(rotation))*(width/2), targetZ);
			v2 = new Vertex3D(targetX+Math.sin(toRadians(rotation+180))*(width/2), targetY+Math.cos(toRadians(rotation+180))*(width/2), targetZ);
		}
		
		/**
		 * Extends the ribbon to the current target position.
		 */
		public function draw():void
		{
			v3 = new Vertex3D(targetX+Math.sin(toRadians(rotation))*(width/2), targetY+Math.cos(toRadians(rotation))*(width/2), targetZ);
			v4 = new Vertex3D(targetX+Math.sin(toRadians(rotation+180))*(width/2), targetY+Math.cos(toRadians(rotation+180))*(width/2), targetZ);
			
			var plane:TriangleMesh3D;
			
			if (numChildren >= length){
				plane = planes.shift();
				plane.geometry.vertices = [v1, v2, v3, v4];
				plane.geometry.faces = [newTriangle(plane,0), newTriangle(plane,1)];
				planes.push(plane);
			}else{
				plane = newPlane();
				planes.push(plane);
				addChild(plane);
			}

			v1 = v3;
			v2 = v4;
		}
		
		/**
		 * Extends the ribbon to the target position given.
		 * @param n A Number3D representing to coordinates of the new target position
		 */
		public function drawTo(n:Number3D):void
		{
			targetX = n.x;
			targetY = n.y;
			targetZ = n.z;
			draw();
		}
		
		/**
		 * Sets the target position but does not extend ribbon.
		 * @param n A Number3D representing to coordinates of the new target position
		 */
		public function set targetPosition(n:Number3D):void
		{
			targetX = n.x;
			targetY = n.y;
			targetZ = n.z;
		}
		
		/**
		 * Returns the current target postion as a Number3D.
		 */
		public function get targetPosition():Number3D
		{
			return new Number3D(targetX,targetY,targetZ);
		}

		private function newPlane():TriangleMesh3D
		{
			var plane:TriangleMesh3D = new TriangleMesh3D(material, [], []);
			
			plane.geometry.vertices.push(v1, v2, v3, v4);
			plane.geometry.faces.push(newTriangle(plane, 0));
			plane.geometry.faces.push(newTriangle(plane, 1));
			plane.geometry.ready = true;

			return plane;
		}
		
		private function newTriangle(plane:TriangleMesh3D, targetYpe:int):Triangle3D
		{
			var b:Boolean = Boolean(targetYpe);
			
			var vA:Vertex3D = plane.geometry.vertices[ b ? 3 : 0 ];
			var vB:Vertex3D = plane.geometry.vertices[ b ? 1 : 2 ];
			var vC:Vertex3D = plane.geometry.vertices[ b ? 2 : 1 ];
			
			var nA:NumberUV = new NumberUV(int(b), 1);
			var nB:NumberUV = new NumberUV(int(b), int(!b));
			var nC:NumberUV = new NumberUV(int(!b), int(b));
			
			return new Triangle3D(plane, [vA, vB, vC], null, [nA, nB, nC ]);
		}
		
		private function toRadians(degrees:Number):Number
		{
			return degrees*Math.PI/180;
		}
	}
	
}
