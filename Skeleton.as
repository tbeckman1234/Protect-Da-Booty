package
{
	
	import SkeleBullet;
	import flash.utils.Timer;
	
	import SkeleBullet;
	
	import adobe.utils.CustomActions;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import SkeletonStates.BumpState;
	import SkeletonStates.ChaseState;
	import SkeletonStates.IAgentState;
	import SkeletonStates.StopState;
	import SkeletonStates.ThrowState;
	import SkeletonStates.WanderState;
	
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class Skeleton extends MovieClip
	{
		public static const WANDER:IAgentState = new WanderState();
		public static const BUMP:IAgentState = new BumpState();
		public static const INIT:IAgentState = new StopState();
		public static const CHASE:IAgentState = new ChaseState();
		public static const THROW:IAgentState = new ThrowState();
		
		private var _previousState:IAgentState;
		private var _currentState:IAgentState;
		
		private var _vx:Number;
		private var _vy:Number;
		
		public var health:Number = 100;
		public var speed:Number;
		
		private var _isSkeleBump:Boolean;
		private var _bumperFrames:Number = 0;
		private var bumperBuffer:Number = 10;
		
		private var _isPlayerNear:Boolean = false;
		
		public var chaseRadius:Number = 900;
		public var throwRadius:Number = 700;
		private var _hitRadius:Number = 1;
		
		public var _target:MovieClip;
		
		public var bulletsFired:Array = new Array;
		
		public function Skeleton()
		{
			_vx = Math.random() - Math.random();
			_vy = Math.random() - Math.random();
			speed = 10;
			_currentState = WANDER;
		}
		
		public function update():void
		{
			//_isSkeleBump = false;
			if (!_currentState) return;
			_currentState.update(this);
			//trace ("Spoopy Skeleton Update!");
			
			if (_isSkeleBump == true)
			{
				_bumperFrames++;
				this.bumperFrames()
			}
		
		}
		
		public function setState(newState:IAgentState):void
		{
			if (_currentState == newState) return;
			if (_currentState)
			{ // this will be clear when we look at other states
				_currentState.exit(this);
			}
			_previousState = _currentState; // moving from one state to another
			_currentState = newState;
			_currentState.enter(this);
		}
		
		public function set target(target:MovieClip):void
		{
			_target = target;
		}
		
		public function set isSkeleBump(i:Boolean):void
		{
			_isSkeleBump = i;
		}
		
		public function set vx(vx:Number):void
		{
			_vx = vx;
		}
		
		public function set vy(vy:Number):void
		{
			_vy = vy;
		}
		
		public function get vx():Number
		{
			return _vx;
		}
		
		public function get vy():Number
		{
			return _vy;
		}
		
		public function get target():MovieClip
		{
			return _target;
		}
		
		public function get previousState():IAgentState
		{
			return _previousState;
		}
		
		public function get currentState():IAgentState
		{
			return _currentState;
		}
		
		public function get isBump():Boolean
		{
			return _isSkeleBump;
		}
		
		public function get isPlayerNear():Boolean
		{
			return _isPlayerNear;
		}
		
		public function move():void
		{
			var angle = Math.atan2(this.vy * Math.PI, this.vx * Math.PI);
			this.x += Math.cos(angle) * speed;
			this.y += Math.sin(angle) * speed;
		}
		
		public function didHitObject(dspOb:DisplayObject):void
		{
			if (this.hitTestObject(dspOb) == true)
			{
				_isSkeleBump = true;
				
			}
		}
		
		private function bumperFrames():void
		{
			if (_bumperFrames < bumperBuffer)
			{
				this._isSkeleBump = true;
			}
			
			else if (_bumperFrames > bumperBuffer)
			{
				this._isSkeleBump = false;
				_bumperFrames = 0;
			}
		}
		
		public function distanceToPlayer():Number
		{
			var dx:Number = _target.x - this.x;
			var dy:Number = _target.y - this.y;
			var distance = Math.sqrt(dx * dx + dy * dy);
			
			return distance;
		}
		
		public function moveTowardPlayer()
		{
			var dx:Number = _target.x - this.x;
			var dy:Number = _target.y - this.y;
			var angle = Math.atan2(dy, dx);
			this.x += Math.cos(angle) * speed;
			this.y += Math.sin(angle) * speed;
		}
		
		public function killSkeleton():void
		{
			this.parent.removeChild(this);
		}
		
		public function stopSkeleton()
		{
			this.vx = 0
			this.vy = 0
			this._currentState = INIT;
			this.alpha = 0;
		
			
		}
		
		public function killBullets():void
		{
			for (var i:Number = 0; i < bulletsFired.length; i++)
			{
				if (bulletsFired.length > 0)
				{
					this.parent.removeChild(bulletsFired[i])
						//bulletsFired.removeAt(i);
				}
			}
		}
	
	}
}
