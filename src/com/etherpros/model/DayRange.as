package com.etherpros.model {
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;

	public class DayRange {
		// number of miliseconds in a day.
		private static const MS_IN_DAY:Number = 86400000;	
		private static const WEEKS_IN_CALENDAR:int = 6;
		
		private var _weeks:ArrayCollection;
		
		public function DayRange(weeks:ArrayCollection=null) {
			this.weeks = weeks;
		}
		
		/** Returns row, column index values for a particular date.
		 *  Used for positioning jobs on the calendar. **/
		public function getDateRowAndColumn(date:Date):Point {
			var pos:Point = new Point();
			var time:Number = date.getTime();
			var weekIndex:Number = 0;
			// find the corresponding week for this date
			// by comparing time ranges/
			for each(var week:Week in weeks) {
				
				var weekStart:Number = week.getDayByIndex(0).date.getTime();
				var weekEnd:Number = week.getDayByIndex(6).date.getTime();
				
				// if the date time fits inside of this week.
				if(time >= weekStart && time <= weekEnd) {
					// now that the corresponding week has been found, return position.
					pos.y = weekIndex;
					pos.x = date.day;
					return pos;
				}
				
				weekIndex++;
			}
			
			// if no matches were found, return a null object.
			return null;
		}
		
		
		/** Constructs a DayRange object with all the weeks necessary 
		 *  from a month index passed in. **/
		public static function createFromMonth(month:int, year:int):DayRange {
			var range:DayRange = new DayRange();
			var weeks:ArrayCollection = new ArrayCollection();
			// first day of month.
			var	monthDate:Date = new Date(year, month, 1);			
			var firstDayOfCalendar:Date = new Date();
			firstDayOfCalendar.setTime(monthDate.time - (monthDate.day * MS_IN_DAY));
			
			for(var i:int = 0; i < WEEKS_IN_CALENDAR; i++) {
				var week:Week = new Week();
				// create days
				for(var j:int = 0; j < 7; j++) {
					var dayNum:int = firstDayOfCalendar.date + (i*7)+j;
					var day:Day = new Day();
					var date:Date = new Date(firstDayOfCalendar.fullYear, firstDayOfCalendar.month, dayNum);
					day.dayName = indexToDayName(date.day);
					day.date = date;
					day.dayNumber = date.date;
					
					if(date.month != month) {
						day.isOtherMonth = true;
					}
					
					week.days[j] = day;
				}
				weeks.addItem(week);
			}
			range.weeks = weeks;			
			return range;
		}
	
		private static function indexToDayName(index:int):String {
			switch(index) {
				case 0: return Week.SUNDAY;
				case 1: return Week.MONDAY;
				case 2: return Week.TUESDAY;
				case 3: return Week.WEDNESDAY;
				case 4: return Week.THURSDAY;
				case 5: return Week.FRIDAY;
				case 6: return Week.SATURDAY;
			}
			return null;
		}
	
		public function get startDay():Day {
			return weeks[0].getDayByIndex(0);
		}
		
		public function get endDay():Day {
			return weeks[weeks.length-1].getDayByIndex(6);
		}
		
		public function set weeks(arr:ArrayCollection):void {			
			_weeks = arr;
		}
		
		public function get weeks():ArrayCollection {
			return this._weeks;
		}
		
	}
}