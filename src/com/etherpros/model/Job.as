package com.etherpros.model
{
	/***
	 * Class used for storing the Job details for repainting a JobView component
 	* */
	public class Job implements IDataModel		
	{
		private var _startDay:Day;
		private var _endDay:Day;
		private var _contractor:Contractor;
		private var _jobColor:int;
		private var _project:Project;
		private var _rig:Rig;
		private var _client:Client;
		private var _AssignmentID;
		
		/**
		 * Determines whether the startDay/endDay range has changed.
		 * from its original value in the database.
		 */ 
		public var dirty:Boolean;		
		private var _persisted:Boolean;
		
		public function Job()
		{
		}
		
		public function get persisted():Boolean {
			return _persisted;
		}
		
		public function set persisted(value:Boolean):void {
			_persisted = value;
		}
		
		public function get uniqueID():String {
			return _AssignmentID;
		}
		
		public function get startDay():Day
		{
			return _startDay;
		}

		public function set startDay(value:Day):void
		{
			// if the date is different.
			if(_startDay && startDay.date.getTime() != value.date.getTime()) {
				// set model to dirty.
				dirty = true;
			}
			
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
			// if date is different.
			if(_endDay && endDay.date.getTime() != value.date.getTime()) {
				// set model to dirty.
				dirty = true;
			}
			
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

		public function get rig():Rig
		{
			return _rig;
		}

		public function set rig(value:Rig):void
		{
			_rig = value;
		}

		public function get client():Client
		{
			return _client;
		}

		public function set client(value:Client):void
		{
			_client = value;
		}

		public function get AssignmentID()
		{
			return _AssignmentID;
		}

		public function set AssignmentID(value):void
		{
			_AssignmentID = value;
		}


	}
}