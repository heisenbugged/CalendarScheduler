package com.etherpros.model {
	import mx.collections.ArrayCollection;

	public class DayRange {
				
		private var _weeks:ArrayCollection;
		
		public function DayRange(weeks:ArrayCollection=null) {
			this.weeks = weeks;
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