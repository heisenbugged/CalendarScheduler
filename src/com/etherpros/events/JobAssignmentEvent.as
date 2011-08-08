package com.etherpros.events
{
	import com.etherpros.model.Job;
	
	import flash.events.Event;
	/***
	 * Class for managing events related with managing information
	 * */
	public class JobAssignmentEvent extends Event
	{
		[Bindable]
		public var job:Job;
		public static const JOB_ASSIGNMENT_SAVE:String = 'jobAssignmentSaveEvent';
		public static const FIND_ALL_DONE:String = 'findAllDoneAssignmentEvent';
		public static const FIND_ALL:String = 'findAllAssignmentEvent';
		public function JobAssignmentEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}