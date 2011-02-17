package org.redblind.pv3d
{
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Plane;

	public class DoubleSidedPlane extends DisplayObject3D
	{
		public var front:Plane;
		public var back:Plane;
		
		public function DoubleSidedPlane(materials:MaterialsList, width:Number=0, height:Number=0, segmentsW:Number=0, segmentsH:Number=0, initObject:Object=null )
		{
			super();
			front = new Plane(materials.getMaterialByName('front'),width,height,segmentsW,segmentsH,initObject);
			back = new Plane(materials.getMaterialByName('back'),width,height,segmentsW,segmentsH,initObject);
			back.z = -1;
			back.rotationY = 180;
			addChild(front);
			addChild(back);
		}
	}
}