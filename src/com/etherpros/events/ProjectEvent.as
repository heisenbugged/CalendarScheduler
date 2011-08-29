package com.etherpros.events {
	import com.etherpros.model.DataModelCollection;
	import com.etherpros.model.data.Client;
	import com.etherpros.model.data.Project;
	
	import flash.events.Event;
	
	
	public class ProjectEvent extends Event
	{
		public static const FIND_ALL_DONE:String = 'findAllDoneProject';
		public static const FIND_ALL:String = 'findAllProject';
		public static const ADD_NEW:String = 'addNewProject';
		[Bindable]
		public var projects:DataModelCollection;
		public var client:Client;
		public var project:Project;
		public function ProjectEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}