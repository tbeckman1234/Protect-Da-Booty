package {

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;


	public class Pirate extends MovieClip {
		public var isAlive:Boolean = true;
		public var speed: Number = 15;
		public var status: String = "Alive";
		public var life: Number = 200;
		public var angle:Number;
		public var pointOfInterest:Number;
		
		public function Pirate():void {
			
		}
		public function lookAtAnObject(objectX:Number, objectY:Number):Number{
			angle = Math.atan2(objectY - this.y, objectX - this.x);
			var pirateAngle: Number = angle * 180 / Math.PI;
			pointOfInterest = pirateAngle;
			/*trace(pointOfInterest);*/
			return pointOfInterest;
		}
		public function lookAtIt():void {
			this.rotation = pointOfInterest;
		}

		
	}


}