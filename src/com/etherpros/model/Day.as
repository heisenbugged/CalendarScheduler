package com.etherpros.model
{
	public class Day
	{
		private var _dayNumber:int = -1;
		private var _dayName:String = "";
		private var _date:Date;
		
		public var dayIndex:int;
		public var weekIndex:int;
		
		private var _isBeginDayWeek:Boolean = false;
		private var _isEndDayWeek:Boolean= false;
		
		private var _isPreviousMonth:Boolean = false;
		private var _isNextMonth:Boolean = false;
		
		
 
		
		public function Day() {
			
		}
		
		
		public function get date():Date {
			return _date;
		}
		
		public function set date(value:Date):void {
			_date = value;
		}
		
		public function get dayName():String {
			return _dayName;
		}

		public function set dayName(value:String):void {
			_dayName = value;
		}

		public function get dayNumber():int {
			return _dayNumber;
		}

		public function set dayNumber(value:int):void {
			_dayNumber = value;
		}

		public function get isBeginDayWeek():Boolean {
			return _isBeginDayWeek;
		}

		public function set isBeginDayWeek(value:Boolean):void {
			_isBeginDayWeek = value;
		}

		public function get isEndDayWeek():Boolean {
			return _isEndDayWeek;
		}

		public function set isEndDayWeek(value:Boolean):void {
			_isEndDayWeek = value;
		}

		public function get isPreviousMonth():Boolean
		{
			return _isPreviousMonth;
		}

		public function set isPreviousMonth(value:Boolean):void
		{
			_isPreviousMonth = value;
		}

		public function get isNextMonth():Boolean
		{
			return _isNextMonth;
		}

		public function set isNextMonth(value:Boolean):void
		{
			_isNextMonth = value;
		}


	}
}