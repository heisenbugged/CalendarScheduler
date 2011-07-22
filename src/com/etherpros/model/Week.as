package com.etherpros.model
{
	import mx.charts.AreaChart;
	import mx.collections.ArrayCollection;

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
		
		private var _days:Array;
		
		public function Week() {
			// instantiate days array with empty values.
			days = [null, null, null, null, null, null, null];
		}
				
		public function getDayByIndex(index:int):Day {
			return days[index];
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
		
		public function get days():Array {
			return _days;
		}
		
		public function set days(value:Array):void {
			_days = value;
		}
		
		public function get saturday():Day {
			return _days[6];
		}

		public function set saturday(value:Day):void {
			_days[6] = value;
		}

		public function get friday():Day {
			return _days[5];
		}

		public function set friday(value:Day):void {
			_days[5] = value;
		}

		public function get thursday():Day {
			return _days[4];
		}

		public function set thursday(value:Day):void {
			_days[4] = value;
		}

		public function get wednesday():Day {
			return _days[3];
		}

		public function set wednesday(value:Day):void {
			_days[3] = value;
		}

		public function get tuesday():Day {
			return _days[2];
		}

		public function set tuesday(value:Day):void {
			_days[2] = value;
		}

		public function get monday():Day {
			return _days[1];
		}

		public function set monday(value:Day):void {
			_days[1] = value;
		}

		public function get sunday():Day {
			return _days[0];
		}

		public function set sunday(value:Day):void {
			_days[0] = value;			
		}

	}
}