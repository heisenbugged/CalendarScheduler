package com.etherpros.events
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	public class ProjectEvent extends Event
	{
		public static const FIND_ALL_DONE:String = 'findAllDoneProject';
		public static const FIND_ALL:String = 'findAllProject';
		[Bindable]
		public var projects:ArrayCollection;
		public function ProjectEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}