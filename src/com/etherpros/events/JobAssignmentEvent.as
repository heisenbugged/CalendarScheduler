package com.etherpros.events
{
	import com.etherpros.model.DataModelCollection;
	import com.etherpros.model.data.Job;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;

	/***
	 * Class for managing events related with managing information
	 * */
	public class JobAssignmentEvent extends Event
	{
		[Bindable]
		public var job:Job;
		public var jobs:DataModelCollection;
		
		[Bindable]
		public var startDate:Date;
		
		public var endDate:Date;
		
		public static const JOB_ASSIGNMENT_SAVE:String = 'jobAssignmentSaveEvent';
		// FIND_ALL_DONE is dispatched when assignment models are loaded from the database.
		public static const FIND_ALL_DONE:String = 'findAllDoneAssignmentEvent';
		public static const FIND_ALL:String = 'findAllAssignmentEvent';
		
		// JOBS_LOADED is dispatched when all the assignments have been converted into
		// jobs and the cache inside DataManager has been refreshed.
		public static const JOBS_LOADED:String = "jobsLoadedAssignmentEvent";
		
		public function JobAssignmentEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}