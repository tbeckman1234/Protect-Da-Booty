package SkeletonStates
{
	import Skeleton;
	
	public class ChaseState implements IAgentState
	{
		
		/* INTERFACE agent.states.IAgentState */
		
		public function update(s:Skeleton):void
		{
			/*var dx = s._target.x - s.x;
			   var dy = s._target.y - s.y;
			   var angle = Math.atan2(dy, dx);
			   s.vx = Math.cos(angle);
			   s.vy = Math.sin(angle);
			 */
			s.moveTowardPlayer();
			if (s.isBump == true) 
			{
				s.setState(Skeleton.BUMP);
			}
			if (s.distanceToPlayer() < s.throwRadius)
			{
				s.setState(Skeleton.THROW);
			}
			else if (s.distanceToPlayer() > s.chaseRadius)
			{
				s.setState(Skeleton.WANDER);
			}
		
		}
		
		public function enter(s:Skeleton):void
		{
		
		}
		
		public function exit(s:Skeleton):void
		{
		
		}
	
	}

}