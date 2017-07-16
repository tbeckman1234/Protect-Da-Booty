package SkeletonStates // pointing itself is stored
{
	import Skeleton; // making a connection ot agent
	
	public interface IAgentState 
	{
		function update(s:Skeleton):void;
		function enter(s:Skeleton):void;
		function exit(s:Skeleton):void; // basic function of agent behaviors 
	}
	
}