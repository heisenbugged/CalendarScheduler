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
		
		// event types
		public static const JOB_RESIZED:String = 'jobResizedEvent';		
		public static const ADD_JOB_SPRITE:String = 'addJobSpriteEvent';	
		public static const HIGHLIGHT:String = 'jobHighlightedEvent';
		public static const UNHIGHLIGHT:String = 'jobUnHighlightedEvent';
		
		public function JobEvent(type:String,  bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}

	}
}