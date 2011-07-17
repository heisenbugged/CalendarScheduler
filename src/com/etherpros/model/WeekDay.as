package com.etherpros.model
{
	public class WeekDay
	{
		private var _dayNumber:int = -1;
		private var _dayName:String = "";
		
		public var dayIndex:int;
		public var weekIndex:int;
		
		private var _isBeginDayWeek:Boolean = false;
		private var _isEndDayWeek:Boolean= false;
		
		public function WeekDay()
		{
		}
		

		public function get dayName():String
		{
			return _dayName;
		}

		public function set dayName(value:String):void
		{
			_dayName = value;
		}

		public function get dayNumber():int
		{
			return _dayNumber;
		}

		public function set dayNumber(value:int):void
		{
			_dayNumber = value;
		}

		public function get isBeginDayWeek():Boolean
		{
			return _isBeginDayWeek;
		}

		public function set isBeginDayWeek(value:Boolean):void
		{
			_isBeginDayWeek = value;
		}

		public function get isEndDayWeek():Boolean
		{
			return _isEndDayWeek;
		}

		public function set isEndDayWeek(value:Boolean):void
		{
			_isEndDayWeek = value;
		}


	}
}