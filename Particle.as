package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class Particle extends MovieClip
	{
		public var xVel:Number;
		public var yVel:Number;
		public var airResistance:Number;
		public var life:Number;
		public var interacts:Boolean;
		public var ownedByPlayer:Boolean;
		
		public function Particle()
		{
			ownedByPlayer = true;
			interacts = true;
			life = 200;
			xVel = 0;
			yVel = 0;
			airResistance = 1;
		}
		
		public function update():void
		{
			life--;
			
			yVel *= airResistance;
			xVel *= airResistance;
			
			rotation = Math.atan2(yVel, xVel) * 180 / Math.PI;
			
			x += xVel;
			y += yVel;
		}
	}
}