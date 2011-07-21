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

		private var _sunday:Day;
		private var _monday:Day;
		private var _tuesday:Day;
		private var _wednesday:Day;
		private  var _thursday:Day;
		private var _friday:Day;
		private var _saturday:Day;
		
		public function Week()
		{
		}
		
		public function getDayByIndex(index:int):Day {
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
		
		public function get saturday():Day
		{
			return _saturday;
		}

		public function set saturday(value:Day):void
		{
			_saturday = value;
		}

		public function get friday():Day
		{
			return _friday;
		}

		public function set friday(value:Day):void
		{
			_friday = value;
		}

		public function get thursday():Day
		{
			return _thursday;
		}

		public function set thursday(value:Day):void
		{
			_thursday = value;
		}

		public function get wednesday():Day
		{
			return _wednesday;
		}

		public function set wednesday(value:Day):void
		{
			_wednesday = value;
		}

		public function get tuesday():Day
		{
			return _tuesday;
		}

		public function set tuesday(value:Day):void
		{
			_tuesday = value;
		}

		public function get monday():Day
		{
			return _monday;
		}

		public function set monday(value:Day):void
		{
			_monday = value;
		}

		public function get sunday():Day
		{
			return _sunday;
		}

		public function set sunday(value:Day):void
		{
			_sunday = value;
		}

	}
}