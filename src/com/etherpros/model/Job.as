package com.etherpros.model
{
	/***
	 * Class used for storing the Job details for repainting a JobView component
 	* */
	public class Job
	{
		private var _startDay:Day;
		private var _endDay:Day;
		private var _contractor:Contractor;
		private var _jobColor:int;
		private var _project:Project;
			
		public function Job()
		{
		}

		public function get startDay():Day
		{
			return _startDay;
		}

		public function set startDay(value:Day):void
		{
			_startDay = value;
		}

		public function get endDay():Day
		{
			if(_endDay != null) {
				return _endDay;	
			} else {
				
			// if the endDay is null, then that means that the
			// job is only one day long, so return start day
			// since the start day and end day are the same.
				
				return _startDay;
			}
			
		}

		public function set endDay(value:Day):void
		{
			_endDay = value;
		}

		public function get jobColor():int
		{
			return _jobColor;
		}

		public function set jobColor(value:int):void
		{
			_jobColor = value;
		}

		public function get contractor():Contractor
		{
			return _contractor;
		}

		public function set contractor(value:Contractor):void
		{
			_contractor = value;
		}

		public function get project():Project
		{
			return _project;
		}

		public function set project(value:Project):void
		{
			_project = value;
		}


	}
}