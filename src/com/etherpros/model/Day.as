package com.etherpros.model
{
	public class Day
	{
		// number of miliseconds in a day.
		public static const MILISECONDS:Number = 86400000;	
		
		private var _dayNumber:int = -1;
		private var _dayName:String = "";
		private var _date:Date;		
		private var _isBeginDayWeek:Boolean = false;
		private var _isEndDayWeek:Boolean= false;
		private var _isOtherMonth:Boolean = false;
		
		public function Day() {
			
		}
		
		
		public function get date():Date {
			return _date;
		}
		
		public function set date(value:Date):void {
			_date = value;
		}
		
		public function get time():Number {
			return _date.getTime();
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

		public function get isOtherMonth():Boolean
		{
			return _isOtherMonth;
		}

		public function set isOtherMonth(value:Boolean):void
		{
			_isOtherMonth = value;
		}


	}
}