package com.etherpros.model
{
	/***
	 * Class used for storing the Rig details for repainting a RigView component
 	* */
	public class Rig
	{
		private var _startDay:WeekDay;
		private var _endDay:WeekDay;
		private var _staff:Staff;
		private var _rigColor:int;
		public function Rig()
		{
		}

		public function get startDay():WeekDay
		{
			return _startDay;
		}

		public function set startDay(value:WeekDay):void
		{
			_startDay = value;
		}

		public function get endDay():WeekDay
		{
			return _endDay;
		}

		public function set endDay(value:WeekDay):void
		{
			_endDay = value;
		}

		public function get staff():Staff
		{
			return _staff;
		}

		public function set staff(value:Staff):void
		{
			_staff = value;
		}

		public function get rigColor():int
		{
			return _rigColor;
		}

		public function set rigColor(value:int):void
		{
			_rigColor = value;
		}


	}
}