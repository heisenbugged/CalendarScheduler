package com.etherpros.events {
	import com.etherpros.model.DataModelCollection;
	import flash.events.Event;
	
	
	public class ProjectEvent extends Event
	{
		public static const FIND_ALL_DONE:String = 'findAllDoneProject';
		public static const FIND_ALL:String = 'findAllProject';
		[Bindable]
		public var projects:DataModelCollection;
		public function ProjectEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}