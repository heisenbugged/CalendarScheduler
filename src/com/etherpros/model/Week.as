package com.etherpros.model
{
	public class Week
	{
		public static const SUNDAY:String ="sunday";
		public static const MONDAY:String ="monday";
		public static const TUESDAY:String ="tuesday";
		public static const WEDNESDAY:String ="wednesday";
		public static const THURSDAY:String ="thursday";
		public static const FRIDAY:String ="friday";
		public static const SATURDAY:String ="saturday";
		public static const DAYS_BY_WEEK:int = 7;

		private var _sunday:WeekDay;
		private var _monday:WeekDay;
		private var _tuesday:WeekDay;
		private var _wednesday:WeekDay;
		private  var _thursday:WeekDay;
		private var _friday:WeekDay;
		private var _saturday:WeekDay;
		
		public function Week()
		{
		}
		
		public function getDayByIndex(index:int):WeekDay {
			switch(index) {
				case 0: return sunday;
				case 1: return monday;
				case 2: return tuesday;
				case 3: return wednesday;
				case 4: return thursday;
				case 5: return friday;
				case 6: return saturday;
			}
			return null;
		}
		
		public function getIndexByDay(dayName:String):int {
			switch(dayName.toLowerCase()) {
				case SUNDAY: return 0;
				case MONDAY: return 1;
				case TUESDAY: return 2;
				case WEDNESDAY: return 3;
				case THURSDAY: return 4;
				case FRIDAY: return 5;
				case SATURDAY: return 6;
			}
			return -1;
		}
		
		public function get saturday():WeekDay
		{
			return _saturday;
		}

		public function set saturday(value:WeekDay):void
		{
			_saturday = value;
		}

		public function get friday():WeekDay
		{
			return _friday;
		}

		public function set friday(value:WeekDay):void
		{
			_friday = value;
		}

		public function get thursday():WeekDay
		{
			return _thursday;
		}

		public function set thursday(value:WeekDay):void
		{
			_thursday = value;
		}

		public function get wednesday():WeekDay
		{
			return _wednesday;
		}

		public function set wednesday(value:WeekDay):void
		{
			_wednesday = value;
		}

		public function get tuesday():WeekDay
		{
			return _tuesday;
		}

		public function set tuesday(value:WeekDay):void
		{
			_tuesday = value;
		}

		public function get monday():WeekDay
		{
			return _monday;
		}

		public function set monday(value:WeekDay):void
		{
			_monday = value;
		}

		public function get sunday():WeekDay
		{
			return _sunday;
		}

		public function set sunday(value:WeekDay):void
		{
			_sunday = value;
		}

	}
}