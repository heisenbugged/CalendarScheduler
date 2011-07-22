package com.etherpros.model
{
	/***
	 * Class used for storing the Rig details for repainting a RigView component
 	* */
	public class Rig
	{
		private var _startDay:Day;
		private var _endDay:Day;
		private var _contractor:Contractor;
		private var _rigColor:int;
			
		public function Rig()
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
			// rig is only one day long, so return start day
			// since the start day and end day are the same.
				
				return _startDay;
			}
			
		}

		public function set endDay(value:Day):void
		{
			_endDay = value;
		}

		public function get rigColor():int
		{
			return _rigColor;
		}

		public function set rigColor(value:int):void
		{
			_rigColor = value;
		}

		public function get contractor():Contractor
		{
			return _contractor;
		}

		public function set contractor(value:Contractor):void
		{
			_contractor = value;
		}


	}
}