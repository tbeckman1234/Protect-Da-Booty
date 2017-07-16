package  {
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.media.Sound;
    import flash.media.SoundChannel; 
	import flash.net.*;
	
	public class Player extends MovieClip {
		
		public var xVel:Number;
		public var yVel:Number;
		public var movingSpeed:Number;
		public var speed:Number;
		public var life:Number;
		public var ammo:Number;
		public var ponyTail:Segment;
		private var dredLock1:Segment;
		private var dredLock2:Segment;
		private var dredLock3:Segment;
		private var dredLock4:Segment;
		private var dredLock5:Segment;
		private var dredLock6:Segment;
		private var dredLock7:Segment;
		private var collidedObject:DisplayObject;
		private var collided:Boolean = false;
		private var takeDamage:Boolean = false;
		public var movingVerticle:Boolean;
		private var damageFrames:Number = 0;
		private var damageBuffer:Number = 15;
		private var bumpBuffer:Number = 20;
		private var addedAmmo:Number = 5;
		private var playerGotHit:Sound;
		
		private var channel:SoundChannel;
		
		
		
		
		
		private var dredLocks:Array = new Array(); 
		
		public function Player() {
			

			
			dredLock1= new Segment(50, 10, 0x603913);
			dredLock1.x = x;
			dredLock1.y = y;
			
			dredLock2= new Segment(50, 10, 0x603913);
			dredLock2.x = x-6;
			dredLock2.y = y+9;
			
			dredLock3= new Segment(50, 10, 0x603913);
			dredLock3.x = x-6;
			dredLock3.y = y-9;
			
			dredLock4= new Segment(50, 10, 0x603913);
			dredLock4.x = x-12;
			dredLock4.y = y + 22;
		
			dredLock5= new Segment(50, 10, 0x603913);
			dredLock5.x = x-12;
			dredLock5.y = y-22;
			
			dredLock6= new Segment(50, 10, 0x603913);
			dredLock6.x = x-20;
			dredLock6.y = y+30;
		
			dredLock7= new Segment(50, 10, 0x603913);
			dredLock7.x = x-20;
			dredLock7.y = y-30;
			
			/*ponyTail= new Segment(70, 10, 0x603913);
			addChild(ponyTail);*/

			playerGotHit = new Sound(new URLRequest("gameSounds/playerBeingHit.mp3"));
			xVel = 0;
			yVel = 0;
			movingSpeed = 20;
			speed = 1.7;
			life = 1000;
			ammo = 12;
			
			/*dredLocks.push(dredLock1, dredLock2, dredLock3, dredLock4, dredLock5, dredLock6, dredLock7);*/
			dredLocks.push(dredLock7, dredLock6, dredLock5, dredLock4, dredLock3, dredLock2, dredLock1);
			
		}
		public function didHitObject(dispObj:DisplayObject):void {
			if (this.hitTestObject(dispObj) == true)
			{
				collided = true
				collidedObject = dispObj;
				stopPlayer();
			}
		}
		public function didHitEnemy(enemy:MovieClip):void {
			if(this.hitTestObject(enemy) == true)
			{
				damage();
				takeDamage = true;
				damageFrames++;
				
			}
		}
		private function damage():void 
		{
			if(damageFrames == damageBuffer && takeDamage == true){
				life -= 100;
				takeDamage = false;
				makeSound();
			}
			else if (damageFrames > damageBuffer){
				damageFrames = 0;
			}
			
		}
		private function makeSound():void {
			for(var i:int = 0; i < 1; i++){
			channel = playerGotHit.play();
			}
		}
		private function hitByBullet():void {
			life -= 100;
		}
		private function stopPlayer():void {
			//xVel = 0;
			//yVel = 0;
			
			if(this.y > collidedObject.y && this.yVel == -movingSpeed)
			{
				bumpBuffer = movingSpeed
				this.y += bumpBuffer; 
			}
			if(this.y < collidedObject.y && this.yVel == movingSpeed)
			{
				bumpBuffer = movingSpeed
				this.y -= bumpBuffer;
			}
			
			if (this.x > collidedObject.x && this.xVel == -movingSpeed)
			{
				bumpBuffer = movingSpeed
				this.x += bumpBuffer;
			}
			if(this.x < collidedObject.x && this.xVel == movingSpeed)
			{
				bumpBuffer = movingSpeed
				this.x -= bumpBuffer;
			}
			
			//var playerHalfWidth:Number = this.width/2;
			//var playerHalfHeight:Number = this.height/2;
			//
			////stop the player when it reaches the edges
			////if (player.x > stage.stageWidth)
			//if (this.x + playerHalfWidth > collidedObject.width) {
			//	
			//	//player.x = stage.stageWidth;
			//	this.x = collidedObject.width - playerHalfWidth;
			//}/*else if (this.x - playerHalfWidth < 0) {
			//	this.x = 0 + playerHalfWidth;
			//}*/
			//if (this.y + playerHalfHeight > collidedObject.height) {
			//	this.y = collidedObject.height - playerHalfHeight;
			//}/*else if (this.y - playerHalfHeight < 0){
			//	this.y = 0 + playerHalfHeight;
			//}*/
		}
		
		public function addAmmo():void {
			for (var i: uint = 0; i < 1 ; i++) {
				if (ammo + addedAmmo < 25) {
				ammo += addedAmmo;
				}
				else if (ammo + addedAmmo > 25) {
					ammo += 25 - ammo;
				}
			}			
		}
			
		private function hairMovement():void {
			
			
			for each(var dred:Segment in dredLocks) {
				dred.rotation = 180;
				addChild(dred);
			if (xVel > 0) {
				if (dred.rotation > -90) {
					dred.rotation = -160;
					
				}
				
				
			} else if (xVel < 0) {
				if (dred.rotation > 90) {
				dred.rotation = 160;
				}
			}
			if (yVel > 0) {
				if (dred.rotation > 90) {
				dred.rotation = 160;
				}
				
			} else if (yVel < 0) {
				if (dred.rotation > -90) {
				dred.rotation = -160;
				}
			}
		}
		}
		public function update():void
		{
			x += xVel;
			y += yVel;
		hairMovement();	
		
		}
		
	}
	
}
