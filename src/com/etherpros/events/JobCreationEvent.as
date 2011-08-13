package com.etherpros.events
{
	import com.etherpros.components.JobView;
	import com.etherpros.model.data.Contractor;
	import com.etherpros.model.Day;
	
	import flash.events.Event;
	
	public class JobCreationEvent extends Event
	{
		public static const REACHED_WEEK_LIMIT:String = "reachedWeekLimit";
		public static const ADD_NEW_JOB:String ="addNewJob";
		
		private var _jobView:JobView;
		private var _contractorJob:Contractor;
		private var _weekDay:Day;
		public function JobCreationEvent(type:String,jobView:JobView = null,  bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this._jobView = jobView;
		}

		public function get jobView():JobView
		{
			return _jobView;
		}

		public function set jobView(value:JobView):void
		{
			_jobView = value;
		}

		public function get weekDay():Day
		{
			return _weekDay;
		}

		public function set weekDay(value:Day):void
		{
			_weekDay = value;
		}

		public function get contractorJob():Contractor
		{
			return _contractorJob;
		}

		public function set contractorJob(value:Contractor):void
		{
			_contractorJob = value;
		}


	}
}