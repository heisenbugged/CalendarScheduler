package com.etherpros.events
{
	import com.etherpros.components.JobView;
	import com.etherpros.model.Job;
	
	import flash.events.Event;
	
	public class JobEvent extends Event
	{
		public var view:JobView;
		public var model:Job;
		
		// Used when re-drawing a job
		public var jobTotalWidth:Number;
		public var isRedraw:Boolean = false;
		
		public static const JOB_RESIZED:String = 'jobResizedEvent';		
		public static const ADD_JOB_SPRITE:String = 'addJobSprite';	
		
		public function JobEvent(type:String,  bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}

	}
}