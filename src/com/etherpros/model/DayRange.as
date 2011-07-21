package com.etherpros.model {
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;

	public class DayRange {
				
		private var _weeks:ArrayCollection;
		
		public function DayRange(weeks:ArrayCollection=null) {
			this.weeks = weeks;
		}
		
		/** Returns row, column index values for a particular date.
		 *  Used for positioning rigs on the calendar. **/
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