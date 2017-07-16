package SkeletonStates
{
	import Skeleton;
	
	public class WanderState implements IAgentState
	{
		private var frames:Number = 0;
		private var startFrames:Number = 30;
		
		public function update(s:Skeleton):void
		{
			if (s.isBump == true)
			{
				s.setState(Skeleton.BUMP)
			}
			if (s.distanceToPlayer() < s.chaseRadius)
			{
				s.setState(Skeleton.CHASE);
				/*trace("Enter Chase");*/
			}
			frames++;
			s.move();
		}
		
		public function enter(s:Skeleton):void
		{
		/*if (frames < startFrames)
		   {
		   s.move();
		   }
		   frames++*/
		}
		
		public function exit(s:Skeleton):void
		{
		
		}
	}
}